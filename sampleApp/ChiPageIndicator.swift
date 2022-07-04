//
//  ChiPageIndicator.swift
//  sampleApp
//
//  Created by Eldos Thomas on 30/6/22.
//

import Foundation
import UIKit

@IBDesignable
class ChiPageIndicator: UIView {

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    private let pageControl = CHIPageControlJaloro(frame: .zero)
    var items = [ChiPageIndicatorCellItem]() {
        didSet {
            pageControl.numberOfPages = items.count
            pageControl.radius = 2
            pageControl.tintColor = .gray
            pageControl.currentPageTintColor = .white
            pageControl.padding = 6
            pageControl.elementWidth = 25
            pageControl.elementHeight = 2
            pageControl.enableTouchEvents = true
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



        collectionView.register(ChiPageIndicatorCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false

        pageControl.transform = CGAffineTransform(scaleX: 2, y: 2)
        
//        pageControl.pageIndicatorTintColor = UIColor.lightGray
//        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.backgroundColor = UIColor.clear

//        pageControl.addTarget(self, action: #selector(pageControlSelectionAction), for: .allTouchEvents)

        let views: [String: Any] = [
            "collectionView": collectionView,
            "pageControl": pageControl]
1
        var allConstraints: [NSLayoutConstraint] = []

        let horizontalCollectionViewConstraints = NSLayoutConstraint.constraints(
          withVisualFormat: "H:|-0-[collectionView]-0-|",
          metrics: nil,
          views: views)

        let horizontalPageControlConstraints = NSLayoutConstraint.constraints(
          withVisualFormat: "H:|-(0)-[pageControl]-0-|",
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
//            self.pageControl.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 0),
//            self.pageControl.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: 0)
//        ])
    }

    func reloadData() {
        collectionView.reloadData()
    }

    @objc func pageControlSelectionAction(_ sender: CHIPageControlJaloro) {
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


class ChiPageIndicatorCell: UICollectionViewCell {

    private var imageView = UIImageView()

    var chiPageIndicatorItem: ChiPageIndicatorCellItem? {
        didSet {
            imageView.image = chiPageIndicatorItem?.image
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

struct ChiPageIndicatorCellItem {
    var image: UIImage?
 //   var action: (() -> Void)?
    var action: ((_ item: ChiPageIndicatorCellItem) -> Void)? = nil
}

extension ChiPageIndicator: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //MARK: CollectionView Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChiPageIndicatorCell

        let item = items[indexPath.row]
        cell.chiPageIndicatorItem = item

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

}

extension ChiPageIndicator: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isPageControlTriggering {
            pageControl.progress = Double(scrollView.contentOffset.x/scrollView.bounds.size.width)
        }
    }
}

extension ChiPageIndicator: CHIBasePageControlDelegate {
    func didTouch(pager: CHIBasePageControl, index: Int) {
        self.collectionView.scrollToItem(at: NSIndexPath(row: index, section: 0) as IndexPath, at: .left, animated: true)
    }
}

