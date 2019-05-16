//
//  ViewController.swift
//  CraftAR
//
//  Created by Isaac Raval on 5/16/19.
//  Copyright © 2019 Isaac Raval. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //Collection view outlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    //AR Properties and outlets
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var cameraState: UILabel!
    @IBOutlet weak var planeDetection: UILabel!
    var anchors: [ARPlaneAnchor] = []
    var planeHeight: CGFloat = 0.01
    var objects: [SCNNode] = []
    var configuration = ARWorldTrackingConfiguration()
    
    //More properties
    var nameOfBlockSelected = "GBTop.png"
    let reuseIdentifier = "cell" // When using this, we are refrencing the collection view identifier in the storyboard
    var items = ["Box", "cube2", "cube3", "GBBottom", "GBSide", "GBTop", "treeTexture", "wood", "pickaxe"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        setSessionConfiguration()
    }
}


