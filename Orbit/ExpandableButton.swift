//
//  ExpandableButton.swift
//  Orbit
//
//  Created by ilhan won on 15/12/2018.
//  Copyright © 2018 orbit. All rights reserved.
//

import UIKit
import ExpandableButton

extension ListViewController {
    func setExpandableButton() {
        let insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let attributeString : [NSAttributedString] = [NSAttributedString(string: "",
                                                                         attributes: [NSAttributedString.Key.foregroundColor : UIColor.black,
                                                                                      NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)]),
                                                      NSAttributedString(string: "",
                                                                         attributes: [NSAttributedString.Key.foregroundColor : UIColor.black,
                                                                                      NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)]),
                                                      NSAttributedString(string: "",
                                                                         attributes: [NSAttributedString.Key.foregroundColor : UIColor.black,
                                                                                      NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)])]
        
        let items : [ExpandableButtonItem] = [
            ExpandableButtonItem(image: UIImage(named: "memo"), highlightedImage: nil,
                                 attributedTitle: attributeString[0], highlightedAttributedTitle: nil,
                                 contentEdgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                                 titleEdgeInsets: UIEdgeInsets(top: 34, left: -30, bottom: 0, right: 0),
                                 imageEdgeInsets: insets, size: CGSize(width: 48, height: 48),
                                 titleAlignment: .center,
                                 imageContentMode: .scaleAspectFit,
                                 action: { (_) in
                                    self.presentMemoViewController()
                                    
            }),
            ExpandableButtonItem(image: UIImage(named: "draw"), highlightedImage: nil,
                                 attributedTitle: attributeString[1], highlightedAttributedTitle: nil,
                                 contentEdgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                                 titleEdgeInsets: UIEdgeInsets(top: 36, left: -30, bottom: 0, right: 0),
                                 imageEdgeInsets: insets, size: CGSize(width: 48, height: 46),
                                 titleAlignment: .center,
                                 imageContentMode: .scaleAspectFit,
                                 action: { (_) in
                                    self.pushDrawingViewController()
                                    self.exButton.isHidden = true
            }),
            ExpandableButtonItem(image: UIImage(named: "edit"), highlightedImage: nil,
                                 attributedTitle: attributeString[2], highlightedAttributedTitle: nil,
                                 contentEdgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                                 titleEdgeInsets: UIEdgeInsets(top: 36, left: -30, bottom: 0, right: 0),
                                 imageEdgeInsets: insets, size: CGSize(width: 48, height: 46),
                                 titleAlignment: .center,
                                 imageContentMode: .scaleAspectFit,
                                 action: { (_) in
                                    self.pushWriteViewController()
                                    self.exButton.isHidden = true
            }),
        ]

        let xpoint = UIScreen.main.bounds.width - 50
        self.exButton = ExpandableButtonView(frame: CGRect(x: xpoint, y: 46, width: 48, height:  48), direction: .left, items: items)

        let const : [NSLayoutConstraint] = [NSLayoutConstraint(item: self.exButton, attribute: .width, relatedBy: .equal,
                                                               toItem: nil, attribute: .width,
                                                               multiplier: 1, constant: 48),
                                            NSLayoutConstraint(item: self.exButton, attribute: .height, relatedBy: .equal,
                                                               toItem: nil, attribute: .height,
                                                               multiplier: 1, constant: 48),
                                            NSLayoutConstraint(item: self.exButton, attribute: .centerX, relatedBy: .equal,
                                                               toItem: optionIcon, attribute: .centerX,
                                                               multiplier: 1, constant: 0),
                                            NSLayoutConstraint(item: self.exButton, attribute: .bottom, relatedBy: .equal,
                                                               toItem: self.navigationController?.navigationBar,
                                                               attribute: .bottom,
                                                               multiplier: 1, constant: -6)]
        self.navigationController?.navigationBar.addSubview(self.exButton)
        self.navigationController?.navigationBar.addConstraints(const)
        self.exButton.closeOnAction = true
        self.exButton.animationDuration = 0.2
        self.exButton.separatorColor = .clear
        self.exButton.isHapticFeedback = true
        exButton.isSeparatorHidden = false
    }
    
}
