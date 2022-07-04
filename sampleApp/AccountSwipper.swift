//
//  AccountSwipper.swift
//  sampleApp
//
//  Created by Eldos Thomas on 4/7/22.
//


import Foundation
import UIKit

@IBDesignable
open class AccountSwipper: UIView {
    
    open var currentSelectedIndex = 0 {
        didSet {
            collectionView.reloadData()
        }
    }
    
    @IBInspectable
    open var numberOfVisibleViews: CGFloat = 2.2
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    
    open var items = [HorizontalAccountSwipperCellItem]()
    
    public init() {
        super.init(frame: CGRect.zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        collectionView.register(HorizontalAccountSwipperCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    open func reloadData() {
        collectionView.reloadData()
    }
}

public struct HorizontalAccountSwipperCellItem {
    public var titleAccountName: String? = nil
    public var titleAccountNumber: String? = nil
    public var titleAmount: String? = nil
    public var action: ((_ item: HorizontalAccountSwipperCellItem) -> Void)? = nil
    public var width: CGFloat = 80.0
}

open class HorizontalAccountSwipperCell: UICollectionViewCell {
    private let labelAccountName = UILabel()
    private let labelAccountNumber = UILabel()
    private let labelAmount = UILabel()
    private let containerView = UIView()
    private let containerViewImage = UIView()
    
    
    open var containerViewImageHeightConstraint: NSLayoutConstraint? = nil
    
    open var item: HorizontalAccountSwipperCellItem? {
        didSet {
            labelAccountName.text = item?.titleAccountName
            labelAccountNumber.text = item?.titleAccountNumber
            labelAmount.text = item?.titleAmount
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        setUp()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        backgroundColor = UIColor.clear
        
        addSubview(containerView)
        containerView.addSubview(containerViewImage)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerViewImage.translatesAutoresizingMaskIntoConstraints = false
        containerViewImage.backgroundColor = .white
        containerView.backgroundColor = .clear
        
        
        let views: [String: Any] = [
            "labelAccountName": labelAccountName,
            "labelAccountNumber": labelAccountNumber,
            "labelAmount": labelAmount,
            "containerView": containerView,
            "containerViewImage" : containerViewImage]

        var allConstraints: [NSLayoutConstraint] = []
        
        let verticalContentConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[containerViewImage]-10-|", metrics: nil, views: views)
        
        let horizontalContainerViewImageConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[containerViewImage]-0-|", metrics: nil, views: views)
        
        
        allConstraints += verticalContentConstraints
        allConstraints += horizontalContainerViewImageConstraints

        NSLayoutConstraint.activate(allConstraints)

        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        containerViewImageHeightConstraint = containerViewImage.heightAnchor.constraint(equalTo: containerViewImage.widthAnchor, multiplier: 0.65, constant: 1)
        containerViewImageHeightConstraint?.isActive = true
    }
    
    public override func layoutSubviews() {
        containerViewImage.widthAnchor.constraint(equalToConstant: 6).isActive = true
        containerViewImage.layer.cornerRadius = 16
        containerViewImage.layer.shadowRadius = 4
        containerViewImage.layer.shadowColor = UIColor.systemGray4.cgColor
        containerViewImage.layer.shadowOpacity = 1
   //     containerViewImage.layer.shadowOffset = .zero
        containerViewImage.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
}

extension AccountSwipper: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //MARK: CollectionView Datasource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HorizontalAccountSwipperCell
        
        let item = items[indexPath.row]
        cell.tintColor = tintColor
        cell.item = item
        
        return cell
    }
    
    //MARK: CollectionView Delegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        item.action?(item)
        currentSelectedIndex = indexPath.row
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        reloadData()
    }
    
    //MARK: CollectionViewFlow Delegate
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let item = items[indexPath.row]
        return CGSize(width: item.width, height: collectionView.frame.size.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

