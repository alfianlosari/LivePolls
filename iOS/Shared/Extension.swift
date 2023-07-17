//
//  Extension.swift
//  LivePolls
//
//  Created by Alfian Losari on 17/07/23.
//

import Foundation

extension String: Identifiable {
    public var id: Self { self }
}

extension String: Error, LocalizedError {
    
    public var errorDescription: String? { self }
}
