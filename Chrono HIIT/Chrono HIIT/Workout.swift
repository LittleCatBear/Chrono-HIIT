//
//  Workout.swift
//  Chrono HIIT
//
//  Created by Julie Huguet on 02/04/2015.
//  Copyright (c) 2015 Shokunin-Software. All rights reserved.
//

import Foundation
import CoreData

@objc(Workout)
class Workout: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var swap: NSInteger
    @NSManaged var countdown: NSInteger
    @NSManaged var totalTime: NSInteger
    @NSManaged var exercise: NSOrderedSet

}
