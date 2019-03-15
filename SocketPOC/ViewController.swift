//
//  ViewController.swift
//  SocketPOC
//
//  Created by Subhra Roy on 14/03/19.
//  Copyright © 2019 ARC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var socketHandler : SocketHandler = SocketHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        socketHandler.messageDelegate = self
        socketHandler.setupNetworkCommunication()
        socketHandler.addUserToken(token: "123")
        
        self.perform(#selector(ViewController.sendText), with: nil, afterDelay: 5.0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        socketHandler.stopSocketSession()
    }
    
    @objc private func sendText() -> Void{
        
        socketHandler.sendMessage(message: "What's the order status of  2827333")
    }

}

extension ViewController : SocketHandlerProtocol{
    
    func didReceiveMessage(message: MessageModel) {
        
        print("\(String(describing: message.responseBody))")
        print("\(String(describing: message.userToken))")
        
    }
    
}

