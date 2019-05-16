//
//  ViewController+HelperFunctions.swift
//  CraftAR
//
//  Created by Isaac Raval on 5/16/19.
//  Copyright © 2019 Isaac Raval. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

extension ViewController {
    //Session config setup
    func setSessionConfiguration() {
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func setupScene() {
        navigationController?.navigationBar.isTranslucent = true
        sceneView.delegate = self
        sceneView.showsStatistics = true
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.showsStatistics = true
        self.sceneView.automaticallyUpdatesLighting = true
    }
    
    @IBAction func reset(_ sender: UIButton) {
        planeDetection.text = ""
        removeAllObjects()
        setSessionConfiguration()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}

//Handle placing and removing blocks
extension ViewController {
    
    //Handle touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: sceneView)
        let hitResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        
        /* Add block to scene only if pickaxe is not selected */
        if(nameOfBlockSelected != "pickaxe") {
            if hitResults.count > 0 {
                let result: ARHitTestResult = hitResults.first!
                
                let newLocation = SCNVector3Make(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
                addCube(location: newLocation)
            }
        }
        
        /* If using pickaxe, remove tapped block */
        if(nameOfBlockSelected == "pickaxe") {
            if(touch.view == self.sceneView) {
                print("touch working")
                let viewTouchLocation:CGPoint = touch.location(in: sceneView)
                guard let result = sceneView.hitTest(viewTouchLocation, options: nil).first else {
                    return
                }
                /* Only delete blocks */
                if(result.node.name == "block") {
                    result.node.removeFromParentNode()
                }
            }
        }
    }
    
    //Add cube
    func addCube(location: SCNVector3) {
        let dimension: CGFloat = 0.1
        var cubePosition = location
        cubePosition.y += 0.5
        let cube = SCNBox(width: dimension, height: dimension, length: dimension, chamferRadius: 0)
        let cubeNode = SCNNode(geometry: cube)
        let img = UIImage(named: nameOfBlockSelected)
        let material = SCNMaterial()
        material.diffuse.contents = img
        cube.materials = [material, material, material, material, material, material]
        cubeNode.position = cubePosition
        cubeNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: cube, options: nil))
        cubeNode.name = "block"
        cubeNode.physicsBody?.angularVelocityFactor = SCNVector3(0, 0, 0) //Disable blocks from turning on impact
        
        objects.append(cubeNode)
        sceneView.scene.rootNode.addChildNode(cubeNode)
    }
    
    //Renove all blocks
    func removeAllObjects() {
        for object in objects {
            object.removeFromParentNode()
        }
        objects = []
    }
}
