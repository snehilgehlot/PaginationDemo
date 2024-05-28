//
//  CustomActivityIndicatorView.swift
//  PaginationDemo
//
//  Created by shree on 28/05/24.
//

import UIKit

class CustomActivityIndicatorView: UIView {

    private var isAnimating = false
       private let circleLayer = CAShapeLayer()

       override init(frame: CGRect) {
           super.init(frame: frame)
           setupView()
       }

       required init?(coder: NSCoder) {
           super.init(coder: coder)
           setupView()
       }

       private func setupView() {
           self.layer.addSublayer(circleLayer)
           let circlePath = UIBezierPath(ovalIn: self.bounds.insetBy(dx: 5, dy: 5))
           circleLayer.path = circlePath.cgPath
           circleLayer.fillColor = UIColor.clear.cgColor
           circleLayer.strokeColor = UIColor.blue.cgColor
           circleLayer.lineWidth = 3.0
       }

       func startAnimating() {
           if isAnimating { return }
           isAnimating = true
           addAnimation()
       }

       func stopAnimating() {
           isAnimating = false
           circleLayer.removeAnimation(forKey: "rotation")
       }

       private func addAnimation() {
           let rotation = CABasicAnimation(keyPath: "transform.rotation")
           rotation.fromValue = 0
           rotation.toValue = 2 * CGFloat.pi
           rotation.duration = 1
           rotation.repeatCount = .infinity
           circleLayer.add(rotation, forKey: "rotation")
       }
}

extension UIView {

    private static let indicatorTag = 999999

    func showActivityIndicator() {
        if let existingIndicator = viewWithTag(UIView.indicatorTag) as? CustomActivityIndicatorView {
            existingIndicator.startAnimating()
        } else {
            let indicatorSize: CGFloat = 50
            let customIndicator = CustomActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: indicatorSize, height: indicatorSize))
            customIndicator.center = self.center
            customIndicator.tag = UIView.indicatorTag
            addSubview(customIndicator)
            customIndicator.startAnimating()
        }
    }

    func hideActivityIndicator() {
        if let existingIndicator = viewWithTag(UIView.indicatorTag) as? CustomActivityIndicatorView {
            existingIndicator.stopAnimating()
            existingIndicator.removeFromSuperview()
        }
    }
}
