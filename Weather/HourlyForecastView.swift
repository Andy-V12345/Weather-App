//
//  DailyForecastView.swift
//  Weather
//
//  Created by Andy Vu on 8/24/22.
//

import SwiftUI

struct HourlyForecastView: View {
    
    var time: String
    var temp: String
    var icon: String
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(time)
                .font(.subheadline)
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon).png")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            
            
            Text(temp)
                .font(.headline)
        }
        .padding()
    }
}

struct HourlyForecastView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyForecastView(time: "12 pm", temp: "89°", icon: "01d")
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
