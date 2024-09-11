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
            Text("미카운터")
                .font(.largeTitle)
                .fontWeight(.medium)

            Text("기록은 모두 옳다")
                .font(.title2)
                .fontWeight(.medium)

            
            Text("환영합니다. \n구글 아이디로 로그인해주세요.")
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

struct LoginHeader_Previews: PreviewProvider {
    static var previews: some View {
        LoginHeader()
    }
}
