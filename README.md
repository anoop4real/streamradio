# streamradio
A Test app to try radio streaming using AVPlayer in Swift.
This app uses API from Orange

`Prerequisite:-`
* Need an API access to Orange/ SignIn create an App and choose the below mentioned API access (radio)
[Orange Signin](https://developer.orange.com/signin)

* Add the API data in *Constants.swift*
```
let kAppClientID:String = "YOUR CLIENT ID"
let kAppClientSecret:String = "YOUR CLIENT SECRET"
let kAppAuthHeader:String   = "YOUR AUTH HEADER"
```
[Getting Started:- https://developer.orange.com/apis/orangeradio/getting-started](https://developer.orange.com/apis/orangeradio/getting-started)

`APIs used:-`

[Orange API](https://developer.orange.com/apis/orangeradio/api-reference)

The App currently uses channels from France, to change this put the rigt country code in *ViewController.swift*
```
self.musicStore = MusicStore(countryCode: "fr")
```
