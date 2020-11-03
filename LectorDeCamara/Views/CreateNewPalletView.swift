//
//  CreateNewPalletView.swift
//  LectorDeCamara
//
//  Created by Carlos Caraccia on 11/2/20.
//

import SwiftUI
import CoreData
import Introspect

extension  UITextField {
   @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
      self.resignFirstResponder()
   }
}

struct CreateNewPalletView: View {
    
    @Environment(\.managedObjectContext) var viewContext:NSManagedObjectContext
    
    @State private var fechaDeCreacion = Date()
    @State private var numeroDePallet = ""
    @State private var cantidadDeCajas = ""
    @State private var isAlertPresented = false
    @Binding var isBeingShown:Bool
    
    var isSaveEnabled:Bool {
        (cantidadDeCajas != "" && numeroDePallet != "") ? true : false
    }
    
    var body: some View {
        VStack {
            Text("New pallet")
                .font(.system(size: 35, weight: .heavy, design: .monospaced))
            Form {
                DatePicker("Fecha", selection: $fechaDeCreacion, displayedComponents: .date)
                TextField("Numero: ", text: $numeroDePallet)
                    .keyboardType(.decimalPad)
                    .introspectTextField { (textField) in
                        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
                        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textField.doneButtonTapped(button:)))
                        doneButton.tintColor = .systemPink
                        toolBar.items = [flexButton, doneButton]
                        toolBar.setItems([flexButton, doneButton], animated: true)
                        textField.inputAccessoryView = toolBar
                     }
                
                TextField("max cajas: ", text: $cantidadDeCajas)
                    .keyboardType(.decimalPad)
                    .introspectTextField { (textField) in
                        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
                        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textField.doneButtonTapped(button:)))
                        doneButton.tintColor = .systemPink
                        toolBar.items = [flexButton, doneButton]
                        toolBar.setItems([flexButton, doneButton], animated: true)
                        textField.inputAccessoryView = toolBar
                     }
            }
            
            Button("Save") {
                guard let numeroPallet = Int32(numeroDePallet) else { fatalError("Could not convert the numero de pallet to string") }
                isAlertPresented = !Pallet.with(numero: numeroPallet, fecha: fechaDeCreacion, context: viewContext)
                isBeingShown = false
            }
            .disabled(!isSaveEnabled)
            .alert(isPresented: $isAlertPresented, content: {
                Alert(title: Text("Pallet already added"), message: Text("The pallet could not be added because it already is in store. Change its number."), dismissButton: .default(Text("OK")))
            })
        }
    }
}

struct CreateNewPaleetView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewPalletView(isBeingShown: .constant(false))
    }
}
