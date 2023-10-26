//
//  CustomTabBarController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate{

    let controllers: [UIViewController]
    let locationManager: LocationManager
    let firebaseFoundSerivce: FirebaseFoundService
    
    lazy var cameraButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = UIColor(hexCode: "5DDFDE")
        button.layer.cornerRadius = 20
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        configureTabBarControllers()
        configureCameraButton()
    }
    
    init(controllers: [UIViewController], locationManager: LocationManager, firebaseFoundSerivce: FirebaseFoundService) {
        self.controllers = controllers
        self.locationManager = locationManager
        self.firebaseFoundSerivce = firebaseFoundSerivce
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTabBarControllers() {

        let mapTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "map"), tag: 0)
        mapTabBarItem.selectedImage = UIImage(systemName: "map.fill")
        controllers[0].tabBarItem = mapTabBarItem
        
        let lostListTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "menucard"), tag: 1)
        lostListTabBarItem.selectedImage = UIImage(systemName: "menucard.fill")
        controllers[1].tabBarItem = lostListTabBarItem
        
        let dummyTabBarItem = UITabBarItem(title: nil, image: nil, tag: 2)
        controllers[2].tabBarItem = dummyTabBarItem
        
        let chatTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "message"), tag: 3)
        chatTabBarItem.selectedImage = UIImage(systemName: "message.fill")
        controllers[3].tabBarItem = chatTabBarItem
        
        let myInfoTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), tag: 4)
        myInfoTabBarItem.selectedImage = UIImage(systemName: "person.fill")
        controllers[4].tabBarItem = myInfoTabBarItem
    
        self.viewControllers = controllers
          
        self.tabBar.barTintColor = UIColor(hexCode: "5DDFDE")
        self.tabBar.unselectedItemTintColor = .black
        self.tabBar.backgroundColor = .white
    }
    
    func configureCameraButton() {
        self.tabBar.addSubview(cameraButton)
        cameraButton.frame = CGRect(x: Int(self.tabBar.bounds.width / 2) - 25, y: -20, width: 50, height: 50)
    }
    
    @objc func cameraButtonTapped() {
        let camera = UIImagePickerController()
        camera.sourceType = .camera
        camera.allowsEditing = true
        camera.cameraDevice = .rear
        camera.cameraCaptureMode = .photo
        camera.delegate = self
        
        present(camera, animated: true)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == controllers[2] {
            return false
        }
        return true
    }
}

extension CustomTabBarController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage else { return }
        
        let currentLocation = locationManager.fetchLocation()
        
        guard let latitude = currentLocation?.latitude, let longitude = currentLocation?.longitude else { return }
        
        Task {
            do {
                let url = try await FirebaseImageUploadService.uploadeFoundImage(image: image)
                let foundDTD = FoundResponseDTO(latitude: latitude, longitude: longitude, imageURL: url, date: Date(), userIdentifier: "045RhOisSFgjp0AjR2DusTpDsyb2")
            } catch {
                print(error)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
