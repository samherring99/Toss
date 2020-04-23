//
//  Cup.swift
//  Toss
//
//  Created by Sam Herring on 4/13/20.
//  Copyright © 2020 Sam Herring. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class Cup : SCNNode {
    
    var anchor: ARPlaneAnchor
    var planeGeometry: SCNPlane!
    var referenceNode1: SCNReferenceNode!
    var referenceNode2: SCNReferenceNode!
    var referenceNode3: SCNReferenceNode!
    var referenceNode4: SCNReferenceNode!
    
    init(anchor: ARPlaneAnchor) {
        self.anchor = anchor
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    func update(anchor: ARPlaneAnchor) {
        let gp: Grid = self.parent as! Grid
        referenceNode1.scale = SCNVector3(Float(2.0 * Float(self.anchor.extent.x / 100.0)), 2.0 * Float(self.anchor.extent.x / 100.0), 2.0 * Float(self.anchor.extent.x / 100.0))
        referenceNode2.scale = SCNVector3(Float(2.0 * Float(self.anchor.extent.x / 100.0)), 2.0 * Float(self.anchor.extent.x / 100.0), 2.0 * Float(self.anchor.extent.x / 100.0))
        referenceNode3.scale = SCNVector3(Float(2.0 * Float(self.anchor.extent.x / 100.0)), 2.0 * Float(self.anchor.extent.x / 100.0), 2.0 * Float(self.anchor.extent.x / 100.0))
        referenceNode4.scale = SCNVector3(Float(2.0 * Float(self.anchor.extent.x / 100.0)), 2.0 * Float(self.anchor.extent.x / 100.0), 2.0 * Float(self.anchor.extent.x / 100.0))
        //referenceNode.position = SCNVector3(gp.anchor.center.x + Float(gp.planeGeometry.height / 2.0), gp.anchor.center.y, gp.anchor.center.z  + Float(gp.planeGeometry.width / 2.0))
        referenceNode1.position = SCNVector3(x: gp.anchor.center.x + gp.anchor.extent.x, y: gp.anchor.center.y, z: gp.anchor.center.z - gp.anchor.extent.z)
        referenceNode2.position = SCNVector3(x: gp.anchor.center.x - gp.anchor.extent.x, y: gp.anchor.center.y, z: gp.anchor.center.z - gp.anchor.extent.z)
        referenceNode3.position = SCNVector3(x: gp.anchor.center.x - gp.anchor.extent.x, y: gp.anchor.center.y, z: gp.anchor.center.z + gp.anchor.extent.z)
        referenceNode4.position = SCNVector3(x: gp.anchor.center.x + gp.anchor.extent.x, y: gp.anchor.center.y, z: gp.anchor.center.z + gp.anchor.extent.z)
        
        let planeNode = self.childNodes.first!
        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: self.planeGeometry, options: nil))
    }
    
    private func setup() {
        planeGeometry = SCNPlane(width: CGFloat(0.04), height: CGFloat(0.04))
        
        guard let urlPath = Bundle.main.url(forResource: "Solocup", withExtension: "usdz") else {
            return
        }
        referenceNode1 = SCNReferenceNode(url: urlPath)
        
        referenceNode1!.load()
        
        //planeGeometry.materials = [material]
        //let planeNode = SCNNode(geometry: self.planeGeometry)
        referenceNode1?.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: self.planeGeometry, options: nil))
        referenceNode1?.physicsBody?.categoryBitMask = 2
        
        //referenceNode?.scale = SCNVector3(0.02, 0.02, 0.02)
        
        referenceNode1?.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
        referenceNode1?.transform = SCNMatrix4MakeRotation(Float(0.0), 1.0, 0.0, 0.0);

        addChildNode(referenceNode1!)
    }
}
