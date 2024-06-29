//
//  ZoomToResizeDemo.swift
//  ViewManipulationDemo
//
//  Created by Itsuki on 2024/06/28.
//

import SwiftUI

struct PinchToResizeDemo: View {
    
    @State private var viewScale: CGFloat = 1.0
    @State private var viewSize: CGSize = CGSize(width: 60, height: 60)

    
    var body: some View {
        Image(systemName: "dog.fill")
            .resizable()
            .frame(width: viewSize.width, height: viewSize.height)
            .padding(.horizontal, viewSize.width/2)
            .padding(.vertical, viewSize.height/2)
            .foregroundStyle(.white)
            .background(Circle().fill(.black))
            .scaleEffect(viewScale)
            .gesture(
                MagnifyGesture(minimumScaleDelta: 0)
                    .onChanged({gesture in
                        viewScale = gesture.magnification
                    })
                    .onEnded({gesture in
                        viewSize = CGSize(width: viewSize.width * gesture.magnification, height: viewSize.height * gesture.magnification)
                        viewScale = 1
                    })
            )
    }
}


#Preview {
    PinchToResizeDemo()
}
