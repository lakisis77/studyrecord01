//
//  ContentView.swift
//  SignInUsingGoogle
//
//  Created by Swee Kwang Chua on 12/5/22.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

struct LoginScreen: View {
    @EnvironmentObject var viewModel: ViewModel
//    @StateObject var viewModel: ViewModel
    @State var username: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack {
            VStack {
                LoginHeader()
                    .padding(.bottom)
                
//                CustomTextfield(text: $username)
                
//                CustomTextfield(text: $username)
                
//                HStack {
//                    Spacer()
//                    Button(action: {}) {
//                        Text("Forgot Password?")
//                    }
//                }
                .padding(.trailing, 24)
                
//                CustomButton()
                
                
//                Text("or")
                .padding(.bottom, 200)
                
                GoogleSiginBtn {
                    // TODO: - Call the sign method here
                    guard let clientID = FirebaseApp.app()?.options.clientID else { return }

                    // Create Google Sign In configuration object.
                    let config = GIDConfiguration(clientID: clientID)
                    GIDSignIn.sharedInstance.configuration = config

                    // Start the sign in flow!
                    GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { result, error in
                      guard error == nil else {
                        // ...
                          return
                      }

                      guard let user = result?.user,
                         let idToken = user.idToken?.tokenString
                         
                      else {
                        // ...
                          return
                      }
                                              
//                        print(user)
                      let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                                     accessToken: user.accessToken.tokenString)

                        
                      // ...
//                        let name = user.profile?.name
                        
                        
                        Auth.auth().signIn(with: credential) { result, error in
                            guard error == nil else {
                                return
                            }
                        
//                            username = user.profile?.email
                            let email = user.profile?.email ?? ""
                            
                            
//                            username = email
                            
                            print("로그인 성공")
                            print(email)
                            print(idToken)
                            
                            UserDefaults.standard.set(email, forKey: "email")
//                            @AppStorage("email") var email = email
                            
                            let parameters: [String: Any] = [ "email": email, "idToken": idToken]
                            viewModel.loginInfo(parameters: parameters)
                            
                            UserDefaults.standard.set(true, forKey: "signIn")
                        }
                    }
                } // GoogleSiginBtn
            } // VStack
            .padding(.top, 52)
            Spacer()
        }
    }
}


struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
