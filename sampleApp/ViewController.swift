//
//  ViewController.swift
//  sampleApp
//
//  Created by Eldos Thomas on 28/6/22.
//

import UIKit
//import CHIPageControl


class ViewController: UIViewController {

    
    @IBOutlet weak var carouselView: CarouselView!
    
    @IBOutlet weak var chiPageIndicatorView: ChiPageIndicator!
    @IBOutlet weak var imageSwipperView: ImageSwipper!
    @IBOutlet weak var pageControlView: PageControl!
    @IBOutlet weak var indicatorBar: IndicatorBar!
    
    var carouselCellItems = [CarouselCellItem]()
    var pageControlCellItems = [PageControlCellItem]()
    var imageSwipperCellItems = [ImageSwipperCellItem]()
    var chiPageIndicatorCellItems = [ChiPageIndicatorCellItem]()
    var categoryCellItems = [HorizontalCategoryBarCellItem]()
    var indicatorBarView = IndicatorBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
   //     setUpCarouselItems()
        setUpCategoryBarItems()
  //      setUpPageControlItems()
  //      pageControlView.pageIndicatorColor = .red
        setUpChiPageItems()
    }

    
//    func setUpCarouselItems() {
//        carouselCellItems = [CarouselCellItem(image: UIImage(named: "1"), action: nil),
//                   CarouselCellItem(image: UIImage(named: "2"), action: nil),
//                   CarouselCellItem(image: UIImage(named: "3"), action: nil),
//                   CarouselCellItem(image: UIImage(named: "4"), action: nil),
//                             CarouselCellItem(image: UIImage(named: "1"), action: nil)]
//
//        carouselView.items = carouselCellItems
//        carouselView.reloadData()
//    }
    
    
//    func setUpPageControlItems() {
//        pageControlCellItems = [PageControlCellItem(image: UIImage(named: "1"), action: nil),
//                                PageControlCellItem(image: UIImage(named: "2"), action: nil),
//                                PageControlCellItem(image: UIImage(named: "3"), action: nil),
//                                PageControlCellItem(image: UIImage(named: "4"), action: nil),
//                                PageControlCellItem(image: UIImage(named: "1"), action: nil)]
//
//        pageControlView.items = pageControlCellItems
//        pageControlView.reloadData()
//    }
    
        func setUpChiPageItems() {
            chiPageIndicatorCellItems = [ChiPageIndicatorCellItem(image: UIImage(named: "1"), action: nil),
                                         ChiPageIndicatorCellItem(image: UIImage(named: "2"), action: nil),
                                         ChiPageIndicatorCellItem(image: UIImage(named: "3"), action: nil),
                                         ChiPageIndicatorCellItem(image: UIImage(named: "4"), action: nil),
                                         ChiPageIndicatorCellItem(image: UIImage(named: "1"), action: nil)]
    
            chiPageIndicatorView.items = chiPageIndicatorCellItems
            chiPageIndicatorView.reloadData()
        }
    
    
//    func setUpCarouselItems() {
//        imageSwipperCellItems = [ImageSwipperCellItem(image: UIImage(named: "1"), action: { [weak self] cell in
//            self?.view.backgroundColor = .red
//        }),
//                                 ImageSwipperCellItem(image: UIImage(named: "2"), action: nil),
//                                 ImageSwipperCellItem(image: UIImage(named: "3"), action: nil),
//                                 ImageSwipperCellItem(image: UIImage(named: "4"), action: nil),
//                                 ImageSwipperCellItem(image: UIImage(named: "1"), action: nil)]
//
//        imageSwipperView.items = imageSwipperCellItems
//        imageSwipperView.reloadData()
//    }
    
    func setUpCategoryBarItems() {
        let navItemWidth = UIScreen.main.bounds.width/(indicatorBarView.numberOfVisibleViews)
        categoryCellItems = [HorizontalCategoryBarCellItem(action: { [weak self] cell in
            
            self?.view.backgroundColor = .red
                            
        }, width: navItemWidth),
                         HorizontalCategoryBarCellItem(action: { [weak self] cell in
                            
            self?.view.backgroundColor = .yellow
                            
                        }, width: navItemWidth),
                         HorizontalCategoryBarCellItem(action: { [weak self] cell in
                            
            self?.view.backgroundColor = .blue
                            
                        }, width: navItemWidth),
                             HorizontalCategoryBarCellItem(action: { [weak self] cell in
                                
                self?.view.backgroundColor = .blue
                                
                            }, width: navItemWidth),
                             HorizontalCategoryBarCellItem(action: { [weak self] cell in
                                
                self?.view.backgroundColor = .blue
                                
                            }, width: navItemWidth),
                         HorizontalCategoryBarCellItem(action: { [weak self] cell in
                            
            self?.view.backgroundColor = .black
                            
                        }, width: navItemWidth)]
        
        indicatorBar.items = categoryCellItems
        indicatorBar.reloadData()
    }
    
    
}

