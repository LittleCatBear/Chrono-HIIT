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
    
    
    @IBOutlet weak var totalChronoView: UIView!
    
    //totalTime
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var exerciseLabel: UILabel!
    
    //swap
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
  
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var pauseLabel: UILabel!
    @IBOutlet weak var circleView: UIView!
    
    @IBOutlet weak var progressBarView: UIProgressView!
    
    // temporary totalTiming
    var sec : NSInteger = 0
    
    // temporary Swap
    var tempSwap:NSInteger = 0
    
    // timer for each exercise
    var timer = NSTimer()
    
    // timer for countdown
    var countdown = NSTimer()
    
    // temporary countdown
    var cd:NSInteger = 0
    
    var flag:Bool = false
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    
    var screenSize: CGSize = CGSize()
    //# MARK: design var
  
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var stopLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenSize = UIScreen.mainScreen().bounds.size
        
        UIApplication.sharedApplication().idleTimerDisabled = true
        repeatButton.enabled = false
        pauseButton.enabled = false
        
        progressBarView.setProgress(0, animated: true)
        
        cd = NSInteger(workoutModel.countdown)
        self.sec = NSInteger(workoutModel.totalTime)
        self.tempSwap = NSInteger(workoutModel.swap)
        
        if(isRegistered){
            redDesign()
        } else{
            blueDesign()
        }
        
        if(cd > 0){
            countdown = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("countDownSub"), userInfo: nil, repeats: true)
            pauseButton.enabled = false
        } else{
            //addCircleView(totalChronoView, duration:NSTimeInterval(sec), withFadeOut:false)
            repeatButton.enabled = true
            repeatLabel.text = "Restart"
            self.counter = 0
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
        pauseButton.enabled = true
        var t = NSTimeInterval(timing-0.2)
        self.exerciseLabel.text = getExercise() as String
       
        self.exerciseLabel.adjustsFontSizeToFitWidth = true
        
        
        self.exerciseLabel.fadeIn(completion: {
            (finished:Bool) -> Void in
            self.exerciseLabel.fadeOut()
        })
        
        speech(self.exerciseLabel.text!)
        addCircleView(circleView, duration: NSTimeInterval(workoutModel.swap), withFadeOut:true)
        self.tempSwap = NSInteger(workoutModel.swap)
        self.roundLabel.text = "\(sec)"
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
    }
    
    func speech(say:String){
        myUtterance = AVSpeechUtterance(string:say)
        myUtterance.rate = 0.1
        synth.speakUtterance(myUtterance)
    }
    
    func countDownSub(){
        if(cd == -1){
            repeatButton.enabled = true
            repeatLabel.text = "Restart"
            countdown.invalidate()
           // addCircleView(totalChronoView, duration:NSTimeInterval(sec), withFadeOut:false)
            
            lauchExercise(Float(workoutModel.totalTime))
        } else if(cd == 0){
            self.exerciseLabel.text = "Begin"
            speech(self.exerciseLabel.text!)
            
        } else{
            pauseButton.enabled = false
            repeatButton.enabled = false
            repeatLabel.text = "Restart"
            self.exerciseLabel.text = "\(cd)"
            self.counter = 0
            speech(self.exerciseLabel.text!)
        }
        cd--
    }
    
    func subtractTime() {
        sec--
        tempSwap--
        startProgressBar()
        roundLabel.text = " \(sec)"
        if(sec == 0){
            var temp = view.subviews[view.subviews.count-1] as! CircleAnimationView
            temp.pauseAnim()
            self.exerciseLabel.text = "Time completed"
            speech(self.exerciseLabel.text!)
            timer.invalidate()
            repeatButton.enabled = true
            repeatLabel.text = "Repeat"
            pauseButton.enabled = false
        }else if(tempSwap == 0)  {
            timer.invalidate()
           
            lauchExercise(Float(workoutModel.totalTime))
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    @IBAction func onClickStopButton(sender: UIButton) {
        timer.invalidate()
        synth.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        countdown.invalidate()
        UIApplication.sharedApplication().idleTimerDisabled = false
        repeatButton.enabled = true
    }
    
    @IBAction func onClickRepeatButton(sender: UIButton) {
        if(flag){
            flag = false
            
            pauseLabel.text = "Pause"
            if(isRegistered){
                pauseButton.setImage(UIImage(named: "pauseRed.png"), forState: UIControlState.Normal)
            }else{
                pauseButton.setImage(UIImage(named: "pauseBlue.png"), forState: UIControlState.Normal)
            }

        }
       // repeatButton.enabled = false
        timer.invalidate()
        cd = NSInteger(workoutModel.countdown)
        sec = NSInteger(workoutModel.totalTime)
        tempSwap = NSInteger(workoutModel.swap)
        countdown = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("countDownSub"), userInfo: nil, repeats: true)
    }
    
    @IBAction func onClickPauseButton(sender: UIButton) {
        if(!flag ){
            flag = true
            synth.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
            var temp = view.subviews[view.subviews.count-1]as! CircleAnimationView
            temp.pauseAnim()
            pauseLabel.text = "Resume"
            if(isRegistered){
                pauseButton.setImage(UIImage(named: "startRed.png"), forState: UIControlState.Normal)
            }else{
                pauseButton.setImage(UIImage(named: "startBlue.png"), forState: UIControlState.Normal)
            }
            timer.invalidate()
        } else{
            var temp = view.subviews[view.subviews.count-1] as! CircleAnimationView
            temp.resumeAnim()
            pauseLabel.text = "Pause"
           // timer.fire()
            lauchExercise(Float(sec))
            flag = false
            if(isRegistered){
                pauseButton.setImage(UIImage(named: "pauseRed.png"), forState: UIControlState.Normal)
            }else{
                pauseButton.setImage(UIImage(named: "pauseBlue.png"), forState: UIControlState.Normal)
            }
        }
    }
    
    func addCircleView(attachableView:UIView, duration: NSTimeInterval, withFadeOut:Bool) {
        
        switch(screenSize.width, screenSize.height) {
            
            case (320, 480):
                var circleWidth = CGFloat(attachableView.frame.width - 50)
                var circleHeight = circleWidth
                var circleAnimationView = CircleAnimationView(frame: CGRectMake(attachableView.center.x - circleWidth/2,attachableView.center.y - circleHeight/2, circleWidth, circleHeight), line: 10.0)
            view.addSubview(circleAnimationView)
            circleAnimationView.animateCircle(duration)
            if(withFadeOut){
                circleAnimationView.fadeOutNoRepeat(duration: duration, delay: 1.0)
            }
            case (414, 736):
                var circleWidth = CGFloat(attachableView.frame.width - 50)
                var circleHeight = circleWidth
                var circleAnimationView = CircleAnimationView(frame: CGRectMake(attachableView.center.x - circleWidth/2,attachableView.center.y - circleHeight/2, circleWidth, circleHeight), line: 50.0)
                view.addSubview(circleAnimationView)
                circleAnimationView.animateCircle(duration)
                if(withFadeOut){
                    circleAnimationView.fadeOutNoRepeat(duration: duration, delay: 1.0)
                }
            default:
                var circleWidth = CGFloat(attachableView.frame.width - 50)
                var circleHeight = circleWidth
                var circleAnimationView = CircleAnimationView(frame: CGRectMake(attachableView.center.x - circleWidth/2,attachableView.center.y - circleHeight/2, circleWidth, circleHeight), line: 50.0)
            view.addSubview(circleAnimationView)
            circleAnimationView.animateCircle(duration)
            if(withFadeOut){
                circleAnimationView.fadeOutNoRepeat(duration: duration, delay: 1.0)
            }
        }
        
    }
    
    //# MARK: progress bar
    var counter:Int = 0 {
        didSet {
            let fractionalProgress = (Float(counter) / Float(workoutModel.totalTime) )
            let animated = counter != 0
            progressBarView.setProgress(fractionalProgress, animated: true)
        }
    }
    
    func startProgressBar(){
        self.counter++
    }
    
    //# MARK: Design
    
    func blueDesign(){
        
        titleLabel.text = "Unregistered workout"
        topBarView.backgroundColor = blue()
        pauseLabel.textColor = blue()
        stopLabel.textColor = blue()
        repeatLabel.textColor = blue()
        pauseButton.setImage(UIImage(named: "pauseBlue"), forState: UIControlState.Normal)
        stopButton.setImage(UIImage(named: "stopBlue"), forState: UIControlState.Normal)
        repeatButton.setImage(UIImage(named: "repeatBlue"), forState: UIControlState.Normal)
    }
    
    func redDesign(){
       
        titleLabel.text = "\(workoutModel.name) exercises"
        topBarView.backgroundColor = red()
        pauseLabel.textColor = red()
        stopLabel.textColor = red()
        repeatLabel.textColor = red()
        pauseButton.setImage(UIImage(named: "pauseRed"), forState: UIControlState.Normal)
        stopButton.setImage(UIImage(named: "stopRed"), forState: UIControlState.Normal)
        repeatButton.setImage(UIImage(named: "repeatRed"), forState: UIControlState.Normal)
    }
    
    func red() -> UIColor{
        return UIColor(red: 0.75, green: 0.118, blue: 0.176, alpha: 1.0)
    }
    
    func blue() -> UIColor{
        return UIColor(red: 0.082, green: 0.647, blue: 0.859, alpha: 1.0)
    }
  
}

