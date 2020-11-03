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
    
    var pallet:Pallet
        
    var body: some View {
        
        NavigationView {
            List {
                ForEach( Array(pallet.cajas), id:\.boxId) { caja in
                    VStack {
                        HStack {
                            Text("\(caja.fechaInString!)")
                                .font(.system(size: 12, weight: .light, design: .monospaced))
                            Spacer()
                            Text("\(caja.descripcion!)")
                                .font(.system(size: 12, weight: .light, design: .monospaced))
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        
                        HStack {
                            Text("\(caja.pesoBruto!)" as String)
                                .font(.system(size: 12, weight: .light, design: .monospaced))
                            Spacer()
                            Text("\(caja.pesoNeto!)" as String)
                                .font(.system(size: 12, weight: .light, design: .monospaced))
                            Spacer()
                            Text("\(caja.pesoDelEnvase!)" as String)
                                .font(.system(size: 12, weight: .light, design: .monospaced))
                        }.padding(.bottom, 5)
                    }
                }
            }
            .navigationBarItems(trailing: Button(action: {navigationTrailingButton()}, label: {
                Image("icons8-general-ocr-40")
            }))
            .navigationTitle("Box scanner")
            .fullScreenCover(isPresented: $isCameraBeingShown, content: {
                CamBoxView()
            })
        }
    }
    
    func navigationTrailingButton() {
        print("navigation trailing button pressed")
        isCameraBeingShown.toggle()
    }
}
struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let pallet = Pallet()
        return PalletDetailsView(pallet: pallet)
    }
}
