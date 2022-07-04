//
//  ImageSwipper.swift
//  sampleApp
//
//  Created by Eldos Thomas on 29/6/22.
//

import Foundation
import UIKit

class ImageSwipper: UIView {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    open var containerAffirm = UIView()
    let pageControl = IndicatorBar(frame: .zero)
    var items = [ImageSwipperCellItem]() {
        didSet {
            pageControl.currentSelectedIndex = 0
            let navItemWidth = 60.0
            pageControl.items =
            [HorizontalCategoryBarCellItem(action: { [weak self] cell in

            }, width: navItemWidth),
             HorizontalCategoryBarCellItem(action: { [weak self] cell in

            }, width: navItemWidth),
             HorizontalCategoryBarCellItem(action: { [weak self] cell in

            }, width: navItemWidth),
             HorizontalCategoryBarCellItem(action: { [weak self] cell in

            }, width: navItemWidth)]
//
           collectionView.reloadData()
        }
    }
    
    var isPageControlTriggering = false
    
    init() {
        super.init(frame: CGRect.zero)
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    override func prepareForInterfaceBuilder() {
        setUp()
    }
    
   
    
    private func setUp() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        addSubview(collectionView)
        addSubview(containerAffirm)
        containerAffirm.addSubview(pageControl)
        
        containerAffirm.translatesAutoresizingMaskIntoConstraints = false
        containerAffirm.backgroundColor = UIColor.white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ImageSwipperCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false

        let views: [String: Any] = [
            "collectionView": collectionView,
            "pageControl": pageControl]
        
        var allConstraints: [NSLayoutConstraint] = []

        let horizontalCollectionViewConstraints = NSLayoutConstraint.constraints(
          withVisualFormat: "H:|-0-[collectionView]-0-|",
          metrics: nil,
          views: views)
        
        let horizontalPageControlConstraints = NSLayoutConstraint.constraints(
          withVisualFormat: "H:|-0-[pageControl]-0-|",
          metrics: nil,
          views: views)
        
        let verticalConstraints = NSLayoutConstraint.constraints(
          withVisualFormat: "V:|-0-[collectionView]-(-40)-[pageControl(30)]-0-|",
          metrics: nil,
          views: views)
        
        allConstraints += horizontalCollectionViewConstraints
        allConstraints += horizontalPageControlConstraints
        allConstraints += verticalConstraints
        
        NSLayoutConstraint.activate(allConstraints)
        
//        NSLayoutConstraint.activate([
//            self.pageControl.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: -30),
//        ])
        
        containerAffirm.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        containerAffirm.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        containerAffirm.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        containerAffirm.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}


class ImageSwipperCell: UICollectionViewCell {
    
    private var imageView = UIImageView()
    
    var ImageSwipperItem: ImageSwipperCellItem? {
        didSet {
            imageView.image = ImageSwipperItem?.image
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setUp()
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
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
}

struct ImageSwipperCellItem {
    var image: UIImage?
    var action: ((_ item: ImageSwipperCellItem) -> Void)? = nil
}

extension ImageSwipper: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //MARK: CollectionView Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageSwipperCell
        
        let item = items[indexPath.row]
        cell.ImageSwipperItem = item
        
        return cell
    }
    
    //MARK: CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        
        if let action = item.action {
            action(item)
        }
        
        collectionView.reloadData()
    }
    
    //MARK: CollectionViewFlow Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        pageControl.currentPage = indexPath.row
//    }
    
}

extension ImageSwipper: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isPageControlTriggering {
  //          pageControl.currentPage = Int(scrollView.contentOffset.x/scrollView.bounds.size.width)
        }
    }
}

extension ImageSwipper: CHIBasePageControlDelegate {
    func didTouch(pager: CHIBasePageControl, index: Int) {
        print(pager, index)
    }
}

