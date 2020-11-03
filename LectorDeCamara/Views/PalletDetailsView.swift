//
//  PalletDetailsView.swift
//  LectorDeCamara
//
//  Created by Carlos Caraccia on 10/30/20.
//

import SwiftUI
import CoreData

struct PalletDetailsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State var isCameraBeingShown = false
    
    @FetchRequest var pallet:FetchedResults<Pallet>
    
    init(numeroDePallet:Int32) {
        let fetchRequest = NSFetchRequest<Pallet>(entityName: "Pallet")
        fetchRequest.predicate = NSPredicate(format: "numero == %ld", numeroDePallet)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "numero", ascending: false)]
        _pallet = FetchRequest(fetchRequest: fetchRequest)
    }
    
    var body: some View {
        List {
            ForEach( Array(pallet.first!.cajas), id:\.boxId) { caja in
                BoxDescriptionView(caja: caja)
            }
            .onDelete(perform: { indexSet in
                indexSet.map {Array(pallet.first!.cajas)[$0]}.forEach { (caja) in
                    // we only remove the reference, the box is still in the database
                    // but has no pallet associated
                    caja.pallet = nil
                    try? viewContext.save()
                }
            })
        }
        .navigationBarItems(trailing: Button(action: {navigationTrailingButton()}, label: {
            Image("icons8-general-ocr-40")
        }))
        .fullScreenCover(isPresented: $isCameraBeingShown, content: {
            CamBoxView(pallet:pallet.first!)
        })
    }
    
    func navigationTrailingButton() {
        print("navigation trailing button pressed")
        isCameraBeingShown.toggle()
    }
}
struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        return PalletDetailsView(numeroDePallet: Int32(33))
    }
}
