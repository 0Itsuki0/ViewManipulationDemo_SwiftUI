//
//  DragOnlyDemo.swift
//  ViewManipulationDemo
//
//  Created by Itsuki on 2024/06/29.
//

import SwiftUI

struct DragOnlyDemo: View {
    
    @State private var anchor: UnitPoint = .topLeading
    @State private var viewPosition: CGPoint = CGPoint(x: 150, y: 250)
    @State private var viewOffsetTemp: CGSize = .zero

    @State private var viewSize: CGSize = CGSize(width: 120, height: 120)
    @State private var viewScaleTemp: CGSize = CGSize(width: 1, height: 1)

    @State private var angleTemp: CGFloat = 60
    @State private var angle: CGFloat = 60
    
    @State private var isResizing: Bool = false
    @State private var isRotating: Bool = false
    
    
    private let minSize: CGSize = CGSize(width: 50, height: 50)
    private let translationFactor: CGFloat = 0.5
    private let borderWidth: CGFloat = 3
    private let cornerSize: CGSize = CGSize(width: 20, height: 20)

    var body: some View {
        
        Image(systemName: "dog.fill")
            .resizable()
            .foregroundStyle(.black)
            .frame(width: viewSize.width, height: viewSize.height)
            .scaleEffect(viewScaleTemp, anchor: anchor)
            .rotationEffect(.degrees(angleTemp))
            .offset(viewOffsetTemp)
            .highPriorityGesture(positionGesture)
            // top edge
            .overlay(content: {
                makeEdge(for: .top)
            })
            // bottom edge
            .overlay(content: {
                makeEdge(for: .bottom)
            })
            // leading edge
            .overlay(content: {
                makeEdge(for: .leading)
            })
            // trailing edge
            .overlay(content: {
                makeEdge(for: .trailing)
            })
            // top leading corner
            .overlay(content: {
                makeCorner(for: .topLeading)
            })
            // top trailing corner
            .overlay(content: {
                makeCorner(for: .topTrailing)
            })
            // bottom leading corner
            .overlay(content: {
                makeCorner(for: .bottomLeading)
            })
            // bottom trailing corner
            .overlay(content: {
                makeCorner(for: .bottomTrailing)
            })
            .position(viewPosition)

    }
}

extension DragOnlyDemo {
    func makeCorner(for corner: UnitPoint) -> some View {
        
        let targetAnchor: UnitPoint =
        switch corner {
        case .topLeading:
            .bottomTrailing
        case .topTrailing:
            .bottomLeading
        case .bottomTrailing:
            .topLeading
        case .bottomLeading:
            .topTrailing
        default:
            .center
        }
        
        return Rectangle()
            .fill(.clear)
            .corner(size: CGSize(width: cornerSize.width/viewScaleTemp.width, height: cornerSize.height/viewScaleTemp.height), anchors: [corner], color: .red)
            .scaleEffect(viewScaleTemp, anchor: anchor)
            .rotationEffect(.degrees(angleTemp))
            .offset(viewOffsetTemp)
            .simultaneousGesture(DragGesture()
                .onChanged({ gesture in
                    onResizingGestureChanged(gesture.translation, targetAnchor: targetAnchor)
                })
                .onEnded({gesture in
                    onResizingGestureEnded(currentAnchor: targetAnchor)
                })
            )
            .simultaneousGesture(rotationGesture)
    }
    
    
    func makeEdge(for edge: Edge) -> some View {
        let targetAnchor: UnitPoint =
        switch edge {
        case .top:
            .bottomTrailing
        case .bottom:
            .topLeading
        case .leading:
            .bottomTrailing
        case .trailing:
            .topLeading
        }
        
        let scaledWidth: CGFloat =
        switch edge {
        case .top:
            borderWidth/viewScaleTemp.height
        case .bottom:
            borderWidth/viewScaleTemp.height
        case .leading:
            borderWidth/viewScaleTemp.width
        case .trailing:
            borderWidth/viewScaleTemp.width
        }
        
        return Rectangle()
            .fill(.clear)
            .border(width: scaledWidth, edges: [edge], color: .red)
            .scaleEffect(viewScaleTemp, anchor: anchor)
            .rotationEffect(.degrees(angleTemp))
            .offset(viewOffsetTemp)
            .gesture(DragGesture()
                .onChanged({ gesture in
                    onResizingGestureChanged(gesture.translation, targetAnchor: targetAnchor, edge: edge)

                })
                .onEnded({gesture in
                    onResizingGestureEnded(currentAnchor: targetAnchor)
                })
            )
    }
}

