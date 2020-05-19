//
//  ViewController.swift
//  ASWebAuthenticationSessionRedirectTest
//
//  Created by Lucas Stomberg on 5/19/20.
//  Copyright © 2020 Epic. All rights reserved.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {

    @IBOutlet var urlTextView: UITextView!
    @IBOutlet var schemeTextField: UITextField!
    @IBOutlet var responseTextView: UITextView!
    @IBOutlet var errorTextView: UITextView!

    @IBAction public func buttonWasTapped() {
        guard var text = urlTextView.text else {
            print("no text in url text view")
            return
        }

        if !text.starts(with: "https") {
            if text.starts(with: "http") {
                text = text.replacingOccurrences(of: "http", with: "https")
            } else {
                text = "https://\(text)"
            }
        }
        guard let url = URL(string: text) else {
            print("invalid url text: \(text)")
            return
        }

        let session = ASWebAuthenticationSession(url: url,
                                   callbackURLScheme: schemeTextField.text) { (url, error) in
                                    if let url = url {
                                        self.responseTextView.text = url.absoluteString
                                        print("URL:", url)
                                    } else {
                                        self.responseTextView.text = "No URL response"
                                    }

                                    if let error = error {
                                        self.errorTextView.text = String(describing: error)
                                        print("Error:", error)
                                    } else {
                                        self.errorTextView.text = "No error"
                                    }
        }
        session.presentationContextProvider = self
        session.start()
    }


    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }


}

