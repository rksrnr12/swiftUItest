import SwiftUI
import HealthKit
import CoreMotion

struct SideWork: View {
    @StateObject private var viewModel = SideWorkViewModel()
    @FocusState private var focus: Bool
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.openURL) private var openURL

    private let completedColor = Color(red: 168/255, green: 230/255, blue: 207/255)
    private let pendingColor = Color(red: 179/255, green: 229/255, blue: 152/255)
    
    var body: some View {
        VStack(spacing: 20) {
            topInfoView
            mainListView
        }
        .task {
            viewModel.getStepCountWithCoreMotion()
            viewModel.loadData()
        }
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .active {
                viewModel.getStepCountWithCoreMotion()
                if viewModel.selection != .none {
                    viewModel.openAlert = true
                }
            }
        }
        .alert(viewModel.selection.rawValue + " 완료?", isPresented: $viewModel.openAlert) {
            TextField("가능하면 금액 입력", value: $viewModel.price, formatter: Self.formatter)
                .keyboardType(.numbersAndPunctuation)
                .multilineTextAlignment(.trailing)
                .onSubmit {
                    viewModel.completedAction()
                    viewModel.openAlert = false
                }
            Button("아니요") {
                viewModel.price = 0
                viewModel.selection = .none
            }
            Button("완료") {
                viewModel.completedAction()
            }
        }
    }

    private var topInfoView: some View {
        HStack(spacing: 20) {
            Text("🚶‍♂️ : \(viewModel.todayWork.steps)")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.blue)
            Text("💰 : \(viewModel.totalPrice)원")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.green)
        }
    }

    private var mainListView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(alignment: .top, spacing: 15) {
                    commonListView(isAttendance: false)
                    commonListView(isAttendance: true)
                }
                DatePicker("", selection: $viewModel.selectedDate, displayedComponents: .date)
                    .labelsHidden()
                    .environment(\.locale, Locale(identifier: "ko_KR"))
                priceListCell(item: viewModel.selectedTotalWork)
            }
            .padding(.horizontal, 15)
            .animation(.default, value: viewModel.selectedDate)
        }
    }

    private func commonListView(isAttendance: Bool) -> some View {
        VStack(spacing: 20) {
            Text(isAttendance ? "✅ 출석체크" : "🏃 만보기")
                .font(.headline)
            ForEach(isAttendance ? WorkType.attendanceList : WorkType.pedometerList) { item in
                Button {
                    viewModel.selection = item
                    if let schemeURL = URL(string: item.scheme), !item.scheme.isEmpty {
                        openURL(schemeURL)
                    }
                } label: {
                    HStack {
                        Text(item.rawValue)
                        Spacer()
                        Image(systemName: viewModel.todayWork.workList.keys.contains(item) ? "checkmark.circle.fill" : "checkmark.circle")
                            .foregroundColor(.white)
                    }
                    .onLongPressGesture {
                        viewModel.selection = item
                        viewModel.openAlert = true
                    }
                }
                .buttonStyle(ColorButtonStyle(bgColor: viewModel.todayWork.workList.keys.contains(item) ? completedColor : pendingColor))
            }
        }
    }
    
    private func priceListCell(item: TodayWork) -> some View {
        VStack(alignment: .trailing, spacing: 10) {
            HStack {
                Text("🗓️ \(item.savedDate.string(format: "yyyy년 MM월 dd일"))")
                Spacer()
                Text("🏃 \(item.steps)").foregroundStyle(.blue)
            }
            ForEach(Array(item.workList).sorted(by: { $0.value > $1.value }), id: \.key) { workType, price in
                if viewModel.selection == workType, !viewModel.openAlert {
                    HStack {
                        Text(workType.rawValue)
                        Spacer()
                        TextField("가능하면 금액 입력", value: $viewModel.price, formatter: Self.formatter)
                            .keyboardType(.numbersAndPunctuation)
                            .multilineTextAlignment(.trailing)
                            .focused($focus)
                            .onSubmit {
                                if let index = viewModel.totalWorkList.firstIndex(where: { $0.id == item.id }) {
                                    focus = false
                                    viewModel.totalWorkList[index].totalPrice -= price
                                    viewModel.editData(index: index, workType: workType)
                                }
                            }
                    }
                    .font(.system(size: 14, weight: .regular))
                } else {
                    Button {
                        withAnimation {
                            viewModel.selection = workType
                            viewModel.price = price
                            focus = true
                        }
                    } label: {
                        HStack {
                            Text(workType.rawValue)
                            Spacer()
                            Text("\(price) 원")
                        }
                        .font(.system(size: 14, weight: .regular))
                    }
                }
            }
            Text("합계 : \(item.totalPrice) 원")
        }
        .font(.system(size: 14, weight: .semibold))
        .padding(.all, 20)
        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 10))
    }
    
    // formatter를 static let으로 선언
    private static let formatter: CustomNumberFormatter = {
        let formatter = CustomNumberFormatter()
        formatter.numberStyle = .decimal
        formatter.zeroSymbol = ""
        return formatter
    }()
}
