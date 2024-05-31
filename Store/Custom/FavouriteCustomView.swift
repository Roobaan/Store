//
//  FavouriteCustomView.swift
//  Store
//
//  Created by SCT on 31/05/24.
//

import UIKit

class FavouriteCustomView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {

        
        let shapeLayer = CAShapeLayer()
        let path = createTrianglePath(with: bounds, cornerRadius: 20)
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.candy.cgColor
        
        // Add the CAShapeLayer as a sublayer
        layer.addSublayer(shapeLayer)
        
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapButton))
        addGestureRecognizer(tapGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure that the CAShapeLayer is resized to match the view's bounds
        if let shapeLayer = layer.sublayers?.first as? CAShapeLayer {
            shapeLayer.frame = bounds
            // Update the path with the new bounds
            let path = createTrianglePath(with: bounds, cornerRadius: 20)
            shapeLayer.path = path.cgPath
        }
    }
    
    private func createTrianglePath(with rect: CGRect, cornerRadius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.width , y: 0))
        path.addLine(to: CGPoint(x: cornerRadius - (rect.width * 0.8), y: 0))

        path.addLine(to: CGPoint(x: rect.width, y: (rect.height * 0.8) + cornerRadius ))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addArc(withCenter: CGPoint(x: rect.width - cornerRadius, y: cornerRadius),
                    radius: cornerRadius,
                    startAngle: CGFloat(0),
                    endAngle: CGFloat(3 * Double.pi / 2),
                    clockwise: false)
        path.close()
        return path
    }
    
    @objc private func didTapButton() {
        // Handle button tap action
        print("Favorite button tapped!")
    }
}
