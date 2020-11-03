//
//  ShareViewController.swift
//  ExternalFilesOpener
//
//  Created by Carlos Caraccia on 10/6/20.
//  Copyright © 2020 Carlos Caraccia. All rights reserved.
//

import UIKit
import CoreData


class CustomShareViewController:UIViewController {
    
    // Fire the persistant container to get the view context
    lazy var persistentContainer: NSCustomPersistentContainer = {
        let container = NSCustomPersistentContainer(name: "LectorDeCamara")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // Bool to show the done button after file is parsed.
    // When somenone presses it, it dismisses the VC by
    // calling the completeed request method of the nsextension
    // context
    private var activateDoneButton = false
    
    // Label used to show the result of the parse
    let informationLabel = UILabel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // sep up the navigation bar
        setupNavBar()
        
        // configure the navigation bar
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // grab the nsmanagedobjectcontext
        let context = persistentContainer.viewContext
        
        // MARK: add subview, just one label showing the result of the parsed file, this must be done in code without using the story boards
        view.backgroundColor = .white
        setUpLabel()
        
        
        // MARK:-  when we load the view, we will parse the file from the NSExtensionContext if it contains certain strings
        let content = extensionContext?.inputItems[0] as? NSExtensionItem
        guard let attachment = content?.attachments?.first else { fatalError("Problem loading the attachment") }
        // check if the attachment conforms to the public.plain-text
        if attachment.hasItemConformingToTypeIdentifier("public.plain-text") {
            attachment.loadItem(forTypeIdentifier: "public.plain-text", options: nil) { data, error in
                guard let fileUrl = data as? URL else { fatalError("Could not get data url") }
                // Send the operantion to the background in case it takes too long, extensions cannot run long long tasks
                DispatchQueue.global(qos: .userInitiated).async {
                    let message = StoreFrigoFiles.with(fileUrl: fileUrl, fileData: nil, context: context)
                    DispatchQueue.main.async {
                        // go to the main queue and diplay the label
                        self.informationLabel.isHidden = false

                        // display the text
                        self.informationLabel.text = message
                    }
                }
            }
        }
    }
    
    // MARK:- UISetup
    private func setUpLabel() {
        
        // add the view to the subview
        view.addSubview(informationLabel)
        
        // we will use autolayout so
        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // we set up the constrints for the only view we
        // have. To the center
        informationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        informationLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        informationLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        informationLabel.isHidden = true
        
        informationLabel.numberOfLines = 10
    }
    
    
    // Set up the nav bar
    private func setupNavBar() {
        
        // give a small title to our inputing file
        self.navigationItem.title = "Input File"

        // creating the cancel uibarbutton item
        let itemCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        self.navigationItem.setLeftBarButton(itemCancel, animated: false)
        itemCancel.isEnabled = activateDoneButton

        // create and configure the done uibarbuttonitem
        let itemDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        self.navigationItem.setRightBarButton(itemDone, animated: true)
    }
    

    /// function to cancel the input file view controller and halt and error
    @objc private func cancelAction () {
        let error = NSError(domain: "some.bundle.identifier", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error description"])
        extensionContext?.cancelRequest(withError: error)
    }

    
    /// function to dismiss the Input file view controller
    @objc private func doneAction() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}

