//
//  ControllerPadViewController.swift
//  Bluefruit Connect
//
//  Created by Antonio García on 12/02/16.
//  Copyright © 2016 Adafruit. All rights reserved.
//

import UIKit

protocol ControllerPadViewControllerDelegate: class {
    func onSendControllerPadButtonStatus(tag: Int, isPressed: Bool)
}

class ControllerPadViewController: UIViewController {

    //  Constants
    static let prefix = "!B"

    // UI
    @IBOutlet weak var directionsView: UIView!
    @IBOutlet weak var numbersView: UIView!
    
    // Data
    weak var delegate: ControllerPadViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup buttons targets
        for subview in directionsView.subviews {
            if let button = subview as? UIButton {
                setupButton(button)
            }
        }
        
        for subview in numbersView.subviews {
            if let button = subview as? UIButton {
                setupButton(button)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Fix: remove the UINavigationController pop gesture to avoid problems with the arrows left button
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigationController?.interactivePopGestureRecognizer?.delaysTouchesBegan = false
            self.navigationController?.interactivePopGestureRecognizer?.delaysTouchesEnded = false
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - UI
    fileprivate func setupButton(_ button: UIButton) {
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.masksToBounds = true
        
        button.setTitleColor(UIColor.lightGray, for: .highlighted)
        
        let hightlightedImage = UIImage(color: UIColor.darkGray)
        button.setBackgroundImage(hightlightedImage, for: .highlighted)
        
        button.addTarget(self, action: #selector(onTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(onTouchUp(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(onTouchUp(_:)), for: .touchDragExit)
        button.addTarget(self, action: #selector(onTouchUp(_:)), for: .touchCancel)
    }
    
    // MARK: - Actions
    func onTouchDown(_ sender: UIButton) {
        sendTouchEvent(tag: sender.tag, isPressed: true)
    }
    
    func onTouchUp(_ sender: UIButton) {
        sendTouchEvent(tag: sender.tag, isPressed: false)
    }

    private func sendTouchEvent(tag: Int, isPressed: Bool) {
        if let delegate = delegate {
            delegate.onSendControllerPadButtonStatus(tag: tag, isPressed: isPressed)
        }
    }

    @IBAction func onClickHelp(_ sender: UIBarButtonItem) {
        let localizationManager = LocalizationManager.sharedInstance
        let helpViewController = storyboard!.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
        helpViewController.setHelp(localizationManager.localizedString("controlpad_help_text"), title: localizationManager.localizedString("controlpad_help_title"))
        let helpNavigationController = UINavigationController(rootViewController: helpViewController)
        helpNavigationController.modalPresentationStyle = .popover
        helpNavigationController.popoverPresentationController?.barButtonItem = sender
        
        present(helpNavigationController, animated: true, completion: nil)
    }
}
