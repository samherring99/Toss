//
//  MenuViewController.swift
//  Toss
//
//  Created by Sam Herring on 6/23/20.
//  Copyright © 2020 Sam Herring. All rights reserved.
//

import UIKit
import SwiftUI

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mv = MenuView()
        let controller = UIHostingController(rootView: mv)
        addChild(controller)
        //controller.view.translatesAutoresizingMaskIntoConstraints = false
        //controller.view.contentScaleFactor = 0.5
        controller.view.frame = self.view.frame
        view.addSubview(controller.view)
        controller.didMove(toParent: self)
        
//        NSLayoutConstraint.activate([
//                    controller.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
//                    controller.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
//                    controller.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//                    controller.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//                ])
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCameraSegue" {
            if segue.destination is ViewController {
                // do something w destination
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
