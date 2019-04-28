//
//  StartViewController.swift
//  Chat
//
//  Created by Vadim Koronchik on 4/27/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var label: UILabel!
    @IBOutlet var loadingLabel: UILabel!
    
    var viewModel: StartViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        configureViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { (_) in
            self.viewModel.input.animationDidFinish.onNext(())
        }
        
        UIView.animate(withDuration: 0.7, delay: 0.2, options: .curveEaseInOut, animations: {
            self.imageView.center.x += self.view.frame.width / 2 + self.imageView.frame.width
        })
        
        UIView.animate(withDuration: 0.7, delay: 0.4, options: .curveEaseInOut, animations: {
            self.label.center.x -= self.view.frame.width / 2 + self.label.frame.width
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            self.loadingLabel.alpha -= 1.0
        })
    }
    
    private func configureViewModel() {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension StartViewController {
    
    static func create(with viewModel: StartViewModel) -> StartViewController {
        let viewController = R.storyboard.auth.startViewController()!
        viewController.viewModel = viewModel
        
        return viewController
    }
    
}
