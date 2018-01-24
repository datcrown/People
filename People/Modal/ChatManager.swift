//
//  ChatManager.swift
//  People
//
//  Created by Quoc Dat on 12/18/17.
//  Copyright © 2017 Quoc Dat. All rights reserved.
//

import Foundation
import SocketIO
import SwiftSocket
class chatManager {
    func connectSocket() {
    let socket = TCPClient(address: "202.32.203.168", port: 9118)
        switch socket.connect(timeout: 10) {
        case .success:
        print("11111111")
        let data = socket.read(1024*10)
            print(data)
        case .failure(let error):
            print(error)
            
        }
        
    }
}
