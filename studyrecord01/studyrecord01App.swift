//
//  CRUDApp.swift
//  studyrecord01
//
//  Created by Min Lee on 8/14/24.
//

import SwiftUI

@main
struct studyrecord01: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(ViewModel())
        }
    }
}
