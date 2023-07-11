//
//  HomeView.swift
//  LivePolls
//
//  Created by Alfian Losari on 09/07/23.
//

import SwiftUI

struct HomeView: View {
    
    @Bindable var vm = HomeViewModel()
    
    var body: some View {
        List {
            existingPollSection
            livePollsSection
            createPollsSection
            addOptionsSection
        }
        .scrollDismissesKeyboard(.interactively)
        .alert("Error", isPresented: .constant(vm.error != nil)) {
            
        } message: {
            Text(vm.error ?? "an error occured")
        }
        .sheet(item: $vm.modalPollId) { id in
            NavigationStack {
                PollView(vm: .init(pollId: id))
            }
        }
        .navigationTitle("XCA LivePolls")
        .onAppear {
            vm.listenToLivePolls()
        }
    }
    
    var existingPollSection: some View {
        Section {
            DisclosureGroup("Join a Poll") {
                TextField("Enter poll id", text: $vm.existingPollId)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                Button("Join") {
                    Task { await vm.joinExistingPoll() }
                }
            }
        }
    }
    
    var livePollsSection: some View {
        Section {
            DisclosureGroup("Latest Live Polls") {
                ForEach(vm.polls) { poll in
                    VStack {
                        HStack(alignment: .top) {
                            Text(poll.name)
                            Spacer()
                            Image(systemName: "chart.bar.xaxis")
                            Text(String(poll.totalCount))
                            if let updatedAt = poll.updatedAt {
                                Image(systemName: "clock.fill")
                                Text(updatedAt, style: .time)
                            }
                        }
                        PollChartView(options: poll.options)
                            .frame(height: 160)
                    }
                    .padding(.vertical)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        vm.modalPollId = poll.id
                    }
                }
            }
            
        }
    }
    
    var createPollsSection: some View {
        Section {
            TextField("Enter poll name", text: $vm.newPollName, axis: .vertical)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
            Button("Submit") {
                Task { await vm.createNewPoll() }
            }.disabled(vm.isCreateNewPollButtonDisabled)
            
            if vm.isLoading {
                ProgressView()
            }
        } header: {
            Text("Create a Poll")
        } footer: {
            Text("Enter poll name & add 2-4 options to submit")
        }
    }
    
    var addOptionsSection: some View {
        Section("Options") {
            TextField("Enter option name", text: $vm.newOptionName)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
            Button("+ Add Option") {
                vm.addOption()
            }.disabled(vm.isAddOptionsButtonDisabled)
            
            ForEach(vm.newPollOptions) {
                Text($0)
            }.onDelete { indexSet in
                vm.newPollOptions.remove(atOffsets: indexSet)
            }
        }
    }
}

extension String: Identifiable {
    public var id: Self { self }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
