//
//  HorizontalCategoryBar.swift
//  sampleApp
//
//  Created by Eldos Thomas on 5/7/22.
//

import Foundation
import UIKit

class HorizontalCategoryBar: UIView {
    
    var currentSelectedIndex = 0 {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    
    var items = [HorizontalCategoryCellItem]()
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
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
        
        collectionView.register(HorizontalCategoryCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}

struct HorizontalCategoryCellItem {
    var title: String? = nil
    var image: UIImage? = nil
    var action: ((_ item: HorizontalCategoryCellItem) -> Void)? = nil
    var width: CGFloat = 90.0
}

class HorizontalCategoryCell: UICollectionViewCell {
    
    private let containerView = UIView()
    private let containerViewImage = UIView()
    private let imageView = UIImageView()
    private let label = UILabel()
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                label.textColor = tintColor
                imageView.tintColor = UIColor.white
                containerViewImage.backgroundColor = .blue
            } else {
                label.textColor = UIColor.darkGray
                imageView.tintColor = UIColor.darkGray
                containerViewImage.backgroundColor = .lightGray
            }
        }
    }
    
    var item: HorizontalCategoryCellItem? {
        didSet {
            imageView.image = item?.image
            label.text = item?.title
  //          label.font = item?.image != nil ? UIFont.CarrierStandard.Light12 : UIFont.CarrierStandard.Bold16
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        backgroundColor = UIColor.clear
        
        addSubview(containerView)
        containerView.addSubview(containerViewImage)
        containerView.addSubview(label)
        containerViewImage.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerViewImage.translatesAutoresizingMaskIntoConstraints = false
        
        containerViewImage.backgroundColor = .lightGray
        
        imageView.image = item?.image
        imageView.tintColor = UIColor.white
        
        label.text = item?.title
        label.textAlignment = .center
 //       label.font = item?.image != nil ? UIFont.CarrierStandard.Light12 : UIFont.CarrierStandard.Bold16
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        let views: [String: Any] = [
            "imageView": imageView,
            "label": label,
            "containerView": containerView,
            "containerViewImage" : containerViewImage]

        var allConstraints: [NSLayoutConstraint] = []
        
        let verticalContentConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[containerViewImage]-0-[label]-0-|", metrics: nil, views: views)
        
        let horizontalContainerViewImageConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[containerViewImage]-15-|", metrics: nil, views: views)
        
        let horizontalLabelConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[label]-0-|", metrics: nil, views: views)
        
        
        allConstraints += verticalContentConstraints
        allConstraints += horizontalContainerViewImageConstraints
        allConstraints += horizontalLabelConstraints

        NSLayoutConstraint.activate(allConstraints)
        
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        imageView.topAnchor.constraint(equalTo: containerViewImage.topAnchor, constant: 10).isActive = true
        imageView.bottomAnchor.constraint(equalTo: containerViewImage.bottomAnchor, constant: -10).isActive = true
        imageView.leadingAnchor.constraint(equalTo: containerViewImage.leadingAnchor, constant: 10).isActive = true
        imageView.trailingAnchor.constraint(equalTo: containerViewImage.trailingAnchor, constant: -10).isActive = true
        
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        containerViewImage.heightAnchor.constraint(equalTo: containerViewImage.widthAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        containerViewImage.layer.cornerRadius = (frame.width-30) / 2
    }
}

extension HorizontalCategoryBar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //MARK: CollectionView Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HorizontalCategoryCell
        
        let item = items[indexPath.row]
        cell.tintColor = tintColor
        cell.item = item
        
        cell.isHighlighted = indexPath.row == currentSelectedIndex ? true : false
        
        return cell
    }
    
    //MARK: CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        
        item.action?(item)
        
        currentSelectedIndex = indexPath.row
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    //MARK: CollectionViewFlow Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let item = items[indexPath.row]
        return CGSize(width: item.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

