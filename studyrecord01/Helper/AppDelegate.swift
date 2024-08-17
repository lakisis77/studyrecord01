//
//  AppDelegate.swift
//  studyrecord01
//
//  Created by Min Lee on 8/17/24.
//
//초기화 코드 추가
//앱이 시작될 때 Firebase에 연결하려면 아래의 초기화 코드를 앱의 기본 진입점에 추가합니다.

import SwiftUI
import FirebaseCore
import GoogleSignIn


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
               didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
    }
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}
