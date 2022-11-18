//
//  DailyForecastView.swift
//  Weather
//
//  Created by Andy Vu on 8/25/22.
//

import SwiftUI

struct DailyForecastView: View {
    
    var date: String
    var icon: String
    var low: Int
    var high: Int
    
    var body: some View {
        HStack(spacing: 8) {
            Text(date)
                .font(.headline)
                .fontWeight(.medium)
            Spacer()
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon).png")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
            } placeholder: {
                ProgressView()
            }
            Spacer()
            Text("L: \(low)°")
                .font(.subheadline)
            Spacer()
            Text("H: \(high)°")
                .font(.subheadline)
        }
    }
}

struct DailyForecastView_Previews: PreviewProvider {
    static var previews: some View {
        DailyForecastView(date: "Today", icon: "01d", low: 60, high: 90)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
