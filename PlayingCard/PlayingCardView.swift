 //
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by Danny on 28.10.21.
//

import UIKit

class PlayingCardView: UIView {
    
    var rank: Int = 11 { didSet{ setNeedsLayout(); setNeedsLayout()}}
    var suit: String = "❤️" { didSet{ setNeedsLayout(); setNeedsLayout()}}
    var isFacedUp: Bool = true { didSet{ setNeedsLayout(); setNeedsLayout()}}
    
    
    private func centredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString{
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.paragraphStyle: paragraphStyle,.font:font])
    }
    
    private var cornerString: NSAttributedString{
        return centredAttributedString(rankString+"\n"+suit, fontSize: cornerFontSize)
    }

    private lazy var upperleftCornerLabel = createCornerLabel()
    private lazy var lowerRightCornerLabel = createCornerLabel()
    
    private func createCornerLabel() -> UILabel{
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
    private func configureCornerLabel(_ label: UILabel) {
        label.attributedText = cornerString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !isFacedUp
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureCornerLabel(upperleftCornerLabel)
        upperleftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerFontSize, dy: cornerFontSize)
        
        configureCornerLabel(lowerRightCornerLabel)
        lowerRightCornerLabel.transform = CGAffineTransform.identity.translatedBy(x: lowerRightCornerLabel.frame.size.width, y: lowerRightCornerLabel.frame.size.height)
            .rotated(by: CGFloat.pi)
        lowerRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY).offsetBy(dx: -cornerOffset, dy: -cornerOffset)
            .offsetBy(dx: -lowerRightCornerLabel.frame.size.width, dy: -lowerRightCornerLabel.frame.size.height)
    }
    
    private func drawPips(){
        let pipsPerRowForRank = [[0],[1],[1,1],[1,1,1],[2,2],[2,1,2]]
    }
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.red.setStroke()
        roundedRect.fill()
        
        if let facrCardImage = UIImage(named: rankString+suit){
            facrCardImage.draw(in: bounds.zoom(by: SizeRation.faceCardImageSizeToBoundsSize))
        }
        
    }
}
 
 extension PlayingCardView {
    private struct SizeRation {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRation.cornerRadiusToBoundsHeight
    }
    
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRation.cornerOffsetToCornerRadius
    }
    
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRation.cornerRadiusToBoundsHeight
    }
    
    private var rankString: String {
        switch rank {
        case 1:
            return "A"
        case 2...10:
            return String(rank)
        case 11:
            return "J"
        case 12:
            return "Q"
        case 13:
            return "K"
        default:
            return "?"
        }
    }
 }
 
 extension CGPoint{
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
 }
