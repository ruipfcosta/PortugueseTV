

import UIKit
import AVKit

private let cellIdentifier = "channelCell"

class HomeViewController: UIViewController {
    
    var channels: [Entry] = []
    var player: AVPlayer?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.global(qos: .background).async { [weak self] in
            let url = URL(string: "http://lista.kodiportugal.com")!
            let data = try! Data(contentsOf: url)
            let file = String(data: data, encoding: .utf8)!
            
            self?.channels = Parser.parse(file: file)
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func playVideo(url: URL) {
        let playerController = AVPlayerViewController()
        player = AVPlayer(url: url)
        playerController.player = player
        
        present(playerController, animated: true) {
            self.player?.play()
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let channel = channels[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = channel.title
        
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = channels[(indexPath as NSIndexPath).row]
        
        guard let channelUrl = channel.url, let url = URL(string: channelUrl) else { return }
        
        playVideo(url: url)
    }
}
