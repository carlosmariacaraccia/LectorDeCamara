//
//  CoreDataExtensions.swift
//  LectorDeCamara
//
//  Created by Carlos Caraccia on 11/2/20.
//

import Foundation
import CoreData

extension Pallet {
    
    /// Function to create Pallet objects and insert the into the managed object context
    /// - Parameters:
    ///   - numero: an int representing the pallet id
    ///   - fecha: the date the pallet was created
    ///   - context: the managed object context instance where the object will be inserted
    /// - Returns: a bool indicating where the operation succeeded or not
    static func with(numero:Int32, fecha:Date, context:NSManagedObjectContext) -> Bool {
        
        let request = NSFetchRequest<Pallet>(entityName: "Pallet")
        request.predicate = NSPredicate(format: "numero == %ld", numero)
        request.sortDescriptors = [NSSortDescriptor(key: "fecha", ascending: false)]
        
        guard let result = try? context.fetch(request) else { fatalError("Problem fetching Pallet from the store.") }
        
        if result.count > 1 {
            fatalError("We cannot have and object with the same id more than once")
        } else if result.count == 0 {
            
            let pallet = Pallet(context: context)
            pallet.fecha = fecha
            pallet.numero = numero
            
            try? context.save()
            return true
            
        } else {
            return false
        }
    }
}

extension Caja {
    
    /// property to initialize a date formatter object
    private var formatter:DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter
    }
    /// property to format the date if possible
    var fechaInString:String? {
        guard let fecha = fechaDeProduccion else { fatalError("Could not get fecha de produccion from box") }
        return formatter.string(from: fecha)
    }
    
    /// convert from objc NSDecimalNumber (core data stores it this way) to Decimal
    var pesoNeto:Decimal? {
        get { pesoNeto_ as Decimal?  }
        set { pesoNeto_ = newValue as NSDecimalNumber? }
    }
    
    /// convert from objc NSDecimalNumber (core data stores it this way) to Decimal
    var pesoBruto:Decimal? {
        get { pesoBruto_ as Decimal? }
        set { pesoNeto_ = newValue as NSDecimalNumber? }
    }
    
    /// convert from objc NSDecimalNumber (core data stores it this way) to Decimal
    var pesoDelEnvase:Decimal? {
        get { pesoDelEnvase_ as Decimal? }
        set { pesoNeto_ = newValue as NSDecimalNumber? }

    }

    
}

extension Pallet {
    
    /// property to initialize a date formatter object
    private var formatter:DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter
    }
    
    /// property to format the date if possible
    var fechaInString:String? {
        guard let fecha = fecha else { fatalError("Could not get fecha de produccion from box") }
        return formatter.string(from: fecha)
    }
    
    /// convert from objc NSSet (core data stores it this way) to the new Swift Set
    var cajas:Set<Caja> {
        get { (cajas_ as? Set<Caja>) ?? []}
        set { cajas_ = (newValue as NSSet) }
    }
    
    /// property that returns the added weight of the boxes in a pallet (a pallet contains an Set of boxes, in which we add the weight
    var pesoNetoDeCajas:Decimal {
        cajas.reduce(0) {x, y in
            x + y.pesoNeto!
        }
    }
}
