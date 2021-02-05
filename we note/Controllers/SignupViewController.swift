//
//  SignupViewController.swift
//  we note
//
//  Created by Mohamed Ali on 2/4/21.
//

import UIKit
import ProgressHUD

class SignupViewController: UIViewController {

    // Make Object from Class SignupView.
    var signupview: SignupView! {
        guard isViewLoaded else { return nil }
        return (view as! SignupView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    // MARK:- TODO:- Make Action For Login
    @IBAction func BTNSignup(_ sender:Any) {
        Signup()
    }
    
    // MARK:- TODO:- Make Action For Signup Button.
    @IBAction func BTNLoginin (_ sender:Any) {
        // Return to login Page.
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK:- TODO:- Function Login Operation.
    func Signup() {
        // operation Signup
        // 1)  check all fields aren't empty
        // 2)  make operation signup from firebase.
        
        if (self.signupview.EmailTextField.text == "" || self.signupview.PasswordTextField.text == "") {
            // Create Alert to fill all fields.
            Tools.MakeAlert(Title: "Error", Mess: "Please Fill All Fields Before Sign up", ob: self)
        }
        else {
            // Make Signup Operation.
            FirebaseNetworking.createAccount(Email: signupview.EmailTextField.text!, Password: signupview.PasswordTextField.text!) { (mess) in
                if mess == "Success" {
                    ProgressHUD.showSuccess("Your Account is created Successfully")
                    self.dismiss(animated: true, completion: nil)
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

extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == signupview.EmailTextField {
            // If Press next in email keypad foucus on password
            signupview.PasswordTextField.becomeFirstResponder()
        }
        else {
            // dismiss keypad and make Login operation
            self.view.endEditing(true)
            Signup()
        }
        return true
    }
}
