//
//  BoxDescriptionView.swift
//  LectorDeCamara
//
//  Created by Carlos Caraccia on 11/3/20.
//

import SwiftUI

struct BoxDescriptionView:View {
    
    var caja:Caja
    
    var body: some View {
        VStack {
            HStack {
                Text("\(caja.fechaInString!)")
                    .font(.system(size: 12, weight: .light, design: .monospaced))
                Spacer()
                Text("\(caja.boxId)")
                    .font(.system(size: 12, weight: .light, design: .monospaced))
                Spacer()
                Text("\(caja.descripcion!)")
                    .font(.system(size: 12, weight: .light, design: .monospaced))
            }
            .padding(.top, 5)
            .padding(.bottom, 5)
            HStack {
                Text("\(caja.pesoBruto!) kg" as String)
                    .font(.system(size: 12, weight: .light, design: .monospaced))
                Spacer()
                Text("\(caja.pesoNeto!) kg" as String)
                    .font(.system(size: 12, weight: .light, design: .monospaced))
                Spacer()
                Text("\(caja.pesoDelEnvase!) kg" as String)
                    .font(.system(size: 12, weight: .light, design: .monospaced))
            }.padding(.bottom, 5)
        }
    }
}
struct BoxDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        BoxDescriptionView(caja: Caja())
    }
}
