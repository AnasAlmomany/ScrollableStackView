//
//  ViewController.swift
//  scrollableStackView
//
//  Created by Anas Almomany on 1/24/18.
//  Copyright © 2018 Anas Almomany. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scrollView.alwaysBounceVertical = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addPressed(_ sender: Any) {
        let newView = UIView(frame: .zero)
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        newView.backgroundColor = .random()

        let textField = UITextField()
        newView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        textField.leadingAnchor.constraint(equalTo: newView.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: newView.trailingAnchor, constant: -20).isActive = true
        textField.centerYAnchor.constraint(equalTo: newView.centerYAnchor).isActive = true
        textField.becomeFirstResponder()
        
        stack.addArrangedSubview(newView)
    }
    
    @IBAction func removePressed(_ sender: Any) {
        if let toBeRemoved = stack.arrangedSubviews.randomItem() {
            toBeRemoved.fadeOut(duration: 0.250, completionHandler: {
                toBeRemoved.removeFromSuperview()
            })
        }
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}
extension UIView {
    func fadeOut(duration: Float, delay: Float = 0.0, completionHandler: @escaping () -> Void) {
        UIView.animate(withDuration: TimeInterval(duration), delay: TimeInterval(delay), options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: { done in
            completionHandler()
        })
    }
}
extension Array {
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
