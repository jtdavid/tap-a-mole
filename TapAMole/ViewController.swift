//
//  ViewController.swift
//  TapAMole
//
//  Created by Carlos Santos on 07/09/2017.
//  Copyright © 2017 Carlos Santos. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    fileprivate enum Constants {

        static let boxWidth: CGFloat = 0.1
    }

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.debugOptions = .showWireframe

        // Create a new scene
        let scene = SCNScene()
        // create box
//        let boxGeometry = SCNBox(width: Constants.boxWidth, height: Constants.boxWidth, length: Constants.boxWidth, chamferRadius: 0.0)
//        let boxNode = SCNNode(geometry: boxGeometry)
//        boxNode.position = SCNVector3Make(0.0, 0.0, -0.1)
//        scene.rootNode.addChildNode(boxNode)

        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}

// MARK: - ARSCNViewDelegate

extension ViewController : ARSCNViewDelegate {

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {

        let node = SCNNode()
        // TODO
        return node
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {

        guard let anchor = anchor as? ARPlaneAnchor else {
            return
        }
        print("Anchor => \(anchor)")

//        let planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
//        let planeNode = SCNNode(geometry: planeGeometry)
//        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
//
//        self.sceneView.scene.rootNode.addChildNode(node)


        let planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        let planeNode = SCNNode(geometry: planeGeometry)
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(Float(-Double.pi / 2), 1.0, 0.0, 0.0)
        node.addChildNode(planeNode)
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {


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
}
