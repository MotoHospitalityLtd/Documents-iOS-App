//
//  ConfigVC.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 21/07/2021.
//

import UIKit

class ConfigVC: UIViewController, HasBackButton {
    //# MARK: - Data
    var stateController: StateController!
    
    //# MARK: - Variables
    var pinger: SimplePing?
    
    var googleResponse = false
    
    var pingTimer: Timer?
    
    var isRefreshing = false
    
    var hostCheckCount: Int = 0 {
        didSet {
            checksPerformed()
        }
    }

    var internetStatus: HostMO.Status = .connecting {
        didSet {
            self.googleResponse = true
            checksPerformed()
        }
    }
    
    //# MARK: - IB Outlets
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("TEST")
        print("hostCount: \(stateController.networkController.hosts.count)")
        notificationSetup()
        uiSetup()
        refreshControlSetup()
    }
    
    @objc func appBecameActive() {
        reSetRefreshControl()
        tableView.layoutSubviews()
        refreshUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        reSetRefreshControl()
    }
    
    private func notificationSetup() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appBecameActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    //# MARK: - Setup
    private func uiSetup() {
        configureBackButton()
    }
    
    //# MARK: - Connectivity Methods
    @objc func refreshUI() {
        tableView.refreshControl!.beginRefreshing()
        
        guard isRefreshing == false else {return}
        
        connectivityChecks()
        tableView.reloadData()
    }
    
    func checksPerformed() {
//        print("HOST COUNT: \(stateController.networkController.hosts.count)")
        tableView.reloadData()
        print("GoogleResponse: \(googleResponse)")
        
        if googleResponse == true && hostCheckCount == stateController.networkController.hosts.count {
            isRefreshing = false

            print("Checks performed")
            tableView.isUserInteractionEnabled = true
            tableView.refreshControl?.isEnabled = true
            tableView.refreshControl?.endRefreshing()
        }
        
        else {
            print("Checks not performed")
        }
    }
    
    func connectivityChecks() {
         internetStatus = .connecting
         
         for host in stateController.networkController.hosts {
             host.status = .connecting
         }
         
         hostCheckCount = 0
         isRefreshing = true
         
         googleResponse = false
         
         tableView.isUserInteractionEnabled = false
         tableView.refreshControl?.isEnabled = false
         
         internetCheck()
         hostCheck()
     }
     
     func internetCheck() {
         self.pinger = SimplePing(hostName: "8.8.8.8")
         self.pinger!.delegate = self
         self.pinger!.start()
     }
     
     func hostCheck() {
         for host in stateController.networkController.hosts {
             host.healthCheck(networkController: stateController.networkController) { (response) in
                 host.hasResponded = false
                 self.hostCheckCount += 1
             
                 print("Response from: \(host.name!)")
                 print("Host URL: \(host.url!)")
                 print("hostCheckCount: \(self.hostCheckCount)")
             }
         }
     }
     
     @objc func pingTimeout() {
         pinger?.stop()
         pingTimer?.invalidate()
         internetStatus = .offline
         googleResponse = true
     }
     
     //# MARK: - Refresh Control
     func refreshControlSetup() {
         tableView.refreshControl = UIRefreshControl()
         tableView.refreshControl!.addTarget(self, action: #selector(refreshUI), for: .valueChanged)
         tableView.refreshControl!.beginRefreshingManually()
         refreshUI()
     }
     
     func reSetRefreshControl() {
         pingTimer?.invalidate()
         pinger?.stop()
         tableView.refreshControl!.endRefreshing()
         tableView.refreshControl?.isEnabled = true
         tableView.reloadData()
         isRefreshing = false
     }
    
    //# MARK: - Button Actions
    internal func backTapped(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindFromConfigVC", sender: self)
    }
    
    //# MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let host = sender as? HostMO else {return}
        
        if segue.identifier == "showEditConfigVC" {
            let editConfigVC = segue.destination as! EditConfigVC
            editConfigVC.stateController = self.stateController
            editConfigVC.host = host
        }
    }
    
    @IBAction func unwindFromEditConfigVC(segue: UIStoryboardSegue) {
        refreshUI()
        tableView.refreshControl!.beginRefreshingManually()
        tableView.layoutSubviews()
        tableView.refreshControl!.layoutSubviews()
        tableView.deselectSelectedRow(animated: true)
    }
}
