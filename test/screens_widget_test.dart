import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/screens/bookings_screen.dart';
import 'package:myapp/screens/buildings_screen.dart' as buildings;
import 'package:myapp/screens/home_screen.dart' as home_scr;
import 'package:myapp/screens/group_chat_screen.dart';
import 'package:myapp/screens/login_screen.dart';
import 'package:myapp/screens/profile_screen.dart';
import 'package:myapp/main.dart';

//wrap widget in MaterialApp: so renders
Widget wrap(Widget child) => MaterialApp(home: child);

//ammend bookings_screen building selction test
//add validation tests on booking_screens
 
void main() {
  // ******bookings_screen******
  
  group('BookingsScreen', () {
    testWidgets('displays title: "Bookings"', (tester) async {
      await tester.pumpWidget(wrap(const BookingsScreen()));
      expect(find.text('Bookings'), findsOneWidget);
    });

    testWidgets('top right home icon button displayed', (tester) async {
      await tester.pumpWidget(wrap(const BookingsScreen()));
      expect(find.byIcon(Icons.home), findsOneWidget);
    });

    testWidgets('displays all booking_screen buttons', (tester) async {
      await tester.pumpWidget(wrap(const BookingsScreen()));
      expect(find.text('Start Booking'), findsOneWidget);
      expect(find.text('Building Selection'), findsOneWidget);
      expect(find.text('Room Layout'), findsOneWidget);
      expect(find.text('My Bookings'), findsOneWidget);
    });

    testWidgets('"Start Booking" button navigates to BookingStepperPage',
        (tester) async {
      await tester.pumpWidget(wrap(const BookingsScreen()));
      await tester.tap(find.text('Start Booking'));
      await tester.pumpAndSettle();
      expect(find.text('Book a Room'), findsOneWidget);
    });

    testWidgets('"Building Selection" navigates to BuildingSelectionPage',
        (tester) async {
      await tester.pumpWidget(wrap(const BookingsScreen()));
      await tester.tap(find.text('Building Selection'));
      await tester.pumpAndSettle();
      expect(find.text('Select Building'), findsOneWidget);
    });

    testWidgets('"Room Layout" navigates to RoomLayoutPage',
        (tester) async {
      await tester.pumpWidget(wrap(const BookingsScreen()));
      await tester.tap(find.text('Room Layout'));
      await tester.pumpAndSettle();
      expect(find.text('Room Layout'), findsWidgets);
    });

    testWidgets('"My Bookings" navigates to ViewBookingPage',
        (tester) async {
          await tester.pumpWidget(wrap(const BookingsScreen()));
          await tester.tap(find.text('My Bookings'));
          await tester.pumpAndSettle();
          expect(find.text('Your Bookings'), findsOneWidget);
        });
  });

  // BookingStepper
  group('BookingStepperPage', () {
    testWidgets('displays first stepper "Building"',
        (tester) async {
      await tester.pumpWidget(wrap(const BookingStepperPage()));
      await tester.pump();
      expect(find.text('Building'), findsOneWidget);
    });

    testWidgets('"Continue" fails to proceed displaying SnackBar - no building selected', (tester) async {
      await tester.pumpWidget(wrap(const BookingStepperPage()));
      await tester.pump();
      await tester.tap(find.text('Continue'));
      await tester.pump();
      expect(find.text('Please select a building.'), findsOneWidget);
    });// building validation for continue button 

    testWidgets('"Cancel" pops current step/return to previous screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (ctx) => TextButton(
                onPressed: () => Navigator.push(
                    ctx,
                    MaterialPageRoute(
                        builder: (_) => const BookingStepperPage())),
                child: const Text('Go'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Go'), findsOneWidget);
    });

    testWidgets('displays building DropdownButton', (tester) async {
      await tester.pumpWidget(wrap(const BookingStepperPage()));
      await tester.pump();
      expect(find.byType(DropdownButton<String>), findsOneWidget);
    });
  });

  // BuildingSelection
  group('BuildingSelectionPage', () {
    testWidgets('displays "Select Building"', (tester) async {
      await tester.pumpWidget(wrap(const BuildingSelectionPage()));
      expect(find.text('Select Building'), findsOneWidget);
    });

  });

  // RoomLayout
  group('RoomLayoutPage', () {
    testWidgets('displays title "Room Layout"', (tester) async {
      await tester.pumpWidget(wrap(const RoomLayoutPage()));
      expect(find.text('Room Layout'), findsOneWidget);
    });

    testWidgets('displays seat cells', (tester) async {
      await tester.pumpWidget(wrap(const RoomLayoutPage()));
      expect(find.text('1'), findsOneWidget);
      expect(find.text('20'), findsOneWidget);
    });

    testWidgets('tapping "seat 1" shows SnackBar confirmation message "Seat 1 selected"',
        (tester) async {
      await tester.pumpWidget(wrap(const RoomLayoutPage()));
      await tester.tap(find.text('1'));
      await tester.pump();
      expect(find.text('Seat 1 selected'), findsOneWidget);
    });
  });

  // ViewBooking
  group('ViewBookingPage', () {
    testWidgets('displays title "Your Bookings"', (tester) async {
      await tester.pumpWidget(wrap(const ViewBookingPage()));
      expect(find.text('Your Bookings'), findsOneWidget);
    });

    testWidgets('displays "No bookings yet" when bookings list empty',(tester) async {
      await tester.pumpWidget(wrap(const ViewBookingPage()));
      await tester.pumpAndSettle();
      expect(find.text('No bookings yet.'), findsOneWidget);
    });
  });

  // ******buildings_screen******
  // temporary test
  group('BuildingsScreen (placeholder)', () {

    testWidgets('displays title "buiding selection"', (tester) async {
      await tester.pumpWidget(MaterialApp(home: buildings.GroupChatScreen()));
      expect(find.text('buiding selection'), findsOneWidget);
    });

  });

  // ***group_chat_screen***
  // need to ammend if pages added
  group('GroupSelectionPage', () {
    testWidgets('displays title "Select Group"', (tester) async {
      await tester.pumpWidget(wrap(const GroupSelectionPage()));
      expect(find.text('Select Group'), findsOneWidget);
    });

    testWidgets('displays group names', (tester) async {
      await tester.pumpWidget(wrap(const GroupSelectionPage()));
      expect(find.text('Study Group A'), findsOneWidget);
      expect(find.text('Project Team'), findsOneWidget);
      expect(find.text('Friends'), findsOneWidget);
    });

    testWidgets('tapping a group navigates to GroupOptionsPage', (tester) async {
      await tester.pumpWidget(wrap(const GroupSelectionPage()));
      await tester.tap(find.text('Study Group A'));
      await tester.pumpAndSettle();
      expect(find.text('Study Group A'), findsOneWidget);
      expect(find.text('Group Chat'), findsOneWidget);
    });
  });

  group('GroupOptionsPage', () {
    testWidgets('displays "Group Chat", "Edit Group", "Group Details" options',
        (tester) async {
      await tester.pumpWidget(
          wrap(const GroupOptionsPage(groupName: 'Test Group')));
      expect(find.text('Group Chat'), findsOneWidget);
      expect(find.text('Edit Group'), findsOneWidget);
      expect(find.text('Group Details'), findsOneWidget);
    });

    testWidgets('"Group Chat" navigates to GroupChatPage',
        (tester) async {
      await tester.pumpWidget(
          wrap(const GroupOptionsPage(groupName: 'Test Group')));
      await tester.tap(find.text('Group Chat'));
      await tester.pumpAndSettle();
      expect(find.text('Test Group'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('"Edit Group" displays "coming-soon" SnackBar', (tester) async {
      await tester.pumpWidget(
          wrap(const GroupOptionsPage(groupName: 'Test Group')));
      await tester.tap(find.text('Edit Group'));
      await tester.pump();
      expect(find.text('Edit Group (coming soon)'), findsOneWidget);
    });

    testWidgets('"Group Details" displays "coming-soon" SnackBar',
        (tester) async {
      await tester.pumpWidget(
          wrap(const GroupOptionsPage(groupName: 'Test Group')));
      await tester.tap(find.text('Group Details'));
      await tester.pump();
      expect(find.text('Group Details (coming soon)'), findsOneWidget);
    });
  });

  group('GroupChatPage', () {

    testWidgets('displays message input field and send button', (tester) async {
      await tester.pumpWidget(wrap(const GroupChatPage(groupName: 'Testers')));
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.send), findsOneWidget);
    });

    testWidgets('typing and sending a message displays it',
        (tester) async {
      await tester.pumpWidget(wrap(const GroupChatPage(groupName: 'Testers')));
      await tester.enterText(find.byType(TextField), 'Hello team!');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();
      expect(find.text('Hello team!'), findsOneWidget);
    });

    testWidgets('sending an empty message does not display', (tester) async {
      await tester.pumpWidget(wrap(const GroupChatPage(groupName: 'Testers')));
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();
      expect(find.text('No messages yet'), findsOneWidget);
    });

    testWidgets('sending whitespace-only message does not display',
        (tester) async {
      await tester.pumpWidget(wrap(const GroupChatPage(groupName: 'Testers')));
      await tester.enterText(find.byType(TextField), '   ');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();
      expect(find.text('No messages yet'), findsOneWidget);
    });

    testWidgets('TextField clears after message is sent', (tester) async {
      await tester.pumpWidget(wrap(const GroupChatPage(groupName: 'Testers')));
      await tester.enterText(find.byType(TextField), 'Cleared?');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();
      // message added to list
      expect(find.text('Cleared?'), findsOneWidget);
      // input feild empty
      final editableText = tester.widget<EditableText>(
        find.descendant(
          of: find.byType(TextField),
          matching: find.byType(EditableText),
        ),
      );
      expect(editableText.controller.text, '');
    });

    testWidgets('multiple messages sent are visible', (tester) async {
      await tester.pumpWidget(wrap(const GroupChatPage(groupName: 'Testers')));
      for (final msg in ['First', 'Second', 'Third']) {
        await tester.enterText(find.byType(TextField), msg);
        await tester.tap(find.byIcon(Icons.send));
        await tester.pump();
      }
      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);
      expect(find.text('Third'), findsOneWidget);
    });
  });

  // ***home_screen***
  // temp test
  group('HomeScreen (placeholder)', () {

    testWidgets('displays title "the home sceen" (intentional typo)',
        (tester) async {
      await tester.pumpWidget(MaterialApp(home: home_scr.GroupChatScreen()));
      expect(find.text('the home sceen'), findsOneWidget);
    });

  });

  // ***login_screen***
  group('LoginScreen', () {
    testWidgets('displays title "Login"', (tester) async {
      await tester.pumpWidget(wrap(const LoginScreen()));
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('displays Email text field', (tester) async {
      await tester.pumpWidget(wrap(const LoginScreen()));
      expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
    });

    testWidgets('displays Password text field', (tester) async {
      await tester.pumpWidget(wrap(const LoginScreen()));
      expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
    });

    testWidgets('Password field hides chracters (obscureText is true)', (tester) async {
      await tester.pumpWidget(wrap(const LoginScreen()));
      final passwordField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Password'),
      );
      expect(passwordField.obscureText, isTrue);
    });

    testWidgets('displays "Log In" button', (tester) async {
      await tester.pumpWidget(wrap(const LoginScreen()));
      expect(find.text('Log In'), findsOneWidget);
    });

    testWidgets('"Log In" pops screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (ctx) => TextButton(
                onPressed: () => Navigator.push(
                    ctx,
                    MaterialPageRoute(builder: (_) => const LoginScreen())),
                child: const Text('Open Login'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open Login'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();
      expect(find.text('Open Login'), findsOneWidget);
    });

    testWidgets('email field accepts typed text', (tester) async {
      await tester.pumpWidget(wrap(const LoginScreen()));
      await tester.enterText(
          find.widgetWithText(TextField, 'Email'), 'test@myport.ac.uk');
      expect(find.text('test@myport.ac.uk'), findsOneWidget);
    });
  });

  // ******profile_screen******
  group('ProfileScreen', () {
    testWidgets('displays title "Profile"', (tester) async {
      await tester.pumpWidget(wrap(const ProfileScreen()));
      expect(find.text('Profile'), findsOneWidget);
    });

  });

  // ******main******
  group('HomeDashboard', () {
    testWidgets('displays dashboard cards', (tester) async {
      await tester.pumpWidget(wrap(const HomeDashboard()));
      expect(find.text('Booking'), findsOneWidget);
      expect(find.text('Notes'), findsOneWidget);
      expect(find.text('Groups'), findsOneWidget);
      expect(find.text('Calendar'), findsOneWidget);
      expect(find.text('Files'), findsOneWidget);
      expect(find.text('Upload'), findsOneWidget);
    });

    testWidgets('"Booking" navigates to BookingsScreen',
        (tester) async {
      await tester.pumpWidget(wrap(const HomeDashboard()));
      await tester.tap(find.text('Booking'));
      await tester.pumpAndSettle();
      expect(find.text('Bookings'), findsOneWidget);
    });

    testWidgets('"Groups" navigates to GroupSelectionPage',
        (tester) async {
      await tester.pumpWidget(wrap(const HomeDashboard()));
      await tester.tap(find.text('Groups'));
      await tester.pumpAndSettle();
      expect(find.text('Select Group'), findsOneWidget);
    });
  });

  group('MyHomePage (bottom nav)', () {
    testWidgets('displays "Home", "Chat", "Profile" on bottom navigation bar',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MyHomePage()));
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Chat'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

  
    testWidgets('starts up on Home tab showing HomeDashboard', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MyHomePage()));
      expect(find.text('Booking'), findsOneWidget);
    });

    testWidgets('"Chat" displays GroupSelectionPage', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MyHomePage()));
      await tester.tap(find.text('Chat'));
      await tester.pumpAndSettle();
      expect(find.text('Select Group'), findsOneWidget);
    });

    testWidgets('"Profile" displays ProfileScreen', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MyHomePage()));
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(find.text('User Profile Info Here'), findsOneWidget);
    });

    testWidgets('login icon navigates to LoginScreen', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MyHomePage()));
      await tester.tap(find.byIcon(Icons.login));
      await tester.pumpAndSettle();
      expect(find.text('Log In'), findsOneWidget);
    });
  });
}
