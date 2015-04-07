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
    @IBOutlet weak var timingLab: UILabel!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().idleTimerDisabled = true
        repeatButton.enabled = false
        pauseButton.enabled = false
        
        progressBarView.setProgress(0, animated: true)
        
        cd = NSInteger(workoutModel.countdown)
        self.sec = NSInteger(workoutModel.totalTime)
        self.tempSwap = NSInteger(workoutModel.swap)
        if(cd > 0){
            countdown = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("countDownSub"), userInfo: nil, repeats: true)
        } else{
            //addCircleView(totalChronoView, duration:NSTimeInterval(sec), withFadeOut:false)
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
        self.exerciseLabel.text = getExercise()
        self.exerciseLabel.sizeToFit()
        self.exerciseLabel.numberOfLines = 0
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
    
    func speech(say:NSString){
        myUtterance = AVSpeechUtterance(string:say)
        myUtterance.rate = 0.1
        synth.speakUtterance(myUtterance)
    }
    
    func countDownSub(){
        if(cd == -1){
            countdown.invalidate()
           // addCircleView(totalChronoView, duration:NSTimeInterval(sec), withFadeOut:false)
            startProgressBar()
            lauchExercise(Float(workoutModel.totalTime))
        } else if(cd == 0){
            self.exerciseLabel.text = "Begin"
            speech(self.exerciseLabel.text!)
        } else{
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
            var temp = view.subviews[view.subviews.count-1] as CircleAnimationView
            temp.pauseAnim()
            self.exerciseLabel.text = "Time completed"
            speech(self.exerciseLabel.text!)
            timer.invalidate()
            repeatButton.enabled = true
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
        countdown.invalidate()
        UIApplication.sharedApplication().idleTimerDisabled = false
        repeatButton.enabled = true
    }
    
    @IBAction func onClickRepeatButton(sender: UIButton) {
        repeatButton.enabled = false
        timer.invalidate()
        cd = NSInteger(workoutModel.countdown)
        sec = NSInteger(workoutModel.totalTime)
        tempSwap = NSInteger(workoutModel.swap)
        countdown = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("countDownSub"), userInfo: nil, repeats: true)
    }
    
    @IBAction func onClickPauseButton(sender: UIButton) {
        if(flag == false){
            flag = true
            
            
            var temp = view.subviews[view.subviews.count-1] as CircleAnimationView
            temp.pauseAnim()
            pauseButton.setImage(UIImage(named: "start.png"), forState: UIControlState.Normal)
            timer.invalidate()
        } else{
            var temp = view.subviews[view.subviews.count-1] as CircleAnimationView
            temp.resumeAnim()
           // timer.fire()
            lauchExercise(Float(sec))
            flag =  false
            pauseButton.setImage(UIImage(named: "pause.png"), forState: UIControlState.Normal)
        }
    }
    
    func addCircleView(attachableView:UIView, duration: NSTimeInterval, withFadeOut:Bool) {
        var circleWidth = CGFloat(attachableView.frame.width-50)
        var circleHeight = circleWidth
        var circleAnimationView = CircleAnimationView(frame: CGRectMake(attachableView.center.x - circleWidth/2,attachableView.center.y - circleHeight/2, circleWidth, circleHeight), line: 50.0)
        view.addSubview(circleAnimationView)
        circleAnimationView.animateCircle(duration)
        if(withFadeOut){
            circleAnimationView.fadeOutNoRepeat(duration: duration, delay: 1.0)
        }
    }
    
    //# MARK: progress bar
    var counter:Int = 0 {
        didSet {
            let fractionalProgress = Float(counter) / Float(workoutModel.totalTime)
            let animated = counter != 0
            NSLog("\(fractionalProgress)")
            progressBarView.setProgress(fractionalProgress, animated: animated)
        }
    }
    
    func startProgressBar(){
       // self.counter = 0
        self.counter++
    }
  
}

