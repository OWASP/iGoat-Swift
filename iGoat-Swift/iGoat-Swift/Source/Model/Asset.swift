import Foundation

struct Asset {
    enum Key: String {
        case name
        case description
        case exercises
    }
    
    let title: String?
    let description: String?
    let exercises: [Exercise]
    
    init(assetInfo: [String: Any]) {
        title = assetInfo[Key.name.rawValue] as? String
        description = assetInfo[Key.description.rawValue] as? String
        var exercises = [Exercise]()
        if let exerciseInfos = assetInfo[Key.exercises.rawValue] as? [Any] {
            exerciseInfos.forEach {
                guard let exercise = $0 as? [String: Any] else {
                    fatalError("exercise is not strutured")
                }
                exercises.append(Exercise(exerciseInfo: exercise))
            }
        }
        self.exercises = exercises
    }
    
    static func allAssets() -> [Asset] {
        let bundlePath = Bundle.main.bundlePath
        guard let allExercisesInfo = NSDictionary(contentsOfFile: bundlePath + "/" + assetsFileName) as? [String: Any]
            else { fatalError("Unable to map th exercises. Please check the format") }
        
        var assets = [Asset]()
        for key in allExercisesInfo.keys {
            if var exerciseInfo = allExercisesInfo[key] as? [String: Any] {
                exerciseInfo[Asset.Key.name.rawValue] = key
                assets.append(Asset(assetInfo: exerciseInfo))
            }
        }
        return assets
    }
}
