//
//  TutorialViewController.swift
//  irregularVerbs
//
//  Created by Admin on 2/18/19.
//  Copyright © 2019 RK. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var pageControl: UIPageControl!
    private let slides: [TutorialView] = TutorialViewController.createSlides()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slides.last?.nextButtonPress = { [weak self] in
            self?.nextButtonPressed()
        }
        slides.forEach { scrollView.addSubview($0) }

        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.alwaysBounceVertical = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateScrollViewContentSize()
    }
    
    private static func createSlides() -> [TutorialView] {
        
        let slide1:TutorialView = Bundle.main.loadNibNamed("TutorialView", owner: self, options: nil)?.first as! TutorialView
        slide1.imageView.image = UIImage(named: "swipe2")
        slide1.tutorialLabel.text = "On this screen you can learn and listen to the words."
        slide1.nextButton.isHidden = true
        
        let slide2:TutorialView = Bundle.main.loadNibNamed("TutorialView", owner: self, options: nil)?.first as! TutorialView
        slide2.imageView.image = UIImage(named: "swipe3")
        slide2.tutorialLabel.text = "Select the desired mode. All One by One-you will learn words in the order of the list. All randomly-you will learn words in the random mode. Only selected-you will learn only selected words. All with skipping - you will skip selected words"

        slide2.nextButton.isHidden = true
        
        let slide3:TutorialView = Bundle.main.loadNibNamed("TutorialView", owner: self, options: nil)?.first as! TutorialView
        slide3.imageView.image = UIImage(named: "swipe4")
        slide3.tutorialLabel.text = "Only selected mode - you will learn only selected words in the training mode. Just check words you want to learn. If you want to remove words from the list -  uncheck required words."
        slide3.nextButton.isHidden = true
        
        
        let slide4:TutorialView = Bundle.main.loadNibNamed("TutorialView", owner: self, options: nil)?.first as! TutorialView
        slide4.imageView.image = UIImage(named: "swipe5")
        slide4.tutorialLabel.text = "All with skipping mode - you will skip selected words in the training mode. Just check words you want to skip. If you want to remove words from the list -  uncheck required words."
        slide4.nextButton.isHidden = true
        
        let slide5:TutorialView = Bundle.main.loadNibNamed("TutorialView", owner: self, options: nil)?.first as! TutorialView
        slide5.imageView.image = UIImage(named: "swipe6")
        slide5.tutorialLabel.text = "Training mode. You can listen to the words (Play button). Tap the buttons  with the desired letters to fill the input fields. If you'll make 5 mistakes, the entered words will be displayed again. Enjoy your learning!"
        slide5.nextButton.layer.cornerRadius = slide4.nextButton.frame.size.height / 5.0
        slide5.nextButton.isHidden = false
        return [slide1, slide2, slide3, slide4, slide5]
    }
    
     func nextButtonPressed() {
        DataManager.instance.isTutorialChoosen = true
        performSegue(withIdentifier: "MainMenuViewController", sender: nil)
     }
    
    func updateScrollViewContentSize() {
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * CGFloat(slides.count), height: scrollView.bounds.height)
        for i in 0..<slides.count {
            slides[i].frame = CGRect(x: scrollView.bounds.width * CGFloat(i), y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        
        if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
            
            slides[0].imageView.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
            slides[1].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)
            
        } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.50) {
            slides[1].imageView.transform = CGAffineTransform(scaleX: (0.50-percentOffset.x)/0.25, y: (0.50-percentOffset.x)/0.25)
            slides[2].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.50, y: percentOffset.x/0.50)
            
        } else if(percentOffset.x > 0.50 && percentOffset.x <= 0.75) {
            slides[2].imageView.transform = CGAffineTransform(scaleX: (0.75-percentOffset.x)/0.25, y: (0.75-percentOffset.x)/0.25)
            slides[3].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.75, y: percentOffset.x/0.75)
            
        } else if(percentOffset.x > 0.75 && percentOffset.x <= 1) {
            slides[3].imageView.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.25, y: (1-percentOffset.x)/0.25)
            slides[4].imageView.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
        }
    }
}

extension TutorialViewController {
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
