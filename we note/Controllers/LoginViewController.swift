//
//  ViewController.swift
//  we note
//
//  Created by Mohamed Ali on 2/4/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    // Make Object from Class LoginView.
    var loginview: LoginView! {
        guard isViewLoaded else { return nil }
        return (view as! LoginView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    // MARK:- TODO:- Make Action For Login
    @IBAction func BTNLogin(_ sender:Any) {
        Login()
    }
    
    // MARK:- TODO:- Make Action For Signup Button.
    @IBAction func BTNSignup (_ sender:Any) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let next = story.instantiateViewController(withIdentifier: "SignupView") as! SignupViewController
        next.modalPresentationStyle = .fullScreen
        self.present(next, animated: true, completion: nil)
    }
    
    // MARK:- TODO:- Function Login Operation.
    func Login() {
        // operation Login
        // 1)  check all fields aren't empty
        // 2)  make operation login from firebase.
        
        if (self.loginview.EmailTextField.text == "" || self.loginview.PasswordTextField.text == "") {
            // Create Alert to fill all fields.
            Tools.MakeAlert(Title: "Error", Mess: "Please Fill All Fields Before Login", ob: self)
            
        }
        else {
            // Make Login Operation.
            
            FirebaseNetworking.MakeLogin(Email: loginview.EmailTextField.text! , Password: loginview.PasswordTextField.text!) { (res) in
                
                if res == "Success" {
                    let story = UIStoryboard(name: "Main", bundle: nil)
                    let next = story.instantiateViewController(withIdentifier: "NotesView") as! NotesViewController
                    next.modalPresentationStyle = .fullScreen
                    self.present(next, animated: true, completion: nil)
                }
                else {
                    self.loginview.PasswordTextField.text = ""
                    self.loginview.PasswordTextField.becomeFirstResponder()
                }
                
            }
            
        }
    }
    
    // MARK:- TODO:- When Touch in any point in screen.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dismiss Keypad.
        self.view.endEditing(true)
    }
}

// Handle Retrun button in textfield.
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginview.EmailTextField {
            // If Press next in email keypad foucus on password
            loginview.PasswordTextField.becomeFirstResponder()
        }
        else {
            // dismiss keypad and make Login operation
            self.view.endEditing(true)
            Login()
        }
        return true
    }
}

