# RedditFeed
App build using Xcode9.0.1 

# Task
[Task.pdf](https://github.com/Quarezz/RedditFeed/blob/master/Task.pdf)

## Notes:
* Architecture

I’ve used simple MVC approach + services DI into models. Adding flow coordinator to manage navigation and passing data between controllers. 

* Network

Connection to Reddit API goes through https://www.reddit.com/top.json. No ssl handling or custom urlSessions, wanted to leave it as simple as possible.

* Restoration

Restoration is covered by image page. The navigation stack and image link  is cached and restored on relaunch. 

* Tests

Code basics are pretty much covered. There is an issue with making Photos framework a dependency, but it can be hidden behind a protocol. Didn’t want to spend too much time on it. 
The same goes for ApiClient and some parts of models. The approach is just to inject stuff like UrlSession with default values and mock them in test cases. Also ignored ViewControllers.


