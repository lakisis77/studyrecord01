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

struct TRDataModel: Decodable {
    let error: Bool
    let message: String
    let data: [TimerecordModel]
}

struct DRDataModel: Decodable {
    let error: Bool
    let message: String
    let data: [DurationModel]
}

struct PostModel: Decodable {
    let id: Int
    let title: String
    let post: String
    let email: String
}

struct TimerecordModel: Decodable {
    let id: Int
    let title: String
    let rating: Int
    let duration: Int
    let email: String
    let comments: String
    let starttime: Int
}

struct apikeyModel: Decodable {
    let error: Bool
    let message: String
    let apikey: String
}

struct DurationModel: Decodable {
    let title: String
    let sum_duration: Int
    let avg_rating: Float
}
