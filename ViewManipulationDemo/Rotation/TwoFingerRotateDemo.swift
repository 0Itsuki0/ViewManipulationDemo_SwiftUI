//
//  TwoFingerRotationDemo.swift
//  ViewManipulationDemo
//
//  Created by Itsuki on 2024/06/29.
//

import SwiftUI

struct TwoFingerRotateDemo: View {
    @State private var angleTemp: CGFloat = 0
    @State private var angle: CGFloat = 0
    
    private let viewSize: CGSize = CGSize(width: 60, height: 60)
    
    var body: some View {
        Image(systemName: "dog.fill")
            .resizable()
            .frame(width: viewSize.width, height: viewSize.height)
            .padding(.horizontal, viewSize.width/2)
            .padding(.vertical, viewSize.height/2)
            .foregroundStyle(.white)
            .background(Circle().fill(.black))
            .rotationEffect(.degrees(angleTemp))

            .gesture(
                RotateGesture(minimumAngleDelta: .degrees(0))
                    .onChanged({ gesture in
                        angleTemp = angle + gesture.rotation.degrees
                    })
                    .onEnded({ _ in
                        angle = angleTemp
                    })
            )

    }
}

#Preview {
    TwoFingerRotateDemo()
}
