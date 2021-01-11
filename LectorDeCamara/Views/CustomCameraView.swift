//
//  CustomCameraView.swift
//  FaenaManager
//
//  Created by Carlos Caraccia on 10/27/20.
//

import SwiftUI

struct CustomCameraView:UIViewControllerRepresentable {
    
    @State var pallet:Pallet

    
    /// Function to display in swiftui the representing object of a story board
    /// - Parameter context: <#context description#>
    /// - Returns: the returning uiview controller from the storyboard
    func makeUIViewController(context: Context) ->  UIViewController {
        let storyBoard = UIStoryboard(name: "Custom", bundle: Bundle.main)
        let controller = storyBoard.instantiateViewController(identifier: "CamView") as? VisionViewController
        controller?.pallet = pallet
        return controller!
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
