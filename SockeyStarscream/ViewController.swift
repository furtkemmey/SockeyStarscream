//
//  ViewController.swift
//  SockeyStarscream
//
//  Created by KaiChieh on 26/03/2018.
//  Copyright © 2018 KaiChieh. All rights reserved.
//

import UIKit
import Starscream

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!

    var socket: WebSocket?

    @IBAction func btnAction(_ sender: UIButton) {
        socket?.write(string: "John")

    }
    
    override func viewWillAppear(_ animated: Bool) {
//        socket = WebSocket(url: URL(string: "ws://localhost:1337/")!, protocols: ["chat"])
        socket = WebSocket(url: URL(string: "wss://ws.ptt.cc/bbs/")!, protocols: ["chat","superchat"])
        socket?.delegate = self
        socket?.connect()
        textView.text = ""
    }
    override func viewWillDisappear(_ animated: Bool) {
        socket?.disconnect(forceTimeout: 0)
        socket?.delegate = nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ViewController: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print("Did connect")
    }

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("Did disconnect \(error)")
    }

    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
//        print("Received message \(text)")
        // 1
        guard let data = text.data(using: .utf16),
            let jsonData = try? JSONSerialization.jsonObject(with: data),
            let jsonDict = jsonData as? [String: Any],
            let messageType = jsonDict["type"] as? String else {
                return
        }

        // 2
        if messageType == "message",
            let messageData = jsonDict["data"] as? [String: Any],
            let messageAuthor = messageData["author"] as? String,
            let messageText = messageData["text"] as? String {

//            print("\(messageAuthor): \(messageText)")
            textView.text.append("\(messageAuthor): \(messageText)\n")
        }
    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Received data")
    }


}

