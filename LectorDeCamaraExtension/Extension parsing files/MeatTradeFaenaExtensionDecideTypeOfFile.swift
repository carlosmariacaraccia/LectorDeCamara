//
//  MeatTradeFaenaDecideTypeOfFile.swift
//  MeatTradeFaenaExtension
//
//  Created by Carlos Caraccia on 10/29/20.
//

import Foundation

enum typesOfFiles{
    
    case romaneoDeFaena
    case stockDeCamara1
    case stockDeCamara2
    case ingresoACuarteo
    case salidaDeDepostada
    case romaneoDeSalidaDePlanta
}



class DecideTypeOfFile {
    
    ///  Function to decide which type of file we are being given to enter to the system
    /// - Parameter fileUrl: the url obtained from the NSExtensionContext
    /// - Returns: a typeOfFiles enum to later switch to enter files and a string with file content
    static func with(fileUrl: URL) -> (fileType: typesOfFiles?, stringFromFile:String?) {
        
        // get the string from the file
        guard let stringFromFile = try? String(contentsOf: fileUrl, encoding: .ascii) else { return (nil,nil) }
        
        // date formatter to che for dates
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        
        // check for splitted strings
        let splittedStrings = stringFromFile.components(separatedBy: "\n")
        guard let firstSplittedString = splittedStrings.first else { return  (nil,nil) }
        
        // first condition
        if firstSplittedString == "" || firstSplittedString == "\r" {
            
             let secondString = splittedStrings[1]
            
            if secondString.contains("MEAT TRA") && secondString.contains("500000") && secondString.contains("MEDIA RES") {
                
                return (typesOfFiles.stockDeCamara1, stringFromFile)
                
            } else {
                
                 let line16 = splittedStrings[16]
                 let line17 = splittedStrings[17]
                 let line24 = splittedStrings[24]
                
                if checkLine16(line: line16) && checkLine17(line: line17) && checkLine24(line: line24) {
                    
                    return (.romaneoDeFaena, stringFromFile)
                    
                } else {
                    
                    return (nil,nil)
                }
            }
            
        } else if firstSplittedString.contains("75") && firstSplittedString.contains("MEDIA RES") {
            
            let scanner = Scanner(string: firstSplittedString)
            let fecha = formatter.date(from: scanner.scanUpToString(" ") ?? "")
            
            if fecha != nil {
                
                return (.ingresoACuarteo, nil)
                
            } else if scanner.scanUpToString(" ") == "MEAT" {
                
                return (.stockDeCamara2, stringFromFile)
            }
            
        } else if firstSplittedString.contains("Romaneo") {
            
            let line2 = splittedStrings[1].contains("Usuario")
            let line3 = splittedStrings[2].contains("Transportista")
            let line4 = splittedStrings[3].contains("Chofer")
            let line5 = splittedStrings[4].contains("Sanitarios")
            let line6 = splittedStrings[5].contains("Nros")
            
            if line2 && line3 && line4 && line5 && line6 {
                return (.romaneoDeSalidaDePlanta, stringFromFile)
            } else {
                
                return  (nil,nil)
            }
            
        } else if let _ = formatter.date(from: (Scanner(string:firstSplittedString).scanUpToString(" ") ?? "")) {
            
            return (.salidaDeDepostada, stringFromFile)
            
        } else {
            
            return (nil,nil)
            
        }
        
        return (nil,nil)
        
    }
    
    fileprivate static func checkLine16(line:String) -> Bool {
        
        return line.contains("Est.Faenador")
    }
    
    fileprivate static func checkLine17(line:String) -> Bool {
        
        return line.contains("MEAT TRADE") && line.contains("30-70985969-9")
    }
    
    fileprivate static func checkLine24(line:String) -> Bool {
        
        let scanner = Scanner(string: line)
        let _ = scanner.scanUpToString("Romaneo#: SA-")
        let result = Int((scanner.scanUpToString("|")?.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "Romaneo#: SA-", with: "").trimmingCharacters(in: .whitespacesAndNewlines))!)
        
        if result != nil {
            
            return true
            
        } else {
            
            return false
        }
    }
}
