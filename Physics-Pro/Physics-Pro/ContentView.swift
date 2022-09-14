//
//  ContentView.swift
//  Physics-Pro
//
//  Created by Rafael Carvalho on 09/09/22.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

extension ARView: ARCoachingOverlayViewDelegate {
    func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView()
                coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                coachingOverlay.goal = .horizontalPlane
                coachingOverlay.session = self.session
                coachingOverlay.delegate = self
                self.addSubview(coachingOverlay)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        context.coordinator.view = arView
        context.coordinator.buildEnvironment()
        
        arView.addCoaching()
        
        return arView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
