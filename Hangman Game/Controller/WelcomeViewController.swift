import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var playBtn: UIButton!
    
    let defaults = UserDefaults.standard
    var totalScore = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        setNeedsStatusBarAppearanceUpdate()
        if let score = defaults.integer(forKey: Constants.scoreKey) as? Int {
            totalScore = score
        } else {
            totalScore = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = " "
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func playBtnPressed(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now()  + 0.6) {
            [weak self] in
            self?.performSegue(withIdentifier: Constants.gameSeugue, sender: self)
        }
    }
}
