//
//  PalletBuilderMainView.swift
//  LectorDeCamara
//
//  Created by Carlos Caraccia on 11/2/20.
//

import SwiftUI
import CoreData
import Introspect

struct PalletBuilderMainView: View {
    
    @Environment(\.managedObjectContext) var viewContext:NSManagedObjectContext
    
    @State private var isCreatePalletPresented = false
    
    @FetchRequest var pallets:FetchedResults<Pallet>
    
    
    // table view to solve deselecting rows
    @State private var tableView:UITableView?
    
    init() {
        let request = NSFetchRequest<Pallet>(entityName: "Pallet")
        request.predicate = NSPredicate(format: "TRUEPREDICATE")
        request.sortDescriptors = [NSSortDescriptor(key: "fecha", ascending: false)]
        _pallets = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack(alignment: .leading){
                Text("Pallets")
                    .font(.system(size: 18, weight: .medium, design: .monospaced))
                    .padding(.top, 20)
                    .padding(.leading, 15)
                List {
                    ForEach(pallets, id:\.numero) { pallet in
                        NavigationLink(destination: PalletDetailsView(numeroDePallet: pallet.numero).navigationBarTitle("Pallet: \(pallet.numero)")) {
                            VStack {
                                HStack {
                                    Text("Date: \(pallet.fechaInString!)")
                                    Spacer()
                                    Text("id: \(pallet.numero)" as String)
                                }
                                .padding(.bottom, 10)
                                HStack {
                                    Text("Boxes: \(pallet.cajas.count) u")
                                    Spacer()
                                    Text("Wt.: \(pallet.pesoNetoDeCajas) kg" as String)
                                }
                            }
                        }
                        .font(.system(size: 14, weight: .light, design: .monospaced))
                        .onAppear(perform: {
                            deselectRows()
                        })
                    }.onDelete(perform: { indexSet in
                        indexSet.map{pallets[$0]}.forEach { (pallet) in
                            // we delete the pallet but the boxes are still in the database
                            // this is because the delete rule in the relationship is nullify
                            viewContext.delete(pallet)
                            try? viewContext.save()
                        }
                    })
                }
                .introspectTableView { (tableView) in
                    self.tableView = tableView
                }
            }
            .navigationBarTitle("Pallet Builder")
            .navigationBarItems(trailing: Button(action: { isCreatePalletPresented.toggle() }) {
                Image("icons8-plus-40")
                    .imageScale(.small)
            })
            .sheet(isPresented: $isCreatePalletPresented) {
                CreateNewPalletView(isBeingShown: $isCreatePalletPresented).environment(\.managedObjectContext, viewContext)
            }
        }
    }
    
    private func deselectRows() {
        if let tableView = tableView, let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: false)
        }
    }
}

struct PalletBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        PalletBuilderMainView()
    }
}
