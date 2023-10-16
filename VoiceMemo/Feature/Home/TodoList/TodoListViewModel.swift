//
//  TodoListViewModel.swift
//  VoiceMemo
//
//  Created by dodor on 2023/10/16.
//

import Foundation

class TodoListViewModel: ObservableObject {
    @Published var todos: [Todo]
    @Published var isEditTodoMode: Bool
    @Published var removeTodos: [Todo]
    @Published var isDisplayRemoveTodoAlert: Bool
    
    var removeTodosCount: Int {
        return removeTodos.count
    }
    var navigationBarRightButtonMode: NavigationBarButtonType {
        isEditTodoMode ? .complete : .edit
    }
    
    init(
        todos: [Todo] = [],
        isEditModeTodoMode: Bool = false,
        removeTodos: [Todo] = [],
        isDisplayRemoveTodoAlert: Bool = false
    ) {
        self.todos = todos
        self.isEditTodoMode = isEditModeTodoMode
        self.removeTodos = removeTodos
        self.isDisplayRemoveTodoAlert = isDisplayRemoveTodoAlert
    }
}

extension TodoListViewModel {
    func selectedBoxTapped(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0 == todo }) {
            todos[index].selected.toggle()
        }
    }
    
    func addTodo(_ todo: Todo) {
        todos.append(todo)
    }
    
    func navigationRightButtonTapped() {
        if isEditTodoMode {
            if removeTodos.isEmpty {
                isEditTodoMode = false
            } else {
                // 얼럿을 불러준다
                setIsDisplayRemoveTodoAlert(true)
            }
        } else {
            isEditTodoMode = true
        }
    }
    
    func setIsDisplayRemoveTodoAlert(_ isDisplay: Bool) {
        isDisplayRemoveTodoAlert = isDisplay
    }
    
    func todoRemoveSelectedBoxTapped(_ todo: Todo) {
        if let index = removeTodos.firstIndex(of: todo) {
            removeTodos.remove(at: index)
        } else {
            removeTodos.append(todo)
        }
    }
    
    func removeButtonTapped() {
        todos.removeAll { todo in
            removeTodos.contains(todo)
        }
        removeTodos.removeAll()
        isEditTodoMode = false
    }
}
