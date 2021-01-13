//
//  MeatTradeFaenaExtensionParseInputFile.swift
//  MeatTradeFaenaExtension
//
//  Created by Carlos Caraccia on 10/29/20.
//

import Foundation

class ParseInputFile {
    
    /// Function to pares the Produccion file in a performant way
    /// - Parameter txtFileString: the string resultant of the file in the NSExtensionContext
    /// - Returns: a tuple with 1 a dict with the details of the box with its Id as key, 2 and array of uniques ids, 3 the production id
    static func parseProduccionFile(from txtFileString:String?) throws -> (dictBoxIdDetails:[String:[String]], uniqueIds:[String], idProduccion:String) {
        
        guard let fileString = txtFileString else { throw FileValidationError.invalidFile }
        var fileLines = fileString.components(separatedBy: "\r\n").filter {!$0.contains("-------")}
        fileLines = fileLines.filter{!$0.contains(">>")}.filter{!$0.contains("Tot,")}.filter{$0.contains("/")}
        
        var result = [String:[String]]()
        var uniqueIds = [String]()
        var pesoTotal:Decimal = 0
        let fechaAComparar = fileLines.first?.components(separatedBy: " ").first!
        
        for line in fileLines {
            let scanner = Scanner(string: line)
            scanner.charactersToBeSkipped = .whitespacesAndNewlines
            
            let fecha = scanner.scanUpToString(" ")?.trimmingCharacters(in: .whitespacesAndNewlines)
            if fechaAComparar != fecha {
                throw FileValidationError.invalidFile
            }
            let _ = scanner.scanUpToString(" ")
            let _ = scanner.scanUpToString(" ")
            let _ = scanner.scanUpToString(" ")
            guard let boxId =  scanner.scanUpToString(" ") else { throw FileValidationError.invalidFile }
            let uniqueId = fecha! + "-" + boxId
            uniqueIds.append(uniqueId)
            guard let categoria =  scanner.scanUpToString(" ") else  { throw FileValidationError.invalidFile }
            guard let descripcionEspañol = scanner.scanUpToString("1")?.trimmingCharacters(in: .whitespacesAndNewlines) else { throw FileValidationError.invalidFile }
            let _ = scanner.scanUpToString(" ")
            guard let destino = scanner.scanUpToString(" ") else { throw FileValidationError.invalidFile }
            let _ =  scanner.scanUpToString(" ")
            guard let possibleValue = scanner.scanUpToString(" ") else { throw FileValidationError.invalidFile }
            if descripcionEspañol.contains("RECORTE") && possibleValue.contains(",") {
                let unidadesPorCaja1 = "0"
                let pesoBruto1 = possibleValue.replacingOccurrences(of: ",", with: ".")
                guard let pesoDelEnvase1 = scanner.scanUpToString(" ")?.replacingOccurrences(of: ",", with: ".") else { throw FileValidationError.invalidFile }
                guard let pesoNeto1 = scanner.scanUpToString(" ")?.replacingOccurrences(of: ",", with: ".") else { throw FileValidationError.invalidFile }
                pesoTotal += Decimal(string:pesoNeto1)!
                result[uniqueId] = [destino, boxId, pesoBruto1, pesoDelEnvase1, pesoNeto1, unidadesPorCaja1, categoria, descripcionEspañol]
            } else {
                let unidadesPorCaja = possibleValue
                guard let pesoBruto = scanner.scanUpToString(" ")?.replacingOccurrences(of: ",", with: ".") else { throw FileValidationError.invalidFile }
                guard let pesoDelEnvase = scanner.scanUpToString(" ")?.replacingOccurrences(of: ",", with: ".") else { throw FileValidationError.invalidFile }
                guard let pesoNeto = scanner.scanUpToString(" ")?.replacingOccurrences(of: ",", with: ".") else { throw FileValidationError.invalidFile }
                pesoTotal += Decimal(string:pesoNeto)!
                result[uniqueId] = [destino, boxId, pesoBruto, pesoDelEnvase, pesoNeto, unidadesPorCaja, categoria, descripcionEspañol]
            }
        }
        return (result,uniqueIds,"\(fechaAComparar!)-\(fileLines.count)-\(pesoTotal)")
    }
}
