## A quick example
Lets say we have a Login endpoint which we want to model. The endpoint accepts an username and a password via an HTTP Post. Upon successful login, the endpoint will return an inflated user. For this example the user will simply be a `name`, `age`, and `sex`. Something like the following:

```Swift
struct User {
    enum Sex: String, Codable {
        case male, female
    }

    var name: String
    var age: Int
    var sex: Sex
}
extension User: Codable {}

struct LoginRequest: Encodable {
    var username: String
    var password: String
}

extension LoginRequest: Postable {
    typealias ResponseType = User

    var baseUrl: String { return "https://myserver.ca/api/v1" }

    var path: String { return "/login" }
}

let request = LoginRequest(username: "Jerry", password: "Hellooooooo!")
request.submit() { result in 
    // We get a Result enum, which on success will hold the inflated Decodable 
    // (as defined by the ResponseType typealias, above)
    // and a Restivus.HTTPError on failure.
    switch result {
    case let .success(user):
        // a successful call will return to us a fully inflated User struct
        print(user)
    case let .failure(error):
        // There can be several reasons for failure, which we won't get into here
        print(error)
    }
}
```

### An Explanation
Lets breakdown the above. We'll start with the conformance to the `Postable` protocol by the `LoginRequest:
```Swift
extension LoginRequest: Postable
```
The `Postable` protocol is what turns our `LoginRequest` into a `POST` request. Restivus has a few different HTTP method protocols for commonly used request types: `Gettable`, `Deletable`, `Patchable`, `Postable`, and `Puttable`. Each one maps to its respective method.

All of these protocols inherit from `Restable`, which in turn defines the conformance requirements and bulk of the functionality for any request. Its children (`Gettable` and the rest of the crew) provide sensible defaults for creating the actual underlying `URLRequest`.

Next is the `ResponseType`:
```Swift
typealias ResponseType = User
```
This defines what the returned payload should be deserialized into. In our case, the Login endpoint will return some JSON describing a User (as we structured above). 

Following that are the two properties, `baseUrl` and `path`. 
```Swift
var baseUrl: String {
    "https://myserver.ca/api/v1"
}

var path: String {
    "/login"
}
```
These are pretty self explanatory. They are defined in the `Restable` protocol, and default to empty strings. In my experience, the `baseUrl` will typically be the same value for most, if not all the requests. As such, it's a bit of a pain in the butt to repeat that same property over and over again. Since Swift allows for protocol extensions, it's easier to have a global extension of `Restable` that returns a sensible default for `baseUrl`. 

For example, if we were going to create several requests for our `myserver.ca` endpoint, it makes more sense to do the following:

```Swift
extension Restable {
    var baseUrl: String { return "https://myserver.ca/api/v1" }
}
```
This also works well if you have different servers for different environments that are determined at runtime, from a configuration. By extending `Restable` to have a default for `baseUrl`, we can then omit it from our `Postable` conformance:

```Swift
extension LoginRequest: Postable {
    typealias ResponseType = User
    var path: String { "/login" }
}
```

Finally, lets talk about what the conforming our `LoginRequest` to `Encodable` will do:
```Swift
struct LoginRequest: Encodable {}
```
If you submit a `Restable` which conforms to `Encodable`, then Restivus will serialize that Restable into JSON and submit it as the body of the request. In our case, the following JSON will be submitted in the body of the `LoginRequest`:
```JSON
{
    "username": "Jerry",
    "password": "Hellooooooo!"
}
```

If you'd like to get a bit more of a feel for Swift 4's `Codable` (which is just a combination of `Encodable & Decodable`), put the following into a Playground.
```Swift
import Foundation

struct User: Codable {
    enum Sex: String, Codable {
        case male, female
    }
    
    var name: String
    var age: Int
    var sex: Sex
}

let user = User(name: "Ryan", age: 38, sex: .male)
var encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
let data = try! encoder.encode(user)
print(String(data: data, encoding: .utf8)!)

let inflatedUser = try! JSONDecoder().decode(User.self, from: data)
```
