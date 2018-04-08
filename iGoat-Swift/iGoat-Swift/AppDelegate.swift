
//TODO: Comment

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configureSideMenu()
        configureRootController()
        return true
    }
}

extension AppDelegate {
    func configureRootController() {
        self.window = UIWindow()
        let menuTC = MenuTableViewController()
        let sideMenuViewController = SideMenuController()
        sideMenuViewController.embed(sideViewController: menuTC)
        menuTC.assets = Asset.allAssets()
        window?.rootViewController = sideMenuViewController
        window?.makeKeyAndVisible()
    }
    
    func configureSideMenu() {
        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "menu")
        SideMenuController.preferences.drawing.sidePanelPosition = .underCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = 300
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .horizontalPan
        SideMenuController.preferences.animating.transitionAnimator = FadeAnimator.self
    }
}
