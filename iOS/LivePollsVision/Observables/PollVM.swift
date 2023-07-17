//
//  PollVM.swift
//  LivePollsVision
//
//  Created by Alfian Losari on 16/07/23.
//

import FirebaseFirestore
import Foundation
import SwiftUI
import Observation

@Observable
class PollViewModel {
    
    let db = Firestore.firestore()
    var pollId: String = ""
    
    var poll: Poll? = nil
    
    var listenerToken: ListenerRegistration? = nil
    
    init(pollId: String = "", poll: Poll? = nil) {
        self.pollId = pollId
        self.poll = poll
    }
    
    @MainActor
    func listenToPoll() {
        poll = nil
        removeListener()
        
        guard !pollId.isEmpty else { return }
        db.document("polls/\(pollId)")
            .addSnapshotListener { snapshot, error in
                guard let snapshot else { return }
                do {
                    let poll = try snapshot.data(as: Poll.self)
                    withAnimation {
                        self.poll = poll
                    }
                } catch {
                    print("Failed to fetch poll")
                }
            }
    }
    
    func incrementOption(_ option: Option) {
        guard let index = poll?.options.firstIndex(where: {$0.id == option.id}) else { return }
        db.document("polls/\(pollId)")
            .updateData([
                "totalCount": FieldValue.increment(Int64(1)),
                "option\(index).count": FieldValue.increment(Int64(1)),
                "lastUpdatedOptionId": option.id,
                "updatedAt": FieldValue.serverTimestamp()
            ]) { error in
                print(error?.localizedDescription ?? "")
            }
    }
    
    func updatePoll(id: String) {
        self.pollId = id
        Task { await self.listenToPoll() }
    }
 
    func removeListener() {
        listenerToken?.remove()
        listenerToken = nil
    }
    
}
