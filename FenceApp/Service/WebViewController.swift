//
//  WebViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 11/8/23.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    private let webView = WKWebView()
    private let urlString: String
    
    lazy var leftButtonItem: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(rightButtonItemTapped), for: .touchUpInside)
        return button
    }()

    lazy var navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.items = [UINavigationItem()]
        navigationBar.items?[0].setLeftBarButton(UIBarButtonItem(customView: self.leftButtonItem), animated: true)
        return navigationBar
    }()
    
    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUrl()
        configureUI()
    }
    
    func setUrl() {
        guard let url = URL(string: self.urlString) else {
            dismiss(animated: true)
            return
        }
        webView.load(URLRequest(url: url))
    }
    

    func configureUI() {
        view.addSubview(navigationBar)
        view.addSubview(webView)
        
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        webView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc func rightButtonItemTapped() {
        dismiss(animated: true)
    }
}
