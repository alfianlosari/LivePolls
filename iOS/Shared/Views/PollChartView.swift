//
//  PollChartView.swift
//  LivePolls
//
//  Created by Alfian Losari on 09/07/23.
//

import Charts
import SwiftUI

struct PollChartView: View {
    
    let options: [Option]
    
    var body: some View {
        Chart {
            ForEach(options) { option in
                SectorMark(
                    angle: .value("Count", option.count),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .cornerRadius(5)
                .foregroundStyle(by: .value("Name", option.name))
            }
        }
    }
}

#Preview {
    PollChartView(options: [
        .init(count: 2, name: "PS5"),
        .init(count: 1, name: "Xbox SX"),
        .init(count: 2, name: "Switch"),
        .init(count: 1, name: "PC")
    ])
}
