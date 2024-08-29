//
//  DetailView.swift
//  studyrecord01
//
//  Created by Min Lee on 8/14/24.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode
    let item: PostModel
    @State var title = ""
    @State var post = ""
    
    var body: some View {
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
                .onAppear(perform: {
                    self.title = item.title
                    self.post = item.post
                })
            
        }
        
        .navigationBarTitle("Edit post", displayMode: .inline)
        .navigationBarItems(trailing: trailing)
    }
    
    var trailing: some View {
        Button(action: {
            // update post
            if (title != "" && post != "") {
                let parameters: [String: Any] = ["id": item.id, "title": title, "post": post]
                viewModel.updatePost(parameters: parameters) {
                       viewModel.fetchPost()
                }
//                viewModel.updatePost(parameters: parameters)
//                viewModel.fetchPost()
                presentationMode.wrappedValue.dismiss()
                
            }
            
        }, label: {Text("Save")})
    }

}

struct TRDetailView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode
    let item: TimerecordModel
    @State var title = ""
    @State var duration = 0
    @State var rating = 0
    
    var body: some View {
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
                                
                Spacer()
            }.padding()
                .onAppear(perform: {
                    self.title = item.title
//                    self.post = item.post
                })
            
        }
        
        .navigationBarTitle("Edit post", displayMode: .inline)
        .navigationBarItems(trailing: trailing)
    }
    
    var trailing: some View {
        Button(action: {
            // update post
            if (title != "") {
                let parameters: [String: Any] = ["id": item.id, "title": title]
                viewModel.updatePost(parameters: parameters) {
                       viewModel.fetchPost()
                }
//                viewModel.updatePost(parameters: parameters)
//                viewModel.fetchPost()
                presentationMode.wrappedValue.dismiss()
                
            }
            
        }, label: {Text("Save")})
    }

}

//#Preview {
//    DetailView()
//}
