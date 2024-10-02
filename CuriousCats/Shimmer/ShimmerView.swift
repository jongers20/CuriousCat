//
//  ShimmerView.swift
//  CuriousCats
//
//  Created by Erika Ypil on 10/2/24.
//


import UIKit

class ShimmerView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShimmerEffect()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupShimmerEffect()
    }
    
    private func setupShimmerEffect() {
        
        gradientLayer.colors = [
            UIColor(white: 0.85, alpha: 1.0).cgColor,  // Light gray
            UIColor(white: 0.95, alpha: 1.0).cgColor,  // Lighter gray (shimmer)
            UIColor(white: 0.85, alpha: 1.0).cgColor   // Light gray
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations = [0.0, 0.5, 1.0]
        layer.addSublayer(gradientLayer)
        startShimmering()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        gradientLayer.frame = bounds
    }
    
    func startShimmering() {
        let shimmerAnimation = CABasicAnimation(keyPath: "locations")
        shimmerAnimation.fromValue = [-1.0, -0.5, 0.0]
        shimmerAnimation.toValue = [1.0, 1.5, 2.0]
        shimmerAnimation.duration = 1.5
        shimmerAnimation.repeatCount = .infinity
        gradientLayer.add(shimmerAnimation, forKey: "shimmerAnimation")
    }
    
    func stopShimmering() {
        gradientLayer.removeAnimation(forKey: "shimmerAnimation")
    }
}
