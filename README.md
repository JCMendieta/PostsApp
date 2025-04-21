# PostsApp

## Description

PostsApp is an iOS application designed to display a list of posts. When a user taps on a post, they are navigated to a detail screen showing:

- Post title and description
- Post author information
- List of comments for the post

### Core Functionalities

- Favorite/Unfavorite posts: Favorite posts are displayed at the top with a star indicator.
- Delete posts: Users can delete individual posts.
- Remove all non-favorite posts: A mechanism to clear all posts except the favorites.
- Load posts from an API: Fetch all posts from an external API.
- Unit tests: Include testing for key functionalities using XCTest.

### Future Improvements

- Add a reactive solution for better UI updates and data handling.
- Implement a local database to store posts after loading them.

## Approach

The app will follow the **MVVM architecture** using **UIKit**. It will also incorporate various design patterns and best practices to ensure clean, maintainable code.

### Good Practices

- **Protocol-Oriented Programming**: Use protocols where applicable.
- **Dependency Injection**: Initialize classes using dependency injection.
- **Use Cases**: Separate business logic into dedicated use case classes.

### Design Patterns

- **Coordinator**: Centralized navigation management using the Coordinator pattern.
- **Repository**: Separate the networking layer to act as a bridge between the app and API services.
- **Facade**: Combine multiple networking responsibilities into one interface, hiding implementation details.
- **Strategy**: Represent swappable functionalities as interchangeable classes.
- **Adapter**: Convert DTOs into domain models using adapters to manage transformation logic.

## Testing

- **XCTest** will be used to write and manage unit tests.
