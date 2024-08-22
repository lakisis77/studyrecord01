//
//  ResponsiveView.swift
//  studyrecord01
//
//  Created by Min Lee on 8/22/24.
//

import SwiftUI

// Mark: Custom View Useful properties

struct ResponsiveView<Content: View>: View {
    var content: (Properties)-> Content
    init(@ViewBuilder content: @escaping (Properties)-> Content) {
        self.content = content
    }
    var body: some View {
        GeometryReader{proxy in
            let size = proxy.size
            let isLandscape = size.width > size.height
            let isIpad = UIDevice.current.userInterfaceIdiom == .pad
            let isMaxSplit = isSplit() && size.width < 400
            let properties = Properties(isLandscape: isLandscape, isiPad: isIpad, isSplit: isSplit(), isMaxSplit: isMaxSplit, size: size)
            content(properties)
                .frame(width: size.width, height: size.height)
        }
    }
    
    // MARK: Find split View
    func isSplit()->Bool{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene
            else{return false}
        return screen.windows.first?.frame.size != screen.screen.bounds.size
    }
}

struct Properties {
    var isLandscape: Bool
    var isiPad: Bool
    var isSplit: Bool
    // MARK: If the App size is reduced more 1/3 in split mode
    var isMaxSplit: Bool
    var size: CGSize
}
