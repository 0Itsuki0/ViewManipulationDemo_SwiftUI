//
//  viewExtensions.swift
//  ViewManipulationDemo
//
//  Created by Itsuki on 2024/06/29.
//

import SwiftUI


extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
    
    func corner(size: CGSize, anchors: [UnitPoint], color: Color) -> some View {
        overlay(CornerRect(size: size, anchors: anchors).foregroundColor(color))
    }
}

struct CornerRect: Shape {
    var size: CGSize
    var anchors: [UnitPoint]

    func path(in rect: CGRect) -> Path {
        anchors.map { anchor -> Path in
            switch anchor {
            case .topLeading:
                return Path(.init(x: rect.minX - size.width*0.25, y: rect.minY - size.height*0.25, width: size.width, height: size.height))
            case .topTrailing:
                return Path(.init(x: rect.maxX - size.width*0.75, y: rect.minY - size.height*0.25, width: size.width, height: size.height))
            case .bottomLeading:
                return Path(.init(x: rect.minX - size.width*0.25, y: rect.maxY - size.height*0.75, width: size.width, height: size.height))
            case .bottomTrailing:
                return Path(.init(x: rect.maxX - size.width*0.75, y: rect.maxY - size.height*0.75, width: size.width, height: size.height))
            default:
                return Path(CGRect.zero)
            }
        }.reduce(into: Path()) { $0.addPath($1) }

    }
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        edges.map { edge -> Path in
            switch edge {
            case .top: return Path(.init(x: rect.minX, y: rect.minY, width: rect.width, height: width))
            case .bottom: return Path(.init(x: rect.minX, y: rect.maxY - width, width: rect.width, height: width))
            case .leading: return Path(.init(x: rect.minX, y: rect.minY, width: width, height: rect.height))
            case .trailing: return Path(.init(x: rect.maxX - width, y: rect.minY, width: width, height: rect.height))
            }
        }.reduce(into: Path()) { $0.addPath($1) }
    }
}
