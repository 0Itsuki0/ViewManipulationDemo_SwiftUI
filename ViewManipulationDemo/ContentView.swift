//
//  ContentView.swift
//  ViewManipulationDemo
//
//  Created by Itsuki on 2024/06/30.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Combination: resize, rotate, reposition")
                .font(.title)
            
            HStack(spacing: 30) {
                NavigationLink {
                    MagnifyRotateDragDemo()
                } label: {
                    Text("MagnifyGesture + \nRotateGesture + \nDragGesture")
                        .multilineTextAlignment(.leading)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(RoundedRectangle(cornerRadius: 16).fill(.black))
                }
                
                NavigationLink {
                    DragOnlyDemo()
                } label: {
                    Text("DragGesture Only")
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(RoundedRectangle(cornerRadius: 16).fill(.black))
                }
            }
            .font(.system(size: 16))
            .foregroundColor(.white)
            .fixedSize(horizontal: true, vertical: true)
            
            Spacer()
                .frame(height: 50)
            
            Text("Resize View")
                .font(.title)
            
            HStack(spacing: 30) {
                NavigationLink {
                    PinchToResizeDemo()
                } label: {
                    Text("Pinch To Resize")
                        .multilineTextAlignment(.leading)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(RoundedRectangle(cornerRadius: 16).fill(.black))
                }
                
                NavigationLink {
                    DragToResizeDemo()
                } label: {
                    Text("Drag To Resize")
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(RoundedRectangle(cornerRadius: 16).fill(.black))
                }
            }
            .font(.system(size: 16))
            .foregroundColor(.white)
            .fixedSize(horizontal: true, vertical: true)
            
            Spacer()
                .frame(height: 50)

            Text ("Rotate View")
                .font(.title)
            
            HStack(spacing: 30) {
                NavigationLink {
                    TwoFingerRotateDemo()
                } label: {
                    Text("Two Finger Rotate \nwith Rotate Gesture")
                        .multilineTextAlignment(.leading)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(RoundedRectangle(cornerRadius: 16).fill(.black))
                }
                
                NavigationLink {
                    DragToRotateDemo()
                } label: {
                    Text("Drag To Rotate")
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(RoundedRectangle(cornerRadius: 16).fill(.black))
                }
            }
            .font(.system(size: 16))
            .foregroundColor(.white)
            .fixedSize(horizontal: true, vertical: true)            

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.top, 50)
    }
}


#Preview {
    NavigationStack {
        ContentView()
    }
}
