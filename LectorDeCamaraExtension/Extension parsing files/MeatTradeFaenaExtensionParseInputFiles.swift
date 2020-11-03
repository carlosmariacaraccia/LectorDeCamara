//
//  MeatTradeExtensionParseInputFiles.swift
//  MeatTradeFaenaExtension
//
//  Created by Carlos Caraccia on 10/29/20.
//

import Foundation

extension ParseInputFile {
    
    /// Fucntion to pase the Romaneo de faena file
    /// - Parameter txtFileString: the string from the file of the NSExtensionContext
    /// - Returns: a tuple with 1: a nested dictionary containing the header of the file, 2: a dictionary with the body of the file, 3: an array of dictionaries of medias reces
    static func parseRomaneoDeFaena(from txtFileString:String?) -> (romaneoDeFaenaHeader:[String : [String : [String : String?]]], romaneoDeFaenaBody:[String : Optional<String>], mediasReces:[[String:String]]){
                            
            guard let fileString = txtFileString else { fatalError("Could not open file romaneo de faena") }
            
            let scanner = Scanner(string: fileString)
            scanner.charactersToBeSkipped = .whitespacesAndNewlines
            
            let establecimientoFaenador = self.retrieveGeneralnfo(from: scanner, stringToFind: "Est.Faenador:")
            let establecimientoFaenadorRuca = self.retrieveGeneralnfo(from: scanner, stringToFind: "RUCA.:")
            let establecimientoFaenadorCUIT = self.retrieveGeneralnfo(from: scanner, stringToFind: "C.U.I.T.:")
            let usuario = self.retrieveGeneralnfo(from: scanner, stringToFind: "Usuario.....:")
            let usuarioRuca = self.retrieveGeneralnfo(from: scanner, stringToFind: "RUCA.:")
            let usuarioCUIT = self.retrieveGeneralnfo(from: scanner, stringToFind: "C.U.I.T.:")
            let vendedor = self.retrieveGeneralnfo(from: scanner, stringToFind: "Vendedor....:")
            let vendedorRuca = self.retrieveGeneralnfo(from: scanner, stringToFind: "RUCA.:")
            let vendedorCUIT = self.retrieveGeneralnfo(from: scanner, stringToFind: "C.U.I.T.:")
            let productor = self.retrieveGeneralnfo(from: scanner, stringToFind: "Productor...:")
            let productorRuca = scanner.scanUpToString("|")
            let productorCUIT = self.retrieveGeneralnfo(from: scanner, stringToFind: "C.U.I.T.:")
            let lugarDeProcedencia = self.retrieveGeneralnfo(from: scanner, fromString: "Procedencia.:", toString: "Provincia:",
                                                             incluedeColonAndSpace: false)
            let provincia = self.retrieveGeneralnfo(from:scanner, fromString: ":", toString: "|", incluedeColonAndSpace: true)
            let departamentoNumero = self.retrieveGeneralnfo(from: scanner, stringToFind: "Depto:")
            let departamentoString = self.retrieveGeneralnfo(from: scanner, fromString: " ", toString: "|",
                                                             incluedeColonAndSpace: false)
            let feedLots = self.retrieveRenspa(from: scanner)
            let feedLotsDte = self.retrieveGeneralnfo(from: scanner, stringToFind: "DTE (ori):")
            let feedLotsCUIT = self.retrieveGeneralnfo(from: scanner, stringToFind: "C.U.I.T.:")
            let tropaNumero = self.retrieveGeneralnfo(from: scanner, stringToFind: "Tropa Nro..:")?.replacingOccurrences(of: ",", with: "").trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let totalCabezas = self.retrieveGeneralnfo(from: scanner, stringToFind: "Total Cabezas...:") ?? ""
            let pesoVivo = self.retrieveGeneralnfo(from: scanner, stringToFind: "Kilos Vivos:")?.replacingOccurrences(of: ",", with: "") ?? ""
            let dteFaena = self.retrieveGeneralnfo(from: scanner, stringToFind: "D.T.E...:")?.replacingOccurrences(of: "/", with: "") ?? ""
            let fechaDeFaena = self.retrieveGeneralnfo(from: scanner, stringToFind: "Fecha de Faena:") ?? ""
            let guiaNumero = self.retrieveGeneralnfo(from: scanner, stringToFind: "Nro.de Guia:") ?? ""
            let cabezasFaenadasNumero = self.retrieveGeneralnfo(from: scanner, stringToFind: "Cabezas Faenadas:") ?? ""
            let muertosNumero = self.retrieveGeneralnfo(from: scanner, stringToFind: "Muertos....:") ?? ""
            let romaneoNumero =  self.retrieveGeneralnfo(from: scanner, stringToFind: "Romaneo#:")?.replacingOccurrences(of: "SA-", with: "").replacingOccurrences(of: ",", with: "").trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let tipoDeRomaneo = self.retrieveGeneralnfo(from: scanner, stringToFind: "Tipo.......:")
            let pesoPromedio = self.retrieveGeneralnfo(from: scanner, stringToFind: "Promedio........:") ?? ""
            let romaneoInternoNumero = self.retrieveGeneralnfo(from: scanner, stringToFind: "Roma.Int.#.:")?.replacingOccurrences(of: ",", with: "").trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let renspa = self.retrieveGeneralnfo(from: scanner, stringToFind: "RENSPA:") ?? ""
            let garronInicialNumero = self.retrieveGeneralnfo(from: scanner, fromString: "Del:", toString: "al", incluedeColonAndSpace: true) ?? ""
            let garronFinalNumero = self.retrieveGeneralnfo(from: scanner, fromString: " ", toString: "|", incluedeColonAndSpace: false) ?? ""
            
            let lineasDeMediasReces = self.createLineaMediaRes(from: scanner)
            let reces = lineasDeMediasReces.map{self.createMediaRes(from: $0)}
            
            
            let establecimientoFaenadorDict = ["establecimentoFaenador":["nombre":establecimientoFaenador,"ruca":establecimientoFaenadorRuca, "cuit":establecimientoFaenadorCUIT]]
            let usuarioDeFaenaDict = ["usuarioDeFaena":["nombre":usuario, "ruca":usuarioRuca, "cuit":usuarioCUIT]]
            let vendedorFaenaDict = ["vendedorFaena":["nombre":vendedor, "ruca":vendedorRuca, "cuit":vendedorCUIT ]]
            let productorFaenaDict = ["productorFaena":["nombre":productor, "ruca":productorRuca, "cuit":productorCUIT ]]
            let procedenciaFaenaDict = ["procedenciaFaena":["lugar":lugarDeProcedencia, "provincia":provincia, "departamentoNumero":departamentoNumero, "departamentoNombre":departamentoString!]]
            let feedLotsDict = ["feedLotsFaenaDict":["nombre":feedLots, "renspaOrigen":renspa, "dteOrigen":feedLotsDte, "cuit":feedLotsCUIT]]
            let romaneoDeFaenaHeader = ["establecimientoFaenador":establecimientoFaenadorDict, "usuarioDeFaena":usuarioDeFaenaDict, "vendedorFaena":vendedorFaenaDict, "productorFaena":productorFaenaDict, "procedenciaFaena":procedenciaFaenaDict, "feedLotsFaena":feedLotsDict]
            let romaneoDeFaenaBodyDict = ["tropaNumero":tropaNumero, "totalCabezas":totalCabezas, "pesoVivo":pesoVivo, "dteFaena":dteFaena, "fechaDeFaena":fechaDeFaena, "guiaNumero":guiaNumero, "cabezasFaenadasNumero": cabezasFaenadasNumero, "muertosNumero":muertosNumero, "romaneoNumero":romaneoNumero, "tipoDeRomaneo":tipoDeRomaneo, "pesoPromedio":pesoPromedio, "romaneoInternoNumero":romaneoInternoNumero, "renspa":renspa, "garronInicialNumero":garronInicialNumero, "garronFinalNumero": garronFinalNumero]
            return (romaneoDeFaenaHeader, romaneoDeFaenaBodyDict, reces)
        }
    
