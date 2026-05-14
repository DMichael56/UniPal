======================
Frontend Documentation
======================

The UniPal frontend is a mobile-first application built using the Flutter SDK. It adheres to Material Design 3 principles to provide a clean, accessible, and intuitive user interface. 

This document outlines all implemented components, screens, and features within the presentation layer.

.. contents:: Table of Contents
   :local:
   :depth: 2

1. Application Root & Navigation
================================

Persistent Bottom Navigation (MyHomePage)
---------------------------------------------
The root scaffold is managed by MyHomePage, a StatefulWidget that maintains the state of the BottomNavigationBar. 

.. list-table:: Navigation Tabs
   :widths: 20 20 60
   :header-rows: 1

   * - Index
     - Tab Name
     - Target Widget
   * - 0
     - Home
     - HomeDashboard()
   * - 1
     - Chat
     - GroupSelectionPage()
   * - 2
     - Profile
     - ProfileScreen()

Home Dashboard
--------------
The HomeDashboard is a GridView containing cards for the core modules. It utilizes a helper method _card() to dynamically build GestureDetector components that route to individual feature pages like Bookings, Notes, Groups, and Calendar.

2. Authentication
=================

Login Screen (LoginScreen)
------------------------------
A simple authentication form accessible via the login icon in the main AppBar.

* **Email Field:** Standard TextField for the university email.
* **Password Field:** A TextField with obscureText: true enabled to safely mask password characters.

3. Room Booking System
======================

The room booking system is the primary feature of the application, encompassing building selection, room layouts, and a multi-step reservation wizard.

Booking Menu (BookingsScreen)
---------------------------------
Provides a ListView menu routing to specific booking features: Start Booking, Building Selection, Room Layout, and My Bookings.

Booking Wizard (BookingStepperPage)
---------------------------------------
A stateful 4-step wizard utilizing the Flutter Stepper widget.

1. **Building Step:** Uses a FutureBuilder mapped to BuildingService to populate a dropdown.
2. **Room Step:** Dynamically filters rooms based on the building selected in Step 1.
3. **Details Step:** Captures the booking title, date (via showDatePicker), time (via dropdown), and a custom attendee counter.
4. **Confirm Step:** Displays a summary. Upon confirmation, a unique UUID is generated, the booking is dispatched to the service, and a success SnackBar is shown.

.. warning::
   The Stepper enforces strict validation. Users are prevented from progressing past Step 1 or Step 2 if a building or room is not explicitly selected. A SnackBar handles the error messaging.

Building Directory (BuildingSelectionPage)
----------------------------------------------
Displays a list of all available university buildings. It dynamically generates subtitle text for each building's card based on boolean amenity flags:

.. code-block:: dart

   final facilities = [
     if (building.hasCafe) 'Cafe',
     if (building.hasElevator) 'Elevator',
     if (building.hasHelpdesk) 'Helpdesk',
   ];

Managing Bookings (ViewBookingPage & EditBookingPage)
-------------------------------------------------------------
* **ViewBookings:** A FutureBuilder list showing active bookings. Users can tap the delete icon to remove a booking, which triggers a _refreshBookings() state update.
* **EditBookings:** Tapping a booking opens the EditBookingPage``, allowing users to modify the title, time, and attendees, seamlessly updating the existing record.

4. Group Collaboration
======================

The group chat implementation allows students to coordinate study sessions effectively.

Group Directory (GroupSelectionPage)
----------------------------------------
A ListView.builder rendering available groups (e.g., "Study Group A", "Project Team").

Group Options (GroupOptionsPage)
------------------------------------
A sub-menu for a specific group, offering options to enter the group chat, edit the group, or view details. (Edit and Details currently trigger "coming soon" SnackBar messages).

Chat Interface (GroupChatPage)
----------------------------------
The live messaging screen. 

* **Message List:** An Expanded, ListView.builder that renders messages stored in the local state array.
* **Input Area:** A styled Container at the bottom of the screen containing a TextField and a send IconButton.

.. note::
   The sendMessage() method includes whitespace trimming validation (controller.text.trim().isEmpty) to prevent users from sending blank messages.

5. User Profile
===============

Profile View (ProfileScreen)
--------------------------------
Currently implemented as a structural placeholder, this Scaffold contains a centered text widget intended to house detailed user profile data, avatars, and application settings in future iterations.