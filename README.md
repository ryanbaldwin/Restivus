[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=59d2cc3ff4e144000158b811&branch=master&build=latest)](https://dashboard.buddybuild.com/apps/59d2cc3ff4e144000158b811/build/latest?branch=master)
# Restivus
> _Finally!_ A Festivus for the _Restivus_!

Yes, it's true, this library is named after the infamous [_Festivus_ Seinfeld episode](https://www.youtube.com/watch?v=HX55AzGku5Y). I had no choice, as my initial name, RestEasy, was [already taken by the JBoss Community](http://resteasy.jboss.org), and I don't wanna mess with them.

## What the heck is Restivus?
Restivus is a mostly protocol based approach to creating structured HTTP requests and responses. It's simple, easy, and is built around Swift 4's `Codable` protocol.

# Installation
I do not currently support CocoaPods because, frankly, I hate it. If there's enough demand I might change my mind. In the interim I recommend using [Carthage](https://github.com/Carthage/Carthage), as it doesn't take over your workspace.

## Carthage
1. In your cartfile simply add the following

        github "ryanbaldwin/Restivus" == 0.1
 
   or, if you're running Xcode 9.1

        github "ryanbaldwin/Restivus" == 0.1.1
        
2. Run a `carthage update`
3. Add the framework to your project, as defined [here](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos)

## Good ol' Build It Yourself
1. Clone the repo
2. Open in Xcode 9
3. Build it
4. Celebrate
5. Go for nachos
6. Keep eating nachos
7. If you do not hate yourself yet, repeat step 6
8. Sleepy time

# Some quick examples
Get the contents of the Google homepage as raw data:
```Swift
struct GoogleHomepageRequest: Gettable {
    typealias ResponseType = Raw
    var resultFormat: ResultFormat = .raw
    var url = URL(string: "https://www.google.com")
}

let runningTask = try? GoogleHomepageRequest().submit { result in
    if case let Result.success(data) = result {
        print(String(data: data, encoding: .utf8))
    }
}
```

Submit a login request which, upon success, returns the authenticated user JSON in the response, something like the following:
```Json
{ "name": "Ryan Baldwin",
  "age": 38,
  "sex": "male"
}
```

```Swift
struct User: Codable {
    enum Sex: String, Codable {
        case male, female
    }

    var name: String
    var age: Int
    var sex: Sex
}

struct LoginRequest: Encodable {
    var username: String
    var password: String
}

extension LoginRequest: Postable {
    typealias ResponseType = User
    let url = URL(string: "https://my.awesome-app.com/login")
}

_ = try? LoginRequest(username: "rbaldwin", password: "insecure").submit() { result in 
    if case let Result.success(user) = result {
        print("\(user.name) (\(user.sex)) is \(user.age) years young, and looking mighty fine.")
    }
}
```
Submit a request against a protected endpoint:
```Swift
struct UpdateUserRequest: Encodable {
    var user: User
}

extension UpdateUserRequest: Authenticating, Postable {
    typealias ResponseType = User
    lazy var url: URL? = {
        URL(string: "https://my.awesome-app.com/user/\(self.user.name)")
    }

    /// Sign this request by putting some token in the "Authorization" header
    /// This function comes from the `Authenticating` protocol
    func sign(request: URLRequest) -> URLRequest {
        var req = request
        req.setValue("Token I_AM_KING", forHTTPHeaderField: "Authorization")
        return req
    }
}

let userForUpdate = User(name: "Ryan Baldwin", age: 39, sex: .male)
_ = try? UpdateUserRequest(user: userForUpdate).submit() { result in 
    if case let Result.success(updatedUser) = result {
        print("\(user.name) is now a \(user.age) year old \(user.sex)")
    }
}
```
The above POSTs the JSON encoded `userForUpdate` to the server as the following:
```JSON
{ "user": {"name": "Ryan Baldwin",
           "age": 39,
           "sex": "male"}}
```
If you don't like that you can implement the `Swift.Encodable`'s `encode` function, such as the following:
```Swift
struct UpdateUserRequest: Encodable {
    var user: User

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        container.encode(self.user)
    }
}
```
This will now yield the resulting JSON as the following:
```JSON
{"name": "Ryan Baldwin",
 "age": 39,
 "sex": "male"}
```

## More Info
Examples, tutorials, whatevers will be posted at [Restivus' GH Pages site](https://ryanbaldwin.github.io/Restivus). There, you can also [find the official library documentation](https://ryanbaldwin.github.io/Restivus/docs).

If you're new to Swift 4 and it's `Codable` protocols, I suggest you take a look at the following articles:
- [Swift 4 Decodable: Beyond The Basics](https://medium.com/swiftly-swift/swift-4-decodable-beyond-the-basics-990cc48b7375)
- [Ultimate Guide to JSON Parsing With SWift 4](http://benscheirman.com/2017/06/ultimate-guide-to-json-parsing-with-swift-4/)
- [Encoding, Decoding, and Serialization](https://developer.apple.com/documentation/swift/encoding_decoding_and_serialization)
