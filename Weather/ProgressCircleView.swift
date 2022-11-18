//
//  ProgressCircleView.swift
//  Weather
//
//  Created by Andy Vu on 8/30/22.
//

import SwiftUI

struct ProgressCircleView: View {
    
    var progress: Int
    var color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color, lineWidth: 6)
                .opacity(0.4)
                .frame(width: 63, height: 63, alignment: .leading)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(Double(self.progress) / 100, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .frame(width: 63, height: 63, alignment: .leading)
                .rotationEffect(Angle(degrees: 270))
            Text("\(progress)%")
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 5)
        }
    }
}

struct ProgressCircleView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressCircleView(progress: 100, color: .blue)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
