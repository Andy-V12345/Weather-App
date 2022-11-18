//
//  CompassMarkerView.swift
//  Weather
//
//  Created by Andy Vu on 8/31/22.
//

import SwiftUI

struct Marker: Hashable {
    let degrees: Double
    let label: String
    
    init(degrees: Double, label: String = "") {
        self.degrees = degrees
        self.label = label
    }
    
    
    
    static func markers() -> [Marker] {
        var markers: [Marker] = []
        for i in 0...71 {
            if i == 0 {
                markers.append(Marker(degrees: Double(i)*5, label: "S"))
            }
            else if i == 18 {
                markers.append(Marker(degrees: Double(i)*5, label: "W"))
            }
            else if i == 36 {
                markers.append(Marker(degrees: Double(i)*5, label: "N"))
            }
            else if i == 54 {
                markers.append(Marker(degrees: Double(i)*5, label: "E"))
            }
            else {
                markers.append(Marker(degrees: Double(i)*5))
            }
        }
        
        return markers
    }
}

struct CompassMarkerView: View {
    
    private func textAngle(marker: Marker) -> Angle {
        return Angle(degrees: 0 - marker.degrees)
    }
    
    private func markerOpacity(marker: Marker) -> Double {
        return marker.label == "" ? 0.7 : 1
    }
    
    var markers: [Marker] = Marker.markers()
    
    var body: some View {
        ZStack {
            ForEach(markers, id: \.self) { marker in
                VStack() {
                    Capsule()
                        .frame(width: 3, height: 15)
                        .foregroundColor(Color.gray)
                        .opacity(markerOpacity(marker: marker))
                        .padding(.bottom, 105)
                    
                    Text(marker.label)
                        .font(.footnote)
                        .fontWeight(.bold)
                        .rotationEffect(textAngle(marker: marker))
                        .padding(.bottom, 25)
                    
                }
                .rotationEffect(Angle(degrees: marker.degrees))
            }
            

            
        }
        .rotationEffect(Angle(degrees: 0))
        
    }
}

struct CompassMarkerView_Previews: PreviewProvider {
    static var previews: some View {
        CompassMarkerView()
    
    }
}
