//
//  CompassPointer.swift
//  Weather
//
//  Created by Andy Vu on 9/2/22.
//

import SwiftUI

struct CompassPointer: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Image(systemName: "circle.fill")
                .imageScale(.small)
            Rectangle()
                .frame(width: 1.5)
            Image(systemName: "arrowtriangle.down.fill")
        }
    }
}

struct CompassPointer_Previews: PreviewProvider {
    static var previews: some View {
        CompassPointer()
    }
}
