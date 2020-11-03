//
//  Persistence.swift
//  LectorDeCamara
//
//  Created by Carlos Caraccia on 10/30/20.
//

import CoreData

class NSCustomPersistentContainer: NSPersistentContainer {
    
    override open class func defaultDirectoryURL() -> URL {
        var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.LectorDeCamara")
        storeURL = storeURL?.appendingPathComponent("LectorDeCamara.sqlite")
        return storeURL!
    }

}

struct PersistenceController {
    
    static let shared = PersistenceController()
    
    let container: NSCustomPersistentContainer

    init(inMemory: Bool = false) {
        container = NSCustomPersistentContainer(name: "LectorDeCamara")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
