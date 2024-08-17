//
//  NewPostView.swift
//  studyrecord01
//
//  Created by Min Lee on 8/14/24.
//

import SwiftUI
import GoogleSignIn

struct NewPostView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Binding var isPresented: Bool
    @Binding var title: String
    @Binding var post: String
    @State var isAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading) {
                    
                    Text("Create New Post")
                        .font(Font.system(size: 16, weight:  .bold))
                    
                    TextField("Title", text:$title)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(6)
                        .padding(.bottom)
                    
                    TextField("Write Someting", text:$post)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(6)
                        .padding(.bottom)
                    
                    Spacer()
                }.padding()
                    .alert(isPresented: $isAlert, content: {
                        let title = Text("No Data")
                        let message = Text("Please fill you title and post")
                        return Alert(title: title, message: message)
                    }
                    )
            }
            
            .navigationBarTitle("New posts", displayMode: .inline)
            .navigationBarItems(leading: leading, trailing: trailing)
        
        }
    }
    
    var leading: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {Text("Cancel")})
    }
    
    var trailing: some View {
        Button(action: {
            if(title != "" && post != "") {
                let parameters: [String: Any] = [ "title": title, "post": post]
                viewModel.createPost(parameters: parameters) {
                       viewModel.fetchPost()
                }
//                viewModel.createPost(parameters: parameters)
//                viewModel.fetchPost()
//                DispatchQueue.main.sync{viewModel.createPost(parameters: parameters)}
//                DispatchQueue.main.sync{viewModel.fetchPost()}
                
                isPresented.toggle()
                
            } else {
                isAlert.toggle()
            }
                
            
            
        }, label: {Text("Post")})
    }

}

//#Preview {
//    NewPostView()
//}
