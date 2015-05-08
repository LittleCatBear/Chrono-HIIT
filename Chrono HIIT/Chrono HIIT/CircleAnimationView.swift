//
//  CircleAnimationView.swift
//  Chrono HIIT
//
//  Created by Julie Huguet on 03/04/2015.
//  Copyright (c) 2015 Witios. All rights reserved.
//

import Foundation
import UIKit


class CircleAnimationView : UIView{
    var circleLayer: CAShapeLayer!
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = UIColor.redColor().CGColor
        circleLayer.lineWidth = 5.0
        
        circleLayer.strokeEnd = 0.0
        
        layer.addSublayer(circleLayer)
    }

    init(frame: CGRect, line: CGFloat) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = UIColor(red: 0.75, green: 0.118, blue: 0.176, alpha: 1.0).CGColor
        circleLayer.lineWidth = line
        
        circleLayer.strokeEnd = 0.0
        
        layer.addSublayer(circleLayer)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func pauseAnim(){
        //CATimeInterval pauseTime = circleLayer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        circleLayer.speed = 0.0
        circleLayer.timeOffset = circleLayer.convertTime(CACurrentMediaTime(), fromLayer: circleLayer)
    }
    
    func resumeAnim(){
        circleLayer.speed = 1.0
        circleLayer.timeOffset = 0.0
        circleLayer.beginTime = circleLayer.convertTime(CACurrentMediaTime(), fromLayer: circleLayer) - circleLayer.timeOffset
    }
    
    func animateCircle(duration: NSTimeInterval) {
        
        
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        circleLayer.strokeEnd = 1.0
        circleLayer.addAnimation(animation, forKey: "animateCircle")
    }

}