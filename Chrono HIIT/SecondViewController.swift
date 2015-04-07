//
//  SecondViewController.swift
//  Chrono HIIT
//
//  Created by Julie Huguet on 26/03/2015.
//  Copyright (c) 2015 Shokunin-Software. All rights reserved.
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
    
    //error label
    @IBOutlet weak var errorLabel: UILabel!
    
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
    
    //# MARK: Prepare and load current view according to context (new workout, unregistered workout, saved workout)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timingTextField.delegate = self
        self.roundTextField.delegate = self
        self.countDownTextField.delegate = self
        self.countDownTextField.text = "5"
        self.errorLabel.text = ""
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if(isRegistered){
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
        /*
        if token2{
            cleanFields()
            token2 = false
            updateButton.hidden = true
            updateButton.enabled = false
            updateLabel.hidden = true
            saveButton.enabled = true
            saveButton.hidden = false
            saveLabel.hidden = false
            workoutNameLabel.hidden = true
            workoutNameTextField.hidden = true
            //  blueDesign()
        }
        else if workoutModel.name != ""{
            getWorkoutData()
            updateButton.hidden = false
            updateButton.enabled = true
            updateLabel.hidden = false
            saveButton.enabled = false
            saveButton.hidden = true
            saveLabel.hidden = true
            workoutNameLabel.hidden = false
            workoutNameTextField.hidden = false
            // redDesign()
        }
        else{
            updateButton.hidden = true
            updateButton.enabled = false
            updateLabel.hidden = true
            workoutNameLabel.hidden = true
            workoutNameTextField.hidden = true
            // blueDesign()
        }
*/
    }
    
    func cleanFields(){
        self.workoutStatusLabel.text = "New workout"
        self.timingTextField.text = ""
        self.roundTextField.text = ""
        self.countDownTextField.text = ""
    }
    
    func getWorkoutData(){
        self.workoutStatusLabel.text = "Editing workout \(workoutModel.name)"
        timingTextField.text = String(workoutModel.swap)
        countDownTextField.text = String(workoutModel.countdown)
        roundTextField.text = String(workoutModel.totalTime)
        workoutNameTextField.text = workoutModel.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //# MARK: Unwind segue from TimerViewController
    @IBAction func goToInit(segue:UIStoryboardSegue){
        self.errorLabel.text = ""
      //  self.errorLabel.textColor = UIColor.blackColor()
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
        
        if shouldPerformSegueWithIdentifier("showTimer", sender: sender){
            self.performSegueWithIdentifier("showTimer", sender: sender)
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
      return validateData()
    }
    
    func validateData() -> Bool {
        var flag:Bool = false
        if (self.timingTextField.text != ""){
            if(self.timingTextField.text!.toInt() != nil && self.timingTextField.text.toInt() > 0){
                if(self.roundTextField.text != "" && self.roundTextField.text!.toInt() != nil && self.roundTextField.text.toInt() > 0){
                    if(self.countDownTextField.text!.toInt()<0){
                        errorLabel.textColor = UIColor.redColor()
                        errorLabel.text = "Invalid data for COUNTDOWN. Countdown should be >= 0 sec"
                    }
                    else{
                        flag = true
                    }
                    
                } else{
                    errorLabel.textColor = UIColor.redColor()
                    errorLabel.text = "Invalid data for TOTAL TIME. Total time should be >= 1 sec"
                }
                
            } else{
                errorLabel.textColor = UIColor.redColor()
                errorLabel.text = "Invalid data for SWAP. Swap timing should be >= 1 sec"
            }
        }
        return flag
    }
    
    //# MARK: keyboard behaviour
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.errorLabel.text = ""
       // self.errorLabel.textColor = UIColor.blackColor()
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
        workoutModel.countdown = self.countDownTextField!.text.toInt()!
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
            let ex = NSManagedObject(entity: ent!, insertIntoManagedObjectContext:managedObjectContext) as Exercise
            ex.setValue(e.name, forKey: "name")
            exe.append(ex)
        }
        
        wo.setValue(NSOrderedSet(array: exe), forKey: "exercise")
        wo.setValue(workoutModel.totalTime, forKey: "totalTime")
        
        var error: NSError?
        if !(managedObjectContext?.save(&error) != nil) {
            println("Could not save workout\(error), \(error?.userInfo)")
        }
        else{
            isRegistered = true
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
            let textField = alert.textFields![0] as UITextField
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
                alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    let textField = alert.textFields![0] as UITextField
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
        var toUpdate:Workout = managedObjectContext?.objectWithID(workoutId) as Workout
        println("to update \(toUpdate.name)")
        return toUpdate
    }
    
    // updating a workout: delete odl exercises array and create a new one with current exercise array from FirstViewController
    func updateWorkout(){
        var toUpdate = getWorkoutToUpdatewithId()
        
        let fetchRequest = NSFetchRequest(entityName:"Exercise")
        let predicate = NSPredicate(format: "workout == %@", toUpdate)
        fetchRequest.predicate = predicate
        
        var err: NSError? = nil
        var exeToDelete = managedObjectContext!.executeFetchRequest(fetchRequest,error: &err)! as [Exercise]
        for e in exeToDelete{
            NSLog("deletion: %@", e)
            managedObjectContext!.deleteObject(e as Exercise)
        }
        
        toUpdate.setValue(workoutModel.name, forKey: "name")
        toUpdate.setValue(workoutModel.countdown, forKey: "countdown")
        toUpdate.setValue(workoutModel.totalTime, forKey: "totalTime")
        toUpdate.setValue(workoutModel.swap, forKey: "swap")
        
        var exe:[Exercise] = [Exercise]()
        for e in workoutModel.exercise{
            let ent = NSEntityDescription.entityForName("Exercise", inManagedObjectContext: managedObjectContext!)
            let ex = NSManagedObject(entity: ent!, insertIntoManagedObjectContext:managedObjectContext) as Exercise
            ex.setValue(e.name, forKey: "name")
            exe.append(ex)
        }
        
        toUpdate.setValue(NSOrderedSet(array: exe), forKey: "exercise")
        
        var error: NSError?
        if !(managedObjectContext?.save(&error) != nil) {
            println("Could not save workout\(error), \(error?.userInfo)")
        }
        managedObjectContext?.reset()
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

