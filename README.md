# Timely

---

## Resources 

- [Riverpod Architecture](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/)

## Folder Structure and App Architecture

It is important to understand the folder hierarchy of the app. The structure is inspired majorly from the Riverpod Architecture by Andrea. 

The database is a set of JSON files. Each tab has its own database file.

Each folder has 4 subfolders: 

- Models: These are data classes. They are unique for each unique feature. There primary purpose is to hold data and they have JSON serialization methods, toJson and fromJson. 

- Repositories: Their primary function is to send deal with the external world (REST API, local database, etc.). They save and load model classes from the database. 

- Controllers: Their purpose is to manage the state of the widgets that are displayed on screen. They hold the model and have getters and setters. Widgets usually listen to the controllers and update themselves whenever a change is notified. 

- Views: All the 'tangible' widgets that the user interacts with on the screen. They can include anything from buttons, text widgets, and text fields to list views and grids.

In essence, here's how the things flow with each other: 

When, for example, the icon of output screen of tab 1 (*output screen* refers to the screen that is responsible for **displaying** data only) is clicked, the controller calls a method from the repository that reads the database, fetches the data and returns a list of models. While this asynchronous operation is being performed, the screen shows a loading indicator. Once the models are accessible, the output screen widget rebuilds, this time, with the models shown in a list view.

If a user creates a new entry, the input controller notifies the output controller that something has changed (this is done by invalidating the controller). In response, the output controller re-runs the fetching function, the listeners rebuild, and new data is displayed.

You may also be surprised to see a *common* folder. Simply put, it contains all those components that are being used by more than 1 feature/tab throughout the app. For example, the scheduling feature has different operations and widgets that are being used by tab 2, 6, 7, and 12. Therefore, it is sensible to separate scheduling components rather than create copies of the same thing for each tab.