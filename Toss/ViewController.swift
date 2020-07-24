//
//  ViewController.swift
//  Toss
//
//  Created by Sam Herring on 4/13/20.
//  Copyright © 2020 Sam Herring. All rights reserved.
//

// For single player, essentially build turn system off of CPU ghost playes in other 3 spots.
// Will entail setting up gameplay framework, spawning die at opponent positions, and having those die move with a somewhat randomized force vector towards the table.

import UIKit
import SceneKit
import ARKit
import RealityKit
import CoreMotion
import Combine

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    let manager = CMMotionManager()
    let queue = OperationQueue()
    let dieNodeName = "die"
    var grids = [Grid]()
    
    //create dataframes
    
    var throwing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard manager.isAccelerometerAvailable else {
            return
        }
        
        let setButton = UIButton()
        setButton.setTitle("Table is Set", for: .normal)
        setButton.setTitleColor(UIColor.white, for: .normal)
        setButton.titleLabel?.textAlignment = .center
        setButton.frame = CGRect(x: self.view.frame.width / 3.0, y: self.view.frame.height - self.view.frame.height/8.0, width: 100.0, height: 40.0)
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
        
        //sceneView.debugOptions = [.showPhysicsShapes]
        
        //addTapGestureToSceneView()
        
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
        //manager.startAccelerometerUpdates()
        
        manager.deviceMotionUpdateInterval = 1.0 / 10 // 1/50 = 50Hz
        manager.startDeviceMotionUpdates(to: queue) { (deviceMotion: CMDeviceMotion?, error: Error?) in
            if error != nil {
                print("Encountered error: \(error!)")
            }
            
            
            //self.a = deviceMotion!.userAcceleration
            
            //self.r = deviceMotion!.rotationRate

            if deviceMotion != nil {
                //self.processDeviceMotion(deviceMotion!) // Start processing device motion.
                
                if self.throwing {
                    print(deviceMotion?.userAcceleration)
                    print(deviceMotion?.rotationRate)
                    
                    // fill dataframes
                }
                
                
            }
            
            //self.sendDatatoDelegate()
        }
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
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.addDieToSceneView(withGestureRecognizer:)))
        //sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func addThrowGesturetoSceneView() {
        let gsr = UITapGestureRecognizer(target: self, action: #selector(ViewController.addDieThrowToScene(withGestureRecognizer:)))
        
        gsr.numberOfTapsRequired = 1
        
        sceneView.addGestureRecognizer(gsr)
        
    }
    
    let CollisionCategoryDie = 1 << 1
    let CollisionCategoryTable = 1 << 2
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("started")
        // This runs once at the beginning of the throw, reset dataframes and log world front
        print(sceneView.pointOfView?.worldFront)
        throwing = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("ended")
        // Release die with force and rotation
        throwing = false
    }
    
    @objc func addDieThrowToScene(withGestureRecognizer recognizer: UIGestureRecognizer) {
        
        //let tapLocation = recognizer.location(in: sceneView)
        //let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        //guard let hitTestResult = hitTestResults.first else { return }
        
//        let translation = hitTestResult.worldTransform.translation
//        let x = translation.x
//        let y = translation.y + 0.1
//        let z = translation.z
        
        // CLEAN BELOW THIS ALL RUNS AT THE END
        
        let cameraNode = sceneView.pointOfView
        
        
        //print("Started")
        
        print(cameraNode?.position)
        
        // Setting up die shape and physics body
        
        let die = Die(anchor: grids.first!.anchor)
        die.scale = SCNVector3(5.0 * (grids.first?.anchor.extent.x)! / 100.0, 5.0 * (grids.first?.anchor.extent.x)! / 100.0, 5.0 * (grids.first?.anchor.extent.x)! / 100.0)
        
        //die.position.y = die.position.y + 50.0
        
        let box2 = SCNBox(width: die.planeGeometry.width, height: die.planeGeometry.width, length: die.planeGeometry.width, chamferRadius: 0)
        
        let boxBodyShape = SCNPhysicsShape(geometry: SCNBox(width: die.planeGeometry.width, height: die.planeGeometry.width, length: die.planeGeometry.width, chamferRadius: 0.3),
        options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox])
        //die.referenceNode1.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: box2, options: nil))
        //die.physicsBody = SCNPhysicsBody(type: .dynamic, shape: boxBodyShape)
        //die.referenceNode1.physicsBody = SCNPhysicsBody(type: .dynamic, shape: boxBodyShape)
        die.physicsBody = SCNPhysicsBody(type: .dynamic, shape: boxBodyShape)
        
        
