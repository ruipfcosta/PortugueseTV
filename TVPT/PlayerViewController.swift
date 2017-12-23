import Foundation
import UIKit
import AVKit

class PlayerViewController: UIViewController {
    
    let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: .none, bundle: .none)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let playerController = AVPlayerViewController()
        playerController.player = AVPlayer(url: url)
        
        self.addChildViewController(playerController)
        self.view.addSubview(playerController.view)
        playerController.view.frame = self.view.frame
    }
}
