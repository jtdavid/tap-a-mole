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

    @IBOutlet var sceneView: ARSCNView!

    var planes = [UUID: Board]()

    var boardNode: Board?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, SCNDebugOptions.showWireframe]

        // Create a new scene
        let scene = SCNScene()

        self.boardNode = Board(with: 0, z: 0)
        scene.rootNode.addChildNode(self.boardNode!)

        // Set the scene to the view
        sceneView.scene = scene
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)) )
        sceneView.addGestureRecognizer(tapGesture)
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

//        let boardNode = Board(with: anchor)
//        planes[anchor.identifier] = boardNode
//        node.addChildNode(boardNode)
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {

        guard let board = planes[anchor.identifier],
        let anchor = anchor as? ARPlaneAnchor else {

            return
        }
//        board.update(anchor: anchor)
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        print("ERROR: \(error)")
    }

    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay

    }

    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required

    }
}

class Board: SCNNode {

    var planeGeometry: SCNPlane?
    var moles: [Mole] = []

    fileprivate enum Constants {

        static let boxWidth: CGFloat = 0.1
        static let boxHeigth: CGFloat = 0.05
    }

    override init() {

        super.init()
    }

    convenience init(with x: Float, z: Float) {

        let planeGeometry = SCNPlane(width: Constants.boxWidth, height: Constants.boxHeigth)
        self.init()
        self.geometry = planeGeometry
        self.position = SCNVector3Make(0, -1, 1)
        self.transform = SCNMatrix4MakeRotation(Float(-Double.pi / 2), 1.0, 0.0, 0.0)

        let xPositionDelta = Constants.boxWidth / 3
        (0...2).forEach { index in

            let mole = Mole()
            let moleXPosition = xPositionDelta * CGFloat(index) - xPositionDelta
            mole.position = SCNVector3Make(
                Float(moleXPosition),
                Float(0),
                Float(-Mole.Constants.moleHeight/2))
            self.addChildNode(mole)
            moles.append(mole)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(anchor: ARPlaneAnchor) {

        let planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        self.geometry = planeGeometry
        self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
    }
}

// MARK: - UIEvent

extension ViewController {

    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {

        print("Clicked!!!!!")

        let pointInView = gestureRecognizer.location(in: self.sceneView)
        let options: [SCNHitTestOption : Any] = [
            SCNHitTestOption.firstFoundOnly: false,
            SCNHitTestOption.rootNode: self.boardNode!
            ]
        let results = self.sceneView.hitTest(pointInView, options: options)
        print("HIT!!!!! \(hitResult)")
//        results.forEach { result in }

        // TODO: how to detect touch
        //            let anchor = ARAnchor(transform: hitResult.worldTransform)
        //            if let hittedNode = sceneView.node(for: anchor),
        //                let node = hittedNode as? Mole {
        //
        //                print("Mole hitted \(node)")
        //            }

    }

    func addBox(hitResult: ARHitTestResult) {

        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.0)
        let node = SCNNode(geometry: cube)
        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        node.physicsBody?.mass = 2.0
        let insertionOffset: Float = 0.5
//        node.physicsBody?.categoryBitMask = SCNPhysicsCollisionCategoryStatic
        node.position = SCNVector3Make(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + insertionOffset, hitResult.worldTransform.columns.3.z)
        self.sceneView.scene.rootNode.addChildNode(node)
    }
}
