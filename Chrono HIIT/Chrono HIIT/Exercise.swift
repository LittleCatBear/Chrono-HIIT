//
//  Exercise.swift
//  Chrono HIIT
//
//  Created by Julie Huguet on 02/04/2015.
//  Copyright (c) 2015 Shokunin-Software. All rights reserved.
//

import Foundation
import CoreData

class Exercise: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var workout: Workout

}
