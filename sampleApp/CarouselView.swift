//
//  CarouselView.swift
//  sampleApp
//
//  Created by Eldos Thomas on 29/6/22.
//

import Foundation
import UIKit

class CarouselView: UIView {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    private let pageControl = FXPageControl(frame: .zero)
    var items = [CarouselCellItem]() {
        didSet {
            pageControl.numberOfPages = items.count
            pageControl.currentPage = 0
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
        
        pageControl.delegate = self
        
        addSubview(collectionView)
        addSubview(pageControl)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(CarouselViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        pageControl.dotShape = CGPath(roundedRect: CGRect(x: 0, y: 0, width: 50, height: 4), cornerWidth: 3, cornerHeight: 2, transform: .none)
        pageControl.backgroundColor = UIColor.clear
        pageControl.selectedDotColor = UIColor.white
        pageControl.selectedDotSize = 12.0;
        pageControl.dotColor = UIColor.gray
 //       pageControl.dotBorderColor = UIColor.gray
//        pageControl.dotBorderWidth = 1.0;
//        pageControl.selectedDotBorderWidth = 1.0
        pageControl.dotSize = 12.0
        pageControl.dotSpacing = 45.0
 //       pageControl.selectedDotBorderColor = UIColor.darkGray
        pageControl.addTarget(self, action: #selector(self.pageControlSelectionAction(_:)), for: .valueChanged)
        
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
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    @objc func pageControlSelectionAction(_ sender: UIPageControl) {
                //move page to wanted page
    
            let page: Int? = sender.currentPage
                if !self.isPageControlTriggering {
                var frame: CGRect = self.collectionView.frame
                    frame.origin.x = frame.size.width * CGFloat(page ?? 0)
                    frame.origin.y = 0
                    self.collectionView.scrollRectToVisible(frame, animated: true)
                   
            }
        }
    
}

class CarouselViewCell: UICollectionViewCell {
    
    private var imageView = UIImageView()
    
    var carouselItem: CarouselCellItem? {
        didSet {
            imageView.image = carouselItem?.image
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

struct CarouselCellItem {
    var image: UIImage?
    var action: (() -> Void)?
}

extension CarouselView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //MARK: CollectionView Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CarouselViewCell
        
        let item = items[indexPath.row]
        cell.carouselItem = item
        
        return cell
    }
    
    //MARK: CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        
        if let action = item.action {
            action()
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
}

extension CarouselView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isPageControlTriggering {
            pageControl.currentPage = Int(scrollView.contentOffset.x/scrollView.bounds.size.width)
        }
    }
}

extension CarouselView: FXPageControlDelegate {
    func pageControl(_ pageControl: FXPageControl, didSelectItemAt index: Int) -> Void {
        pageControl.isEnabled = false
        isPageControlTriggering = true
        self.collectionView.scrollToItem(at: NSIndexPath(row: index, section: 0) as IndexPath, at: .left, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((0.7 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.isPageControlTriggering = false
            self.pageControl.isEnabled = true
        }
    }
}
