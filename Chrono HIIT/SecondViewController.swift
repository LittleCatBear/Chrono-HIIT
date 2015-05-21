//
//  SecondViewController.swift
//  Chrono HIIT
//
//  Created by Julie Huguet on 26/03/2015.
//  Copyright (c) 2015 Witios. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var saveLabel: UILabel!
    //swap field of a workout
    @IBOutlet weak var timingTextField: UITextField!
    
    //top bar (blue or red)
    @IBOutlet weak var topBarView: UIView!
    
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var swapLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    //totalTime field of a workout
    @IBOutlet weak var roundTextField: UITextField!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playLabel: UILabel!
    //countdown field of a workout
    @IBOutlet weak var countDownTextField: UITextField!
    
    // Tells a user if he is in a new or already saved workout
    @IBOutlet weak var workoutStatusLabel: UILabel!
    
    // The label name for the saved/selected workout
    @IBOutlet weak var workoutNameLabel: UILabel!
    
    // Update a previously saved workout when  clicked
    @IBOutlet weak var updateButton: UIButton!
    
    // The textfield name  of the current saved and selected workout
    @IBOutlet weak var workoutNameTextField: UITextField!
    
    // Save a workout in Core Data
    @IBOutlet weak var saveButton: UIButton!
    
    
    // token to know if keyboard has already push the view up
    var keyboardIsAlreadyShown:Bool = false
   
     var screenSize: CGSize = CGSize()
    //constraint
    
    @IBOutlet weak var totalTimeHeight: NSLayoutConstraint!
    @IBOutlet weak var swapHeight: NSLayoutConstraint!
    @IBOutlet weak var countDownHeight: NSLayoutConstraint!
    @IBOutlet weak var workoutNameHeight: NSLayoutConstraint!
    
    //# MARK: Prepare and load current view according to context (new workout, unregistered workout, saved workout)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenSize = UIScreen.mainScreen().bounds.size
        
        switch(screenSize.width, screenSize.height) {
            case (320, 480):self.canDisplayBannerAds = false
            default: self.canDisplayBannerAds = true
        }

        
        self.timingTextField.delegate = self
        self.roundTextField.delegate = self
        self.countDownTextField.delegate = self
        self.workoutNameTextField.delegate = self
        self.countDownTextField.text = ""
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    func keyboardWillShow(sender: NSNotification) {
        println(sender)
        if(!keyboardIsAlreadyShown){
            self.view.frame.origin.y -= 75
            keyboardIsAlreadyShown = true
        }
        
    }
    func keyboardWillHide(sender: NSNotification) {
        if(keyboardIsAlreadyShown){
            self.view.frame.origin.y += 75
            keyboardIsAlreadyShown = false
        }
                
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.workoutNameTextField.tag = 1
        
        adjustViewLayout(UIScreen.mainScreen().bounds.size)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if(isRegistered){
            updateViewForRegisteredWorkout()
        } else if(isUnregistered){
            
            blueDesign()
            updateButton.hidden = true
            updateButton.enabled = false
            updateLabel.hidden = true
            saveButton.enabled = true
            saveButton.hidden = false
            saveLabel.hidden = false
            workoutNameLabel.hidden = true
            workoutNameTextField.hidden = true
            if(isNew){
                cleanFields()
                isNew = false
            }
        } else{
            cleanFields()
            blueDesign()
            updateButton.hidden = true
            updateButton.enabled = false
            updateLabel.hidden = true
            saveButton.enabled = true
            saveButton.hidden = false
            saveLabel.hidden = false
            workoutNameLabel.hidden = true
            workoutNameTextField.hidden = true
        }
       
    }
    
    func  updateViewForRegisteredWorkout(){
        redDesign()
        getWorkoutData()
        updateButton.hidden = false
        updateButton.enabled = true
        updateLabel.hidden = false
        saveButton.enabled = false
        saveButton.hidden = true
        saveLabel.hidden = true
        workoutNameLabel.hidden = false
        workoutNameTextField.hidden = false
    }
    
    func cleanFields(){
        self.workoutStatusLabel?.text = "New workout"
        self.timingTextField?.text = ""
        self.roundTextField?.text = ""
        self.countDownTextField?.text = ""
    }
    
    func getWorkoutData(){
        self.workoutStatusLabel.text = "Workout \(workoutModel.name)"
        timingTextField.text = "\(workoutModel.swap)"
        countDownTextField.text = "\(workoutModel.countdown)"
        roundTextField.text = "\(workoutModel.totalTime)"
        workoutNameTextField.text = workoutModel.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //# MARK: adjust layout
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        adjustViewLayout(size)
    }
    
    func adjustViewLayout(size: CGSize) {
        
        switch(size.width, size.height) {
        case (320, 480):                        // iPhone 4S in portrait
            totalTimeHeight.constant = 25
            swapHeight.constant = 25
            workoutNameHeight.constant = 25
            countDownHeight.constant = 25
        case (414, 736):                        // iPhone 6 Plus in portrait
            totalTimeHeight.constant = 50
            swapHeight.constant = 50
            workoutNameHeight.constant = 50
            countDownHeight.constant = 50
            view.setNeedsLayout()
        default:
            break
        }
    }
    
    //# MARK: Unwind segue from TimerViewController
    @IBAction func goToInit(segue:UIStoryboardSegue){
        UIApplication.sharedApplication().idleTimerDisabled = false
    }
    
    //# MARK: Data validation before segue & segue to chrono (TimerViewController)
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "showTimer"){
            var temp = 0
            var tempCd = 5
            var tempRound = 0
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
            workoutModel.swap = temp
            workoutModel.totalTime = tempRound
            workoutModel.countdown = tempCd
        }
    }
    
    
    @IBAction func onClickStartButton(sender: UIButton) {
        
        if(!isRegistered){
            isUnregistered = true
        }
        
        if shouldPerformSegueWithIdentifier("showTimer", sender: sender){
            self.performSegueWithIdentifier("showTimer", sender: sender)
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return validateData()
    }
    
    func validateData() -> Bool {
        var flag:Bool = false
        if(exercises.count>0){
            
            if (self.roundTextField.text != "" && self.roundTextField.text!.toInt() != nil && self.roundTextField.text.toInt() > 0){
                if( self.timingTextField.text != "" && self.timingTextField.text!.toInt() != nil && self.timingTextField.text.toInt() > 0){
                    if(self.countDownTextField.text!.toInt() == nil || self.countDownTextField.text!.toInt() >= 0){
                        flag = true
                    }else{
                        self.view.makeToast(message: "Countdown should be at least 0 sec ", duration:3.0, title: "Invalid data", type:"ko")
                    }
                } else{
                    self.view.makeToast(message: "Swap timing should be at least 1 sec", duration:3.0, title: "Invalid data", type:"ko")
                }
            } else{
                self.view.makeToast(message: "Total time should be at least 1 sec", duration:3.0, title: "Invalid data", type:"ko")
            }
        }else{
            self.view.makeToast(message: "You should at least have 1 exercise in your workout ", duration:3.0, title: "Invalid data", type:"ko")
        }
        return flag
    }
    
    //# MARK: keyboard behaviour
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
       
        if(isNew){
            isNew = false
            isUnregistered = true
        }
    }
    
    //# MARK: Save workout
    @IBAction func onClickSaveButton(sender: UIButton) {
        if(validateData()){
            getDataForSaving()
            getWorkoutName()
        }
    }
    
    //Move data from the textfields view to object workoutModel
    func getDataForSaving(){
        workoutModel.swap = self.timingTextField.text!.toInt()!
        if (self.countDownTextField!.text.toInt() == nil){
            workoutModel.countdown = 0
        } else{
            workoutModel.countdown = self.countDownTextField!.text.toInt()!
        }
        workoutModel.totalTime = self.roundTextField!.text.toInt()!
    }
    
    func saveWorkout(){
        let entity =  NSEntityDescription.entityForName("Workout",
            inManagedObjectContext:
            managedObjectContext!)
        let wo = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedObjectContext)
        wo.setValue(workoutModel.name, forKey: "name")
        wo.setValue(workoutModel.swap, forKey: "swap")
        wo.setValue(workoutModel.countdown, forKey: "countdown")
        
        var exe:[Exercise] = [Exercise]()
        for e in workoutModel.exercise{
            let ent = NSEntityDescription.entityForName("Exercise", inManagedObjectContext: managedObjectContext!)
            let ex = NSManagedObject(entity: ent!, insertIntoManagedObjectContext:managedObjectContext) as! Exercise
            ex.setValue(e.name, forKey: "name")
            exe.append(ex)
        }
        
        wo.setValue(NSOrderedSet(array: exe), forKey: "exercise")
        wo.setValue(workoutModel.totalTime, forKey: "totalTime")
        
        var error: NSError?
        if !(managedObjectContext?.save(&error) != nil) {
            println("Could not save workout\(error), \(error?.userInfo)")
            self.view.makeToast(message: "An error occured, your workout is not saved", type:"ko")
        }
        else{
            self.view.makeToast(message: "Workout saved!", type:"ok")
            isRegistered = true
            isUnregistered = false
            updateViewForRegisteredWorkout()
            
            workoutId = wo.objectID
            tabBarController?.tabBar.tintColor = red()
        }
        managedObjectContext?.reset()
    }
    
    // Set Workout's name attribute when it is saved
    func getWorkoutName()->Void{
        var alert = UIAlertController(title: "Saving your workout", message: "Please enter a name for your workout: ", preferredStyle: UIAlertControllerStyle.Alert)
        var name = ""
        
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Enter workout name:"
            
        })
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as! UITextField
            name = textField.text
            if name != ""{
                workoutModel.name = name
                self.saveWorkout()
            } else{
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //# MARK: update workout
    @IBAction func onClickUpdateButton(sender: UIButton) {
        
        if(validateData()){
            getDataForSaving()
            workoutModel.name = workoutNameTextField.text
            if(workoutModel.name != ""){
                updateWorkout()
            } else{
                var alert = UIAlertController(title: "Updating your workout", message: "Please enter a name for your workout: ", preferredStyle: UIAlertControllerStyle.Alert)
                var name = ""
                
                alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                    textField.placeholder = "Enter workout name:"
                    
                })
                
                var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
                    UIAlertAction in
                }
                alert.addAction(cancelAction)
                
                alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    let textField = alert.textFields![0] as! UITextField
                    name = textField.text
                    if name != ""{
                        workoutModel.name = name
                        self.workoutNameTextField.text = name
                        self.updateWorkout()
                    } else{
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    //Get the Core Data Workout to update by its ManagedObjectID got from WorkoutViewController (when a cell is selected)
    func getWorkoutToUpdatewithId()->Workout{
        var toUpdate:Workout = managedObjectContext?.objectWithID(workoutId) as! Workout
        return toUpdate
    }
    
    // updating a workout: delete odl exercises array and create a new one with current exercise array from FirstViewController
    func updateWorkout(){
        var toUpdate = getWorkoutToUpdatewithId()
        
        let fetchRequest = NSFetchRequest(entityName:"Exercise")
        let predicate = NSPredicate(format: "workout == %@", toUpdate)
        fetchRequest.predicate = predicate
        
        var err: NSError? = nil
        var exeToDelete = managedObjectContext!.executeFetchRequest(fetchRequest,error: &err)! as! [Exercise]
        for e in exeToDelete{
            //    NSLog("deletion: %@", e)
            managedObjectContext!.deleteObject(e as Exercise)
        }
        
        toUpdate.setValue(workoutModel.name, forKey: "name")
        toUpdate.setValue(workoutModel.countdown, forKey: "countdown")
        toUpdate.setValue(workoutModel.totalTime, forKey: "totalTime")
        toUpdate.setValue(workoutModel.swap, forKey: "swap")
        
        var exe:[Exercise] = [Exercise]()
        for e in workoutModel.exercise{
            let ent = NSEntityDescription.entityForName("Exercise", inManagedObjectContext: managedObjectContext!)
            let ex = NSManagedObject(entity: ent!, insertIntoManagedObjectContext:managedObjectContext) as! Exercise
            ex.setValue(e.name, forKey: "name")
            exe.append(ex)
        }
        
        toUpdate.setValue(NSOrderedSet(array: exe), forKey: "exercise")
        
        var error: NSError?
        if !(managedObjectContext?.save(&error) != nil) {
            println("Could not save workout\(error), \(error?.userInfo)")
            self.view.makeToast(message: "An error occured, your workout is not updated", type:"ko")
        }
        else{
            self.workoutStatusLabel.text = "Workout \(workoutModel.name)"
            self.view.makeToast(message: "Workout updated!", type:"ok")
        }
        managedObjectContext?.reset()
    }
    
    
    //# MARK: prepare for update when changing tab
    
    func getDataForUpdating(){
        if(self.workoutNameTextField.text != ""){
            workoutModel.name = self.workoutNameTextField.text
        } else{
            workoutModel.name = " "
        }
            if(self.timingTextField.text!.toInt() != nil){
                workoutModel.swap = self.timingTextField.text!.toInt()!
            } else{
             workoutModel.swap = 0
        }
        if(self.countDownTextField!.text.toInt() != nil){
            workoutModel.countdown = self.countDownTextField!.text.toInt()!
        } else{
            workoutModel.countdown = 0
        }
        if(self.roundTextField!.text.toInt() != nil){
             workoutModel.totalTime = self.roundTextField!.text.toInt()!
        } else{
             workoutModel.totalTime = 0
        }
    }
    
    
    //# MARK: Design
    
    func blueDesign(){
        updateLabel.textColor = blue()
        saveLabel.textColor = blue()
        //  workoutNameLabel.textColor = UIColor(red: 0.082, green: 0.647, blue: 0.859, alpha: 1.0)
        saveButton.setImage(UIImage(named: "saveBlue"), forState: UIControlState.Normal)
        totalTimeLabel.textColor = blue()
        swapLabel.textColor = blue()
        countdownLabel.textColor = blue()
        playButton.setImage(UIImage(named: "startBlue"), forState: UIControlState.Normal)
        playLabel.textColor = blue()
        topBarView.backgroundColor = blue()
        
    }
    
    func redDesign(){
        updateLabel.textColor = red()
        saveLabel.textColor = red()
        workoutNameLabel.textColor = red()
        totalTimeLabel.textColor = red()
        swapLabel.textColor = red()
        countdownLabel.textColor = red()
        playButton.setImage(UIImage(named: "startRed"), forState: UIControlState.Normal)
        playLabel.textColor = red()
        topBarView.backgroundColor = red()
    }
    
    func red() -> UIColor{
        return UIColor(red: 0.75, green: 0.118, blue: 0.176, alpha: 1.0)
    }
    
    func blue() -> UIColor{
        return UIColor(red: 0.082, green: 0.647, blue: 0.859, alpha: 1.0)
    }
}

