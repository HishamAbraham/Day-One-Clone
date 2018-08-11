//
//  CreateJornalViewController.swift
//  Day One Clone
//
//  Created by Hisham Abraham on 6/20/18.
//  Copyright © 2018 Hisham Abraham. All rights reserved.
//

import UIKit
import RealmSwift
import Spring

class CreateJornalViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var journalTextView: UITextView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var setDate: UIButton!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var aboveNaveBarView: UIView!
    

    var imagePicker = UIImagePickerController()
    var images : [UIImage] = []
    var startWithCamera = false
    var entry = Entry()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navBar.barTintColor = UIColor(red: 0.298, green: 0.757, blue: 0.988, alpha: 1.00) //4cc1fc
        navBar.tintColor = .white
        navBar.isTranslucent = false
        navBar.titleTextAttributes = [.foregroundColor : UIColor.white]
        aboveNaveBarView.backgroundColor = UIColor(red: 0.298, green: 0.757, blue: 0.988, alpha: 1.00) //4cc1fc
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateDate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if startWithCamera {
            startWithCamera = false
            blueCameraTapped("")
        }
    }
    
    func updateDate() {

        navBar.topItem?.title = entry.datePrettyString()
    }

    @objc func keyboardWillHide(notification:Notification)  {
        changeKeyboardHeight(notification: notification)

    }
    
    @objc func keyboardWillShow(notification:Notification)  {
        changeKeyboardHeight(notification: notification)

    }
    
    func changeKeyboardHeight(notification:Notification) {
        if let keyboardFram = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyHeight = keyboardFram.cgRectValue.height
            bottomConstraint.constant = keyHeight + 10
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        if let realm = try? Realm() {
            entry.text = journalTextView.text
            for image in images {
                let picture = Picture(image: image)
                entry.pictures.append(picture)
                picture.entry = entry
                
            }
            try? realm.write {
                realm.add(entry)
            }
            dismiss(animated: true, completion: nil)
            
        }
    }
    
    @IBAction func setDateTapped(_ sender: UIButton) {
        journalTextView.isHidden = false
        datePicker.isHidden = true
        setDate.isHidden = true
        entry.date = datePicker.date
        updateDate()
    }
    
    @IBAction func blueCalendarTapped(_ sender: UIButton) {
        journalTextView.isHidden = true
        datePicker.isHidden = false
        setDate.isHidden = false
        datePicker.date = entry.date
    }
    
    @IBAction func blueCameraTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            images.append(chosenImage)
            let imageView = SpringImageView()
            imageView.heightAnchor.constraint(equalToConstant: 70.0).isActive=true
            imageView.widthAnchor.constraint(equalToConstant: 70.0).isActive=true
            imageView.image = chosenImage
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            stackView.addArrangedSubview(imageView)
            imagePicker.dismiss(animated: true){
                //Animate
                imageView.animation = "pop"
                imageView.duration = 2.0
                imageView.animate()
                
            }
            
        }
    }
    
    


}
