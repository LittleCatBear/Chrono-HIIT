//
//  WorkoutModel.swift
//  Chrono HIIT
//
//  Created by Julie Huguet on 02/04/2015.
//  Copyright (c) 2015 Shokunin-Software. All rights reserved.
//

import Foundation

class WorkoutModel {
    
    var name: String = ""
    var swap: NSInteger = 0
    var countdown: NSInteger = 0
    var totalTime: NSInteger = 0
    var exercise:[ExerciseModel] = [ExerciseModel]()
    
}