//        die.physicsBody?.categoryBitMask = CollisionCategoryDie
//        grids.first?.physicsBody?.categoryBitMask = CollisionCategoryTable
//        die.physicsBody?.collisionBitMask = CollisionCategoryTable
//        grids.first?.physicsBody?.collisionBitMask = CollisionCategoryDie
        //die.referenceNode1.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: box2, options: nil))
        
        //die.physicsBody?.continuousCollisionDetectionThreshold = 0.025
        //die.physicsBody?.collisionBitMask = 2
        //die.position = SCNVector3(die.position.x, die.position.y + 10.0, die.position.z)
        
        
        //die.position = SCNVector3(die.referenceNode1.position.x, 5.0, die.referenceNode1.position.z)
        
        // Force calculations
        
        print(cameraNode?.worldFront)
        
        // 2
        //let original = SCNVector3(x: 0, y: 5.0, z: -1.0) // y between 4.0 and 6.0, z between -1 and -2?
        
        //let original = SCNVector3(x: 1.67, y: 13.83, z: -18.3)
        let newForce = SCNVector3(1.1 * (cameraNode?.worldFront.x)!, 5.0 + (cameraNode?.worldFront.y)!, (cameraNode?.worldFront.z)!) //AVERGAGE THESE WITH MEASURED VALUES?
        //let force = simd_make_float4(2.0 * (cameraNode?.worldFront.x)!,  5.0 + (cameraNode?.worldFront.y)!, (cameraNode?.worldFront.z)!, 0)
        //let rotatedForce = simd_mul(sceneView.session.currentFrame!.camera.transform, force)

        //let vectorForce = SCNVector3(x:rotatedForce.x, y:rotatedForce.y, z:rotatedForce.z)
        //die.physicsBody?.applyForce(vectorForce, asImpulse: true)
        
        // Apply force
        
        
        die.position = cameraNode?.position as! SCNVector3
        
        
        
        die.physicsBody?.applyForce(newForce, at: cameraNode!.position, asImpulse: true)
        
        
        //die.referenceNode1.position = die.position
        //print(grids.first?.boundingBox)
        let box = SCNBox(width: CGFloat((grids.first?.anchor.extent.x)!) + die.planeGeometry.width, height: 0.0, length: CGFloat((grids.first?.anchor.extent.z)!) + die.planeGeometry.width, chamferRadius: 2.0)
        
        
        
        //print(grids.first!.boundingBox)
        //grids.first?.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: box, options: nil))
        
        grids.first?.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        
        //grids.first?.physicsBody?.categoryBitMask = 2
        
        
        grids.first?.physicsBody?.restitution = 0.262 // die bounce
        
        grids.first?.addChildNode(die)
        
        die.rotation = SCNVector4(0.0, 30.0, 0.0, 69.0) // FIX THIS W MEASURED
        die.eulerAngles = SCNVector3Make(0, Float(7*Double.pi/8), 0);
        
        die.referenceNode1.eulerAngles = SCNVector3Make(0, Float(7*Double.pi/8), 0);
        die.referenceNode1.rotation = SCNVector4(0.0, 30.0, 0.0, 69.0)
        
        if recognizer.state != .ended {
            print("Held")
        }
        
        print("Finished")
        
        throwing = false
        
        print(sceneView.pointOfView?.position)
        
        // create method for math on dataframes, apply force
        
        // CHANGE DIE SIZE A LITTLE BIGGER, FIX LANDING AND BOUNCING SHIT WITH COLLISION
        // ADD THROWING, CATCHING, BOUNCING, LANDING, ETC.
        
//        guard let rocketshipScene = SCNScene(named: "rocketship.scn"),
//            let rocketshipNode = rocketshipScene.rootNode.childNode(withName: "rocketship", recursively: false)
//            else { return }
        
        //rocketshipNode.position = SCNVector3(x,y,z)
        
        // TODO: Attach physics body to rocketship node
        
        //sceneView.scene.rootNode.addChildNode(rocketshipNode)
    }

    @objc func addDieToSceneView(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        guard let hitTestResult = hitTestResults.first else { return }
        
//        let translation = hitTestResult.worldTransform.translation
//        let x = translation.x
//        let y = translation.y + 0.1
//        let z = translation.z
        
        let cameraNode = sceneView.pointOfView
        
        print("Tapped")
        print(manager.accelerometerData?.acceleration)
        print(cameraNode?.position)
        
        let die = Die(anchor: grids.first!.anchor)
        die.scale = SCNVector3(5.0 * (grids.first?.anchor.extent.x)! / 100.0, 5.0 * (grids.first?.anchor.extent.x)! / 100.0, 5.0 * (grids.first?.anchor.extent.x)! / 100.0)
        
        //die.position.y = die.position.y + 50.0
        
        let box2 = SCNBox(width: die.planeGeometry.width, height: die.planeGeometry.width, length: die.planeGeometry.width, chamferRadius: 0)
        
        let boxBodyShape = SCNPhysicsShape(geometry: SCNBox(width: die.planeGeometry.width, height: die.planeGeometry.width, length: die.planeGeometry.width, chamferRadius: 0.3),
        options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox])
        //die.referenceNode1.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: box2, options: nil))
        //die.physicsBody = SCNPhysicsBody(type: .dynamic, shape: boxBodyShape)
        //die.referenceNode1.physicsBody = SCNPhysicsBody(type: .dynamic, shape: boxBodyShape)
        die.physicsBody = SCNPhysicsBody(type: .dynamic, shape: boxBodyShape)
        
