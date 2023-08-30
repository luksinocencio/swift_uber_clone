import CoreLocation
import Firebase
import GeoFire

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
    
    func fetchDriver(location: CLLocation) {
        let geofire = GeoFire(firebaseRef: REF_DRIVERS_LOCATIONS)
        
        REF_DRIVERS_LOCATIONS.observe(.value) { (snapshot) in
//            geofire.query(at: location, withRadius: 50).observe(.keyEntered) { (uid, location) in
//                print("DEBUG: UID is \(uid)")
//            }
        }
    }
}
