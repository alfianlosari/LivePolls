//
//  Poll.swift
//  LivePolls
//
//  Created by Alfian Losari on 09/07/23.
//

import FirebaseFirestoreSwift
import Foundation

struct Poll: Codable, Identifiable, Hashable {
    
    var id: String
    @ServerTimestamp var createdAt: Date?
    @ServerTimestamp var updatedAt: Date?
    
    var name: String 
    var totalCount: Int
    
    var option0: Option
    var option1: Option
    var option2: Option?
    var option3: Option?
    
    var options: [Option] {
        var options = [option0, option1]
        if let option2 { options.append(option2) }
        if let option3 { options.append(option3) }
        return options
    }
    
    var lastUpdatedOptionId: String?
    var lastUpdatedOption: Option? {
        guard let lastUpdatedOptionId else { return nil }
        return options.first { $0.id == lastUpdatedOptionId }
    }
    
    init(id: String = UUID().uuidString, createdAt: Date? = nil, updatedAt: Date? = nil, name: String, totalCount: Int, options: [Option], lastUpdatedOptionId: String? = nil) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.name = name
        self.totalCount = totalCount
        
        assert(options.count >= 2, "Number of options need to be >= 2")
        self.option0 = options[0]
        self.option1 = options[1]
        if options.count > 2 {
            self.option2 = options[2]
        }
        
        if options.count > 3 {
            self.option3 = options[3]
        }
        self.lastUpdatedOptionId = lastUpdatedOptionId
    }
    
}
