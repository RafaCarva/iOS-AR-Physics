//
//  ContentView.swift
//  Physics-Pro
//
//  Created by Rafael Carvalho on 09/09/22.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap)))

        let floorAnchor = AnchorEntity(plane: .horizontal)
        
        // Cria um cubo invisível com altura 0 para servir como chão
        let floor = ModelEntity(mesh: MeshResource.generateBox(size: [1000, 0, 1000]),
                                materials: [OcclusionMaterial()])
        floor.generateCollisionShapes(recursive: true)
        floor.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .default, mode: .static)
        
        floorAnchor.addChild(floor)
        arView.scene.addAnchor(floorAnchor)
        
        context.coordinator.view = arView
        arView.session.delegate = context.coordinator
        
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
