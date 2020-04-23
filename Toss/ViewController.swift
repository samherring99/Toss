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
    var grids = [Grid]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        //configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
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
        let c1 = Cup(anchor: anchor as! ARPlaneAnchor)
        let c2 = Cup(anchor: anchor as! ARPlaneAnchor)
        let c3 = Cup(anchor: anchor as! ARPlaneAnchor)
        let c4 = Cup(anchor: anchor as! ARPlaneAnchor)
        print(grid.planeGeometry.width)
        c1.scale = SCNVector3(2.0 * Float(grid.anchor.extent.x / 100.0), 2.0 * Float(grid.anchor.extent.x / 100.0), 2.0 * Float(grid.anchor.extent.x / 100.0))
        c2.scale = SCNVector3(2.0 * Float(grid.anchor.extent.x / 100.0), 2.0 * Float(grid.anchor.extent.x / 100.0), 2.0 * Float(grid.anchor.extent.x / 100.0))
        c3.scale = SCNVector3(2.0 * Float(grid.anchor.extent.x / 100.0), 2.0 * Float(grid.anchor.extent.x / 100.0), 2.0 * Float(grid.anchor.extent.x / 100.0))
        c4.scale = SCNVector3(2.0 * Float(grid.anchor.extent.x / 100.0), 2.0 * Float(grid.anchor.extent.x / 100.0), 2.0 * Float(grid.anchor.extent.x / 100.0))
        //c.position = SCNVector3(grid.anchor.center.x + Float(grid.planeGeometry.height / 2.0), grid.anchor.center.y, grid.anchor.center.z  + Float(grid.planeGeometry.width / 2.0))
        self.grids.append(grid)
        c1.position = SCNVector3(x: grid.anchor.center.x + grid.anchor.extent.x, y: grid.anchor.center.y, z: grid.anchor.center.z - grid.anchor.extent.z)
        c2.position = SCNVector3(x: grid.anchor.center.x - grid.anchor.extent.x, y: grid.anchor.center.y, z: grid.anchor.center.z - grid.anchor.extent.z)
        c3.position = SCNVector3(x: grid.anchor.center.x - grid.anchor.extent.x, y: grid.anchor.center.y, z: grid.anchor.center.z + grid.anchor.extent.z)
        c4.position = SCNVector3(x: grid.anchor.center.x + grid.anchor.extent.x, y: grid.anchor.center.y, z: grid.anchor.center.z + grid.anchor.extent.z)
        node.addChildNode(grid)
        grid.addChildNode(c1)
        grid.addChildNode(c2)
        grid.addChildNode(c3)
        grid.addChildNode(c4)

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
