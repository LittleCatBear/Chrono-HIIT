//
//  SecondViewController.swift
//  Chrono HIIT
//
//  Created by Julie Huguet on 26/03/2015.
//  Copyright (c) 2015 Shokunin-Software. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var timingTextField: UITextField!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var roundTextField: UITextField!
    @IBOutlet weak var countDownTextField: UITextField!
    var workout:Workout = Workout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timingTextField.delegate = self
        self.roundTextField.delegate = self
        self.countDownTextField.delegate = self
        self.countDownTextField.text = "5"
        self.timingLabel.text = ""

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goToInit(segue:UIStoryboardSegue){
        self.timingLabel.text = ""
        self.timingLabel.textColor = UIColor.blackColor()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if (segue.identifier == "showTimer"){
            var temp = 0
            var tempCd = 5
            var tempRound = 1
            if (self.timingTextField.text != ""){
                temp = self.timingTextField.text.toInt()!
            }
            if (self.roundTextField.text != ""){
                if(self.roundTextField.text!.toInt() != nil && self.roundTextField.text.toInt() > 0){
                    tempRound = self.roundTextField.text!.toInt()!
                }
            }
            if (self.countDownTextField.text != ""){
                if(self.countDownTextField.text!.toInt() != nil && self.countDownTextField.text.toInt() > 0){
                    tempCd = self.countDownTextField.text!.toInt()!
                } else{
                    tempCd = 0
                }
            } else{
                tempCd = 0
            }

            
            var controller:TimerViewController = segue.destinationViewController as TimerViewController
            workout.swap = temp
            workout.totalTime = tempRound
            workout.countdown = tempCd
            //controller.seconds = temp
            //controller.totalRounds = tempRound
            //controller.cd = tempCd
        }
    }
    
    @IBAction func onClickStartButton(sender: UIButton) {
        
        if shouldPerformSegueWithIdentifier("showTimer", sender: sender){
            self.performSegueWithIdentifier("showTimer", sender: sender)
        }
        else{
            self.timingLabel.text = "Wrong data for Switch !"
            self.timingLabel.textColor = UIColor(red: 255.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        var flag:Bool = false
        if (self.timingTextField.text != ""){
            if(self.timingTextField.text!.toInt() != nil && self.timingTextField.text.toInt() > 0){
                flag = true
            }
        }
        return flag
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.timingLabel.text = ""
        self.timingLabel.textColor = UIColor.blackColor()
    }

}

