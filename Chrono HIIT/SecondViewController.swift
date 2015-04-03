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
    

    @IBOutlet weak var timingTextField: UITextField!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var roundTextField: UITextField!
    @IBOutlet weak var countDownTextField: UITextField!
//    var workout:Workout = Workout()
    @IBOutlet weak var workoutStatusLabel: UILabel!
    
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    
    @IBOutlet weak var workoutNameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
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
        
        if token2{
            cleanFields()
            token2 = false
            updateButton.hidden = true
            updateButton.enabled = false
            saveButton.enabled = true
            saveButton.hidden = false
            workoutNameLabel.hidden = true
            workoutNameTextField.hidden = true
        }
        else if workoutModel.name != ""{
            getWorkoutData()
            updateButton.hidden = false
            updateButton.enabled = true
            saveButton.enabled = false
            saveButton.hidden = true
            workoutNameLabel.hidden = false
            workoutNameTextField.hidden = false
        }
        else{
            updateButton.hidden = true
            updateButton.enabled = false
            workoutNameLabel.hidden = true
            workoutNameTextField.hidden = true
        }
    }
    
    func cleanFields(){
        self.workoutStatusLabel.text = "New Workout"
        self.workoutStatusLabel.textColor = UIColor.greenColor()
        self.timingTextField.text = ""
        self.roundTextField.text = ""
        self.countDownTextField.text = ""
    }
    
    func getWorkoutData(){
        self.workoutStatusLabel.text = "Editing Workout \(workoutModel.name)"
        self.workoutStatusLabel.textColor = UIColor.blueColor()
        timingTextField.text = String(workoutModel.totalTime)
        countDownTextField.text = String(workoutModel.countdown)
        roundTextField.text = String(workoutModel.swap)
        workoutNameTextField.text = workoutModel.name
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
            workoutModel.swap = tempRound
            workoutModel.totalTime = temp
            workoutModel.countdown = tempCd
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

    @IBAction func onClickSaveButton(sender: UIButton) {
        getDataForSaving()
        getWorkoutName()
    }
    
    func getDataForSaving(){
        workoutModel.swap = self.roundTextField.text!.toInt()!
        workoutModel.countdown = self.countDownTextField!.text.toInt()!
        workoutModel.totalTime = self.timingTextField!.text.toInt()!
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
        managedObjectContext?.reset()
    }
    
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
            //managedObjectContext!.save(&err)
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
    
    func getWorkoutToUpdatewithId()->Workout{
        var toUpdate:Workout = managedObjectContext?.objectWithID(workoutId) as Workout
        println("to update \(toUpdate.name)")
        return toUpdate
    }
    
    @IBAction func onClickUpdateButton(sender: UIButton) {
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

