//
//  AuthenticationViewController.swift
//  CubezPlus
//
//  Created by mino on 8/26/18.
//  Copyright © 2018 mino. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FBSDKLoginKit



class AuthenticationViewController: UIViewController  , FBSDKLoginButtonDelegate{
    
    
    @IBOutlet weak var EmailTxt: UITextField!
    
    @IBOutlet weak var PassTxt: UITextField!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let FaceBookloginButton = FBSDKLoginButton()
        
        FaceBookloginButton.center = view.center
        
        view.addSubview(FaceBookloginButton)
        
        FBSDKLoginButton.init(frame: CGRect(x:0 , y:0, width:view.frame.width-32, height: 50))
        
        FaceBookloginButton.delegate = self
       // self.view.backgroundColor = UIColor.white
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print ("Did logout of FaceBook")
    
        }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
         if error != nil
         {
            print(error)
            return
        }
        print("Successfully logedin into FaceBook")
        self.performSegue(withIdentifier: "ListOfDrugs", sender: self)
    }

    
    @IBAction func Login(_ sender: UIButton) {
        
        
        if self.EmailTxt.text == "" || self.PassTxt.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            Auth.auth().signIn(withEmail: self.EmailTxt.text!, password: self.PassTxt.text!) { (user, error) in
                
                if error == nil {
                  
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    
                    //Go to the MovieListViewController if the login is sucessful
                    self.performSegue(withIdentifier: "ListOfDrugs", sender: self)
                    
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
        
        
    }
    
    
    @IBAction func SignUp(_ sender: UIButton) {
        
        if EmailTxt.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: EmailTxt.text!, password: PassTxt.text!) { (user, error) in
                
                if error == nil {
                    
                    let alertLogin = UIAlertController(title: "Signup", message: "You have successfully signed up,Please click login button", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertLogin.addAction(defaultAction)
                    
                    self.present(alertLogin, animated: true, completion: nil)
                    
                    //print("You have successfully signed up")
                }
                    
                else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        

        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
