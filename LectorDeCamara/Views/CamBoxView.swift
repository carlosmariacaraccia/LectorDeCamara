//
//  CamBoxView.swift
//  FaenaManager
//
//  Created by Carlos Caraccia on 10/27/20.
//

import SwiftUI

// View we have created to show the camview
struct CamBoxView: View {
    
    var pallet:Pallet
    
    var body: some View {
        CustomCameraView(pallet: pallet)
    }
}

struct CustomCameraView:UIViewControllerRepresentable {
    
    var pallet:Pallet

    func makeUIViewController(context: Context) ->  UIViewController {
        let storyBoard = UIStoryboard(name: "Custom", bundle: Bundle.main)
        let controller = storyBoard.instantiateViewController(identifier: "CamView") as? VisionViewController
        controller?.pallet = pallet
        return controller!
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
