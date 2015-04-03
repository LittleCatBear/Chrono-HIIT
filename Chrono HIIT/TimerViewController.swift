//
//  TimerViewController.swift
//  Chrono HIIT
//
//  Created by Julie Huguet on 26/03/2015.
//  Copyright (c) 2015 Shokunin-Software. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import CoreData

class TimerViewController: UIViewController {
    
    
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var timingLab: UILabel!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    var sec : NSInteger = 0
    
    var tempSwap:NSInteger = 0
    var timer = NSTimer()
    var countdown = NSTimer()
    var cd:NSInteger = 0
    // flag false: button pause not clicked
    // flag true: button pause clicked, waiting for resume
    var flag:Bool = false
    
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().idleTimerDisabled = true
        repeatButton.enabled = false
        pauseButton.enabled = false
        roundLabel.text = "Time left"
        timingLab.text = "Swap"
        cd = NSInteger(workoutModel.countdown)
        self.sec = NSInteger(workoutModel.totalTime)
        //self.tempSwap = self.totalRounds
        self.tempSwap = NSInteger(workoutModel.swap)
        if(cd > 0){
            countdown = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("countDownSub"), userInfo: nil, repeats: true)
        } else{
            self.lauchExercise(Float(sec))
        }
    }
    
    func getExercise() -> NSString{
        var total:UInt32 = UInt32(workoutModel.exercise.count)
        var num = Int(arc4random_uniform(total))
        if workoutModel.exercise.count == 0 {
            return "NO DATA"
        }
        return workoutModel.exercise[num].name
    }
    
    func lauchExercise(timing:Float){
        addCircleView()
        pauseButton.enabled = true
        var t = NSTimeInterval(timing-0.2)
        
        self.exerciseLabel.text = getExercise()
        self.exerciseLabel.sizeToFit()
        
        self.exerciseLabel.numberOfLines = 0
    
        self.exerciseLabel.fadeIn(completion: {
            (finished:Bool) -> Void in
            self.exerciseLabel.fadeOut()
        })
       // self.exerciseLabel.fadeIn(duration: 1.0, delay: 0.0)
        speech(self.exerciseLabel.text!)
        
        self.sec = NSInteger(workoutModel.totalTime)
        self.timingLab.text = "Swap: \(sec)"
        self.roundLabel.text = "Time left: \(tempSwap)"
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
    }
    
    func speech(say:NSString){
        myUtterance = AVSpeechUtterance(string:say)
        myUtterance.rate = 0.1
        synth.speakUtterance(myUtterance)
    }
    
    func countDownSub(){
        
        if(cd == -1){
            countdown.invalidate()
            lauchExercise(Float(workoutModel.totalTime))
        } else if(cd == 0){
            self.exerciseLabel.text = "Begin"
            speech(self.exerciseLabel.text!)
        } else{
            self.exerciseLabel.text = "\(cd)"
            speech(self.exerciseLabel.text!)
        }
        cd--
    }
    
    func subtractTime() {
        sec--
        tempSwap--
        timingLab.text = "Swap: \(sec)"
        roundLabel.text = "Time left: \(tempSwap)"
        if(tempSwap == 0){
            self.timingLab.text = "Swap: 0"
            self.exerciseLabel.text = "Time completed"
            speech(self.exerciseLabel.text!)
            timer.invalidate()
            repeatButton.enabled = true
            pauseButton.enabled = false
        }else if(sec == 0)  {
                timer.invalidate()
                lauchExercise(Float(workoutModel.totalTime))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    @IBAction func onClickStopButton(sender: UIButton) {
        timer.invalidate()
        countdown.invalidate()
        UIApplication.sharedApplication().idleTimerDisabled = false
        repeatButton.enabled = true
    }
    
    @IBAction func onClickRepeatButton(sender: UIButton) {
        repeatButton.enabled = false
        timer.invalidate()
        cd = NSInteger(workoutModel.countdown)
        
        tempSwap = NSInteger(workoutModel.swap)
        countdown = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("countDownSub"), userInfo: nil, repeats: true)
        
    }
    
    @IBAction func onClickPauseButton(sender: UIButton) {
        if(flag == false){
            flag = true
            pauseButton.setImage(UIImage(named: "start.png"), forState: UIControlState.Normal)
            timer.invalidate()
        } else{
            lauchExercise(Float(sec))
            flag =  false
            pauseButton.setImage(UIImage(named: "pause.png"), forState: UIControlState.Normal)
           
        }
    }
    
    func addCircleView() {
        let diceRoll = CGFloat(Int(arc4random_uniform(7))*50)
        var circleWidth = CGFloat(200)
        var circleHeight = circleWidth
        
        // Create a new CircleView
        var circleAnimationView = CircleAnimationView(frame: CGRectMake(diceRoll, 0, circleWidth, circleHeight))
        
        view.addSubview(circleAnimationView)
        
        // Animate the drawing of the circle over the course of 1 second
        circleAnimationView.animateCircle(1.0)
    }
    
    
}

