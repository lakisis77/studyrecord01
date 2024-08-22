//
//  Models.swift
//  studyrecord01
//
//  Created by Min Lee on 8/14/24.
//

import Foundation
import SwiftUI

struct DataModel: Decodable {
    let error: Bool
    let message: String
    let data: [PostModel]
}

struct PostModel: Decodable {
    let id: Int
    let title: String
    let post: String
}

struct apikeyModel: Decodable {
    let error: Bool
    let message: String
    let apikey: String
}
