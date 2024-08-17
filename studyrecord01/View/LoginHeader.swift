//
//  LoginHeader.swift
//  SignInUsingGoogle
//
//  Created by Swee Kwang Chua on 4/9/22.
//

import SwiftUI

struct LoginHeader: View {
    var body: some View {
        VStack {
            Text("학습기록")
                .font(.largeTitle)
                .fontWeight(.medium)
                .padding()
            
            Text("환영합니다. \n구글 아이디로 로그인해주세요.")
                .multilineTextAlignment(.center)
        }
    }
}

struct LoginHeader_Previews: PreviewProvider {
    static var previews: some View {
        LoginHeader()
    }
}
