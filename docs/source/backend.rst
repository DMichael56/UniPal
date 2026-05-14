=====================
Backend Documentation
=====================

.. note::
   UniPal currently operates with a simulated local backend. Instead of a traditional remote server, the application relies on asynchronous Dart service classes that interact with local JSON assets and in-memory lists to simulate network latency and data persistence.

Architecture Overview
=====================

The data layer is tightly coupled within the Flutter project and follows a standard layered architecture:

1. **Models:** Strongly typed Dart classes representing domain entities.
2. **Services:** Asynchronous classes handling business logic, data fetching, and mock API interactions.
3. **Local Data Store:** JSON files located in the assets/data/ directory serving as the database.

.. warning::
   The application is currently transitioning to Firebase (indicated by firebase_auth and firebase_core in pubspec.yaml). The documentation below reflects the current local mock implementation.

Data Models
===========

The domain entities are located in the lib/models/ directory. They handle the conversion between raw JSON data and typed Dart objects using fromJson() and toJson() factory methods.

.. list-table:: Domain Models
   :widths: 20 80
   :header-rows: 1

   * - Model
     - Description
   * - User
     - Represents a student profile containing basic identifiers (id, name, email).
   * - Building
     - Represents a university building, containing location data (address, W3W) and boolean flags for amenities (Cafe, Elevator, Helpdesk).
   * - Room
     - Represents a specific room tied to a buildingId, containing floor level, capacity, and equipment flags (projector, computers).
   * - Booking
     - Represents a reservation made by a user. Includes time bounds, associated group/item IDs, and a list of Attendee objects.
   * - Item
     - Represents resources or study materials uploaded by users.

Service Layer (API Simulation)
==============================

The services located in lib/services/ act as the controllers for our data. They utilise the rootBundle to load JSON files and the Future.delayed method to simulate network latency.

BookingService
--------------

Manages all room and study session bookings. 

.. warning::
   BookingService currently uses an **in-memory list** (List<Booking> _bookings) to store data. Any bookings created, updated, or deleted during a session will be lost when the application is completely restarted.

* getBookings() -> Future<List<Booking>>
    Retrieves all current bookings in the system. Simulates a 300ms network delay.
* addBooking(Booking booking) -> Future<void>``
    Appends a new booking to the in-memory list. Generates unique IDs using the uuid package.
* updateBooking(Booking updatedBooking) -> Future<void>
    Finds a booking by its ID and replaces it with the updated instance.
* removeBooking(String bookingId) -> Future<void>``
    Deletes a specific booking from the list using its unique identifier.
* clearAllBookings() -> Future<void>
    Wipes the entire in-memory booking list.

BuildingService
---------------

Handles the retrieval of university infrastructure data.

.. code-block:: dart

   Future<List<Building>> getBuildings() async { ... }
   Future<List<Room>> getRooms(String buildingId) async { ... }

* getBuildings(): Parses assets/data/building.json and returns a complete list of available university buildings.
* getRooms(String buildingId): Parses the same JSON file but filters the returned Room objects based on the provided buildingId to enforce relational integrity.

UserService & ItemService
-------------------------

These services handle read-only data fetching for users and resources.

* UserService.getUser(): Fetches the primary mocked user from users.json. Currently hardcoded to return the first user in the array (David Heil).
* ItemService.getItems(): Decodes and returns all items/resources from items.json.

Database Schema (JSON Store)
============================

Because the application lacks a relational database, data is stored structurally in JSON format. 

Example: Building and Room Relationship
---------------------------------------

The building.json acts as a relational database containing both the parent (Buildings) and child (Rooms) records.

.. code-block:: json

   {
       "buildings": [
           {
               "id": "bld_1",
               "name": "University Library",
               "has_cafe": true
           }
       ],
       "rooms": [
           {
               "id": "r0.01_bld_1",
               "building_id": "bld_1",
               "room_number": "UL0.01",
               "capacity": 30
           }
       ]
   }

Security & Authentication
=========================

Currently, the LoginScreen features a mocked UI without strict backend validation. Moving forward, the backend documentation will be updated to reflect the implementation of firebase_auth for secure token-based user sessions and Firestore for persistent database rules.