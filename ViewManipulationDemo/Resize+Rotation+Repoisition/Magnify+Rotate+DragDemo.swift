//
//  Magnify+Rotate+DragDemo.swift
//  ViewManipulationDemo
//
//  Created by Itsuki on 2024/06/29.
//

import SwiftUI

struct MagnifyRotateDragDemo: View {
    
    @State private var viewScale: CGFloat = 1.0
    @State private var viewSize: CGSize = CGSize(width: 60, height: 60)
    
    @State private var angleTemp: CGFloat = 0
    @State private var angle: CGFloat = 0
    
    @State private var viewPosition: CGPoint = CGPoint(x: 150, y: 250)
    @State private var viewOffsetTemp: CGSize = .zero

    
    var body: some View {
        Image(systemName: "dog.fill")
            .resizable()
            .frame(width: viewSize.width, height: viewSize.height)
            .padding(.horizontal, viewSize.width/2)
            .padding(.vertical, viewSize.height/2)
            .foregroundStyle(.white)
            .background(Circle().fill(.black))
            .scaleEffect(viewScale)
            .rotationEffect(.degrees(angleTemp))
            .offset(viewOffsetTemp)
            .position(viewPosition)
            .simultaneousGesture(
                MagnifyGesture(minimumScaleDelta: 0)
                    .onChanged({gesture in
                        viewScale = gesture.magnification
                    })
                    .onEnded({gesture in
                        viewSize = CGSize(width: viewSize.width * gesture.magnification, height: viewSize.height * gesture.magnification)
                        viewScale = 1
                    })
            )
            .simultaneousGesture(
                RotateGesture(minimumAngleDelta: .degrees(0))
                    .onChanged({ gesture in
                        angleTemp = angle + gesture.rotation.degrees
                    })
                    .onEnded({ _ in
                        angle = angleTemp
                    })
            )
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ gesture in
                        viewOffsetTemp = gesture.translation
                    })
                    .onEnded({ _ in
                        viewPosition.x = viewPosition.x + viewOffsetTemp.width
                        viewPosition.y = viewPosition.y + viewOffsetTemp.height
                        viewOffsetTemp = .zero
                    })
            )
            
    }
}


#Preview {
    MagnifyRotateDragDemo()
}
