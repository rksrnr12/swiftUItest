//
//  AWSView.swift
//  test0708
//
//  Created by khg on 2/12/26.
//

import SwiftUI
import Amplify
import AWSAPIPlugin

struct AWSView: View {
    
    @State private var testTodo:[Todo] = []
    @State private var selectedItem:Todo = .init(id:"",name: "")
    @State private var name = "1234"
    @State private var desc = "1234"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                HStack(spacing: 5) {
                    VStack(spacing: 5) {
                        TextField("name", text: $name)
                        TextField("description", text: $desc)
                    }
                    Button("저장") {
                        Task {
                            do {
                                if selectedItem.id.isEmpty {
                                    //저장하는법
                                    let test:Todo = .init(name: name, description: desc)
                                    _ = try await Amplify.API.mutate(request: .create(test))
                                }else {
                                    //업데이트
                                    selectedItem.name = name
                                    selectedItem.description = desc
                                    _ = try await Amplify.API.mutate(request: .update(selectedItem))
                                }
                                let load = try await Amplify.API.query(request: .list(Todo.self)).get()
                                withAnimation {
                                    testTodo = load.elements
                                }
                            }catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
                ForEach(testTodo,id:\.id) { item in
                    Menu {
                        Button("수정") {
                            withAnimation {
                                selectedItem = item
                                name = item.name
                                desc = item.description ?? ""
                            }
                        }
                        Button("삭제") {
                            Task {
                                do{
                                    _ = try await Amplify.API.mutate(request: .delete(item))
                                    let load = try await Amplify.API.query(request: .list(Todo.self)).get()
                                    withAnimation {
                                        testTodo = load.elements
                                    }
                                }catch{
                                    
                                }
                            }
                        }
                    } label: {
                        VStack(alignment:.leading,spacing: 10) {
                            Text("이름은 = \(item.name)")
                            Text("내용은 = \(item.description ?? "")")
                        }
                        .frame(alignment:.leading)
                        .padding(.all ,10)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .frame(maxWidth:.infinity)
            .padding(.all,20)
        }
        .task {
            do {
                let session = try await Amplify.Auth.fetchAuthSession()
                print(session)
                //로드하는법
                let load = try await Amplify.API.query(request: .list(Todo.self)).get()
                withAnimation {
                    testTodo = load.elements
                }
            }catch {
                print("기타: \(error)")
            }
        }
        
    }
}

