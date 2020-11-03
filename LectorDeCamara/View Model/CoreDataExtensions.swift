//
//  CoreDataExtensions.swift
//  LectorDeCamara
//
//  Created by Carlos Caraccia on 11/2/20.
//

import Foundation
import CoreData

extension Pallet {
    
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
    
    private var formatter:DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter
    }
    
    var fechaInString:String? {
        guard let fecha = fechaDeProduccion else { fatalError("Could not get fecha de produccion from box") }
        return formatter.string(from: fecha)
    }
    
    var pesoNeto:Decimal? {
        get { pesoNeto_ as Decimal?  }
        set { pesoNeto_ = newValue as NSDecimalNumber? }
    }
    
    var pesoBruto:Decimal? {
        get { pesoBruto_ as Decimal? }
        set { pesoNeto_ = newValue as NSDecimalNumber? }
    }
    
    var pesoDelEnvase:Decimal? {
        get { pesoDelEnvase_ as Decimal? }
        set { pesoNeto_ = newValue as NSDecimalNumber? }

    }

    
}

extension Pallet {
    
    private var formatter:DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter
    }
    
    var fechaInString:String? {
        guard let fecha = fecha else { fatalError("Could not get fecha de produccion from box") }
        return formatter.string(from: fecha)
    }
    
    var cajas:Set<Caja> {
        get { (cajas_ as? Set<Caja>) ?? []}
        set { cajas_ = (newValue as NSSet) }
    }
    
    var pesoNetoDeCajas:Decimal {
        cajas.reduce(0) {x, y in
            x + y.pesoNeto!
        }
    }
}
