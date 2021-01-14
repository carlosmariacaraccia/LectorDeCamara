//
//  ValidationService.swift
//  Lector de camara
//
//  Created by Carlos Caraccia on 1/12/21.
//

import Foundation

enum FileValidationError:LocalizedError {
    
    case invalidFile
    case corruptedFile
    case notFromUser
    case tooBigFile
    case cannotOpenFile
    
    var errorDescription:String? {
        
        switch self {
        case .invalidFile:
            return "The file you are attempting to enter is invalid or unreadable"
        case .corruptedFile:
            return "The file you are attempting to enter is corrupted"
        case .notFromUser:
            return "The file you are attempting to enter does not belongs to this user"
        case .tooBigFile:
            return "This file might not belong to us becasuse its too big"
        case .cannotOpenFile:
            return "The url where the file is stored seems to be invalid"
        }
    }
}


struct FileValidationService {
    
    let maxFileSize:UInt64 = 1000000
    
    typealias SalidaDepostada = (dictBoxIdDetails:[String:[String]], uniqueIds:[String], idProduccion:String)

    
    func validateInputFile(urlFile: URL?) throws -> SalidaDepostada {
        
        guard let inputString = checkIfFileCanBeOpened(of: urlFile) else { throw FileValidationError.cannotOpenFile }
        
        guard let totals = getTotals(from: inputString) else { throw FileValidationError.invalidFile }
        
        // Try to parse the file
        guard let safeparsedFileResults = ParseInputFile.parseProduccionFile(from: inputString) else { throw FileValidationError.corruptedFile }
        
        // first we will check the totals
        guard safeparsedFileResults.uniqueIds.count == totals.numberOfBoxes else { throw FileValidationError.invalidFile }
        
        // now from the safely parsed file we will get the net wt and the gross wt with the below function
        guard let weights = getTotalNetAndGrossWt(form: safeparsedFileResults) else { throw FileValidationError.invalidFile }
        
        // check if results are the same
        guard totals.netWeight == weights.netWt else { throw FileValidationError.invalidFile }
        guard totals.grossWeight == weights.grossWt else { throw FileValidationError.invalidFile }

        return safeparsedFileResults
    }
    
    private func checkIfFileCanBeOpened(of url:URL?) -> String?  {
        
        // first check if the url is valid
        guard let validURL = url else { return nil }
        
        // first check if the size of the file is greater than 1 MB.
        let size = try? FileManager.default.attributesOfItem(atPath: validURL.relativePath)[FileAttributeKey.size] as? UInt64
        guard let validSize = size else { return nil }
        guard validSize < maxFileSize else { return nil }
        
        // now get the string from the file
        guard let inputFile = try? String(contentsOf: validURL, encoding: .ascii) else { return nil }
        
        return inputFile
    }

    
    private func getTotals(from file:String) -> (numberOfBoxes:Int, grossWeight:Decimal, netWeight:Decimal)? {
        
        // First split the string in lines
        let fileLines = file.components(separatedBy: "\r\n").filter {!$0.contains("-------")}
        // get the line where the total weights are
        guard let totalWeightLine = fileLines.filter({$0.contains("Total Gral")}).first else { return nil }
        // get the line where the total amount of boxes are
        guard let totalBoxesLine = fileLines.filter({$0.contains("Tot, Cajas")}).first else { return nil }
        
        // create a scanner to get the weight
        let weightScanner = Scanner(string: totalWeightLine)
        let _ = weightScanner.scanUpToString(">>>")
        let _ = weightScanner.scanUpToString(" ")
        let _ = weightScanner.scanUpToString(" ")
        
        // get the gross wt
        guard var totalGrossWtString = weightScanner.scanUpToString(" ") else { return nil }
        totalGrossWtString = totalGrossWtString.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".")
        guard let totalGrossWt = Decimal(string: totalGrossWtString) else { return nil }
        
        // get the net wt
        let _ = weightScanner.scanUpToString(" ")
        guard var totalNetWtString = weightScanner.scanUpToString(" ") else { return nil }
        totalNetWtString = totalNetWtString.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".")
        guard let totalNetWt = Decimal(string: totalNetWtString) else { return nil }
        
        // Get the total number of boxes
        let totalBoxesScanner = Scanner(string: totalBoxesLine)
        let _ = totalBoxesScanner.scanUpToString("Cajas")
        let _ = totalBoxesScanner.scanUpToString(" ")
        guard let totalNumberOfBoxes = totalBoxesScanner.scanInt() else { return nil }
        
        return (totalNumberOfBoxes, totalGrossWt, totalNetWt)
    }
    
    private func getTotalNetAndGrossWt(form parsedFileResult: SalidaDepostada) -> (netWt:Decimal, grossWt:Decimal)? {
        
        // get the gross and net wts
        var grossTotalWt:Decimal = 0.0
        var netTotalWt:Decimal = 0.0
        
        let safeDictBoxIdDetails = parsedFileResult.dictBoxIdDetails
        
        for id in parsedFileResult.uniqueIds {
            
            guard let boxProperties = safeDictBoxIdDetails[id] else { return nil }
            let boxGrossWtString = boxProperties[2]
            let boxNetWtString = boxProperties[4]
            guard let grossBoxWtDecimal = Decimal(string: boxGrossWtString) else { return nil }
            guard let boxNetWtDecimal = Decimal(string: boxNetWtString) else { return nil }
            
            grossTotalWt += grossBoxWtDecimal
            netTotalWt += boxNetWtDecimal

        }
        
       return (netTotalWt, grossTotalWt)
    }
    
    private func checkForValidNumberOfBoxes(from fileString:String, numberOfBoxesFromFile:Int) -> Bool? {
        // grab if exists the line that contains Total Gral
        // first split the file in /n and remove the ones that contain "---------"
        let  fileLines = fileString.components(separatedBy: "\r\n").filter {!$0.contains("-------")}
        
        // we will only check if the extracted boxes match the number of boxes retrieved in the file
        guard let totalBoxes = fileLines.filter({$0.contains("Tot, Cajas")}).first else { return nil }
        
        let totalBoxesScanner = Scanner(string: totalBoxes)
        let _ = totalBoxesScanner.scanUpToString("Cajas")
        let _ = totalBoxesScanner.scanUpToString(" ")
        guard let numberOfBoxes = totalBoxesScanner.scanInt() else { return nil }
        if numberOfBoxes == numberOfBoxesFromFile {
            return true
        }
        return false
    }
    
}
