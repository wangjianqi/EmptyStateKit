//
//  EmptyStateView.swift
//  StateView
//
//  Created by Alberto Aznar de los Ríos on 23/05/2019.
//  Copyright © 2019 Alberto Aznar de los Ríos. All rights reserved.
//

import UIKit

class EmptyStateView: NibView {
    /// 空白页容器
    @IBOutlet weak var messageView: UIView!
    /// 背景图片
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var primaryButton: UIButton!
    
    // Constraints
    /// 按钮宽度
    @IBOutlet var primaryButtonWidthConstraint: NSLayoutConstraint!
    /// centerY
    @IBOutlet var messageViewCenterYConstraint: NSLayoutConstraint!
    /// 底部边距 优先级低
    @IBOutlet var messageViewBottomConstraint: NSLayoutConstraint!
    /// 顶部边距 优先级低
    @IBOutlet var messageViewTopConstraint: NSLayoutConstraint!
    /// left
    @IBOutlet var messageViewLeftConstraint: NSLayoutConstraint!
    /// right
    @IBOutlet var messageViewRightConstraint: NSLayoutConstraint!
    /// 按钮CenterX
    @IBOutlet var primaryButtonCenterXConstraint: NSLayoutConstraint!
    /// left
    @IBOutlet var primaryButtonLeftConstraint: NSLayoutConstraint!
    /// right
    @IBOutlet var primaryButtonRightConstraint: NSLayoutConstraint!
    /// 描述的边距
    @IBOutlet var primaryButtonTopConstraint: NSLayoutConstraint!
    /// 图片的边距
    @IBOutlet var primaryButtonTop2Constraint: NSLayoutConstraint!
    /// 父视图的
    @IBOutlet var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var imageViewBottomConstraint: NSLayoutConstraint!
    /// 描述的顶部：负值
    @IBOutlet var imageViewTop2Constraint: NSLayoutConstraint!
    /// 图片的宽和高
    @IBOutlet var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var titleLabelTopConstraint: NSLayoutConstraint!
    /// 背景图片的
    @IBOutlet weak var coverImageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var coverImageViewBottomConstraint: NSLayoutConstraint!

    // 可以自定义
    struct ViewModel {
        var image: UIImage?
        var title: String?
        var description: String?
        var titleButton: String?
    }
    
    var viewModel = ViewModel() {
        didSet { fillView() }
    }
    
    var format = EmptyStateFormat() {
        didSet { updateUI() }
    }
    
    var actionButton: ((UIButton)->())?
    /// 渐变
    private var gradientLayer: CAGradientLayer?
    
    override func awakeFromNib() {
        primaryButton.layer.cornerRadius = 20
    }
    
    @IBAction func didPressPrimaryButton(_ sender: UIButton) {
        actionButton?(sender)
    }
    
    override func commonInit() {
        super.commonInit()
        setupView()
    }
}

extension EmptyStateView {
    
    private func setupView() {
        
    }
    
    private func fillView() {
        // 配置背景图片
        if case .cover(_, _) = format.position.image {
            coverImageView.image = viewModel.image
            imageView.image = nil
        } else {
            coverImageView.image = nil
            imageView.image = viewModel.image
        }

        // 配置标题
        if let title = viewModel.title {
            titleLabel.isHidden = false
            titleLabel.attributedText = NSAttributedString(string: title, attributes: format.titleAttributes)
        } else {
            titleLabel.isHidden = true
        }

        // 配置详情
        if let description = viewModel.description {
            descriptionLabel.isHidden = false
            descriptionLabel.attributedText = NSAttributedString(string: description, attributes: format.descriptionAttributes)
        } else {
            descriptionLabel.isHidden = true
        }

        // 配置按钮
        if let titleButton = viewModel.titleButton {
            primaryButton.isHidden = false
            primaryButton.setAttributedTitle(NSAttributedString(string: titleButton, attributes: format.buttonAttributes), for: .normal)
        } else {
            primaryButton.isHidden = true
        }
    }
    
    private func updateUI() {
        
        imageView.isHidden = false
        coverImageView.isHidden = true
        if let imageTintColor = format.imageTintColor {
            imageView.tintColor = imageTintColor
            coverImageView.tintColor = imageTintColor
        } else {
            imageView.tintColor = .systemBlue
            coverImageView.tintColor = .systemBlue
        }
        
        // Primary button format
        // 配置按钮
        primaryButton.backgroundColor = format.buttonColor
        primaryButton.layer.cornerRadius = format.buttonRadius
        primaryButton.layer.shadowColor = format.buttonColor.cgColor
        primaryButton.layer.shadowOffset = CGSize(width: 0.0, height: 0)
        primaryButton.layer.masksToBounds = false
        primaryButton.layer.shadowRadius = format.buttonShadowRadius
        primaryButton.layer.shadowOpacity = 0.5
        
        if let buttonWidth = format.buttonWidth {
            primaryButtonWidthConstraint.isActive = true
            primaryButtonWidthConstraint.constant = buttonWidth
        } else {
            primaryButtonWidthConstraint.isActive = false
        }
        
        // Message format
        messageView.alpha = format.alpha
        
        // Background format
        backgroundColor = format.backgroundColor
        
        // Background gradient format
        if let gradientColor = format.gradientColor {
            gradientLayer?.removeFromSuperlayer()
            gradientLayer = CAGradientLayer()
            gradientLayer?.colors = [gradientColor.0.cgColor, gradientColor.1.cgColor]
            gradientLayer?.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer?.endPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer?.locations = [0, 1]
            gradientLayer?.frame = bounds
            layer.insertSublayer(gradientLayer!, at: 0)
        } else {
            gradientLayer?.removeFromSuperlayer()
        }
        
        // Setup constraints
        imageViewWidthConstraint.constant = format.imageSize.width
        imageViewHeightConstraint.constant = format.imageSize.height

        /// 配置约束
        setupViewPosition(format.position.view)
        setupTextPosition(format.position.text)
        setupImagePosition(format.position.image)
        setupLateralPosition()
    }
    
}

extension EmptyStateView {
    
    func play() {
        format.animation?.play?(self)
    }
}
/// 实现
extension EmptyStateView: NibLoadable {}
