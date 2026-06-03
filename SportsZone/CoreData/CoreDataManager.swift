//
//  File.swift
//  SportsZone
//
//  Created by mohamed sharaf on 31/05/2026.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let context =
    (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext
    
    private init() {}
}
