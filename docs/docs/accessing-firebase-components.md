# Accessing Firebase Components

The framework relies on [dart_firebase_admin](https://pub.dev/packages/dart_firebase_admin) package from Invertase to provide easy access to Firebase services. This means you don't need to manually initialize Firebase Admin SDK in your functions.

Available components are: Firestore, Auth and Messaging.

## Firestore

Access Firestore using the global `firestore` variable:

```dart
// Create a document
await firestore.collection('users').doc('user123').set({
  'name': 'John Doe',
  'createdAt': DateTime.now(),
});

// Read a document
final snapshot = await firestore.collection('users').doc('user123').get();
final userData = snapshot.data();

// Query documents
final querySnapshot = await firestore
    .collection('users')
    .where('age', isGreaterThan: 18)
    .get();
```

## Authentication

Access Authentication using the global `auth` variable:

```dart
// Get user by ID
final userRecord = await auth.getUser('user123');

// Create a new user
final userRecord = await auth.createUser(
  email: 'user@example.com',
  password: 'secretPassword',
);

// Update user properties
await auth.updateUser('user123', 
  displayName: 'John Doe',
  emailVerified: true,
);

// Verify ID token
final decodedToken = await auth.verifyIdToken('user-provided-token');
```

## Cloud Messaging

Access Cloud Messaging using the global `messaging` variable:

```dart
// Send message to a specific device
await messaging.send(
  TokenMessage(
    token: "<targeted device's token>",
    notification: Notification(
      title: 'Hello',
      body: 'World',
    ),
  ),
);
```