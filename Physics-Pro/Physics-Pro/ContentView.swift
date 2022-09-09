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
        
        // Plane que vai entender a colision com as boxs
        let planeAnchorEntity = AnchorEntity(plane: .horizontal)
        let plane = ModelEntity(
            mesh: MeshResource.generatePlane(width: 1, depth: 1),
            materials: [SimpleMaterial(color: .orange, isMetallic: true)]
        )
        plane.physicsBody = PhysicsBodyComponent(
            massProperties: .default,
            material: .generate(),
            mode: .static
        )
        plane.generateCollisionShapes(recursive: true)
        
        planeAnchorEntity.addChild(plane)
        arView.scene.anchors.append(planeAnchorEntity)
        
        arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap)))
        
        context.coordinator.view = arView
        //arView.session.delegate = context.coordinator
         
         
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
