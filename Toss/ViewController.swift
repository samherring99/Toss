//
//  ViewController.swift
//  Toss
//
//  Created by Sam Herring on 4/13/20.
//  Copyright © 2020 Sam Herring. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import RealityKit
import Combine

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    var grids = [Grid]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let setButton = UIButton()
        setButton.setTitle("Table is Set", for: .normal)
        setButton.setTitleColor(UIColor.white, for: .normal)
        setButton.titleLabel?.textAlignment = .center
        setButton.frame = CGRect(x: self.view.frame.width / 3.0, y: self.view.frame.height - self.view.frame.height/8.0, width: 100.0, height: 20.0)
        setButton.addTarget(self, action: #selector(setTable), for: .touchUpInside)
        
        self.view.addSubview(setButton)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        //sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        //var cancel: AnyCancellable? = nil
        
        
//        cancel = ModelEntity.loadAsync(named: "Solocup").append(ModelEntity.loadAsync(named: "Solocup"))
//        .collect()
//        .sink(receiveCompletion: {error in
//            print("Error: \(error)")
//            cancel?.cancel()
//        }, receiveValue: { entities in
//            var objects: [ModelEntity] = []
//            for e in entities {
//                e.setScale(SIMD3<Float>(0.02, 0.02, 0.02), relativeTo: AnchorEntity(anchor: self.grids.first!.anchor));
//                e.generateCollisionShapes(recursive: true)
//                for _ in 1...2 {
//                    objects.append(e.clone(recursive: true) as! ModelEntity)
//                }
//            }
            
//            for (index, object) in objects.enumerated() {
//                self.grids.first?.addChildNode()
//            }
        //})
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Create a session configuration
        configuration.planeDetection = .horizontal
        //configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    @objc func setTable() {
        print("Set")
        if grids.count > 0 {
            let (min, max) = (grids.first?.planeGeometry.boundingBox)!
            let c1 = Cup(anchor: grids.first?.anchor as! ARPlaneAnchor)
            let c2 = Cup(anchor: grids.first?.anchor as! ARPlaneAnchor)
            let c3 = Cup(anchor: grids.first?.anchor as! ARPlaneAnchor)
            let c4 = Cup(anchor: grids.first?.anchor as! ARPlaneAnchor)
            
            
            let bottomLeft = SCNVector3(min.x, min.y, 0)
            let topRight = SCNVector3(max.x, max.y, 0)

            let topLeft = SCNVector3(min.x, max.y, 0)
            let bottomRight = SCNVector3(max.x, min.y, 0)
            
//            grids.first?.planeGeometry.position
//
            let worldBottomLeft = c1.convertPosition(bottomLeft, to: grids.first)
//            let worldTopRight = grids.first?.planeGeometry.convertPosition(topRight, to: grids.first)
//
//            let worldTopLeft = grids.first?.planeGeometry.convertPosition(topLeft, to: grids.first)
//            let worldBottomRight = grids.first?.planeGeometry.convertPosition(bottomRight, to: grids.first)
            
            print(min)
            print(max)
            var cupScale = SCNVector3()
            cupScale.x = 2.0 * (grids.first?.anchor.extent.x)! / 100.0
            cupScale.y = 2.0 * (grids.first?.anchor.extent.x)! / 100.0
            cupScale.z = 2.0 * (grids.first?.anchor.extent.x)! / 100.0
            c1.scale = cupScale
            c2.scale = cupScale
            c3.scale = cupScale
            c4.scale = cupScale

            c1.position = SCNVector3(min.x, (grids.first?.anchor.center.y)!, min.y)
            c2.position = SCNVector3(min.x, (grids.first?.anchor.center.y)!, max.y)
            c3.position = SCNVector3(max.x, (grids.first?.anchor.center.y)!, min.y)
            c4.position = SCNVector3(max.x, (grids.first?.anchor.center.y)!, max.y)
            
            grids.first?.addChildNode(c1)
            grids.first?.addChildNode(c2)
            grids.first?.addChildNode(c3)
            grids.first?.addChildNode(c4)
        }
        
        
        configuration.planeDetection = [] //empty array (as opposed to .horizontal .vertical)
        sceneView.session.run(configuration)
    }
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        let grid = Grid(anchor: anchor as! ARPlaneAnchor)
        print(grid.planeGeometry.width)

        self.grids.append(grid)

        node.addChildNode(grid)
        
    }
    
    // 2.
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        let grid = self.grids.filter { grid in
            return grid.anchor.identifier == anchor.identifier
        }.first
        
        guard let foundGrid = grid else {
            return
        }
        
        foundGrid.update(anchor: anchor as! ARPlaneAnchor)
    }
}
