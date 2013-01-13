#What
This is proof of concept code that shows how an iOS password management app (like [1Password](https://agilebits.com/onepassword/ios)) could use **URL schemes** and **JavaScript bookmarklets** to communicate with mobile Safari and Chrome to make it easier for users to fill in login forms on websites. It's **more convenient but less secure** than traditional methods. This is not in any way complete, but it is enough to see how this type of system could work and be useful. The majority of the work that I haven't done (namely flexible form filling JavaScript and, you know, writing a password manager app) has already been done well by existing password managers. Adapting this project to implement a feature like this would not be terribly hard.

#Why
In short, to save an estimated 12 taps each time one has to log in to a website.

Password managers are awesome on desktop platforms. Browser extensions mean that it's easy to use unique, random passwords on each site where one has an account. On iOS, though, browser extensions are not possible. The process of repeatedly switching between browser and password manager and copying/pasting credentials is much more awkward than hitting a keyboard shortcut to open a browser extension. Even worse is when web forms disable pasting altogether.  
**Total number of keystrokes (desktop):** 2 + typing password.  
**Estimated total number of taps (iOS):** 17 + typing password.

1Password [recently added](http://blog.agilebits.com/2013/01/12/1password-ios-4-1/) the `ophttp` and `ophttps` URL schemes, which aim to ease this inconvenience by making it easier to open a website in its built-in browser. This is smart, and better than what we had before, but still not ideal: the built-in browser is not as fast or full-featured as a dedicated browser, and it is frequently nice to authenticate once in one's main browser to be already be logged in for future use.

#How

##From a user's perspective
[Here's a video to demonstrate how the interface and flow would work for logging in to a typical website.](http://www.youtube.com/watch?v=nI0L6S5y9tM)

1. The user navigates to the login form.
2. He runs the 'Login' bookmarklet.
3. The password manager app opens and ask him to authenticate if necessary.
4. Once authenticated, he is returned to the web browser he came from.
5. He runs the bookmarklet again.
6. The login form is filled with his credentials and submitted.

##From a technical perspective
1. The user runs the bookmarklet.
	1. It checks for the presence of a username in the URL hash e.g. (`#?bpiUsername=someUsername`).
	2. It doesn't find one, so it constructs a URL based on the current page's url-encoded URL and the scheme used by the password manager (e.g. `bpi://fillWebForm/http%3A%2F%2Fwww.somesite.com`) and opens it.
2. iOS dispatches the URL request to the password manager and invokes [`-application:openURL:sourceApplication:annotation:`](http://developer.apple.com/library/ios/#documentation/uikit/reference/UIApplicationDelegate_Protocol/Reference/Reference.html).
3. The password manager asks the user to log in (if necessary).
4. Once authenticated, the password manager processes the request.
	1. It decrypts the user's stored credentials.
	2. It retrieves the username and password for the relevant site based on the URL passed by the bookmarklet.
5. The password manager returns the user (and his login credentials) to where he was before.
	1. It examines the URL passed by the bookmarklet to determine the page to open.
	2. It examines the origin application to determine the scheme to use to open the correct browser (Safari or Chrome).
	3. It appends the login information to the URL's hash (e.g. `http://www.somesite.com/login.html#form` becomes `http://www.somesite.com/login.html#form?bpiUsername=someUsername&bpiPassword=somePassword`).
	4. It opens the URL and the browser is launched.
6. The browser loads the website.
	1. It checks whether the page is already open.
	2. It finds that it is, so it reloads the page with the new hash rather than opening it in a new tab (consistent for Safari and Chrome).
7. The user runs the bookmarklet.
	1. It checks for the presence of a username in the URL hash e.g. (`#?bpiUsername=someUsername`).
	2. It finds one, so it logs the user in.
		1. It extracts the username and password from the hash.
		2. It fills the relevant form fields with them.
		3. It triggers a form submission.
8. The user has been logged in.

**Total number of taps:** 5 + typing password.

#Setup and use
1. Visit `/www/index.html` in Mobile Safari and click the 'Copy Code' link. Copy the code. (I'll assume that Chrome users know how to use bookmarklets in Chrome).
2. Bookmark the page.
3. Open your bookmarks, hit edit, select the bookmark you just added, and replace the URL with the code you copied.
4. Build and run the app (`/Xcode/iOS Browser Password Integration.xcodeproj`) on your device.
5. Go to a login form that uses standard HTML conventions (I know Google and Facebook work).
6. Open the bookmarklet.
7. Tap login when the app opens (don't worry about typing a password).
8. Open the bookmarklet again when you are redirected to your browser.
9. A fake username and password will be filled in and the form will be submitted.
10. *Optional:* For full effect, change the app's source to use one of your actual logins.

#License
Licensed under the [WTFPL](http://www.wtfpl.net/). Use this however you want.  
<sub>Especially if you're Agile Bits. Then I really, really, really want you to use this however you want.</sub>