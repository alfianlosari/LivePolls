//
//  Option.swift
//  LivePolls
//
//  Created by Alfian Losari on 09/07/23.
//

import Foundation

struct Option: Codable, Identifiable, Hashable {
    var id = UUID().uuidString
    var count: Int
    var name: String
}
