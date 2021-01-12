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

    var errorDescription:String? {

        switch self {
            case .invalidFile:
                return "The file you are attempting to enter is invalid or unreadable"
            case .corruptedFile:
                return "The file you are attempting to enter is corrupted"
            case .notFromUser:
                return "The file you are attempting to enter does not belongs to this user"
        }
    }
}


struct FileValidationService {

    let maxFileSize:UInt64 = 700000

    func validateInputFile(urlFile:URL?) throws -> (dictBoxIdDetails:[String:[String?]]?, uniqueIds:[String], idProduccion:String) {

        // if the input file is too big the it is not for us. We should not input files bigger than 700KB
        guard let validURL = urlFile else { throw FileValidationError.invalidFile }
        let size = try? FileManager.default.attributesOfItem(atPath: validURL.relativePath)[FileAttributeKey.size] as? UInt64
        guard let validSize = size else { throw FileValidationError.invalidFile }
        guard validSize < maxFileSize else { throw FileValidationError.invalidFile }

        // now get the string from the file
        guard let inputFile = try? String(contentsOf: validURL, encoding: .ascii) else { throw FileValidationError.invalidFile}

        // now I have to check if the file is valid.
        // We will check only one condition, in a produciton environment we would check for more.
        // For that we will try to parse the file. If the number of boxes obtained is Ok we will continue with the process.
        let parsedFileResults = ParseInputFile.parseProduccionFile(from: inputFile)
        // If we try to parse the file and get a nil value, the the file will be corrupted
        guard let safeFileParsed = parsedFileResults else { throw FileValidationError.corruptedFile }
        // Now we will check for the
        let result = checkForValidFile(fileString: inputFile, numberOfBoxesFromFile: safeFileParsed.uniqueIds.count)
        guard result else { throw FileValidationError.notFromUser }
        return safeFileParsed
    }

    private func checkForValidFile(fileString:String, numberOfBoxesFromFile:Int) -> Bool {
        // grab if exists the line that contains Total Gral
        // first split the file in /n and remove the ones that contain "---------"
        let  fileLines = fileString.components(separatedBy: "\r\n").filter {!$0.contains("-------")}
        // we will only check if the extracted boxes match the number of boxes retrieved in the file
        let totalBoxes = fileLines.filter{$0.contains("Tot, Cajas")}[0]
        let totalBoxesScanner = Scanner(string: totalBoxes)
        let _ = totalBoxesScanner.scanUpToString("Cajas")
        let _ = totalBoxesScanner.scanUpToString(" ")
        let numberOfBoxes = totalBoxesScanner.scanInt()
        if numberOfBoxes == numberOfBoxesFromFile {
            return true
        }
        return false
    }
}
