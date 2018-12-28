//
//  ViewController.swift
//  Freezerapp
//
//  Created by Benjamin Van Iseghem on 28/12/2018.
//  Copyright © 2018 Benjamin Van Iseghem. All rights reserved.
//

import UIKit
import FirebaseUI

class ViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        //Get Auth object
        let authUI = FUIAuth.defaultAuthUI()
        
        guard authUI != nil else {
            //Log error
            return
        }
        //Set self as delegate
        authUI?.delegate = self
        
        //Get a reference to the Auth UI view controller
        let authViewController = authUI!.authViewController()
        
        //Show it
        present(authViewController, animated: true, completion: nil)
    }
    
    
    
}

extension ViewController : FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        //Check if there was an error
        guard error == nil else {
            //Log error
            return
        }
        
        //authDataResult?.user.uid  --> code for finding the id of the user
        
        performSegue(withIdentifier: "goToFreezerList", sender: self)
    }
}