//        die.physicsBody?.categoryBitMask = CollisionCategoryDie
//        grids.first?.physicsBody?.categoryBitMask = CollisionCategoryTable
//        die.physicsBody?.collisionBitMask = CollisionCategoryTable
//        grids.first?.physicsBody?.collisionBitMask = CollisionCategoryDie
        //die.referenceNode1.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: box2, options: nil))
        
        //die.physicsBody?.continuousCollisionDetectionThreshold = 0.025
        //die.physicsBody?.collisionBitMask = 2
        //die.position = SCNVector3(die.position.x, die.position.y + 10.0, die.position.z)
        
        
        //die.position = SCNVector3(die.referenceNode1.position.x, 5.0, die.referenceNode1.position.z)
        
        
        let randomZ = Float.random(in: 0.0...1.0)
        let randomY = Float.random(in: 0.0...1.0)
        
        print(cameraNode?.worldFront)
        
        // 2
        let original = SCNVector3(x: 0, y: 5.0, z: -1.0) // y between 4.0 and 6.0, z between -1 and -2?
        
        //let original = SCNVector3(x: 1.67, y: 13.83, z: -18.3)
        let newForce = SCNVector3(1.1 * (cameraNode?.worldFront.x)!, 5.0 + (cameraNode?.worldFront.y)!, (cameraNode?.worldFront.z)!)
        let force = simd_make_float4(2.0 * (cameraNode?.worldFront.x)!,  5.0 + (cameraNode?.worldFront.y)!, (cameraNode?.worldFront.z)!, 0)
        let rotatedForce = simd_mul(sceneView.session.currentFrame!.camera.transform, force)

        let vectorForce = SCNVector3(x:rotatedForce.x, y:rotatedForce.y, z:rotatedForce.z)
        //die.physicsBody?.applyForce(vectorForce, asImpulse: true)
        
        // Apply force
        die.position = cameraNode?.position as! SCNVector3
        die.physicsBody?.applyForce(newForce, at: cameraNode!.position, asImpulse: true)
        
        
        //die.referenceNode1.position = die.position
        //print(grids.first?.boundingBox)
        let box = SCNBox(width: CGFloat((grids.first?.anchor.extent.x)!) + die.planeGeometry.width, height: 0.0, length: CGFloat((grids.first?.anchor.extent.z)!) + die.planeGeometry.width, chamferRadius: 2.0)
        //print(grids.first!.boundingBox)
        //grids.first?.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: box, options: nil))
        grids.first?.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        //grids.first?.physicsBody?.categoryBitMask = 2
        grids.first?.physicsBody?.restitution = 0.262
        grids.first?.addChildNode(die)
        
        die.rotation = SCNVector4(0.0, 30.0, 0.0, 69.0)
        die.eulerAngles = SCNVector3Make(0, Float(7*Double.pi/8), 0);
        die.referenceNode1.eulerAngles = SCNVector3Make(0, Float(7*Double.pi/8), 0);
        die.referenceNode1.rotation = SCNVector4(0.0, 30.0, 0.0, 69.0)
        
        
        
        // CHANGE DIE SIZE A LITTLE BIGGER, FIX LANDING AND BOUNCING SHIT WITH COLLISION
        // ADD THROWING, CATCHING, BOUNCING, LANDING, ETC.
        
//        guard let rocketshipScene = SCNScene(named: "rocketship.scn"),
//            let rocketshipNode = rocketshipScene.rootNode.childNode(withName: "rocketship", recursively: false)
//            else { return }
        
        //rocketshipNode.position = SCNVector3(x,y,z)
        
        // TODO: Attach physics body to rocketship node
        
        //sceneView.scene.rootNode.addChildNode(rocketshipNode)
    }
    
    @objc func setTable() {
        print("Set")
        if grids.count > 0 {
            let (min, max) = (grids.first?.planeGeometry.boundingBox)!
            let c1 = Cup(anchor: grids.first?.anchor as! ARPlaneAnchor)
            let c2 = Cup(anchor: grids.first?.anchor as! ARPlaneAnchor)
            let c3 = Cup(anchor: grids.first?.anchor as! ARPlaneAnchor)
            let c4 = Cup(anchor: grids.first?.anchor as! ARPlaneAnchor)
            
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

            c1.position = SCNVector3(min.x + Float(c1.planeGeometry.width/2.0), (grids.first?.anchor.center.y)!, min.y + Float(c1.planeGeometry.width/2.0))
            c2.position = SCNVector3(min.x + Float(c2.planeGeometry.width/2.0), (grids.first?.anchor.center.y)!, max.y - Float(c2.planeGeometry.width/2.0))
            c3.position = SCNVector3(max.x - Float(c3.planeGeometry.width/2.0), (grids.first?.anchor.center.y)!, min.y + Float(c3.planeGeometry.width/2.0))
            c4.position = SCNVector3(max.x - Float(c4.planeGeometry.width/2.0), (grids.first?.anchor.center.y)!, max.y - Float(c4.planeGeometry.width/2.0))
            
            grids.first?.addChildNode(c1)
            grids.first?.addChildNode(c2)
            grids.first?.addChildNode(c3)
            grids.first?.addChildNode(c4)
            
            //addTapGestureToSceneView()
            addThrowGesturetoSceneView()
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
