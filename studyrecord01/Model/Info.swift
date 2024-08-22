//
//  Info.swift
//  studyrecord01
//
//  Created by Min Lee on 8/22/24.
//

import SwiftUI

struct Info: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var amount: String
    var percentage: Int
    var loss: Bool = false
    var icon: String
    var iconColor: Color
}

var infos: [Info] = [
    Info(title: "Revenues", amount: "$1,234", percentage: 10, icon: "arrow.up.right", iconColor: Color.blue),
    Info(title: "Orders", amount: "$342", percentage: 20, icon: "cart", iconColor: Color.green),
    Info(title: "Dine in", amount: "$204", percentage: 10, icon: "fork.knife", iconColor: Color.red),
    Info(title: "Take away", amount: "$134", percentage: 5, icon: "takeoutbag.and.cup.and.straw.fill", iconColor: Color.yellow)
]
