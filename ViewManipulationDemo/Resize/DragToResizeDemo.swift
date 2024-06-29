//
//  ViewManipulationDemo.swift
//  ViewManipulationDemo
//
//  Created by Itsuki on 2024/06/28.

import SwiftUI

struct DragToResizeDemo: View {
    
    @State private var anchor: UnitPoint = .topLeading
    @State private var viewPosition: CGPoint = CGPoint(x: 150, y: 250)
    
    @State private var viewSize: CGSize = CGSize(width: 60, height: 60)
    @State private var viewScaleTemp: CGSize = CGSize(width: 1, height: 1)
    private let minSize: CGSize = CGSize(width: 30, height: 30)

    private let translationFactor: CGFloat = 0.5
    private let borderWidth: CGFloat = 3
    private let cornerSize: CGSize = CGSize(width: 20, height: 20)

    var body: some View {
        
        
        Image(systemName: "dog.fill")
            .resizable()
            .frame(width: viewSize.width, height: viewSize.height)
            .padding(.horizontal, viewSize.width/2)
            .padding(.vertical, viewSize.height/2)
            .foregroundStyle(.white)
            .background(Ellipse().fill(.black))
            .scaleEffect(viewScaleTemp, anchor: anchor)
            // top edge
            .overlay(content: {
                Rectangle()
                    .fill(.clear)
                    .border(width: borderWidth/viewScaleTemp.height, edges: [.top], color: .red)
                    .scaleEffect(viewScaleTemp, anchor: anchor)
                    .gesture(DragGesture()
                        .onChanged({ gesture in
                            onDragGestureChanged(CGSize(width: 0, height: gesture.translation.height), targetAnchor: .bottomTrailing)

                        })
                        .onEnded({gesture in
                            onDragGestureEnded(currentAnchor: .bottomTrailing)
                        })
                    )
            })
            // bottom edge
            .overlay(content: {
                Rectangle()
                    .fill(.clear)
                    .border(width: borderWidth/viewScaleTemp.height, edges: [.bottom], color: .red)
                    .scaleEffect(viewScaleTemp, anchor: anchor)
                    .gesture(DragGesture()
                        .onChanged({ gesture in
                            onDragGestureChanged(CGSize(width: 0, height: gesture.translation.height), targetAnchor: .topLeading)

                        })
                        .onEnded({gesture in
                            onDragGestureEnded(currentAnchor: .topLeading)
                        })
                    )
            })
            // leading edge
            .overlay(content: {
                Rectangle()
                    .fill(.clear)
                    .border(width: borderWidth/viewScaleTemp.width, edges: [.leading], color: .red)
                    .scaleEffect(viewScaleTemp, anchor: anchor)
                    .gesture(DragGesture()
                        .onChanged({ gesture in
                            onDragGestureChanged(CGSize(width: gesture.translation.width, height: 0), targetAnchor: .bottomTrailing)

                        })
                        .onEnded({gesture in
                            onDragGestureEnded(currentAnchor: .bottomTrailing)
                        })
                    )
            })
            // trailing edge
            .overlay(content: {
                Rectangle()
                    .fill(.clear)
                    .border(width: borderWidth/viewScaleTemp.width, edges: [.trailing], color: .red)
                    .scaleEffect(viewScaleTemp, anchor: anchor)
                    .gesture(DragGesture()
                        .onChanged({ gesture in
                            onDragGestureChanged(CGSize(width: gesture.translation.width, height: 0), targetAnchor: .topLeading)

                        })
                        .onEnded({gesture in
                            onDragGestureEnded(currentAnchor: .topLeading)
                        })
                    )
            })
            // top leading corner
            .overlay(content: {
                Rectangle()
                    .fill(.clear)
                    .corner(size: CGSize(width: cornerSize.width/viewScaleTemp.width, height: cornerSize.height/viewScaleTemp.height), anchors: [.topLeading], color: .red)
                    .scaleEffect(viewScaleTemp, anchor: anchor)
                    .gesture(DragGesture()
                        .onChanged({ gesture in
                            onDragGestureChanged(gesture.translation, targetAnchor: .bottomTrailing)
                        })
                        .onEnded({gesture in
                            onDragGestureEnded(currentAnchor: .bottomTrailing)
                        })
                    )
            })
            // top trailing corner
            .overlay(content: {
                Rectangle()
                    .fill(.clear)
                    .corner(size: CGSize(width: cornerSize.width/viewScaleTemp.width, height: cornerSize.height/viewScaleTemp.height), anchors: [.topTrailing], color: .red)
                    .scaleEffect(viewScaleTemp, anchor: anchor)
                    .gesture(DragGesture()
                        .onChanged({ gesture in
                            onDragGestureChanged(gesture.translation, targetAnchor: .bottomLeading)
                        })
                        .onEnded({gesture in
                            onDragGestureEnded(currentAnchor: .bottomLeading)
                        })
                    )
            })
            // bottom leading corner
            .overlay(content: {
                Rectangle()
                    .fill(.clear)
                    .corner(size: CGSize(width: cornerSize.width/viewScaleTemp.width, height: cornerSize.height/viewScaleTemp.height), anchors: [.bottomLeading], color: .red)
                    .scaleEffect(viewScaleTemp, anchor: anchor)
                    .gesture(DragGesture()
                        .onChanged({ gesture in
                            onDragGestureChanged(gesture.translation, targetAnchor: .topTrailing)

                        })
                        .onEnded({gesture in
                            onDragGestureEnded(currentAnchor: .topTrailing)
                        })
                    )
            })
            // bottom trailing corner
            .overlay(content: {
                Rectangle()
                    .fill(.clear)
                    .corner(size: CGSize(width: cornerSize.width/viewScaleTemp.width, height: cornerSize.height/viewScaleTemp.height), anchors: [.bottomTrailing], color: .red)
                    .scaleEffect(viewScaleTemp, anchor: anchor)
                    .gesture(DragGesture()
                        .onChanged({ gesture in
                            onDragGestureChanged(gesture.translation, targetAnchor: .topLeading)

                        })
                        .onEnded({gesture in
                            onDragGestureEnded(currentAnchor: .topLeading)
                        })
                    )
            })
            .position(viewPosition)

    }
    
    private func onDragGestureChanged(_ translation: CGSize, targetAnchor: UnitPoint) {
        anchor = targetAnchor

        let signX: CGFloat = targetAnchor.x == 0 ? 1 : -1
        let signY: CGFloat = targetAnchor.y == 0 ? 1 : -1
        
        let newHeight = max(minSize.height, viewSize.height + signY * translation.height * translationFactor)

        viewScaleTemp.height = newHeight / viewSize.height
        
        let newWidth = max(minSize.width, viewSize.width + signX * translation.width * translationFactor)
        viewScaleTemp.width = newWidth / viewSize.width
    }
    
    private func onDragGestureEnded(currentAnchor: UnitPoint) {
        
        anchor = .center
        
        let signX: CGFloat = currentAnchor.x == 0 ? -1 : 1
        let signY: CGFloat = currentAnchor.y == 0 ? -1 : 1
        
        viewPosition.x = viewPosition.x + signX * viewSize.width * (1-viewScaleTemp.width)
        viewSize.width = viewSize.width * viewScaleTemp.width
        viewScaleTemp.width = 1

        viewPosition.y = viewPosition.y + signY * viewSize.height * (1-viewScaleTemp.height)
        viewSize.height = viewSize.height * viewScaleTemp.height
        viewScaleTemp.height = 1
    }
}


#Preview {
    DragToResizeDemo()
}

