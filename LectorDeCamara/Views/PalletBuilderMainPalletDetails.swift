//
//  PalletBuilderMainPalletItemView.swift
//  Lector de camara
//
//  Created by Carlos Caraccia on 11/4/20.
//

import SwiftUI

struct PalletBuilderMainPalletItemView:View {
    
    var pallet:Pallet
    
    var body: some View {
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
}
struct PalletBuilderMainPalletDetails_Previews: PreviewProvider {
    static var previews: some View {
        PalletBuilderMainPalletItemView(pallet: Pallet())
    }
}
