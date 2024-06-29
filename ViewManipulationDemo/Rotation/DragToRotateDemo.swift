//
//  DragToRotateDemo.swift
//  ViewManipulationDemo
//
//  Created by Itsuki on 2024/06/29.
//

import SwiftUI

struct DragToRotateDemo: View {
    
    @State private var angleTemp: CGFloat = 0
    @State private var angle: CGFloat = 0
    
    private let borderWidth: CGFloat = 3
    private let viewSize: CGSize = CGSize(width: 60, height: 60)
    private let cornerSize: CGSize = CGSize(width: 20, height: 20)
    

    var body: some View {
        let diagonalRadius = sqrt(pow(viewSize.width, 2) + pow(viewSize.height, 2))
        
        Image(systemName: "dog.fill")
            .resizable()
            .frame(width: viewSize.width, height: viewSize.height)
            .padding(.horizontal, viewSize.width/2)
            .padding(.vertical, viewSize.height/2)
            .foregroundStyle(.white)
            .background(Circle().fill(.black))
            .rotationEffect(.degrees(angleTemp))
            .overlay(content: {
                Rectangle()
                    .fill(.clear)
                    .border(.red, width: borderWidth)
                    .rotationEffect(.degrees(angleTemp))

            })
            .overlay(content: {
                Rectangle()
                    .fill(.clear)
                    .corner(size: CGSize(width: cornerSize.width, height: cornerSize.height), anchors: [.topLeading, .topTrailing, .bottomTrailing, .bottomLeading], color: .red)
                    .rotationEffect(.degrees(angleTemp))
                    .gesture(
                        DragGesture()
                            .onChanged({gesture in
                                let currentLocation = gesture.location
                                let currentAngle = atan2(currentLocation.x - diagonalRadius, diagonalRadius - currentLocation.y)

                                let startLocation = gesture.startLocation
                                let startAngle = atan2(startLocation.x - diagonalRadius, diagonalRadius - startLocation.y)
                                var theta = (currentAngle - startAngle) * 180 / .pi
                                if theta < 0 {
                                    theta = theta + 360
                                }

                                angleTemp = angle + theta
                                
                            })
                            .onEnded({ _ in
                                angle = angleTemp
                            })
                    )
            })
    }
}



#Preview {
    DragToRotateDemo()
}
