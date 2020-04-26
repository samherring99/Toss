//
//  Die.swift
//  Toss
//
//  Created by Sam Herring on 4/24/20.
//  Copyright © 2020 Sam Herring. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class Die : SCNNode {
    
    var anchor: ARPlaneAnchor
    var planeGeometry: SCNPlane!
    var referenceNode1: SCNReferenceNode!
    
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
        
        let planeNode = self.childNodes.first!
        //planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: self.planeGeometry, options: nil))
        referenceNode1?.scale = self.scale
        referenceNode1.physicsBody = self.physicsBody
        referenceNode1.position = self.position
        referenceNode1.rotation = self.rotation
        referenceNode1.eulerAngles = self.eulerAngles
    }
    
    private func setup() {
        planeGeometry = SCNPlane(width: CGFloat(0.04), height: CGFloat(0.04))
        
        guard let urlPath = Bundle.main.url(forResource: "Die", withExtension: "usdz") else {
            return
        }
        referenceNode1 = SCNReferenceNode(url: urlPath)
        
        referenceNode1!.load()
        
        //planeGeometry.materials = [material]
        //let planeNode = SCNNode(geometry: self.planeGeometry)
        //referenceNode1?.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: self.planeGeometry, options: nil))
        //referenceNode1?.physicsBody?.collisionBitMask = 2
        
        //referenceNode1?.scale = SCNVector3(0.02, 0.02, 0.02)
        
        //referenceNode1?.position = SCNVector3Make(anchor.center.x, 50.0, anchor.center.z);
        //self.position = SCNVector3Make((referenceNode1?.position.x)!, 50.0, (referenceNode1?.position.z)!);
        //referenceNode1?.transform = SCNMatrix4MakeRotation(Float(0.0), 1.0, 0.0, 0.0);

        addChildNode(referenceNode1!)
    }
}
