//
//  TutorialViewController.swift
//  irregularVerbs
//
//  Created by Admin on 2/18/19.
//  Copyright © 2019 RK. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var nextButton: UIButton!

    private let slides: [TutorialView] = TutorialViewController.createSlides()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slides.forEach { scrollView.addSubview($0)
            view.backgroundColor = UIColor(red: 236.0/255.0,
                                           green: 247.0/255.0,
                                           blue: 246.0/255.0,
                                           alpha: 1.0)
            
        }

        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        
        let image = UIImage.outlinedEllipse(size: CGSize(width: 7.0, height: 7.0), color: .black)
        self.pageControl.pageIndicatorTintColor = UIColor(patternImage: image!)
        self.pageControl.currentPageIndicatorTintColor = .black

        // по абсолютно непонятный причинам не системный цвет не применяется и всегда белое отображается.
//        let buttonColor = UIColor(red: 57, green: 122, blue: 190, alpha: 1)
        let buttonColor = UIColor.black
        nextButton.tintColor = buttonColor
        nextButton.layer.cornerRadius = 5.0
        nextButton.layer.borderWidth = 2.0
        nextButton.layer.borderColor = buttonColor.cgColor
        nextButton.setTitleColor(buttonColor, for: .normal)
        nextButton.isHidden = true
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.alwaysBounceVertical = false
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateScrollViewContentSize()
    }
    
    private static func createSlides() -> [TutorialView] {
        
        let titles = [
            "A wide variety of irregular verbs",
            "Easy to learn",
            "Listen & Repeat",
            "Exercise",
            "Compete with others.\nEarn stars",
            "Different training modes",
        ]
        let subtitles = [
            "test1",
            "test2",
            "test3",
            "test4",
            "test5",
            "test6"
        ]
        
        var slides = [TutorialView]()
        for i in 0...5 {
            let image = UIImage(named: "tutorial_im\(i + 1)")!
            let slide = TutorialView.make()
            slide.update(title: titles[i], subtitle: subtitles[i], image: image)
            slides.append(slide)
        }
        
        return slides
    }
    
    @IBAction private func nextButtonPressed(_ sender: Any) {
        DataManager.instance.isTutorialChoosen = true
        
        var controllers: [UIViewController] = [MainMenuViewController.instantiateVC()]
        
        if DataManager.instance.choosedLanguage != nil {
            controllers.append(ListViewController.instantiateVC())
        } else if let locale = Locale.preferredLanguages.first {
            let localePrefix = String(locale.prefix(2))
            if let preferredAppLanguage = TranslationLanguage.allCases.first(where: { $0.locale == localePrefix }) {
                DataManager.instance.chooseLanguage(preferredAppLanguage)
                controllers.append(ListViewController.instantiateVC())
            }
        }
        navigationController?.setViewControllers(controllers, animated: true)
    }
    
    private func updateScrollViewContentSize() {
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * CGFloat(slides.count), height: scrollView.bounds.height)
        for i in 0..<slides.count {
            slides[i].frame = CGRect(x: scrollView.bounds.width * CGFloat(i), y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        }
    }
}

extension TutorialViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x / view.frame.width))
        pageControl.currentPage = pageIndex
        nextButton.isHidden = pageIndex != slides.count - 1
        
//        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
//        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
//        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
//        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
//        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
//        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
//
//        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
//
//        if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
//
//            slides[0].imageView.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
//            slides[1].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)
//
//        } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.50) {
//            slides[1].imageView.transform = CGAffineTransform(scaleX: (0.50-percentOffset.x)/0.25, y: (0.50-percentOffset.x)/0.25)
//            slides[2].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.50, y: percentOffset.x/0.50)
//
//        } else if(percentOffset.x > 0.50 && percentOffset.x <= 0.75) {
//            slides[2].imageView.transform = CGAffineTransform(scaleX: (0.75-percentOffset.x)/0.25, y: (0.75-percentOffset.x)/0.25)
//            slides[3].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.75, y: percentOffset.x/0.75)
//
//        } else if(percentOffset.x > 0.75 && percentOffset.x <= 1) {
//            slides[3].imageView.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.25, y: (1-percentOffset.x)/0.25)
//            slides[4].imageView.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
//        }
    }
}

private extension UIImage {
    /// Creates a circular outline image.
    static func outlinedEllipse(size: CGSize, color: UIColor, lineWidth: CGFloat = 1.0) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(lineWidth)
        // Inset the rect to account for the fact that strokes are
        // centred on the bounds of the shape.
        let rect = CGRect(origin: .zero, size: size).insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)
        context.addEllipse(in: rect)
        context.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
