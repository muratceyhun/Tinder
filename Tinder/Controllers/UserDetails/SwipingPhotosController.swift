//
//  SwipingPhotosController.swift
//  Tinder
//
//  Created by Murat Ceyhun Korpeoglu on 21.11.2023.
//

import UIKit

class SwipingPhotosController: UIPageViewController, UIPageViewControllerDataSource {
    
    let controllers = [
        PhotoController(image: #imageLiteral(resourceName: "eray")),
        PhotoController(image: #imageLiteral(resourceName: "mck1")),
        PhotoController(image: #imageLiteral(resourceName: "mck2")),
        PhotoController(image: #imageLiteral(resourceName: "bsra")),
        PhotoController(image: #imageLiteral(resourceName: "info_icon"))
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        
        dataSource = self
  
        setViewControllers([controllers.first! ], direction: .forward, animated: true)
        
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == controllers.count - 1 {return nil}
        return controllers[index + 1 ]
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let index = controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == 0 {return nil}
        return controllers[index - 1]
    }
    

}

class PhotoController: UIViewController {
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "bsra"))

    init(image: UIImage) {
        imageView.image = image
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.fillSuperview()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
