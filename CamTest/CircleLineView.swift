//
//  CircleLineView.swift
//  CamTest
//
//  Created by kyuminlee on 2023/05/10.
//

import Foundation
import UIKit

class CircleLineView: UIView {
    
    override func draw(_ rect: CGRect) {
        self.frame = rect
        self.backgroundColor = .clear
        // Set the line width and color
        let lineWidth: CGFloat = 2.0
        let lineColor = UIColor.red
        
        // Set the center of the circle and the radius
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2.0 - lineWidth
        print("bounds.width: \(bounds.width), bounds.height:\(bounds.height), radius:\(radius)")
        
        // Create the circle path
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0.0, endAngle: .pi, clockwise: true)
        
        // Set the line width and color
        lineColor.setStroke()
        path.lineWidth = lineWidth
        
        // Draw the circle line
        path.stroke()
        
    }
}
