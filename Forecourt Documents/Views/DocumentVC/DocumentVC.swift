//
//  DocumentVC.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 15/07/2021.
//

import UIKit
import PDFKit

class DocumentVC: UIViewController, HasBackButton, HasMenuButton, UIScrollViewDelegate {
 
    //# MARK: - Data
    var stateController: StateController!
    
    //# MARK: - IB Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSetup()
    }
    
    //# MARK: - Setup
    private func uiSetup() {
        self.title = stateController.documentController.currentDocument?.title
        configureBackButton()
        configureMenuButton()
        displayDocument()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private func displayDocument() {
        if let pdfDocument = PDFDocument(data: stateController.documentController.loadDocumentData()) {
            
            let pdfView = PDFView()

            pdfView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(pdfView)

            pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            
            pdfView.document = pdfDocument
        }
        
        if let imageDoc = UIImage(data: stateController.documentController.loadDocumentData()) {
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            
            scrollView.isHidden = false
            
            imageView.image = imageDoc
        }
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
