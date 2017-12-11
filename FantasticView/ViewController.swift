//
//  ViewController.swift
//  Demo_app_swift
//
//  Created by Oleksandr Omelchenko on 18.10.17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import UIKit
class ViewController: UIViewController, GetTokenDelegate {
//publicKey: String, gatewayId: String
    
    func getToken() {
        cardFormView.getToken(publicKey: "8b2dad5fcf18f6f504685a46af0df82216781f3b", gatewayId: "58d06b6a6529147222e4afa8") { (result: String) in
            // do stuff with the result
            print (result)
        }
    }
    
    
    @IBOutlet weak var cardFormView: cardFormView!
    @IBOutlet weak var Submit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardFormView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cardSubmitPressed(_ sender: Any) {
    cardFormView.getToken(publicKey: "8b2dad5fcf18f6f504685a46af0df82216781f3b", gatewayId: "58d06b6a6529147222e4afa8") { (result: String) in
            // do stuff with the result
            print (result)
        }

    }
}