extension DragOnlyDemo {
    var positionGesture: some Gesture {
        DragGesture()
            .onChanged({ gesture in
                viewOffsetTemp = gesture.translation
            })
            .onEnded({ _ in
                viewPosition.x = viewPosition.x + viewOffsetTemp.width
                viewPosition.y = viewPosition.y + viewOffsetTemp.height
                viewOffsetTemp = .zero
            })
    }
    
    
    var rotationGesture: some Gesture {
        LongPressGesture(minimumDuration: 0.4, maximumDistance: 0.5)
            .onEnded({isPressing in
                guard isPressing else {return}
                guard !isResizing else {return}
                isRotating = true
            })
            .simultaneously(with: DragGesture(minimumDistance: 0)
                .onChanged({gesture in
                    onRotatingGestureChanged(start: gesture.startLocation, current: gesture.location)
                })
                .onEnded({ _ in
                    onRotatingGestureEnded()
                }))
     }
    
    private func onRotatingGestureChanged(start: CGPoint, current: CGPoint) {
        guard isRotating else {return}
        guard !isResizing else {return}

        let diagonalRadius = sqrt(pow(viewSize.width, 2) + pow(viewSize.height, 2))
        let currentAngle = atan2(current.x - diagonalRadius/2, diagonalRadius/2 - current.y)
        let startAngle = atan2(start.x - diagonalRadius/2, diagonalRadius/2 - start.y)
//        let currentAngle = atan2(current.x - diagonalRadius, diagonalRadius - current.y)
//        let startAngle = atan2(start.x - diagonalRadius, diagonalRadius - start.y)
        var theta = (currentAngle - startAngle) * 180 / .pi + angle
        if theta < 0 {
            theta = theta + 360
        }
        if theta > 360 {
            theta = theta - 360
        }
        angleTemp = theta
    }
    
    private func onRotatingGestureEnded() {
        guard isRotating else {return}
        isRotating = false
        angle = angleTemp
    }
    
    
    private func onResizingGestureChanged(_ translation: CGSize, targetAnchor: UnitPoint, edge: Edge? = nil) {
        guard !isRotating else {return}

        isResizing = true
        anchor = targetAnchor

        let signX: CGFloat = targetAnchor.x == 0 ? 1 : -1
        let signY: CGFloat = targetAnchor.y == 0 ? 1 : -1
                
        let rawChangeX = translation.width * translationFactor
        let rawChangeY = translation.height * translationFactor
        
        let angleRaw = atan2(rawChangeX, rawChangeY)

        let totalChange = sqrt(pow(rawChangeX, 2) + pow(rawChangeY, 2))
    
        var actualChangeX = totalChange * sin(angleRaw + angle*(.pi)/180)
        var actualChangeY = totalChange * cos(angleRaw + angle*(.pi)/180)
        
        switch edge {
        case .top:
            actualChangeX = 0
        case .bottom:
            actualChangeX = 0
        case .leading:
            actualChangeY = 0
        case .trailing:
            actualChangeY = 0
        default:
            break
        }
        
        let newHeight = max(minSize.height, viewSize.height + signY * actualChangeY)
        let newWidth = max(minSize.width, viewSize.width + signX * actualChangeX)
        
        viewScaleTemp.height = newHeight / viewSize.height
        viewScaleTemp.width = newWidth / viewSize.width
    }
    
    private func onResizingGestureEnded(currentAnchor: UnitPoint) {
        guard isResizing else {return}

        isResizing = false
        anchor = .center
        
        let signX: CGFloat = currentAnchor.x == 0 ? -1 : 1
        let signY: CGFloat = currentAnchor.y == 0 ? -1 : 1
        
        let rawChangeX = signX * viewSize.width * (1-viewScaleTemp.width)
        let rawChangeY = signY * viewSize.height * (1-viewScaleTemp.height)
        
        let angleRaw = atan2(rawChangeX, rawChangeY)

        
        let totalChange = sqrt(pow(rawChangeX, 2) + pow(rawChangeY, 2))
        let actualChangeX = totalChange * sin(angleRaw - angle*(.pi)/180)/2
        let actualChangeY = totalChange * cos(angleRaw - angle*(.pi)/180)/2

        viewPosition.x = viewPosition.x + actualChangeX
        viewSize.width = viewSize.width * viewScaleTemp.width
        viewScaleTemp.width = 1

        viewPosition.y = viewPosition.y + actualChangeY
        viewSize.height = viewSize.height * viewScaleTemp.height
        viewScaleTemp.height = 1
    }
    
}


#Preview {
    DragOnlyDemo()
}
