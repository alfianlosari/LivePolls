//
//  PollOptionVM.swift
//  LivePollsVision
//
//  Created by Alfian Losari on 16/07/23.
//

import FirebaseFirestore
import Foundation
import SwiftUI
import Observation

@Observable
class PollOptionViewModel {
    
    let db = Firestore.firestore()

    var existingPollId: String = ""
    
    var error: String? = nil
    var newPollName: String = ""
    var newOptionName: String = ""
    var newPollOptions: [String] = []
    
    var isLoading = false
    var isCreateNewPollButtonDisabled: Bool {
        isLoading ||
        newPollName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        newPollOptions.count < 2
    }
    
    var isAddOptionsButtonDisabled: Bool {
        isLoading ||
        newOptionName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        newPollOptions.count == 4
    }
    
    var isJoinPollButtonDisabled: Bool {
        isLoading ||
        existingPollId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    @MainActor
    func createNewPoll() async {
        isLoading = true
        error = nil
        defer { isLoading = false }
        
        let poll = Poll(name: newPollName.trimmingCharacters(in: .whitespacesAndNewlines),
                        totalCount: 0,
                        options: newPollOptions.map { Option(count: 0, name: $0) })
        do {
            try db.document("polls/\(poll.id)").setData(from: poll)
            self.newPollName = ""
            self.newOptionName = ""
            self.newPollOptions = []
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    func addOption() {
        self.newPollOptions.append(newOptionName.trimmingCharacters(in: .whitespacesAndNewlines))
        self.newOptionName = ""
    }
    
    @MainActor
    func joinExistingPoll() async throws {
        isLoading = true
        error = nil
        defer { isLoading = false }
        let existingPoll = try await db.document("polls/\(existingPollId)").getDocument()
        guard existingPoll.exists else {
            throw "Poll ID: \(existingPollId) doesn't exists"
        }
    }
    
}
