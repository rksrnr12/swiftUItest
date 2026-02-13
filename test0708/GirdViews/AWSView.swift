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
    
    @State private var testTodo:Todo = .init(name: "")
    
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            Text(testTodo.name)
            Text(testTodo.description ?? "")
            Button("awsTest") {
                let test:Todo = .init(name: "저장테스트", description: "저장테스트해보는중")
                Task {
                    do {
                        //저장하는법
                        let result = try await Amplify.API.mutate(request: .create(test))
                        print(result)
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            }
            Spacer()
        }
        .task {
            do {
                //로드하는법
                let load = try await Amplify.API.query(request: .list(Todo.self)).get()
                testTodo = load.first ?? .init(name: "")
            }catch {
                print(error.localizedDescription)
            }
        }
        
    }
}

