//
//  Spinner.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 04/08/2021.
//

import UIKit

class Spinner: UIView {
    //# MARK: - UI Objects:
    var activityIndicator: UIActivityIndicatorView!
    
    //# MARK: - Initializers:
    init() {
        super.init(frame: UIScreen.main.bounds)
        createActivityIndicator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //# MARK: - Activity Indicator:
    func createActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: self.center.x - 25, y: self.center.y - 25, width: 50, height: 50))
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.color = UIColor.black
        activityIndicator.hidesWhenStopped = true
        
        self.addSubview(activityIndicator)
        UIApplication.shared.beginIgnoringInteractionEvents()
        activityIndicator.startAnimating()
    }
    
    func close() {
        UIApplication.shared.endIgnoringInteractionEvents()
        self.removeFromSuperview()
    }
}
