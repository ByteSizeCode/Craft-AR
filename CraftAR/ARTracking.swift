//
//  AR+Tracking.swift
//  CraftAR
//
//  Created by Isaac Raval on 5/16/19.
//  Copyright © 2019 Isaac Raval. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

//AR Tracking and sufrace/plane detection
extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        var node:   SCNNode?
        if let planeAnchor = anchor as? ARPlaneAnchor {
            DispatchQueue.main.async {
                self.planeDetection.text = "Plane detected"
            }
            let rotationX = anchor.transform.columns.1.y
            var planeType = "Floor"
            if rotationX < 0 {
                planeType = "Ceiling"
            }
            print ("plane type is: ", planeType)
            node = SCNNode()
            let planeGeometry = SCNBox(width: CGFloat(planeAnchor.extent.x), height: planeHeight, length: CGFloat(planeAnchor.extent.z), chamferRadius: 0.0)
            planeGeometry.firstMaterial?.diffuse.contents = UIColor.blue.withAlphaComponent(0.4)
            let planeNode = SCNNode(geometry: planeGeometry)
            planeNode.position = SCNVector3Make(planeAnchor.center.x, Float(planeHeight / 2), planeAnchor.center.z)
            planeNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: planeGeometry, options: nil))
            node?.addChildNode(planeNode)
            anchors.append(planeAnchor)
            
        } else {
            print("not plane anchor \(anchor)")
        }
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            if anchors.contains(planeAnchor) {
                if node.childNodes.count > 0 {
                    let planeNode = node.childNodes.first!
                    planeNode.position = SCNVector3Make(planeAnchor.center.x, Float(planeHeight / 2), planeAnchor.center.z)
                    planeNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: planeNode.geometry!, options: nil))
                    if let plane = planeNode.geometry as? SCNBox {
                        plane.width = CGFloat(planeAnchor.extent.x)
                        plane.length = CGFloat(planeAnchor.extent.z)
                        plane.height = planeHeight
                    }
                }
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("Here")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        print("Interupted")
    }
    
    //AR Tracking feedback
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        let trackingState = camera.trackingState
        var cameraStateString = ""
        
        switch(trackingState) {
        case .notAvailable:
            cameraStateString = "Camera tracking is not available on this device"
            
        case .limited(let reason):
            switch(reason) {
            case .excessiveMotion:
                cameraStateString = "Limited tracking: slow down the movement of the device"
                
            case .insufficientFeatures:
                cameraStateString = "Limited tracking: too few feature points, try areas with more textures"
                
            case .initializing:
                cameraStateString = "Initializing"
            case .relocalizing:
                break
            }
            
        case .normal:
            cameraStateString = "Tracking is back to normal"
        }
        cameraState.text = cameraStateString
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        print("Error: ", error)
    }
}
