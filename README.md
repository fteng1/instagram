# Project 4 - *Instagram* 

**Instagram** is a photo sharing app using Parse as its backend.

Time spent: **15** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign up to create a new account using Parse authentication
- [x] User can log in and log out of his or her account
- [x] The current signed in user is persisted across app restarts
- [x] User can take a photo, add a caption, and post it to "Instagram"
- [x] User can view the last 20 posts submitted to "Instagram"
- [x] User can pull to refresh the last 20 posts submitted to "Instagram"
- [x] User can tap a post to view post details, including timestamp and caption.

The following **optional** features are implemented:

- [x] Run your app on your phone and use the camera to take the photo
- [x] User can load more posts once he or she reaches the bottom of the feed using infinite scrolling.
- [x] Show the username and creation time for each post
- [x] User can use a Tab Bar to switch between a Home Feed tab (all posts) and a Profile tab (only posts published by the current user)
- User Profiles:
  - [x] Allow the logged in user to add a profile photo
  - [x] Display the profile photo with each post
  - [x] Tapping on a post's username or profile photo goes to that user's profile page
- [ ] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse
- [ ] User can comment on a post and see all comments for each post in the post details screen.
- [x] User can like a post and see number of likes for each post in the post details screen.
- [x] Style the login page to look like the real Instagram login page.
- [ ] Style the feed to look like the real Instagram feed.
- [ ] Implement a custom camera view.

The following **additional** features are implemented:

- [ ] List anything else that you can get done to improve the app functionality!

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Refactor or storing data in such a way to reduce the number of network calls made during the execution of the application.
2. Adding a friend or follow system to the app so only posts made by friends are seen, rather than posts from all users.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

User sign up/log in, user persistence:

![instagramuserpersistence](https://user-images.githubusercontent.com/41344374/125132535-4cfaab80-e0b9-11eb-9d9e-cf55591ed3e9.gif)

Create a post, view posts, refresh posts, post details:

![instagrampostandrefresh](https://user-images.githubusercontent.com/41344374/125132890-d7dba600-e0b9-11eb-8ba3-dfd574364e50.gif)

Running the app using the phone camera:

![instagramphonecamera](https://user-images.githubusercontent.com/41344374/125132915-e1650e00-e0b9-11eb-85f4-ea5b035294e1.gif)

Loading more posts with infinite scrolling:

![instagraminfinitescroll](https://user-images.githubusercontent.com/41344374/125132942-ee81fd00-e0b9-11eb-8f08-de1e02bfafda.gif)

Viewing other user profiles, using tab bar, uploading profile picture, liking photos:

![instagramoptionals](https://user-images.githubusercontent.com/41344374/125133092-2b4df400-e0ba-11eb-9db1-7e160121fca0.gif)

GIF created with [EzGif.com](https://ezgif.com/).

## Credits

- [DateTools](https://github.com/MatthewYork/DateTools) - date handling library
- [Parse](https://parseplatform.org/) - database library


## Notes

- The screen did not switch to login page after logging out, which was resolved by changing the screen in the SceneDelegate.
- Switching to the profile tab initially did not bring up the profile of the current user, which required moving code from viewWillAppear to the viewDidLoad function.
- Had issues with getting the TapGestureRecognizer to correspond with the section it was currently in, which required getting the superview of the TapGestureRecognizer and passing the section number through it.

## License

    Copyright 2021 Felianne Teng

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
