//
//  PollView.swift
//  LivePollsVision
//
//  Created by Alfian Losari on 16/07/23.
//

import SwiftUI

struct PollView: View {
    
    var vm = PollViewModel()
    @Environment(NavigationViewModel.self) private var navVM
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading) {
                    Text("Poll ID")
                    Text(vm.pollId)
                        .font(.caption)
                        .textSelection(.enabled)
                }
                
                HStack {
                    Text("Updated at")
                    Spacer()
                    if let updatedAt = vm.poll?.updatedAt {
                        Text(updatedAt, style: .time)
                    }
                }
                
                HStack {
                    Text("Total Vote Count")
                    Spacer()
                    if let totalCount = vm.poll?.totalCount {
                        Text(String(totalCount))
                    }
                }
            }
            
            if let options = vm.poll?.options {
                Section {
                    PollChartView(options: options)
                        .frame(height: 200)
                        .padding(.vertical)
                }
                
                Section("Vote") {
                    ForEach(options) { option in
                        Button(action: {
                            vm.incrementOption(option)
                        }, label: {
                            HStack {
                                Text("+1")
                                Text(option.name)
                                Spacer()
                                Text(String(option.count))
                            }
                        })
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
        .navigationTitle(vm.poll?.name ?? "")
        .onAppear {
            vm.updatePoll(id: navVM.selectedPollId)
        }
        .onDisappear {
            vm.removeListener()
            navVM.isShowingPoll = false
        }
        .onChange(of: navVM.selectedPollId) { _, newValue in
            vm.updatePoll(id: newValue)
        }
        
    }
}
//
//#Preview {
//    PollView()
//}
