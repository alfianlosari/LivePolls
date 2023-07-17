//
//  PollOptionView.swift
//  LivePollsVision
//
//  Created by Alfian Losari on 16/07/23.
//

import SwiftUI

struct PollOptionView: View {
    
    @Environment(\.openWindow) private var openWindow
    @Environment(NavigationViewModel.self) private var navVM
    
    @Bindable var vm = PollOptionViewModel()
    
    var body: some View {
        List {
            if let error = vm.error {
                Text(error).foregroundStyle(Color.red)
            }
            
            existingPollSection
            createPollsSection
            addOptionsSection
            
        }
        .navigationTitle("Poll Options")
        .onDisappear {
            navVM.isShowingPollOption = false
        }
    }
    
    var existingPollSection: some View {
        Section {
            DisclosureGroup("Join a Poll") {
                TextField("Enter poll id", text: $vm.existingPollId)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                Button {
                    Task { @MainActor in
                        do {
                            try await vm.joinExistingPoll()
                            navVM.selectedPollId = vm.existingPollId
                            guard !navVM.isShowingPoll else { return }
                            navVM.isShowingPoll = true
                            openWindow(id: "Poll")
                        } catch {
                            vm.error = error.localizedDescription
                        }
                    }
                    
                } label: {
                    HStack {
                        Spacer()
                        Text("Join")
                        Spacer()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(vm.isJoinPollButtonDisabled)
            }
        }
    }
    
    var createPollsSection: some View {
        Section {
            TextField("Enter poll name", text: $vm.newPollName, axis: .vertical)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
            Button {
                Task { await vm.createNewPoll() }
            } label: {
                HStack {
                    Spacer()
                    Text("Submit")
                    Spacer()
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(vm.isCreateNewPollButtonDisabled)
            
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
            
            Button {
                vm.addOption()
            } label: {
                HStack {
                    Spacer()
                    Text("+ Add Option")
                    Spacer()
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(vm.isAddOptionsButtonDisabled)
            
            ForEach(vm.newPollOptions) {
                Text($0)
            }.onDelete { indexSet in
                vm.newPollOptions.remove(atOffsets: indexSet)
            }
        }
    }
}

//#Preview {
//    PollOptionView()
//}
