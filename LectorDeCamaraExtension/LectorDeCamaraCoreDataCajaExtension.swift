//
//  LectorDeCamaraCoreDataCajaExtension.swift
//  LectorDeCamaraExtension
//
//  Created by Carlos Caraccia on 10/30/20.
//

import Foundation
import CoreData

extension Caja {
    
    static func with(stringFromFile: String, context:NSManagedObjectContext) -> Bool {
        
        // first parse the file into dictionarys
        guard let result = ParseInputFile.parseProduccionFile(from: stringFromFile) else { fatalError("wrong file") }
        
        // check if the box is in the database
        let request = NSFetchRequest<Caja>(entityName: "Caja")
        request.predicate = NSPredicate(format: "uniqueId IN %@", result.uniqueIds)
        request.sortDescriptors = [NSSortDescriptor(key: "fechaDeProduccion", ascending: false)]
        
        // fetch the box
        guard let fetchResult = try? context.fetch(request) else { fatalError("Error when fetching Caja in the database") }
        
        // use set to enter the non entered objects, using substraction
        let substractionSet = Set(result.uniqueIds).subtracting(fetchResult.map{ $0.uniqueId })
        
        // date formatter object we will use to enter the Caja object in the database
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yy"
        
        // store the remaining items in the database
        if substractionSet.count != 0 {
            
            let boxIdToDetails = result.dictBoxIdDetails
            substractionSet.forEach { (uniqueId) in
                
                // create a new Caja object and fill its properties
                let caja = Caja(context: context)
                caja.uniqueId = uniqueId
                caja.boxId = Int64(boxIdToDetails![uniqueId!]![1]!)!
                caja.destino = boxIdToDetails![uniqueId!]![0]!
                caja.pesoBruto_ = (Decimal(string: boxIdToDetails![uniqueId!]![2]!)! as NSDecimalNumber)
                caja.pesoDelEnvase_ = (Decimal(string: boxIdToDetails![uniqueId!]![3]!)! as NSDecimalNumber)
                caja.pesoNeto_ = (Decimal(string: boxIdToDetails![uniqueId!]![4]!)! as NSDecimalNumber)
                caja.codigoProducto = Int32(boxIdToDetails![uniqueId!]![6]!)!
                caja.descripcion = boxIdToDetails![uniqueId!]![7]!
                caja.fechaDeProduccion = formatter.date(from: result.idProduccion.components(separatedBy: "-").first!)
                                
                try? context.save()

            }
            return true
        } else  {
            return false
        }
    }
}
