import Foundation

class MainScene: CCNode {

    func play(){
        let modesScene = CCBReader.loadAsScene("GameModes")
        CCDirector.sharedDirector().replaceScene(modesScene)
        Mixpanel.sharedInstance().track("Play Button Pressed")
    }
    
    func loadHighScore(){
        let highScoreScene = CCBReader.loadAsScene("ViewHighScore")
        CCDirector.sharedDirector().replaceScene(highScoreScene)
    }
}
