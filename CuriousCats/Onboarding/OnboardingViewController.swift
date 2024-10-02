//
//  OnboardingViewController.swift
//  CuriousCats
//
//  Created by Erika Ypil on 10/2/24.
//

import Foundation
import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var onboardingImage: UIImageView!
    @IBOutlet var tap: UITapGestureRecognizer!
    var didTapOnce = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tap.addTarget(self, action: #selector(nextImage(_:)))
    }
    
    @objc func nextImage(_ sender: UITapGestureRecognizer) {
        if didTapOnce {
            UserDefaults.standard.set(true, forKey: "isOnboardingCompleted")
            self.performSegue(withIdentifier: "homeScreenSegue", sender: self)
            return
        }
        onboardingImage.image = UIImage(named: "onboarding2")
        didTapOnce = true
    }
}
