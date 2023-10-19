//
//  EnrollViewController.swift
//  FenceApp
//
//  Created by t2023-m0067 on 10/18/23.
//

import UIKit
import SnapKit

class EnrollViewController: UIViewController {

    let testLablee: UILabel = {
        let lb = UILabel()
        lb.text = "EnrollView"
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(testLablee)
        
        testLablee.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
