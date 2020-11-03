//
//  MeatTradeFaenaExtensionParseFrigoFiles.swift
//  MeatTradeFaenaExtension
//
//  Created by Carlos Caraccia on 10/29/20.
//

import Foundation
import CoreData

class StoreFrigoFiles {
    
    /// A function that classifies the files according to its type and stores it in Core Data
    /// - Parameters:
    ///   - url: the URL resulting from the file in NSExtensionContext
    ///   - data: the Data resulting from the file in NSExtensionContext
    ///   - context: the NSManagedObjectContext in which we are storing the data
    /// - Returns: a String that tells us if we succeeded or not storing the file
    static func with(fileUrl url:URL, fileData data:Data?, context:NSManagedObjectContext) -> String {
        
        let result = DecideTypeOfFile.with(fileUrl: url)
        
        switch result.fileType {
        
        case .salidaDeDepostada:
            let result = Caja.with(stringFromFile: result.stringFromFile!, context: context)
            if result {
                return """
                        Se agregaron las
                        unidades de \n producto
                        terminado.
                        """
            } else {
                return """
                        La unidades de producto termiando
                        no pudieron agregarse, porque ya
                        se encontraban en el stock.
                        """
            }
            
        default:
            return "El archivo no puede ser leido por esta unidad"
        }
        
        
    }
}
