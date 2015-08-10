import Foundation

class MainScene: CCNode {
    
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
}
