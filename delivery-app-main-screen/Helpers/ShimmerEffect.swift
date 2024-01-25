//
//  ShimmerEffect.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 23.01.2024.
//

import UIKit

extension UIView {
    func getFrame() -> CGRect {
        return bounds
    }
}

extension UIView {
    
    /// Set shimmering animation for view.
    /// - Parameters:
    ///   - animate: Specifies the animation is on/off.
    ///   - viewBackgroundColor: The `backgroudColor` of specified views superview.
    ///   - animationSpeed: The speed of the shimmer animation.
    func setShimmeringAnimation(_ animate: Bool, viewBackgroundColor: UIColor? = nil, animationSpeed: CGFloat) {
        let currentShimmerLayer = layer.sublayers?.first(where: { $0.name == Key.shimmer })
        if animate {
            if currentShimmerLayer != nil { return }
        } else {
            currentShimmerLayer?.removeFromSuperlayer()
            return
        }
        
        let baseShimmeringColor: UIColor? = viewBackgroundColor ?? superview?.backgroundColor
        guard let color = baseShimmeringColor else {
            print("⚠️ Warning: `viewBackgroundColor` can not be nil while calling `setShimmeringAnimation`")
            return
        }
        
        // MARK: - Shimmering Layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = Key.shimmer
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = min(bounds.height / 2, 5)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        let gradientColorOne = color.withAlphaComponent(0.5).cgColor
        let gradientColorTwo = color.withAlphaComponent(0.8).cgColor
        gradientLayer.colors = [gradientColorOne, gradientColorTwo, gradientColorOne]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        layer.addSublayer(gradientLayer)
        gradientLayer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        
        // MARK: - Shimmer Animation
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = animationSpeed
        gradientLayer.add(animation, forKey: animation.keyPath)
    }
}

extension UIView {
    
    /// Sets the view as template.
    /// - Parameters:
    ///   - template: Set `true` to make it template. `false` to remove.
    ///   - baseColor: Template layer color.
    func setTemplate(_ template: Bool, baseColor: UIColor? = nil) {
        var color: UIColor
        if let baseColor = baseColor {
            color = baseColor
        } else {
            if #available(iOS 12, *), traitCollection.userInterfaceStyle == .dark {
                color = Color.Placeholder.dark
            } else {
                color = Color.Placeholder.light
            }
        }
        let currentTemplateLayer = layer.sublayers?.first(where: { $0.name == Key.template })
        
        if template {
            if currentTemplateLayer != nil { return }
        } else {
            currentTemplateLayer?.removeFromSuperlayer()
            layer.mask = nil
            return
        }
        
        let templateLayer = CALayer()
        templateLayer.name = Key.template
        
        setNeedsLayout()
        layoutIfNeeded()
        
        let templateFrame = getFrame()
        let cornerRadius: CGFloat = max(layer.cornerRadius, min(bounds.height/2, 5))
        
        // MARK: - Mask Layer
        let maskLayer = CAShapeLayer()
        let ovalPath = UIBezierPath(roundedRect: templateFrame, cornerRadius: cornerRadius)
        maskLayer.path = ovalPath.cgPath
        layer.mask = maskLayer
        
        // MARK: Template Layer
        templateLayer.frame = templateFrame
        templateLayer.cornerRadius = cornerRadius
        templateLayer.backgroundColor = color.cgColor
        layer.addSublayer(templateLayer)
        templateLayer.zPosition = CGFloat(Float.greatestFiniteMagnitude - 1.0)
    }
}
