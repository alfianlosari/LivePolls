//
//  HomeVM.swift
//  LivePolls
//
//  Created by Alfian Losari on 09/07/23.
//

import FirebaseFirestore
import Foundation
import SwiftUI
import Observation

@Observable
class HomeViewModel {
    
    let db = Firestore.firestore()
    var polls = [Poll]()
    var modalPollId: String? = nil
    
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
    func listenToLivePolls() {
        db.collection("polls")
            .order(by: "updatedAt", descending: true)
            .limit(toLast: 10)
            .addSnapshotListener { snapshot, error in
                guard let snapshot else {
                    print("Error fetching snapshot: \(error?.localizedDescription ?? "error")")
                    return
                }
                let docs = snapshot.documents
                let polls = docs.compactMap {
                    try? $0.data(as: Poll.self)
                }
                
                withAnimation {
                    self.polls = polls
                }
            }
    }
    
    @MainActor
    func createNewPoll() async {
        isLoading = true
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
    func joinExistingPoll() async {
        isLoading = true
        defer { isLoading = false }
        guard let existingPoll = try? await db.document("polls/\(existingPollId)").getDocument(),
              existingPoll.exists else {
            error = "Poll ID: \(existingPollId) doesn't exists"
            return
        }
        modalPollId = existingPollId
    }
    
}
