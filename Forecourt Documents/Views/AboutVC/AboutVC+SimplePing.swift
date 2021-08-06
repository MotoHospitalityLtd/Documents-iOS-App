//
//  AboutVC+SimplePing.swift
//  Forecourt Documents
//
//  Created by Edwards, Mike on 23/07/2021.
//

import Foundation

extension AboutVC: SimplePingDelegate {
    func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
        print("Pinger didStart")
        DispatchQueue.main.async {
            self.pinger!.send(with: nil)
            self.pingTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.pingTimeout), userInfo: nil, repeats: true)
        }
    }

    func simplePing(_ pinger: SimplePing, didFailWithError error: Error) {
        print("Pinger didFail")
        DispatchQueue.main.async {
            self.pingTimer?.invalidate()
            self.internetStatus = .offline
            self.googleResponse = true
        }
    }

    func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) {
        print("Pinger didReceive")
        DispatchQueue.main.async {
            self.pingTimer?.invalidate()
            self.internetStatus = .offline
            self.googleResponse = true
        }
    }

    func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
        print("Pinger sent: \(sequenceNumber)")
    }

    func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
        print("Pinger didReceiveResponse")
        DispatchQueue.main.async {
            self.pingTimer?.invalidate()
            self.internetStatus = .online
            self.googleResponse = true
        }
    }

    func simplePing(_ pinger: SimplePing, didFailToSendPacket packet: Data, sequenceNumber: UInt16, error: Error) {
        print("Pinger didFailToSend")
        DispatchQueue.main.async {
            self.pingTimer?.invalidate()
            self.internetStatus = .offline
            self.googleResponse = true
        }
    }
}

