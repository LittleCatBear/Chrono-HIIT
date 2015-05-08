//
//  Exercise.swift
//  Chrono HIIT
//
//  Created by Julie Huguet on 03/04/2015.
//  Copyright (c) 2015 Witios. All rights reserved.
//

import Foundation
import CoreData

@objc(Exercise)
class Exercise: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var workout: Workout

}
