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
            "Welcome to the `Irregular verbs world` application!",
            "Learn and listen to irregular english verbs!",
            "Listen and repeat to remember better!",
            "Do exercises and memorize new words!",
            "Collect points and become a champion!",
            "Use four training modes to improve learning!"
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
        let xOffsetGlobalInPercents = scrollView.contentOffset.x / view.frame.width
        let pageIndex = Int(round(xOffsetGlobalInPercents))
        pageControl.currentPage = pageIndex
        nextButton.isHidden = pageIndex != slides.count - 1
        
        let scaleSpeed: CGFloat = 0.5
        let minScale: CGFloat = 0.5
        
        let xOffset = xOffsetGlobalInPercents - CGFloat(pageIndex)
        if xOffset > 0 {
            guard pageIndex < slides.count - 1 else { return }
            let firstPageScale = 1 - xOffset * scaleSpeed
            let secondPageScale = minScale + xOffset * scaleSpeed
            slides[pageIndex].imageView.transform = CGAffineTransform(scaleX: firstPageScale, y: firstPageScale)
            slides[pageIndex + 1].imageView.transform = CGAffineTransform(scaleX: secondPageScale, y: secondPageScale)
        } else {
            guard pageIndex > 0 else { return }
            let firstPageScale = minScale - xOffset * scaleSpeed
            let secondPageScale = 1 + xOffset * scaleSpeed
            slides[pageIndex - 1].imageView.transform = CGAffineTransform(scaleX: firstPageScale, y: firstPageScale)
            slides[pageIndex].imageView.transform = CGAffineTransform(scaleX: secondPageScale, y: secondPageScale)
        }
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
