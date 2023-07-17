//
//  PollsListView.swift
//  LivePollsVision
//
//  Created by Alfian Losari on 16/07/23.
//

import SwiftUI

struct PollListView: View {
    
    var vm = PollListViewModel()
    @Environment(\.openWindow) private var openWindow
    @Environment(NavigationViewModel.self) private var navVM
    
    private let gridItems: [GridItem] = [.init(.adaptive(minimum: 300), spacing: 16)]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems) {
                ForEach(vm.polls) { poll in
                    Button {
                        navVM.selectedPollId = poll.id
                        guard !navVM.isShowingPoll else { return }
                        navVM.isShowingPoll = true
                        openWindow(id: "Poll")
                    } label: {
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
                        .padding(.vertical, 30)
                    }
                    .buttonStyle(.borderless)
                    .buttonBorderShape(.roundedRectangle(radius: 20))
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 30)
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    navVM.isShowingPollOption = true
                    openWindow(id: "PollOption")
                } label: {
                    Text("Options")
                }.disabled(navVM.isShowingPollOption)
            }
        }
        .navigationTitle("XCA LivePolls Vision")
        .onAppear {
            vm.listenToLivePolls()
        }
    }
}

//#Preview {
//    PollsListView()
//}
