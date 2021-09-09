import Firebase
import Foundation

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_DRIVERS_LOCATIONS = DB_REF.child("driver-locations")
