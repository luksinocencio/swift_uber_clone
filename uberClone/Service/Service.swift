import CoreLocation
import Firebase

struct Service {
    static let shared = Service()
    let currentUid = Auth.auth().currentUser?.uid
    
    func fetchUserData(completion: @escaping(User) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        REF_USERS.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
        
    }
}
