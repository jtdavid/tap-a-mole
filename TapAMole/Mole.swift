//
//  Mole.swift
//  TapAMole
//
//  Created by Carlos Santos on 07/09/2017.
//  Copyright © 2017 HappyTreeFriends. All rights reserved.
//

import Foundation
import ARKit

class Mole: SCNNode {

    enum Constants {

        static let moleWidth: CGFloat = 0.005
        static let moleLength: CGFloat = 0.005
        static let moleHeight: CGFloat = 0.01
    }

    override init() {

        super.init()

        let boxGeometry = SCNBox(width: Constants.moleWidth, height: Constants.moleHeight, length: Constants.moleLength, chamferRadius: 0.0)
        self.geometry = boxGeometry
        self.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        self.physicsBody?.collisionBitMask = 1
        self.transform = SCNMatrix4MakeRotation(Float(-Double.pi / 2), 1.0, 0.0, 0.0)

        self.moveUpAndDown()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func moveUpAction() -> SCNAction {

        let moveUpAnimation = SCNAction.moveBy(x: 0, y: 0, z: Constants.moleHeight, duration: 0.5)
        moveUpAnimation.timingMode = .easeInEaseOut;
        return moveUpAnimation
    }

    func moveDownAction() -> SCNAction {

        let moveDownAnimation = SCNAction.moveBy(x: 0, y: 0, z: -Constants.moleHeight, duration: 0.5)
        moveDownAnimation.timingMode = .easeInEaseOut;
        return moveDownAnimation
    }

    func moveWait() -> SCNAction {

        let moveWaitAnimation = SCNAction.moveBy(x: 0, y: 0, z: 0, duration: Double(arc4random_uniform(3)))
        moveWaitAnimation.timingMode = .easeInEaseOut;
        return moveWaitAnimation
    }

    func moveUpAndDown() {

        let moveWaitAnimation1 = self.moveWait()
        let moveUpAnimation = self.moveUpAction()
        let moveWaitAnimation2 = self.moveWait()
        let moveDownAnimation = self.moveDownAction()
        let moveWaitAnimation3 = self.moveWait()
        let moveSequence = SCNAction.sequence([moveWaitAnimation1, moveUpAnimation, moveWaitAnimation2, moveDownAnimation, moveWaitAnimation3])
        let loopedAction = SCNAction.repeatForever(moveSequence)
        self.runAction(loopedAction)
    }
}
