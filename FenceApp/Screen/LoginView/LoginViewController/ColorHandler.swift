

import UIKit


class ColorHandler {
    static let shared = ColorHandler()
    
    let titleColor: UIColor
    let textColor: UIColor
    let buttonTextColor: UIColor
    let buttonActivatedColor: UIColor
    let buttonDeactivateColor: UIColor
    
    
    private init() {
        titleColor = .black
        textColor = .black
        buttonTextColor = .white
        buttonActivatedColor = UIColor(hexCode: "51DACF")
        buttonDeactivateColor = UIColor(hexCode: "A6A9B6")
    }
}