    fileprivate static func retrieveGeneralnfo(from scanner:Scanner, stringToFind:String) -> String? {
        let _ = scanner.scanUpToString(stringToFind)
        let _ = scanner.scanUpToString(":")
        let _ = scanner.scanUpToString(" ")
        return scanner.scanUpToString("|")?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    fileprivate static func retrieveGeneralnfo(from scanner:Scanner, fromString:String, toString:String, incluedeColonAndSpace:Bool) -> String? {
        let _ = scanner.scanUpToString(fromString)
        if incluedeColonAndSpace {
            let _ = scanner.scanUpToString(":")
            let _ = scanner.scanUpToString(" ")
        }
        return scanner.scanUpToString(toString)?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    
    fileprivate static func retrieveRenspa(from scanner:Scanner) -> String? {
        let _ = scanner.scanUpToString("RENSPA (ori):")
        let _ = scanner.scanUpToString(":")
        return scanner.scanUpToString("/")?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    fileprivate static func createLineaMediaRes(from scanner:Scanner) -> [String] {
        scanner.charactersToBeSkipped = nil
        var lineaMediaRes = String()
        var lineasDeMediasReces = [String]()
        let _ = scanner.scanUpToString("Cuartos Cruzados")
        let _ = scanner.scanUpToString("|")
        while !scanner.isAtEnd  {
            let _ = scanner.scanUpToString(" ")
            lineaMediaRes = scanner.scanUpToString("|") ?? ""
            if lineaMediaRes.count == 30 && !lineaMediaRes.contains("       ") {
                lineasDeMediasReces.append(lineaMediaRes)
            }
        }
        return lineasDeMediasReces
    }
    
    fileprivate static func createMediaRes(from lineaDeMediaRes:String) -> [String:String] {
        let lineaDeMediaResScanner = Scanner(string: lineaDeMediaRes)
        
        let garron = lineaDeMediaResScanner.scanUpToString(" ") ?? ""
        let possibleValue = String((lineaDeMediaResScanner.scanUpToString(" ") ?? "").trimmingCharacters(in: .whitespacesAndNewlines))
        var clasificacion = ""
        var tipificacion = ""
        if possibleValue.count > 2 {
            tipificacion = String(possibleValue.suffix(2))
            clasificacion = possibleValue.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: tipificacion, with: "")
        } else {
            clasificacion = possibleValue
            tipificacion = lineaDeMediaResScanner.scanUpToString(" ") ?? ""
        }
        let destinoComercial = lineaDeMediaResScanner.scanUpToString(" ") ?? ""
        let peso = lineaDeMediaResScanner.scanUpToString(" ") ?? ""
        let denticion = "\(lineaDeMediaResScanner.scanInt() ?? 0)"
        let _ = lineaDeMediaResScanner.scanUpToString(" ") ?? ""
        let h = lineaDeMediaResScanner.scanUpToString(" ") ?? ""
        
        let mediaRes = ["garron":garron,"tipificacion":tipificacion,"clasificacion":clasificacion,"destinoComercial":destinoComercial,"peso":peso,"denticion":denticion, "h":h]
        
        return mediaRes
    }
    
    fileprivate static func convertFechaDeFaena(fecha:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from: fecha)
    }
    
}

