//
//  TodoListView.swift
//  VoiceMemo
//
//  Created by dodor on 2023/10/16.
//

import SwiftUI

struct TodoListView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack {
            if !todoListViewModel.todos.isEmpty {
                CustomNavigationBar(
                    isDisplayLeftButton: false,
                    rightButtonAction: {
                        todoListViewModel.navigationRightButtonTapped()
                    },
                    rightButtonType: todoListViewModel.navigationBarRightButtonMode
                )
            } else {
                Spacer()
                    .frame(height: 30)
            }
            
            TitleView()
                .padding(.top, 20)
            
            if todoListViewModel.todos.isEmpty {
                AnnouncementView()
            } else {
                TodoListContentView()
                    .padding(.top, 20)
            }
        }
//        .modifier(WriteButtonViewModifier(action: { pathModel.paths.append(.todoView) }))
        .writeButton(perform: { pathModel.paths.append(.todoView) })
//        WriteButtonView {
//            VStack {
//                if !todoListViewModel.todos.isEmpty {
//                    CustomNavigationBar(
//                        isDisplayLeftButton: false,
//                        rightButtonAction: {
//                            todoListViewModel.navigationRightButtonTapped()
//                        },
//                        rightButtonType: todoListViewModel.navigationBarRightButtonMode
//                    )
//                } else {
//                    Spacer()
//                        .frame(height: 30)
//                }
//                
//                TitleView()
//                    .padding(.top, 20)
//                
//                if todoListViewModel.todos.isEmpty {
//                    AnnouncementView()
//                } else {
//                    TodoListContentView()
//                        .padding(.top, 20)
//                }
//            }
//        } action: {
//            pathModel.paths.append(.todoView)
//        }
        .alert(
            "To do list \(todoListViewModel.removeTodosCount)개 삭제하시겠습니까?",
            isPresented: $todoListViewModel.isDisplayRemoveTodoAlert
        ) {
            Button("삭제", role: .destructive) {
                todoListViewModel.removeButtonTapped()
            }
            Button("취소", role: .cancel) { }
        }
        .onChange(of: todoListViewModel.todos) { todos in
            homeViewModel.setTodosCount(todos.count)
        }
    }
    
//    var titleView: some View {
//        Text("Title")
//    }
//
//    func titleView() -> some View {
//        Text("Title")
//    }
}

// MARK: - TodoList 타이틀 뷰
private struct TitleView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        HStack {
            if todoListViewModel.todos.isEmpty {
                Text("To do list를\n추가해 보세요.")
            } else {
                Text("To do list \(todoListViewModel.todos.count)개가\n있습니다.")
            }
            
            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}

// MARK: - TodoList 안내 뷰
private struct AnnouncementView: View {
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Spacer()
            
            Image("pencil")
                .renderingMode(.template)
            
            VStack(spacing: 5) {
                Text("\"매일 아침 8시 운동하자\"")
                Text("\"내일 8시 신청하자\"")
                Text("\"1시 반 점심약속\"")
            }
            
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundColor(.customGray2)
    }
}

// MARK: - TodoList 컨텐츠 뷰
private struct TodoListContentView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        VStack {
            HStack {
                Text("할일 목록")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, 20)
                
                Spacer()
            }
            
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.customGray0)
                        .frame(height: 1)
                    
                    ForEach(todoListViewModel.todos, id:\.self) { todo in
                        // TODO: - Todo 셀 뷰 Todo 넣어서 뷰 호출
                        TodoCellView(todo: todo)
                    }
                }
            }
        }
    }
}

// MARK: - Todo 셀 뷰
private struct TodoCellView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @State private var isRemoveSelected: Bool
    private var todo: Todo
    
    fileprivate init(
        isRemoveSelected: Bool = false,
        todo: Todo
    ) {
        _isRemoveSelected = State(initialValue: isRemoveSelected)
        self.todo = todo
    }
    
    fileprivate var body: some View {
        VStack(spacing: 20) {
            HStack {
                if !todoListViewModel.isEditTodoMode {
                    Button {
                        todoListViewModel.selectedBoxTapped(todo)
                    } label: {
                        Image(systemName: todo.selected ? "checkmark.square.fill" : "square")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.customGreen)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text(todo.title)
                        .font(.system(size: 16))
                        .foregroundColor(todo.selected ? .customIconGray : .customBlack)
                    
                    Text(todo.convertedDayAndTime)
                        .font(.system(size: 12))
                        .foregroundColor(.customIconGray)
                }
                .strikethrough(todo.selected)
                
                Spacer()
                
                if todoListViewModel.isEditTodoMode {
                    Button {
                        isRemoveSelected.toggle()
                        todoListViewModel.todoRemoveSelectedBoxTapped(todo)
                    } label: {
                        Image(systemName: isRemoveSelected ? "trash.square.fill" : "square")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.customGreen)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
        
        Rectangle()
            .fill(Color.customGray0)
            .frame(height: 1)
    }
}

// MARK: - Todo 작성 버튼 뷰
private struct WriteTodoButtonView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                Button {
                    pathModel.paths.append(.todoView)
                } label: {
                    Circle()
                        .fill(Color.customGreen)
                        .frame(width: 50)
                        .overlay {
                            Image("pencil")
                                .renderingMode(.template)
                                .foregroundColor(.customWhite)
                        }
                }
            }
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
            .environmentObject(PathModel())
            .environmentObject(TodoListViewModel())
    }
}
