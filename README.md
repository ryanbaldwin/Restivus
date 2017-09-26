# Restivus
> _Finally!_ A Restivus for the rest of us!

Yes, it's true, this library is named after the infamous [_Festivus_ Seinfeld episode](https://www.youtube.com/watch?v=HX55AzGku5Y). I had no choice, as my initial name, RestEasy, was [already taken by the JBoss Community](http://resteasy.jboss.org), and I don't wanna mess with them.

## What the heck is Restivus?
Restivus is a mostly protocol based approach to creating structured HTTP requests and responses. It's simple, easy, and is built around Swift 4's `Codable` protocol.

## A quick example
Lets say we have a Login endpoint which we want to model. The endpoint accepts an username and a password via an HTTP Post. Upon successful login, the endpoint will return an inflated user. For this example the user will simply be a `name`, `age`, and `sex`. Something like the following:

```Swift
struct User {
    enum Sex: String {
        case male, female
    }

    var name: String
    var age: Int
    var sex: Sex
}
extension User: Codable {}

struct LoginRequest: Postable {
    typealias ResponseType = User
    var username: String
    var password: String
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

We can also model the Login Request:
```Swift

```

So far so good. We have 2 very simple structs which model what we're going to send to the server, and what we'll get back. So how do we turn our struct into something that'll actually POST a request to the server? By having it conform Restivus' `Postable` protocol:

```Swift
struct LoginRequest: Postable {
    var username: String
    var password: String
}
```

The `Postable` protocol is a child protocol of the `Restable` protocol, which defines most of the requirements. As it's name eludes to, `Postable`s are for creating POST requests. Similarily, there is also `Gettable`, `Patchable`, `Puttable`, and `Deletable`. 