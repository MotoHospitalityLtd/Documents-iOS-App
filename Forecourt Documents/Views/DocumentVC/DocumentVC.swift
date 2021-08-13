//
//  DocumentVC.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 15/07/2021.
//

import UIKit
import PDFKit

class DocumentVC: UIViewController, HasBackButton, HasMenuButton {
 
    //# MARK: - Data
    var stateController: StateController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSetup()
    }
    
    //# MARK: - Setup
    private func uiSetup() {
        
        configureBackButton()
        configureMenuButton()
        
        
        // Create test PDF view
        let pdfView = PDFView()

        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)

        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
//        guard let path = Bundle.main.url(forResource: "Test PDF 1", withExtension: "pdf") else { return }
        
//        if let document = PDFDocument(url: path) {

//            pdfView.document = document
//        }
        
        
        if let document = PDFDocument(data: stateController.documentController.loadCurrentDocument()) {
            pdfView.document = document
        }
        
        
//        if let document = PDFDocument(data: stateController.pdfData!) {
//            pdfView.document = document
//        }
    }
    
    //# MARK: - Button Actions
    internal func backTapped(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindFromDocumentVC", sender: self)
    }
    
    func menuTapped(sender: UIBarButtonItem) {
        openMenu(sender: sender, withStateController: stateController)
    }
    
    //# MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       
    }
    
    func unwindFromAboutVC(segue: UIStoryboardSegue) {
        
    }
}
