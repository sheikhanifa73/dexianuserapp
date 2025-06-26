dexianUserApp README

Overview

The dexianUserApp is a mobile application built to manage user data using the GoRest API (https://gorest.co.in/public/v2/users). It allows users to create, read, update, and delete user profiles with a clean interface.

How the App Works


The app initializes with a user interface to input or view user details (name, email, gender, status).


It validates user input (e.g., non-empty name, valid email) before sending requests to the API.


API calls (GET, POST, PUT, DELETE) are handled via a NetworkManager to fetch, create, update, or delete users.

Successful operations update the UI, while failures trigger error messages and refresh the user list.

The app uses a repository pattern and view model to manage data flow and state changes.

Installation

Clone the repository: git clone.

Open the project in Xcode.

Install dependencies if any (currently none beyond standard Swift libraries).

Update APIConstants.swift with the correct baseURL and bearerToken.

Build and run the app on a simulator or device.
Important Notes

Ensure the API token (bearerToken) in APIConstants.swift is valid and has access to the GoRest API.https://gorest.co.in


Network connectivity is checked before API calls using NWPathMonitor.


Errors are logged with prefixes  for easy debugging.


The app is designed for iOS and uses Swift with a modular architecture.
