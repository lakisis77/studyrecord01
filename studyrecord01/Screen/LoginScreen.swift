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
    @State private var isContentOn = false
    
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
                    .padding(.bottom, 120)
                
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
                            //                            {
                            viewModel.refresh()
                            //                            }
                            
                            UserDefaults.standard.set(true, forKey: "signIn")
                            
                        }
                    }
                } // GoogleSiginBtn
                .padding(.bottom, 120)
                .opacity(!isContentOn ? 0.5 : 1.0)
                .disabled(!isContentOn)
                
                HStack{
                    Toggle("개인정보보호 및 약관 동의", systemImage: "document", isOn: $showDocument)
                        .tint(.blue)
                        .padding()
                        .toggleStyle(.button)
                        .sheet(isPresented: $showDocument) {
                            DocumentView()}
                    
                    Toggle("", systemImage: "document", isOn: $isContentOn)
                        .tint(.blue)
                        .labelsHidden()
                        .padding()
                        .sheet(isPresented: $showDocument) {
                            DocumentView()}
                }
                
                
            } // VStack
            .padding(.top, 52)
            Spacer()
        }
    }
    @State var showDocument = false
    
    @ViewBuilder
    func DocumentView()->some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Text("약관")
                    .font(.title2)
                    .fontWeight(.medium)
                    .padding()
                
                Text("1. 소개")
                    .font(.headline)
                Text("이 사용 약관(이하 \"약관\")은 [미카운터] (이하 \"앱\")의 사용에 관한 규칙과 조건을 설명합니다. 앱을 사용함으로써 귀하는 이 약관에 동의하는 것으로 간주됩니다.")
                
                Text("2. 사용 조건")
                    .font(.headline)
                Text("앱은 개인적이고 비상업적인 용도로만 사용 가능합니다. 귀하는 앱을 불법적인 목적으로 사용해서는 안 됩니다.")
                
                Text("3. 계정")
                    .font(.headline)
                Text("앱 사용을 위해 구글 계정을 사용합니다. 귀하는 계정 정보의 기밀성을 유지할 책임이 있습니다.")
                
                Text("4. 개인정보 보호")
                    .font(.headline)
                Text("앱은 귀하의 개인정보를 보호하기 위해 최선을 다합니다. 아래의 개인정보보호 약관을 참고하세요")
                
                Text("5. 지적 재산권")
                    .font(.headline)
                Text("앱과 그 콘텐츠는 미카운터의 지적 재산권에 속합니다. 무단 복제, 배포, 수정은 금지됩니다.")
                
                Text("6. 책임의 제한")
                    .font(.headline)
                Text("앱 사용 중 서버 오류 등으로 데이터 손실, 사용 중단이 발생할 수 있고, 회사가 서버 유지의 곤란 등으로 서비스를 지속하기 어려운 경우가 발생할 수 있으며, 미카운터는 앱 사용 또는 서비스 중단으로 인한 어떠한 손해에 대해서도 책임을 지지 않습니다. ")
                
                Text("7. 약관의 변경")
                    .font(.headline)
                Text("[회사 이름]은 언제든지 이 약관을 수정할 수 있는 권리를 보유합니다. 변경된 약관은 앱에 게시된 시점부터 효력이 발생합니다.")
                Text("\n\n\n\n개인정보보호약관")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                Group {
                    Text("1. 개인정보의 수집 및 이용 목적")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("서비스 제공 및 운영\n고객 문의 응대\n마케팅 및 광고 활용")
                        .padding(.bottom, 10)
                    
                    Text("2. 수집하는 개인정보 항목")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("이름, 이메일 주소, 전화번호\n서비스 이용 기록, 접속 로그, 쿠키")
                        .padding(.bottom, 10)
                    
                    Text("3. 개인정보의 보유 및 이용 기간")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("회원 탈퇴 시까지\n법령에 따른 보존 기간")
                        .padding(.bottom, 10)
                    
                    Text("4. 개인정보의 제3자 제공")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("원칙적으로 개인정보를 외부에 제공하지 않습니다.\n법령에 따라 의무로 되어 있는 경우에는 예외로 합니다")
                        .padding(.bottom, 10)
                    
                    Text("5. 개인정보의 파기 절차 및 방법")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("전자적 파일 형태: 복구 불가능한 방법으로 삭제\n종이 문서: 분쇄 또는 소각")
                        .padding(.bottom, 10)
                    
                    Text("6. 이용자의 권리와 행사 방법")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("개인정보 열람, 정정, 삭제 요청\n개인정보 처리 정지 요청")
                        .padding(.bottom, 10)
                    
                    Text("7. 개인정보 보호를 위한 기술적/관리적 대책")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("개인정보 암호화\n접근 권한 관리")
                        .padding(.bottom, 10)
                    
                }
            }
            .padding()
        }
    }
    
}



struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
