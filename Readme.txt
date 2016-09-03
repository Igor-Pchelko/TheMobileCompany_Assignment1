Connect to the foursquare API and retrieve the 10 nearest restaurants to your current location, displaying them in a map and in a list
-------------------------

Assignment implementation has two modes:

- Current: The application automatically updates the list of restaurants according to the current location. To prevent excessive requests to Foursquare service, the application refreshes the list of nearest restaurants only if location significantly changed.

- Manual: In this mode, the application doesn't update visible map region automatically and allows a user to navigate the map. Since the position of the map is changed it refreshes the list of nearest restaurants.
