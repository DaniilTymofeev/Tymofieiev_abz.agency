# InterviewTestApp

A simple SwiftUI application built as a test task for an interview.  
It demonstrates working with REST APIs (GET/POST), pagination, form validation, and offline mode handling.

I've created all the key feature listed, applied all designs and mockups, used all the available information given to me. Also I had a great time practising, polishing and improving developer fundamentals, design patterns, best practices, applying better UX for users. I had a lot of inspiration to put into this test App, making it better, showing my vision, while still be 99.9% strict to design and assignment i was given.

Thnank You

## RESOURCES
Assignment link - https://drive.google.com/file/d/1FYz7jemW9O2mGV6R-MUjZc7ZQa1L3ZLh/view
Design link - https://www.figma.com/design/Ip7bsgTfPlzszIEyIwXzUa/Testtask---App?node-id=85-576&t=BFTUZOnjvMF57Rc0-0
API link - https://openapi_apidocs.abz.dev/frontend-test-assignment-v1#/positions/get_positions

---

## 🚀 Features

- ✅ Fetch and display a paginated list of users from the API
- ✅ Show user avatars and details using cached images
- ✅ Submit a registration form via `POST`, with proper validation and success flow
- ✅ Show available positions via `GET /positions`
- ✅ Handle offline mode with a dedicated screen
- ✅ Responsive and reactive UI
- ✅ Improved UX 'from people - for people'

---

## 🛠️ Tech Stack

- **SwiftUI**
- **MVVM Architecture**
- **SwiftLint** (code style enforcement)
- **Kingfisher** (image loading & caching)
- **NWPathMonitor** (offline detection)

---

## 🧱 Project Structure
# Lifecycle
1. Init App: generating assset and localization >>>
2. Launch Screen >>> 
3. Splash Screen: fetch token that will be saved in UserDefaultf (it 'lives' 40 mins) >>>
4. Main TabBar Screen (Users Screen): opens first tab and shows UserView with auto fetching users model via pagination 6 (due to screen size App loads on last shown another 6) >>>
5. User can scroll new data or go to Sign Up Tab >>>
6. Main TabBar Screen (SignUp Screen): opens view and auto fetches positions >>>
7. User can sign up by filling all textFields, selecting 1 position, uploading photo (all fields are validated in App, camera requires permissions, user can reselect photo) >>>
8. Trying to sign up: if all validation satisfied, ther will be shown SignUpResult screen (user can see if operation successed or get an error validation from API) >>>
9. Success: redirected to users Tab; Failure: user can try again or left this screen.

*while using the App, any total lost of Internet connection will coordinate user to NoConnection Screen, user can try to restore connection and return to the last screen

## 🎥 Screen Recordings of the key features (required by assignment or added by me)

1️⃣ You can see the whole lifecycle of the App (user list, sign up), how works pagination on Users list, loading 'packs' of 6 user models
- on initial load you can see native spinner in the center of the screen;
- avatars might load slowly, so they have placeholders;
- on loading next page you can see custom 'arc' spinner in the bottom of the list;
- using valid information we can create a new user;
- user added to users list;

https://github.com/user-attachments/assets/328b016a-561e-44a3-94e1-37a20264d319

2️⃣ Showing how App works while not having, losing and restoring Internet connection
- lauch app with no Internet will automatically show special screen already on SplashScreen;
- tapping on Try again will trigger checking if connection has been restored, if so - user is coordinated back to the last seen screen;
- I decided to monitor for connection throughout the whole App permanently, not only on lauch;

https://github.com/user-attachments/assets/f016bb2b-3a6d-46bd-9ae1-a3a7e5ffa816

3️⃣ Validation in-App and from API
- showcase of all validations inside the App on sign up;
- sign up button will be enabled when at least 1 filed have at least 1 character, nevertheless, tapping on it will light up all validational errors until managed;
- I used conditions, errors and hints from the assingment's docs and from server information (from Swagger too);
- also created custom validations like:
  a. based on textField design, i managed 3 states; on focusing on one, it shows all 'selected' colors, when typing i switched mini label to normal color or until the validation error kicks in;
  b. hints turns into error messages and validation suggestions based on API requirments;
  c. all keyboards help user to input correct information format;
  d. i handle on the failure screen error messages from the API, except 'token expired' - API message is to debuggy, so i come up with my own (will be addressed in 4 video);
- validation error message from the API;

https://github.com/user-attachments/assets/798034da-a66d-4c4f-b1b2-e2de9cc2b6b0

4️⃣ (Freehand) Sign up with expired token, re-fetching on try again and successfully continue
- i decided to make a use from Token, it's expiration in this App;
- token is saved on initial launch into UserDefaults;
- if you try to sign up, it might be expired;
- i decided not to auto-update token when used (like in real app will be done) just to simulate this test case;
- user can 'try again' in SignUpResult screen - while getting error with token, on pressing the button it will fetch new one and automatically try to sign up again;
- also i though of this due to not wanting testers to terminating and relaunching an App (you still can simulate token expiration error and IF you want, you can manualy fetch new one without app been closed);

https://github.com/user-attachments/assets/124031f1-34e3-497e-8a8d-158b838599d9





