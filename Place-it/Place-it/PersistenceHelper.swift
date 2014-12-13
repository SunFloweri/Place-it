//
//  PersistenceHelper.swift
//  Place-it
//
//  Created by Ilona Michalowska on 12/10/14.
//  Copyright (c) 2014 Ilona Michalowska & Irina Kalashnikova. All rights reserved.
//

import UIKit
import CoreData

class PersistenceHelper: NSObject {
    
    var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    var context: NSManagedObjectContext
    
    override init(){
        context = appDel.managedObjectContext!
    }
    
    
    // here add more paramaters - maybe? +name, desc+
    func save(entity: String, parameters: Dictionary<String,String>) -> Bool{
        
        var newEntity = NSEntityDescription.insertNewObjectForEntityForName(entity, inManagedObjectContext: context) as NSManagedObject
        for (key, value) in parameters{
            newEntity.setValue(value, forKey: key)
        }
        
        return context.save(nil)
    }
    
    func list(entity: String) -> NSArray{
        
        var request = NSFetchRequest(entityName: entity)
        request.returnsObjectsAsFaults = false;
        var results: NSArray = context.executeFetchRequest(request, error: nil)!
        return results
    }
    
    // key here too...
    func remove(entity:String, key:String, value:String) -> Bool{
        
        var request = NSFetchRequest(entityName: entity)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "\(key) = %@", value)
        var results: NSArray = context.executeFetchRequest(request, error: nil)!
        
        if(results.count > 0){
            
            var res = results[0] as NSManagedObject
            context.deleteObject(res)
            context.save(nil)
            return true
        }
        
        return false
    }
    
}