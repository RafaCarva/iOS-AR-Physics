//
//  Coordinator.swift
//  Physics-Pro
//
//  Created by Rafael Carvalho on 09/09/22.
//

import Foundation
import ARKit
import RealityKit
import Combine

class Coordinator: NSObject, ARSessionDelegate {
    
    weak var view: ARView?
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        
        guard let view = self.view else { return }
        let tapLocation = recognizer.location(in: view)
        
        let results = view.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let result = results.first {
            
            let anchorEntity = AnchorEntity(raycastResult: result)
            
            let box = ModelEntity(
                mesh: MeshResource.generateBox(size: 0.3),
                materials: [SimpleMaterial(color: .blue, isMetallic: true)]
            )
            box.physicsBody = PhysicsBodyComponent(
                massProperties: .default,
                material: .generate(),
                mode: .dynamic
            )
            box.generateCollisionShapes(recursive: true)
            box.position = simd_make_float3(0, 0.7, 0)
            
            anchorEntity.addChild(box)
            view.scene.anchors.append(anchorEntity)
        }
    }
    
    
}
