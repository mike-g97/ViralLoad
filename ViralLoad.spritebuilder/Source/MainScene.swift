import Foundation
import GameKit

class MainScene: CCNode {
    
    func didLoadFromCCB() {
        setUpGameCenter()
    }
    
    func setUpGameCenter() {
        let gameCenterInteractor = GameCenterInteractor.sharedInstance
        gameCenterInteractor.authenticationCheck()
    }
    
//    Called when the play button is hit
    func play(){
        let modesScene = CCBReader.loadAsScene("GameModes")
        CCDirector.sharedDirector().replaceScene(modesScene)
        Mixpanel.sharedInstance().track("Play Button Pressed")
    }
    
//    Called when the high score button is hit
    func loadHighScore(){
        let highScoreScene = CCBReader.loadAsScene("ViewHighScore")
        CCDirector.sharedDirector().replaceScene(highScoreScene)
    }
    
    func leaderboard(){
        showLeaderboard()
        Mixpanel.sharedInstance().track("Viewed Game Leaderboard")
    }
}

extension MainScene: GKGameCenterControllerDelegate {
    
    func showLeaderboard() {
        var viewController = CCDirector.sharedDirector().parentViewController!
        var gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        viewController.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    
    // Delegate methods
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}