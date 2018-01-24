//
//  BubbleChat.swift
//  People
//
//  Created by Quoc Dat on 12/15/17.
//  Copyright © 2017 Quoc Dat. All rights reserved.
//

import Foundation
import UIKit

class MessageReciveBubbleView: UIView {
    // MARK: - Life Cycle
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath()
        
        // Draw main body
        bezierPath.move(to: CGPoint(x: rect.minX, y: rect.minY ))
        bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 10.0))
        bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - 10.0))
        bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        
        
        bezierPath.move(to: CGPoint(x: rect.minX + 25.0, y: rect.maxY - 10.0))
        bezierPath.addLine(to: CGPoint(x: rect.minX + 10.0, y: rect.maxY))
        bezierPath.addLine(to: CGPoint(x: rect.minX + 10.0, y: rect.maxY - 10.0))
        
        UIColor.lightGray.setFill()
        
        bezierPath.fill()
        bezierPath.close()
    }
    
}

class MessageSentBubbleView: UIView {
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath()
        
        bezierPath.move(to: CGPoint(x: rect.minX , y: rect.minY ))
        bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 10.0))
        bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - 10.0))
        bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        
        bezierPath.move(to: CGPoint(x: rect.maxX - 25.0, y: rect.maxY - 10.0))
        bezierPath.addLine(to: CGPoint(x: rect.maxX - 10.0, y: rect.maxY ))
        bezierPath.addLine(to: CGPoint(x: rect.maxX - 10.0, y: rect.maxY - 10.0))
        
        
        UIColor.cyan.setFill()
        bezierPath.fill()
        bezierPath.close()
    }
}


