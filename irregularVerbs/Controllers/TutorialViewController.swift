//
//  TutorialViewController.swift
//  irregularVerbs
//
//  Created by Admin on 2/18/19.
//  Copyright © 2019 RK. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet{
            scrollView.delegate = self
        }
    }
    @IBOutlet weak var pageControl: UIPageControl!
    var slides:[TutorialView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        if DataManager.instance.isTutorialChoosen {
            performSegue(withIdentifier: "MainMenuViewController", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backToTutorialController(_ segue: UIStoryboardSegue) {
       DataManager.instance.isTutorialChoosen = false
    }
    
    func createSlides() -> [TutorialView] {
        
        let slide1:TutorialView = Bundle.main.loadNibNamed("TutorialView", owner: self, options: nil)?.first as! TutorialView
        slide1.imageView.image = UIImage(named: "swipe1")
        slide1.tutorialLabel.text = "Welcome to the «World of irregular verbs» application!\n" +
            "Step by step tutorial.\n" + "1. Select the desired language from the list."
        slide1.nextButton.isHidden = true
        
        let slide2:TutorialView = Bundle.main.loadNibNamed("TutorialView", owner: self, options: nil)?.first as! TutorialView
        slide2.imageView.image = UIImage(named: "swipe2")
        slide2.tutorialLabel.text = "2. There are three ways to organize your learning.\n" + " First way. Don't tap any «empty square» buttons. You will learn words in dictation  mode («Training» button) in the order of the list."
        slide2.nextButton.isHidden = true
        
        let slide3:TutorialView = Bundle.main.loadNibNamed("TutorialView", owner: self, options: nil)?.first as! TutorialView
        slide3.imageView.image = UIImage(named: "swipe3")
        slide3.tutorialLabel.text = "Second way. Tap words you already know using «empty square» buttons. In training mode these words will be skipped in the main list. To cancel word skipping - uncheck the button."
        slide3.nextButton.isHidden = true
        
        let slide4:TutorialView = Bundle.main.loadNibNamed("TutorialView", owner: self, options: nil)?.first as! TutorialView
        slide4.imageView.image = UIImage(named: "swipe4")
        slide4.tutorialLabel.text = "Third way. Add words you want to learn using «empty square» buttons. Tap «Learn» button to choose your own list of words. Tap «Training» button  on this screen, and you will  learn words from your custom list. You can delete word from the list or completely clear the list («Clear list» button). Progress of learning isn't saved in this method."
        slide4.nextButton.isHidden = true
        
        let slide5:TutorialView = Bundle.main.loadNibNamed("TutorialView", owner: self, options: nil)?.first as! TutorialView
        slide5.imageView.image = UIImage(named: "swipe5")
        slide5.tutorialLabel.text = "Training mode. You can listen to the words (Play button). Tap the buttons  with the desired letters to fill the input fields. If you'll make 5 mistakes, the entered words will be displayed again. To reset all settings and progress counting, tap «Reset progress» button. Enjoy your learning!"
        slide5.nextButton.layer.cornerRadius = slide5.nextButton.frame.size.height / 5.0
        slide5.nextButtonPress = { [weak self] in
            self?.nextButtonPressed()
        }
        
        return [slide1, slide2, slide3, slide4, slide5]
    }
    
     func nextButtonPressed() {
        DataManager.instance.isTutorialChoosen = true
        performSegue(withIdentifier: "MainMenuViewController", sender: nil)
     }
    
    func setupSlideScrollView(slides : [TutorialView]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
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
