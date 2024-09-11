//
//  ContentView.swift
//  studyrecord01
//
//  Created by Min Lee on 8/14/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    @AppStorage("signIn") var isSignIn = false
//    @AppStorage("email") var email = ""
    
    var body: some View {
        if !isSignIn {
            
            LoginScreen()
        } else {
            
            ResponsiveView { props in
                Home(props: props) }
        }

    }
}

//struct HomeView: View {
////    var email = UserDefaults.standard.string(forKey: "email") ?? ""
//    
//    @EnvironmentObject var viewModel: ViewModel
//    @State var isPresentedNewPost = false
//    @State var title = ""
//    @State var post = ""
//    
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(viewModel.items, id: \.id) { item in
//                    NavigationLink(
//                        destination: DetailView(item: item),
//                        label: {
//                            VStack(alignment: .leading) {
//                                Text(item.title)
//                                Text(item.post).font(.caption).foregroundColor(.gray)
//                            }
//                        
//                    })
//                    
//                }.onDelete(perform: deletePost)
//                
//            }.listStyle(InsetListStyle())
//            .refreshable {
//                viewModel.fetchPost()
//            }
//            
//            .navigationBarTitle("Posts")
//            
////            .navigationBarTitle(email)
//            .navigationBarItems(trailing: plusButton)
//            .navigationBarItems(leading: logoutButton)
//        }.sheet(isPresented: $isPresentedNewPost, content: {
//            NewPostView(isPresented: $isPresentedNewPost, title: $title, post: $post)
//        })
//    }
//    
//    private func deletePost (indexSet: IndexSet) {
//        let id = indexSet.map { viewModel.items[$0].id}
//        DispatchQueue.main.async {
//            let parameters: [String: Any] = ["id": id[0]]
//            viewModel.deletePost(parameters: parameters) {
//                   viewModel.fetchPost()
//            }
//            //            self.viewModel.deletePost(parameters: parameters)
//            self.viewModel.fetchPost()
//        }
//    }
//    
//    var plusButton: some View {
//        Button(action: {
//            isPresentedNewPost.toggle()
//        }, label: {Image(systemName: "plus")})
//    }
//    
//    var logoutButton: some View {
//        Button(action: {
//            let firebaseAuth = Auth.auth()
//            do {
//              try firebaseAuth.signOut()
//            } catch let signOutError as NSError {
//              print("Error signing out: %@", signOutError)
//            }
//            UserDefaults.standard.set(false, forKey: "signIn")
//        }, label: {Image(systemName: "rectangle.portrait.and.arrow.forward")})
//    }
//}
//
//#Preview {
//    ContentView()
//}
