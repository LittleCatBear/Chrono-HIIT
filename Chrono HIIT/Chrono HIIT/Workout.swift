//
//  Workout.swift
//  Chrono HIIT
//
//  Created by Julie Huguet on 02/04/2015.
//  Copyright (c) 2015 Shokunin-Software. All rights reserved.
//

import Foundation
import CoreData

class Workout: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var swap: NSNumber
    @NSManaged var countdown: NSNumber
    @NSManaged var totalTime: NSNumber
    @NSManaged var exercise: NSOrderedSet

}
