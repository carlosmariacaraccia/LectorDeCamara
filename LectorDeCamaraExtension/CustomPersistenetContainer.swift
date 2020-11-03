//
//  CustomPersistenetContainer.swift
//  ExternalFilesOpener
//
//  Created by Carlos Caraccia on 10/6/20.
//  Copyright © 2020 Carlos Caraccia. All rights reserved.
//

import Foundation
import CoreData

class NSCustomPersistentContainer: NSPersistentContainer {
    
    override open class func defaultDirectoryURL() -> URL {
        var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.LectorDeCamara")
        storeURL = storeURL?.appendingPathComponent("LectorDeCamara.sqlite")
        return storeURL!
    }

}

