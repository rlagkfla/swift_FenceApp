//
//  LostListViewCell.swift
//  FenceApp
//
//  Created by t2023-m0067 on 10/17/23.
//

import UIKit
import SnapKit

class LostListViewCell: UITableViewCell {
    
    let testLabel: UILabel = {
        let lb = UILabel()
        lb.text = "test"
        lb.textColor = .black
        return lb
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(){
        self.addSubview(testLabel)
        
        testLabel.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    
}
