import ActivityKit

// MyLiveActivityAttributes 정의
struct MyLiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var progress: Double  // 진행 상태 (예: 0.0에서 1.0까지)
    }
    
    var title: String  // 타이틀 (예: "Tracking Progress")
    var description: String  // 설명 (예: "Your journey is in progress")
}
//
//class LiveActivityManager {
//    static let shared = LiveActivityManager()
//    
//    private init() {}
//    
//    // 현재 진행 중인 라이브 액티비티를 추적
//    private var currentActivity: Activity<MyLiveActivityAttributes>?
//    
//    // 라이브 액티비티가 활성화 되었는지 확인하는 프로퍼티
//    var isActivityActive: Bool {
//        return currentActivity != nil
//    }
//
//    // 라이브 액티비티 시작
//    func startLiveActivity() {
//        let initialState = MyLiveActivityAttributes.ContentState(progress: 0.0)
//        let activityAttributes = MyLiveActivityAttributes(title: "Tracking Progress", description: "Your journey is in progress")
//        
//        do {
//            // 라이브 액티비티 요청
//            let activity = try Activity<MyLiveActivityAttributes>.request(
//                attributes: activityAttributes,
//                contentState: initialState,
//                pushType: nil
//            )
//            
//            currentActivity = activity // 시작된 활동을 currentActivity에 저장
//            print("Activity object: \(activity)")  // activity 객체를 출력
//            print("Live Activity started: \(activity.id)")
//        } catch {
//            print("라이브 액티비티 시작 실패: \(error)")
//        }
//    }
//
//    // 라이브 액티비티 상태 업데이트
//    func updateLiveActivity(progress: Double) {
//        guard let activity = currentActivity else {
//            print("활동이 시작되지 않았습니다.")
//            return
//        }
//        
//        let newState = MyLiveActivityAttributes.ContentState(progress: progress)
//        
//        Task {
//            do {
//                // 상태 업데이트
//                try await activity.update(using: newState)
//                print("라이브 액티비티 업데이트: \(progress)")
//            } catch {
//                print("라이브 액티비티 업데이트 실패: \(error)")
//            }
//        }
//    }
//    
//    // 라이브 액티비티 종료
//    func endLiveActivity() {
//        guard let activity = currentActivity else {
//            print("활동이 시작되지 않았습니다.")
//            return
//        }
//        
//        Task {
//            do {
//                // 활동 종료
//                await activity.end()
//                print("라이브 액티비티 종료: \(activity.id)")
//                currentActivity = nil // 종료 후 currentActivity 초기화
//            } catch {
//                print("라이브 액티비티 종료 실패: \(error)")
//            }
//        }
//    }
//}
