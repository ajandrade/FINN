# FINN

This was a fun project to work on. 

I could have done this faster by using some frameworks (Kingfisher, Moya+Alamofire, etc.), but I've decided to try to do everything as native as possible.
The only framework I've used was Realm, because of its simplicity and because I'm more familiar with it than with Core Data.
Another cool thing about working on this project was that I've tested some things that I haven't done before like the prefetching API.

There were some things I was considering to use, but since the project wasn't that big (only one screen), I've decided to leave them out, like:
- split network provider based on responsability (download and get ads);
- add some kind of navigation mechanism (coordinator, navigator).

The things I didn't add/use because I wasn't too familiar with them was:
- Core data instead of Realm (as mentioned above)
- UI testing

Regarding the design, I tried to keep the design as close as possible as the one shown.

App screenshot:

![alt text](https://github.com/ajandrade/FINN/blob/master/screenshot.png)
