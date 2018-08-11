//
//  JornalDetailViewController.swift
//  Day One Clone
//
//  Created by Hisham Abraham on 6/20/18.
//  Copyright © 2018 Hisham Abraham. All rights reserved.
//

import UIKit

class JornalDetailViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var journalTextLabel: UILabel!
    
    var entry : Entry?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let entry = self.entry {
             title = entry.datePrettyString()
            journalTextLabel.text = entry.text
            for picture in entry.pictures {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                let ratio = picture.fullImage().size.height / picture.fullImage().size.width
                
                imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1.0)
                
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: ratio).isActive = true
                
                imageView.image = picture.fullImage()
                
                stackView.addArrangedSubview(imageView)
                
                
            }
        } else {
            journalTextLabel.text = ""
        }
    }


}
