import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/screens/bookings_screen.dart';
import 'package:myapp/screens/buildings_screen.dart' as buildings;
import 'package:myapp/screens/home_screen.dart' as home_scr;
import 'package:myapp/screens/group_chat_screen.dart';
import 'package:myapp/screens/login_screen.dart';
import 'package:myapp/screens/profile_screen.dart';
import 'package:myapp/main.dart';
import 'package:myapp/models/booking_model.dart'; 
import 'package:myapp/services/booking_service.dart';

//wrap widget in MaterialApp: so renders
Widget wrap(Widget child) => MaterialApp(home: child);
 
void main() {
  // ******bookings_screen******
  group('BookingsScreen', () {

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
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {};

      await tester.pumpWidget(wrap(const BookingsScreen()));
      await tester.tap(find.text('Start Booking'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Book a Room'), findsOneWidget);
      FlutterError.onError = originalOnError;
    });

    testWidgets('"Building Selection" navigates to BuildingSelectionPage',
        (tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {};

      await tester.pumpWidget(wrap(const BookingsScreen()));
      await tester.tap(find.text('Building Selection'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Select Building'), findsOneWidget);

      FlutterError.onError = originalOnError;
    });

    testWidgets('"Room Layout" navigates to RoomLayoutPage',
        (tester) async {
      await tester.pumpWidget(wrap(const BookingsScreen()));
      await tester.tap(find.text('Room Layout'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Room Layout'), findsWidgets);
    });

    testWidgets('"My Bookings" navigates to ViewBookingPage',
        (tester) async {
          final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {};
        await tester.pumpWidget(wrap(const BookingsScreen()));
        await tester.tap(find.text('My Bookings'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        expect(find.text('Your Bookings'), findsOneWidget);
        FlutterError.onError = originalOnError;
        });
  });

  //******bookingStepper******
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
      await tester.tap(find.text('Continue').first);
      await tester.pump();
      expect(find.text('Please select a building.'), findsOneWidget);
    });//test plan: building validation for continue button 

    testWidgets('displays building DropdownButton', (tester) async {
      await tester.pumpWidget(wrap(const BookingStepperPage()));
      await tester.pump();
      expect(find.byType(DropdownButton<String>).first, findsOneWidget);
    });
  });

  //BuildingSelection
  group('BuildingSelectionPage', () {
    testWidgets('displays "Select Building"', (tester) async {
      await tester.pumpWidget(wrap(const BuildingSelectionPage()));
      expect(find.text('Select Building'), findsOneWidget);
    });

  });

  // RoomLayout
  group('RoomLayoutPage', () {

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

    testWidgets('displays "No bookings yet" when bookings list empty',(tester) async {
      await tester.pumpWidget(wrap(const ViewBookingPage()));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('No bookings yet.'), findsOneWidget);
    });

    //test plan: delete button clears chosen booking
    testWidgets('delete button removes only the chosen booking', (tester) async {
      final service = BookingService();
      await tester.runAsync(() async{ 
        
        await service.clearAllBookings();
        
        await service.addBooking(Booking(
          id: 'test-001', itemId: 'item001', groupId: 'g001', bookedBy: 'u001',
          title: 'Test Booking One', date: '2025-06-01',
          startTime: '10:00', endTime: '11:00', status: 'confirmed',
          attendees: [], notificationSent: false, createdAt: '2025-05-01T09:00:00Z',
        ));
        await service.addBooking(Booking(
          id: 'test-002', itemId: 'item002', groupId: 'g001', bookedBy: 'u001',
          title: 'Test Booking Two', date: '2025-06-02',
          startTime: '12:00', endTime: '13:00', status: 'confirmed',
          attendees: [], notificationSent: false, createdAt: '2025-05-01T10:00:00Z',
        ));
      });
      await tester.pumpWidget(wrap(const ViewBookingPage()));
      await tester.pump(const Duration(milliseconds: 300));

      //both bookings visible
      expect(find.text('Test Booking One'), findsOneWidget);
      expect(find.text('Test Booking Two'), findsOneWidget);

      //delete first booking
      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 300)); 

      //first booking cleared, second still visible
      expect(find.text('Test Booking One'), findsNothing);
      expect(find.text('Test Booking Two'), findsOneWidget);

      await tester.runAsync(() => service.clearAllBookings());
    });

    //test plan: delete button visibility
    testWidgets('delete button visible if booking exists, not visible when no bookings',
        (tester) async {
      final service = BookingService();

      // add booking
      await tester.runAsync(() async {
        await service.clearAllBookings();
        await service.addBooking(Booking(
          id: 'test-001', itemId: 'item001', groupId: 'g001', bookedBy: 'u001',
          title: 'Test Booking', date: '2025-06-01',
          startTime: '10:00', endTime: '11:00', status: 'confirmed',
          attendees: [], notificationSent: false, createdAt: '2025-05-01T09:00:00Z',
        ));
      });

      await tester.pumpWidget(wrap(const ViewBookingPage()));
      await tester.pump(const Duration(milliseconds: 300)); 

      //delete button visible when booking exists
      expect(find.byIcon(Icons.delete), findsOneWidget);

      //clear bookings
      await tester.runAsync(() => service.clearAllBookings());

      await tester.pumpWidget(wrap(const ViewBookingPage()));
      await tester.pump(const Duration(milliseconds: 300));

      //delete button not visible when no bookings exist
      expect(find.byIcon(Icons.delete), findsNothing);
      expect(find.text('No bookings yet.'), findsOneWidget);
    });

    //test plan: valid bookings visible
    testWidgets('created booking is displayed in ViewBookingPage', (tester) async {
      final service = BookingService();

      await tester.runAsync(() => service.clearAllBookings());

      //create booking
      await tester.runAsync(() => service.addBooking(Booking(
        id: 'created-001',
        itemId: 'r001',
        groupId: 'b001',
        bookedBy: 'user@example.com',
        title: 'Study Session',
        date: '2026-06-01',
        startTime: '10:00',
        endTime: '11:00',
        status: 'confirmed',
        attendees: [],
        notificationSent: false,
        createdAt: '2026-05-01T09:00:00Z',
      )));

      await tester.pumpWidget(wrap(const ViewBookingPage()));
      await tester.pump(const Duration(milliseconds: 300));

      //booking title is visible
      expect(find.text('Study Session'), findsOneWidget);

      await tester.runAsync(() => service.clearAllBookings());
    });
  });


  // ******edit_booking_page******
  group('EditBookingPage', () {
    final testBooking = Booking(
      id: 'edit-001', itemId: 'r001', groupId: 'b001', bookedBy: 'u001',
      title: 'Original Title', date: '2026-06-01',
      startTime: '10:00', endTime: '11:00', status: 'confirmed',
      attendees: [Attendee(userId: 'u001', rsvp: 'accepted')],
      notificationSent: false, createdAt: '2025-05-01T09:00:00Z',
    );

    //test plan: title/time/date can be edited
    testWidgets('booking title can be edited', (tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {};

      await tester.pumpWidget(wrap(EditBookingPage(booking: testBooking)));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Original Title'), findsOneWidget);

      //title edited
      await tester.enterText(find.byType(TextField), 'New Title');
      await tester.pump();

      expect(find.text('New Title'), findsOneWidget);

      FlutterError.onError = originalOnError;
    });

    testWidgets('booking time can be edited', (tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {};

      await tester.pumpWidget(wrap(EditBookingPage(booking: testBooking)));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('10:00'), findsOneWidget);

      await tester.tap(find.byType(DropdownButton<String>).first);
      await tester.pump();
      await tester.tap(find.text('11:00').last);
      await tester.pump();

      expect(find.text('11:00'), findsOneWidget);

      FlutterError.onError = originalOnError;
    });

    testWidgets('booking date can be edited', (tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {};

      await tester.pumpWidget(wrap(EditBookingPage(booking: testBooking)));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('2026-06-01'), findsOneWidget);

      await tester.tap(find.text('2026-06-01'));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('15'));
      await tester.pump();
      await tester.tap(find.text('OK'));
      await tester.pump(const Duration(milliseconds: 300));

      //edited date
      expect(find.text('2026-06-15'), findsOneWidget);

      FlutterError.onError = originalOnError;
    });

  });

  // ***group_chat_screen***
  
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

  // ***login_screen***
  group('LoginScreen', () {

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

    testWidgets('"Chat" displays GroupSelectionPage', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MyHomePage()));
      await tester.tap(find.text('Chat'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Select Group'), findsOneWidget);
    });

    testWidgets('"Profile" displays ProfileScreen', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MyHomePage()));
      await tester.tap(find.text('Profile'));
      await tester.pump(const Duration(milliseconds: 300));
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
