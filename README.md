
---

# NewsFeed App

NewsFeed is a mobile application built with Google Flutter, designed to display a list of posts with functionalities for adding new posts and liking posts. The app uses Firebase Firestore for authentication and data storage, allowing users to create and manage posts and like/unlike content.

## Features

### 1. Sign In
- **User Authentication:** Users can sign in with their email or create an account by providing an email, password, and username.

### 2. View Newsfeed
- **Display a List of Posts:** The newsfeed displays all posts in chronological order.
- **User’s Name:** Displays the name of the user who posted.
- **Bio:** Shows a brief bio of the user.
- **Post Content:** Includes the title and category of the post.
- **Timestamp:** Shows when the post was created.
- **Like Count:** Displays the number of likes each post has received.
- **Like Button:** Allows users to like or unlike a post.

### 3. Read Article
- **Post Content:** Includes the title, text content, and category of the post.
- **Read Post:** Allows users to read a post by clicking on an article.
- **Like Count:** Displays the number of likes each post has received.
- **Like Button:** Allows users to like or unlike a post.

### 4. Add New Post
- **Create Post:** Users can create a new post by adding a title, text content, and selecting a category.
- **Post Visibility:** Newly created posts appear at the top of the newsfeed.

### 5. Like Post
- **Like/Unlike Posts:** Users can like or unlike posts by tapping the like button.
- **Update Like Count:** The like count updates in real time as users interact with the posts.

### 6. Persist Data
- **Data Storage:** Uses Firebase Firestore to store posts and like counts.
- **Data Persistence:** Data remains available even after the app is closed and reopened.

### 7. Manage Profile
- **Change Username:** Users can edit their username.
- **Add Bio:** Users can add a bio that will appear on any of their posts.
- **View Their Posts:** A page displays a list of all their posts.

## Setup and Installation

To set up and run the NewsFeed app on your local machine, follow these steps:

### Prerequisites
- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Firebase Account: [Create a Firebase project](https://firebase.google.com/)

### Step 1: Clone the Repository
Clone the repository to your local machine using:
```bash
git clone https://github.com/your-username/newsfeed-app.git
```

### Step 2: Set Up Firebase
1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Create a new project or use an existing one.
3. Add an Android/iOS app to your project.
4. Download the `google-services.json` (for Android) or `GoogleService-Info.plist` (for iOS) file and place it in the appropriate directory in your Flutter project (`android/app` for Android and `ios/Runner` for iOS).
5. Enable Firebase Authentication and Firestore in the Firebase Console.

### Step 3: Install Dependencies
Navigate to the project directory and install the necessary dependencies:
```bash
flutter pub get
```

### Step 4: Run the App
Run the app on your emulator or connected device:
```bash
flutter run
```

## Planned Features
- Ability to sort by top-rated posts and categories.
- Ability to comment on posts.
- Ability to add images to posts.
- Google authentication.
- Finishing styling

## Usage
- **Newsfeed:** View and interact with posts.
- **Add Post:** Use the floating action button to create a new post.
- **Like/Unlike Posts:** Tap the like button on any post to like or unlike it.

## License
This project is licensed under the MIT License

---
