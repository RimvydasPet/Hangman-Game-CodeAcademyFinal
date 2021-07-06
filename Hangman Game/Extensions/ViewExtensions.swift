import Foundation
import UIKit

extension GameViewController {
    
    func showAlertAction(title: String, message: String, actionTitle: String = "OK", actionClosure: @escaping () -> Void){
        DispatchQueue.main.async {
            [weak self] in
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: actionTitle, style: .default, handler: {(action: UIAlertAction!) in actionClosure()}))
//            ac.formatUI()
            self?.present(ac, animated: true, completion: nil)
        }
    }
    
}

extension UIImageView {
    func animateImg(duration: Double) {
        self.alpha = 0
        UIView.animate(withDuration: duration) {
            self.alpha = 1.0
        }
    }
    
}

extension UILabel {
    func typingTextAnimation(text: String, timeInterval: Double) {
        self.text = ""
        self.alpha = 0
        var charIndex = 0.0
        
        for letter in text  {
            Timer.scheduledTimer(withTimeInterval: timeInterval * charIndex, repeats: false) { (timer) in
                self.text?.append(letter)
            }
            charIndex += 1
        }
        
        UIView.animate(withDuration: 1.0) {
            self.alpha = 1.0
        }
        
    }
}
