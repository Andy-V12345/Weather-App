//
//  CompassView.swift
//  Weather
//
//  Created by Andy Vu on 8/31/22.
//

import SwiftUI

struct CompassView: View {
    
    var speed: Int
    var windDir: Int
    
    var body: some View {
        ZStack {
            CompassMarkerView()
            
            CompassPointer()
                .rotationEffect(Angle(degrees: Double(windDir)))
                .frame(height: 162)
            
            Circle()
                .frame(width: 70, height: 70)
                .foregroundStyle(.ultraThinMaterial)
            
            VStack {
                Text("\(speed)")
                    .fontWeight(.bold)
                Text("mph")
                    .font(.caption)
                
            }
            
            
        }
        
    }
}

struct CompassView_Previews: PreviewProvider {
    static var previews: some View {
        CompassView(speed: 5, windDir: 30)
    }
}
