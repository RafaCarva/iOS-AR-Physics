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

class Coordinator: NSObject, ARSessionDelegate, UIGestureRecognizerDelegate {
    
    weak var view: ARView?

    var movableEntities = [MovableEntity]()
    
    func buildEnvironment() {
        
        guard let view = view else { return }
        
        let anchor = AnchorEntity(plane: .horizontal)
        
        // Create a floor
        let floor = ModelEntity(mesh: MeshResource.generatePlane(width: 0.9, depth: 0.9), materials: [SimpleMaterial(color: .green, isMetallic: true)])
        floor.generateCollisionShapes(recursive: true)
        floor.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .default, mode: .static)
        
        // Create all movable objects
        let box1 = MovableEntity(size: 0.3, color: .purple, shape: .box)
        let box2 = MovableEntity(size: 0.3, color: .blue, shape: .box)
        let sphere1 = MovableEntity(size: 0.3, color: .orange, shape: .sphere)
        let sphere2 = MovableEntity(size: 0.3, color: .black, shape: .sphere)
        
        // Add objects to anchor
        anchor.addChild(floor)
        anchor.addChild(box1)
        anchor.addChild(box2)
        anchor.addChild(sphere1)
        anchor.addChild(sphere2)
        
        // Populo o meu array de movableEntities
        movableEntities.append(box1)
        movableEntities.append(box2)
        movableEntities.append(sphere1)
        movableEntities.append(sphere2)
        
        view.scene.addAnchor(anchor)
        
        // Habilito gestures para os elementos do array de movableEntities
        movableEntities.forEach {
            view.installGestures(.all, for: $0).forEach {
                $0.delegate = self
            }
        }
        
        setupGestures()
        
    }
    
    @objc func panned(_ sender: UIPanGestureRecognizer) {
        
        switch sender.state {
        case .ended, .cancelled, .failed:
            // Change the physics mode to dynamic
            movableEntities.compactMap { $0 }.forEach {
                $0.physicsBody?.mode = .dynamic
            }
        default:
            return
        }
    }
    
    fileprivate func setupGestures() {
        
        guard let view = view else { return }
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith othergestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let translationGesture = gestureRecognizer as? EntityTranslationGestureRecognizer,
              let entity = translationGesture.entity as? MovableEntity else {
            return true
        }
        
        entity.physicsBody?.mode = .kinematic
        return true
    }
    
}
