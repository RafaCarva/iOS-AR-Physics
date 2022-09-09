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
    var collisionSubscriptions = [Cancellable]()
    
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
                material: .default,
                mode: .dynamic
            )
            box.position.y = 0.3
            box.collision = CollisionComponent(
                shapes: [.generateBox(size: [0.2,0.2,0.2])],
                mode: .trigger,
                filter: .sensor
            )
            
            // Quando acontecer a colisão vai acontecer isso:
            self.collisionSubscriptions.append(view.scene.subscribe(to: CollisionEvents.Began.self) { event in
                box.model?.materials = [SimpleMaterial(color: .purple, isMetallic: true)]
            })
            
            // Quando acabar a colisão vai acontecer isso:
            self.collisionSubscriptions.append(view.scene.subscribe(to: CollisionEvents.Ended.self) { event in
                box.model?.materials = [SimpleMaterial(color: .green, isMetallic: true)]
            })
            
            anchorEntity.addChild(box)
            view.scene.anchors.append(anchorEntity)
        }
    }
    
    
}
