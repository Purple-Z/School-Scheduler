// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Access Denied!`
  String get access_denied {
    return Intl.message(
      'Access Denied!',
      name: 'access_denied',
      desc: '',
      args: [],
    );
  }

  /// `Error Occurred`
  String get error_occurred {
    return Intl.message(
      'Error Occurred',
      name: 'error_occurred',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Today`
  String get today {
    return Intl.message('Today', name: 'today', desc: '', args: []);
  }

  /// `Yesterday`
  String get yesterday {
    return Intl.message('Yesterday', name: 'yesterday', desc: '', args: []);
  }

  /// `Tomorrow`
  String get tomorrow {
    return Intl.message('Tomorrow', name: 'tomorrow', desc: '', args: []);
  }

  /// `Your Account`
  String get your_account {
    return Intl.message(
      'Your Account',
      name: 'your_account',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Surname`
  String get surname {
    return Intl.message('Surname', name: 'surname', desc: '', args: []);
  }

  /// `Update Profile`
  String get update_profile {
    return Intl.message(
      'Update Profile',
      name: 'update_profile',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get change_password {
    return Intl.message(
      'Change Password',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Check Permission`
  String get check_permission {
    return Intl.message(
      'Check Permission',
      name: 'check_permission',
      desc: '',
      args: [],
    );
  }

  /// `Profile Updated`
  String get profile_updated {
    return Intl.message(
      'Profile Updated',
      name: 'profile_updated',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get current_password {
    return Intl.message(
      'Current Password',
      name: 'current_password',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get new_password {
    return Intl.message(
      'New Password',
      name: 'new_password',
      desc: '',
      args: [],
    );
  }

  /// `Password Changed`
  String get password_changed {
    return Intl.message(
      'Password Changed',
      name: 'password_changed',
      desc: '',
      args: [],
    );
  }

  /// `Permission`
  String get permission {
    return Intl.message('Permission', name: 'permission', desc: '', args: []);
  }

  /// `Reload`
  String get reload {
    return Intl.message('Reload', name: 'reload', desc: '', args: []);
  }

  /// `Pending`
  String get pending {
    return Intl.message('Pending', name: 'pending', desc: '', args: []);
  }

  /// `Accepted`
  String get accepted {
    return Intl.message('Accepted', name: 'accepted', desc: '', args: []);
  }

  /// `Refused`
  String get refused {
    return Intl.message('Refused', name: 'refused', desc: '', args: []);
  }

  /// `Cancelled`
  String get cancelled {
    return Intl.message('Cancelled', name: 'cancelled', desc: '', args: []);
  }

  /// `Expired`
  String get expired {
    return Intl.message('Expired', name: 'expired', desc: '', args: []);
  }

  /// `View`
  String get view {
    return Intl.message('View', name: 'view', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Cancel?`
  String get ask_to_cancel {
    return Intl.message('Cancel?', name: 'ask_to_cancel', desc: '', args: []);
  }

  /// `From`
  String get from_maiusc {
    return Intl.message('From', name: 'from_maiusc', desc: '', args: []);
  }

  /// `To`
  String get to_maiusc {
    return Intl.message('To', name: 'to_maiusc', desc: '', args: []);
  }

  /// `Booking Cancelled`
  String get booking_cancelled {
    return Intl.message(
      'Booking Cancelled',
      name: 'booking_cancelled',
      desc: '',
      args: [],
    );
  }

  /// `Filters`
  String get filters {
    return Intl.message('Filters', name: 'filters', desc: '', args: []);
  }

  /// `Time Range`
  String get time_range {
    return Intl.message('Time Range', name: 'time_range', desc: '', args: []);
  }

  /// `Quantity Range`
  String get quantity_range {
    return Intl.message(
      'Quantity Range',
      name: 'quantity_range',
      desc: '',
      args: [],
    );
  }

  /// `People`
  String get people {
    return Intl.message('People', name: 'people', desc: '', args: []);
  }

  /// `Resources`
  String get resources {
    return Intl.message('Resources', name: 'resources', desc: '', args: []);
  }

  /// `Users`
  String get users {
    return Intl.message('Users', name: 'users', desc: '', args: []);
  }

  /// `Roles`
  String get roles {
    return Intl.message('Roles', name: 'roles', desc: '', args: []);
  }

  /// `Bookings`
  String get bookings {
    return Intl.message('Bookings', name: 'bookings', desc: '', args: []);
  }

  /// `Types`
  String get types {
    return Intl.message('Types', name: 'types', desc: '', args: []);
  }

  /// `Places`
  String get places {
    return Intl.message('Places', name: 'places', desc: '', args: []);
  }

  /// `Activities`
  String get activities {
    return Intl.message('Activities', name: 'activities', desc: '', args: []);
  }

  /// `Requests`
  String get requests {
    return Intl.message('Requests', name: 'requests', desc: '', args: []);
  }

  /// `Apply`
  String get apply {
    return Intl.message('Apply', name: 'apply', desc: '', args: []);
  }

  /// `User`
  String get user {
    return Intl.message('User', name: 'user', desc: '', args: []);
  }

  /// `Status`
  String get status {
    return Intl.message('Status', name: 'status', desc: '', args: []);
  }

  /// `Quantity`
  String get quantity {
    return Intl.message('Quantity', name: 'quantity', desc: '', args: []);
  }

  /// `Validator Email`
  String get validator_email {
    return Intl.message(
      'Validator Email',
      name: 'validator_email',
      desc: '',
      args: [],
    );
  }

  /// `From Resource`
  String get from_resource {
    return Intl.message(
      'From Resource',
      name: 'from_resource',
      desc: '',
      args: [],
    );
  }

  /// `Activity`
  String get activity {
    return Intl.message('Activity', name: 'activity', desc: '', args: []);
  }

  /// `Place`
  String get place {
    return Intl.message('Place', name: 'place', desc: '', args: []);
  }

  /// `Cancel This Booking`
  String get cancel_this_booking {
    return Intl.message(
      'Cancel This Booking',
      name: 'cancel_this_booking',
      desc: '',
      args: [],
    );
  }

  /// `Add User`
  String get add_user {
    return Intl.message('Add User', name: 'add_user', desc: '', args: []);
  }

  /// `Load CSV`
  String get load_CSV {
    return Intl.message('Load CSV', name: 'load_CSV', desc: '', args: []);
  }

  /// `Load CSV File`
  String get load_CSV_file {
    return Intl.message(
      'Load CSV File',
      name: 'load_CSV_file',
      desc: '',
      args: [],
    );
  }

  /// `name,surname,email,role1,role2,...,role_n`
  String get description_CSV {
    return Intl.message(
      'name,surname,email,role1,role2,...,role_n',
      name: 'description_CSV',
      desc: '',
      args: [],
    );
  }

  /// `Choose CSV File`
  String get choose_CSV_file {
    return Intl.message(
      'Choose CSV File',
      name: 'choose_CSV_file',
      desc: '',
      args: [],
    );
  }

  /// `Add Users`
  String get add_users {
    return Intl.message('Add Users', name: 'add_users', desc: '', args: []);
  }

  /// `Preview`
  String get preview {
    return Intl.message('Preview', name: 'preview', desc: '', args: []);
  }

  /// `total`
  String get total {
    return Intl.message('total', name: 'total', desc: '', args: []);
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: '', args: []);
  }

  /// `All Users Created`
  String get all_users_created {
    return Intl.message(
      'All Users Created',
      name: 'all_users_created',
      desc: '',
      args: [],
    );
  }

  /// `Users Uncreated`
  String get users_uncreated {
    return Intl.message(
      'Users Uncreated',
      name: 'users_uncreated',
      desc: '',
      args: [],
    );
  }

  /// `Disconnect All Users`
  String get disconnect_all_users {
    return Intl.message(
      'Disconnect All Users',
      name: 'disconnect_all_users',
      desc: '',
      args: [],
    );
  }

  /// `Disconnect All Users?`
  String get ask_disconnect_all_users {
    return Intl.message(
      'Disconnect All Users?',
      name: 'ask_disconnect_all_users',
      desc: '',
      args: [],
    );
  }

  /// `All Users Disconnected`
  String get all_users_disconnected {
    return Intl.message(
      'All Users Disconnected',
      name: 'all_users_disconnected',
      desc: '',
      args: [],
    );
  }

  /// `Manage With Slots`
  String get manage_with_slots {
    return Intl.message(
      'Manage With Slots',
      name: 'manage_with_slots',
      desc: '',
      args: [],
    );
  }

  /// `Auto Accept`
  String get auto_accept {
    return Intl.message('Auto Accept', name: 'auto_accept', desc: '', args: []);
  }

  /// `Allow Over Booking`
  String get allow_over_booking {
    return Intl.message(
      'Allow Over Booking',
      name: 'allow_over_booking',
      desc: '',
      args: [],
    );
  }

  /// `hours`
  String get hours {
    return Intl.message('hours', name: 'hours', desc: '', args: []);
  }

  /// `minutes`
  String get minutes {
    return Intl.message('minutes', name: 'minutes', desc: '', args: []);
  }

  /// `Select Range`
  String get select_range {
    return Intl.message(
      'Select Range',
      name: 'select_range',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `Clear All Filters`
  String get clear_all_filters {
    return Intl.message(
      'Clear All Filters',
      name: 'clear_all_filters',
      desc: '',
      args: [],
    );
  }

  /// `Empty List`
  String get empty_list {
    return Intl.message('Empty List', name: 'empty_list', desc: '', args: []);
  }

  /// `Start`
  String get start {
    return Intl.message('Start', name: 'start', desc: '', args: []);
  }

  /// `End`
  String get end {
    return Intl.message('End', name: 'end', desc: '', args: []);
  }

  /// `Resource`
  String get resource {
    return Intl.message('Resource', name: 'resource', desc: '', args: []);
  }

  /// `Request Details From`
  String get request_details_from {
    return Intl.message(
      'Request Details From',
      name: 'request_details_from',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message('Type', name: 'type', desc: '', args: []);
  }

  /// `Accept`
  String get accept {
    return Intl.message('Accept', name: 'accept', desc: '', args: []);
  }

  /// `Refuse`
  String get refuse {
    return Intl.message('Refuse', name: 'refuse', desc: '', args: []);
  }

  /// `Refuse?`
  String get ask_for_refuse {
    return Intl.message('Refuse?', name: 'ask_for_refuse', desc: '', args: []);
  }

  /// `Request Accepted`
  String get request_accepted {
    return Intl.message(
      'Request Accepted',
      name: 'request_accepted',
      desc: '',
      args: [],
    );
  }

  /// `Request Refused `
  String get request_refused {
    return Intl.message(
      'Request Refused ',
      name: 'request_refused',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `This Reservation Needs To Be Accepted`
  String get this_reservation_needs_to_be_accepted {
    return Intl.message(
      'This Reservation Needs To Be Accepted',
      name: 'this_reservation_needs_to_be_accepted',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get select {
    return Intl.message('Select', name: 'select', desc: '', args: []);
  }

  /// `Book`
  String get book {
    return Intl.message('Book', name: 'book', desc: '', args: []);
  }

  /// `Prediction Graph`
  String get prediction_graph {
    return Intl.message(
      'Prediction Graph',
      name: 'prediction_graph',
      desc: '',
      args: [],
    );
  }

  /// `Select Another Period`
  String get select_another_period {
    return Intl.message(
      'Select Another Period',
      name: 'select_another_period',
      desc: '',
      args: [],
    );
  }

  /// `No Availability`
  String get no_availability {
    return Intl.message(
      'No Availability',
      name: 'no_availability',
      desc: '',
      args: [],
    );
  }

  /// `Bookings Page Instructions`
  String get bookingInstructions {
    return Intl.message(
      'Bookings Page Instructions',
      name: 'bookingInstructions',
      desc: '',
      args: [],
    );
  }

  /// `The app is divided into 3 tabs:`
  String get appSectionsInfo {
    return Intl.message(
      'The app is divided into 3 tabs:',
      name: 'appSectionsInfo',
      desc: '',
      args: [],
    );
  }

  /// `Search Page`
  String get searchPageTitle {
    return Intl.message(
      'Search Page',
      name: 'searchPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `On the search page you select the desired booking period`
  String get searchPageText1 {
    return Intl.message(
      'On the search page you select the desired booking period',
      name: 'searchPageText1',
      desc: '',
      args: [],
    );
  }

  /// `Choose the start and end date by tapping on the displayed date; same for start and end time`
  String get searchPageText2 {
    return Intl.message(
      'Choose the start and end date by tapping on the displayed date; same for start and end time',
      name: 'searchPageText2',
      desc: '',
      args: [],
    );
  }

  /// `Tap the 'Search' button to go to the next page`
  String get searchPageText3 {
    return Intl.message(
      'Tap the \'Search\' button to go to the next page',
      name: 'searchPageText3',
      desc: '',
      args: [],
    );
  }

  /// `View Page`
  String get viewPageTitle {
    return Intl.message('View Page', name: 'viewPageTitle', desc: '', args: []);
  }

  /// `This page is split into two parts: one for the graph and one for viewing graph data`
  String get viewPageText1 {
    return Intl.message(
      'This page is split into two parts: one for the graph and one for viewing graph data',
      name: 'viewPageText1',
      desc: '',
      args: [],
    );
  }

  /// `Reading the Graph`
  String get readGraphTitle {
    return Intl.message(
      'Reading the Graph',
      name: 'readGraphTitle',
      desc: '',
      args: [],
    );
  }

  /// `The graph shows the requested resource quantity over the selected period`
  String get readGraphText1 {
    return Intl.message(
      'The graph shows the requested resource quantity over the selected period',
      name: 'readGraphText1',
      desc: '',
      args: [],
    );
  }

  /// `Tap a point on the graph to view its value`
  String get readGraphText2 {
    return Intl.message(
      'Tap a point on the graph to view its value',
      name: 'readGraphText2',
      desc: '',
      args: [],
    );
  }

  /// `Long press and slide your finger to explore graph values`
  String get readGraphText3 {
    return Intl.message(
      'Long press and slide your finger to explore graph values',
      name: 'readGraphText3',
      desc: '',
      args: [],
    );
  }

  /// `A 'Prediction Graph' button shows estimated future demand overlaid on the graph`
  String get predictionGraphText {
    return Intl.message(
      'A \'Prediction Graph\' button shows estimated future demand overlaid on the graph',
      name: 'predictionGraphText',
      desc: '',
      args: [],
    );
  }

  /// `Since this is a prediction by a machine learning model trained on app data, it may contain uncertainty and errors`
  String get predictionWarning {
    return Intl.message(
      'Since this is a prediction by a machine learning model trained on app data, it may contain uncertainty and errors',
      name: 'predictionWarning',
      desc: '',
      args: [],
    );
  }

  /// `Reading Intervals`
  String get readIntervalsTitle {
    return Intl.message(
      'Reading Intervals',
      name: 'readIntervalsTitle',
      desc: '',
      args: [],
    );
  }

  /// `The second section shows the same data as the graph in tabular form`
  String get readIntervalsText1 {
    return Intl.message(
      'The second section shows the same data as the graph in tabular form',
      name: 'readIntervalsText1',
      desc: '',
      args: [],
    );
  }

  /// `If the resource has slots, tap one to select the time period, and you'll go to the final booking page`
  String get readIntervalsText2 {
    return Intl.message(
      'If the resource has slots, tap one to select the time period, and you\'ll go to the final booking page',
      name: 'readIntervalsText2',
      desc: '',
      args: [],
    );
  }

  /// `Book Page`
  String get bookPageTitle {
    return Intl.message('Book Page', name: 'bookPageTitle', desc: '', args: []);
  }

  /// `This page allows you to make a reservation`
  String get bookPageText1 {
    return Intl.message(
      'This page allows you to make a reservation',
      name: 'bookPageText1',
      desc: '',
      args: [],
    );
  }

  /// `Which Data Can You Modify?`
  String get whatCanModifyTitle {
    return Intl.message(
      'Which Data Can You Modify?',
      name: 'whatCanModifyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Some displayed data is editable (marked in yellow); a suitable UI will appear`
  String get whatCanModifyText {
    return Intl.message(
      'Some displayed data is editable (marked in yellow); a suitable UI will appear',
      name: 'whatCanModifyText',
      desc: '',
      args: [],
    );
  }

  /// `How to Book`
  String get howToBookTitle {
    return Intl.message(
      'How to Book',
      name: 'howToBookTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter the desired quantity and verify it via the provided button`
  String get howToBookText1 {
    return Intl.message(
      'Enter the desired quantity and verify it via the provided button',
      name: 'howToBookText1',
      desc: '',
      args: [],
    );
  }

  /// `Finally, tap the 'Book' button below to confirm`
  String get howToBookText2 {
    return Intl.message(
      'Finally, tap the \'Book\' button below to confirm',
      name: 'howToBookText2',
      desc: '',
      args: [],
    );
  }

  /// `You can always switch between tabs using the top bar`
  String get finalNote {
    return Intl.message(
      'You can always switch between tabs using the top bar',
      name: 'finalNote',
      desc: '',
      args: [],
    );
  }

  /// `Hello `
  String get account_hello {
    return Intl.message('Hello ', name: 'account_hello', desc: '', args: []);
  }

  /// `Profile`
  String get account_your_profile {
    return Intl.message(
      'Profile',
      name: 'account_your_profile',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get account_settings {
    return Intl.message(
      'Settings',
      name: 'account_settings',
      desc: '',
      args: [],
    );
  }

  /// `Bookings`
  String get account_your_bookings {
    return Intl.message(
      'Bookings',
      name: 'account_your_bookings',
      desc: '',
      args: [],
    );
  }

  /// `Activity`
  String get account_your_activity {
    return Intl.message(
      'Activity',
      name: 'account_your_activity',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get account_logout {
    return Intl.message('Logout', name: 'account_logout', desc: '', args: []);
  }

  /// `Not Logged`
  String get account_not_logged {
    return Intl.message(
      'Not Logged',
      name: 'account_not_logged',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get account_login {
    return Intl.message('Login', name: 'account_login', desc: '', args: []);
  }

  /// `Theme`
  String get settings_theme {
    return Intl.message('Theme', name: 'settings_theme', desc: '', args: []);
  }

  /// `Language`
  String get settings_language {
    return Intl.message(
      'Language',
      name: 'settings_language',
      desc: '',
      args: [],
    );
  }

  /// `Not Logged`
  String get settings_not_logged {
    return Intl.message(
      'Not Logged',
      name: 'settings_not_logged',
      desc: '',
      args: [],
    );
  }

  /// `Not Logged`
  String get profile_not_logged {
    return Intl.message(
      'Not Logged',
      name: 'profile_not_logged',
      desc: '',
      args: [],
    );
  }

  /// `Already Logged`
  String get login_already_logged {
    return Intl.message(
      'Already Logged',
      name: 'login_already_logged',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login_login {
    return Intl.message('Login', name: 'login_login', desc: '', args: []);
  }

  /// `Login Success`
  String get login_success {
    return Intl.message(
      'Login Success',
      name: 'login_success',
      desc: '',
      args: [],
    );
  }

  /// `Login Failed`
  String get login_failed {
    return Intl.message(
      'Login Failed',
      name: 'login_failed',
      desc: '',
      args: [],
    );
  }

  /// `Manage Users`
  String get manage_users {
    return Intl.message(
      'Manage Users',
      name: 'manage_users',
      desc: '',
      args: [],
    );
  }

  /// `Manage Roles`
  String get manage_roles {
    return Intl.message(
      'Manage Roles',
      name: 'manage_roles',
      desc: '',
      args: [],
    );
  }

  /// `Manage Types`
  String get manage_types {
    return Intl.message(
      'Manage Types',
      name: 'manage_types',
      desc: '',
      args: [],
    );
  }

  /// `Manage Places`
  String get manage_places {
    return Intl.message(
      'Manage Places',
      name: 'manage_places',
      desc: '',
      args: [],
    );
  }

  /// `Manage Activities`
  String get manage_activities {
    return Intl.message(
      'Manage Activities',
      name: 'manage_activities',
      desc: '',
      args: [],
    );
  }

  /// `Manage Resources`
  String get manage_resources {
    return Intl.message(
      'Manage Resources',
      name: 'manage_resources',
      desc: '',
      args: [],
    );
  }

  /// `Go to page`
  String get manage_go_to_page {
    return Intl.message(
      'Go to page',
      name: 'manage_go_to_page',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get user_name {
    return Intl.message('Name', name: 'user_name', desc: '', args: []);
  }

  /// `Surname`
  String get user_surname {
    return Intl.message('Surname', name: 'user_surname', desc: '', args: []);
  }

  /// `Email`
  String get user_email {
    return Intl.message('Email', name: 'user_email', desc: '', args: []);
  }

  /// `Roles`
  String get user_roles {
    return Intl.message('Roles', name: 'user_roles', desc: '', args: []);
  }

  /// `New User`
  String get user_new_user {
    return Intl.message('New User', name: 'user_new_user', desc: '', args: []);
  }

  /// `Add New User`
  String get user_add_new_user {
    return Intl.message(
      'Add New User',
      name: 'user_add_new_user',
      desc: '',
      args: [],
    );
  }

  /// `Add User`
  String get user_add_user {
    return Intl.message('Add User', name: 'user_add_user', desc: '', args: []);
  }

  /// `User Created`
  String get user_create_success {
    return Intl.message(
      'User Created',
      name: 'user_create_success',
      desc: '',
      args: [],
    );
  }

  /// `User Updated`
  String get user_updated_success {
    return Intl.message(
      'User Updated',
      name: 'user_updated_success',
      desc: '',
      args: [],
    );
  }

  /// `Password Reset`
  String get user_password_reset {
    return Intl.message(
      'Password Reset',
      name: 'user_password_reset',
      desc: '',
      args: [],
    );
  }

  /// `User Deleted`
  String get user_delete_success {
    return Intl.message(
      'User Deleted',
      name: 'user_delete_success',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password?`
  String get user_password_reset_confirmation {
    return Intl.message(
      'Reset Password?',
      name: 'user_password_reset_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Error Occurred`
  String get user_error_occurred {
    return Intl.message(
      'Error Occurred',
      name: 'user_error_occurred',
      desc: '',
      args: [],
    );
  }

  /// `Details for`
  String get user_details {
    return Intl.message(
      'Details for',
      name: 'user_details',
      desc: '',
      args: [],
    );
  }

  /// `Update Roles`
  String get user_update_roles {
    return Intl.message(
      'Update Roles',
      name: 'user_update_roles',
      desc: '',
      args: [],
    );
  }

  /// `Update User`
  String get user_update_user {
    return Intl.message(
      'Update User',
      name: 'user_update_user',
      desc: '',
      args: [],
    );
  }

  /// `Restore Password`
  String get user_restore_password {
    return Intl.message(
      'Restore Password',
      name: 'user_restore_password',
      desc: '',
      args: [],
    );
  }

  /// `Delete User`
  String get user_delete_user {
    return Intl.message(
      'Delete User',
      name: 'user_delete_user',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get user_delete {
    return Intl.message('Delete', name: 'user_delete', desc: '', args: []);
  }

  /// `Name`
  String get role_name {
    return Intl.message('Name', name: 'role_name', desc: '', args: []);
  }

  /// `Description`
  String get role_description {
    return Intl.message(
      'Description',
      name: 'role_description',
      desc: '',
      args: [],
    );
  }

  /// `New Role`
  String get role_new_role {
    return Intl.message('New Role', name: 'role_new_role', desc: '', args: []);
  }

  /// `Add Role`
  String get role_add_role {
    return Intl.message('Add Role', name: 'role_add_role', desc: '', args: []);
  }

  /// `Add New Role`
  String get role_add_new_role {
    return Intl.message(
      'Add New Role',
      name: 'role_add_new_role',
      desc: '',
      args: [],
    );
  }

  /// `Permissions`
  String get role_permissions {
    return Intl.message(
      'Permissions',
      name: 'role_permissions',
      desc: '',
      args: [],
    );
  }

  /// `Role Created`
  String get role_create_success {
    return Intl.message(
      'Role Created',
      name: 'role_create_success',
      desc: '',
      args: [],
    );
  }

  /// `Role Updated`
  String get role_update_success {
    return Intl.message(
      'Role Updated',
      name: 'role_update_success',
      desc: '',
      args: [],
    );
  }

  /// `Role Deleted`
  String get role_delete_success {
    return Intl.message(
      'Role Deleted',
      name: 'role_delete_success',
      desc: '',
      args: [],
    );
  }

  /// `Error Occurred`
  String get role_error_occurred {
    return Intl.message(
      'Error Occurred',
      name: 'role_error_occurred',
      desc: '',
      args: [],
    );
  }

  /// `Details for`
  String get role_details {
    return Intl.message(
      'Details for',
      name: 'role_details',
      desc: '',
      args: [],
    );
  }

  /// `Update Roles`
  String get role_update_roles {
    return Intl.message(
      'Update Roles',
      name: 'role_update_roles',
      desc: '',
      args: [],
    );
  }

  /// `Update Role`
  String get role_update_role {
    return Intl.message(
      'Update Role',
      name: 'role_update_role',
      desc: '',
      args: [],
    );
  }

  /// `Delete Role`
  String get role_delete_role {
    return Intl.message(
      'Delete Role',
      name: 'role_delete_role',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get role_delete {
    return Intl.message('Delete', name: 'role_delete', desc: '', args: []);
  }

  /// `Users Permissions`
  String get role_usersPermissions {
    return Intl.message(
      'Users Permissions',
      name: 'role_usersPermissions',
      desc: '',
      args: [],
    );
  }

  /// `View Users`
  String get role_viewUsers {
    return Intl.message(
      'View Users',
      name: 'role_viewUsers',
      desc: '',
      args: [],
    );
  }

  /// `Edit Users`
  String get role_editUsers {
    return Intl.message(
      'Edit Users',
      name: 'role_editUsers',
      desc: '',
      args: [],
    );
  }

  /// `Create Users`
  String get role_createUsers {
    return Intl.message(
      'Create Users',
      name: 'role_createUsers',
      desc: '',
      args: [],
    );
  }

  /// `Delete Users`
  String get role_deleteUsers {
    return Intl.message(
      'Delete Users',
      name: 'role_deleteUsers',
      desc: '',
      args: [],
    );
  }

  /// `User Own Permissions`
  String get role_userOwnPermissions {
    return Intl.message(
      'User Own Permissions',
      name: 'role_userOwnPermissions',
      desc: '',
      args: [],
    );
  }

  /// `View Own User`
  String get role_viewOwnUser {
    return Intl.message(
      'View Own User',
      name: 'role_viewOwnUser',
      desc: '',
      args: [],
    );
  }

  /// `Edit Own User`
  String get role_editOwnUser {
    return Intl.message(
      'Edit Own User',
      name: 'role_editOwnUser',
      desc: '',
      args: [],
    );
  }

  /// `Create Own User`
  String get role_createOwnUser {
    return Intl.message(
      'Create Own User',
      name: 'role_createOwnUser',
      desc: '',
      args: [],
    );
  }

  /// `Delete Own User`
  String get role_deleteOwnUser {
    return Intl.message(
      'Delete Own User',
      name: 'role_deleteOwnUser',
      desc: '',
      args: [],
    );
  }

  /// `Roles Permissions`
  String get role_rolesPermissions {
    return Intl.message(
      'Roles Permissions',
      name: 'role_rolesPermissions',
      desc: '',
      args: [],
    );
  }

  /// `View Roles`
  String get role_viewRoles {
    return Intl.message(
      'View Roles',
      name: 'role_viewRoles',
      desc: '',
      args: [],
    );
  }

  /// `Edit Roles`
  String get role_editRoles {
    return Intl.message(
      'Edit Roles',
      name: 'role_editRoles',
      desc: '',
      args: [],
    );
  }

  /// `Create Roles`
  String get role_createRoles {
    return Intl.message(
      'Create Roles',
      name: 'role_createRoles',
      desc: '',
      args: [],
    );
  }

  /// `Delete Roles`
  String get role_deleteRoles {
    return Intl.message(
      'Delete Roles',
      name: 'role_deleteRoles',
      desc: '',
      args: [],
    );
  }

  /// `Availability Permissions`
  String get role_availabilityPermissions {
    return Intl.message(
      'Availability Permissions',
      name: 'role_availabilityPermissions',
      desc: '',
      args: [],
    );
  }

  /// `View Availability`
  String get role_viewAvailability {
    return Intl.message(
      'View Availability',
      name: 'role_viewAvailability',
      desc: '',
      args: [],
    );
  }

  /// `Edit Availability`
  String get role_editAvailability {
    return Intl.message(
      'Edit Availability',
      name: 'role_editAvailability',
      desc: '',
      args: [],
    );
  }

  /// `Create Availability`
  String get role_createAvailability {
    return Intl.message(
      'Create Availability',
      name: 'role_createAvailability',
      desc: '',
      args: [],
    );
  }

  /// `Delete Availability`
  String get role_deleteAvailability {
    return Intl.message(
      'Delete Availability',
      name: 'role_deleteAvailability',
      desc: '',
      args: [],
    );
  }

  /// `Resources Permissions`
  String get role_resourcesPermissions {
    return Intl.message(
      'Resources Permissions',
      name: 'role_resourcesPermissions',
      desc: '',
      args: [],
    );
  }

  /// `View Resources`
  String get role_viewResources {
    return Intl.message(
      'View Resources',
      name: 'role_viewResources',
      desc: '',
      args: [],
    );
  }

  /// `Edit Resources`
  String get role_editResources {
    return Intl.message(
      'Edit Resources',
      name: 'role_editResources',
      desc: '',
      args: [],
    );
  }

  /// `Create Resources`
  String get role_createResources {
    return Intl.message(
      'Create Resources',
      name: 'role_createResources',
      desc: '',
      args: [],
    );
  }

  /// `Delete Resources`
  String get role_deleteResources {
    return Intl.message(
      'Delete Resources',
      name: 'role_deleteResources',
      desc: '',
      args: [],
    );
  }

  /// `Booking Permission`
  String get role_bookingPermissions {
    return Intl.message(
      'Booking Permission',
      name: 'role_bookingPermissions',
      desc: '',
      args: [],
    );
  }

  /// `View Booking`
  String get role_viewBooking {
    return Intl.message(
      'View Booking',
      name: 'role_viewBooking',
      desc: '',
      args: [],
    );
  }

  /// `Edit Booking`
  String get role_editBooking {
    return Intl.message(
      'Edit Booking',
      name: 'role_editBooking',
      desc: '',
      args: [],
    );
  }

  /// `Create Booking`
  String get role_createBooking {
    return Intl.message(
      'Create Booking',
      name: 'role_createBooking',
      desc: '',
      args: [],
    );
  }

  /// `Delete Booking`
  String get role_deleteBooking {
    return Intl.message(
      'Delete Booking',
      name: 'role_deleteBooking',
      desc: '',
      args: [],
    );
  }

  /// `User Own Booking Permission`
  String get role_userOwnBookingPermissions {
    return Intl.message(
      'User Own Booking Permission',
      name: 'role_userOwnBookingPermissions',
      desc: '',
      args: [],
    );
  }

  /// `View Own Booking`
  String get role_viewOwnBooking {
    return Intl.message(
      'View Own Booking',
      name: 'role_viewOwnBooking',
      desc: '',
      args: [],
    );
  }

  /// `Edit Own Booking`
  String get role_editOwnBooking {
    return Intl.message(
      'Edit Own Booking',
      name: 'role_editOwnBooking',
      desc: '',
      args: [],
    );
  }

  /// `Create Own Booking`
  String get role_createOwnBooking {
    return Intl.message(
      'Create Own Booking',
      name: 'role_createOwnBooking',
      desc: '',
      args: [],
    );
  }

  /// `Delete Own Booking`
  String get role_deleteOwnBooking {
    return Intl.message(
      'Delete Own Booking',
      name: 'role_deleteOwnBooking',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get type_name {
    return Intl.message('Name', name: 'type_name', desc: '', args: []);
  }

  /// `Description`
  String get type_description {
    return Intl.message(
      'Description',
      name: 'type_description',
      desc: '',
      args: [],
    );
  }

  /// `New Type`
  String get type_new_type {
    return Intl.message('New Type', name: 'type_new_type', desc: '', args: []);
  }

  /// `Details For`
  String get type_details_for {
    return Intl.message(
      'Details For',
      name: 'type_details_for',
      desc: '',
      args: [],
    );
  }

  /// `Update Type`
  String get type_update_type {
    return Intl.message(
      'Update Type',
      name: 'type_update_type',
      desc: '',
      args: [],
    );
  }

  /// `Delete Type`
  String get type_delete_type {
    return Intl.message(
      'Delete Type',
      name: 'type_delete_type',
      desc: '',
      args: [],
    );
  }

  /// `Type Updated`
  String get type_update_success {
    return Intl.message(
      'Type Updated',
      name: 'type_update_success',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get type_delete_confirmation {
    return Intl.message(
      'Delete',
      name: 'type_delete_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Type Deleted`
  String get type_delete_success {
    return Intl.message(
      'Type Deleted',
      name: 'type_delete_success',
      desc: '',
      args: [],
    );
  }

  /// `Error Occurred`
  String get type_error_occurred {
    return Intl.message(
      'Error Occurred',
      name: 'type_error_occurred',
      desc: '',
      args: [],
    );
  }

  /// `Add New Type`
  String get type_add_new_type {
    return Intl.message(
      'Add New Type',
      name: 'type_add_new_type',
      desc: '',
      args: [],
    );
  }

  /// `Add Type`
  String get type_add_type {
    return Intl.message('Add Type', name: 'type_add_type', desc: '', args: []);
  }

  /// `Type Created`
  String get type_create_success {
    return Intl.message(
      'Type Created',
      name: 'type_create_success',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get place_name {
    return Intl.message('Name', name: 'place_name', desc: '', args: []);
  }

  /// `Description`
  String get place_description {
    return Intl.message(
      'Description',
      name: 'place_description',
      desc: '',
      args: [],
    );
  }

  /// `New Place`
  String get place_new_place {
    return Intl.message(
      'New Place',
      name: 'place_new_place',
      desc: '',
      args: [],
    );
  }

  /// `Details For`
  String get place_details_for {
    return Intl.message(
      'Details For',
      name: 'place_details_for',
      desc: '',
      args: [],
    );
  }

  /// `Update Place`
  String get place_update_place {
    return Intl.message(
      'Update Place',
      name: 'place_update_place',
      desc: '',
      args: [],
    );
  }

  /// `Delete Place`
  String get place_delete_place {
    return Intl.message(
      'Delete Place',
      name: 'place_delete_place',
      desc: '',
      args: [],
    );
  }

  /// `Place Updated`
  String get place_update_success {
    return Intl.message(
      'Place Updated',
      name: 'place_update_success',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get place_delete_confirmation {
    return Intl.message(
      'Delete',
      name: 'place_delete_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Place Deleted`
  String get place_delete_success {
    return Intl.message(
      'Place Deleted',
      name: 'place_delete_success',
      desc: '',
      args: [],
    );
  }

  /// `Error Occurred`
  String get place_error_occurred {
    return Intl.message(
      'Error Occurred',
      name: 'place_error_occurred',
      desc: '',
      args: [],
    );
  }

  /// `Add New Place`
  String get place_add_new_place {
    return Intl.message(
      'Add New Place',
      name: 'place_add_new_place',
      desc: '',
      args: [],
    );
  }

  /// `Add Place`
  String get place_add_place {
    return Intl.message(
      'Add Place',
      name: 'place_add_place',
      desc: '',
      args: [],
    );
  }

  /// `Place Created`
  String get place_create_success {
    return Intl.message(
      'Place Created',
      name: 'place_create_success',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get activity_name {
    return Intl.message('Name', name: 'activity_name', desc: '', args: []);
  }

  /// `Description`
  String get activity_description {
    return Intl.message(
      'Description',
      name: 'activity_description',
      desc: '',
      args: [],
    );
  }

  /// `New Activity`
  String get activity_new_activity {
    return Intl.message(
      'New Activity',
      name: 'activity_new_activity',
      desc: '',
      args: [],
    );
  }

  /// `Details For`
  String get activity_details_for {
    return Intl.message(
      'Details For',
      name: 'activity_details_for',
      desc: '',
      args: [],
    );
  }

  /// `Update Activity`
  String get activity_update_activity {
    return Intl.message(
      'Update Activity',
      name: 'activity_update_activity',
      desc: '',
      args: [],
    );
  }

  /// `Delete Activity`
  String get activity_delete_activity {
    return Intl.message(
      'Delete Activity',
      name: 'activity_delete_activity',
      desc: '',
      args: [],
    );
  }

  /// `Activity Updated`
  String get activity_update_success {
    return Intl.message(
      'Activity Updated',
      name: 'activity_update_success',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get activity_delete_confirmation {
    return Intl.message(
      'Delete',
      name: 'activity_delete_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Activity Deleted`
  String get activity_delete_success {
    return Intl.message(
      'Activity Deleted',
      name: 'activity_delete_success',
      desc: '',
      args: [],
    );
  }

  /// `Error Occurred`
  String get activity_error_occurred {
    return Intl.message(
      'Error Occurred',
      name: 'activity_error_occurred',
      desc: '',
      args: [],
    );
  }

  /// `Add New Activity`
  String get activity_add_new_activity {
    return Intl.message(
      'Add New Activity',
      name: 'activity_add_new_activity',
      desc: '',
      args: [],
    );
  }

  /// `Add Activity`
  String get activity_add_activity {
    return Intl.message(
      'Add Activity',
      name: 'activity_add_activity',
      desc: '',
      args: [],
    );
  }

  /// `Activity Created`
  String get activity_create_success {
    return Intl.message(
      'Activity Created',
      name: 'activity_create_success',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get resource_name {
    return Intl.message('Name', name: 'resource_name', desc: '', args: []);
  }

  /// `Description`
  String get resource_description {
    return Intl.message(
      'Description',
      name: 'resource_description',
      desc: '',
      args: [],
    );
  }

  /// `Quantity`
  String get resource_quantity {
    return Intl.message(
      'Quantity',
      name: 'resource_quantity',
      desc: '',
      args: [],
    );
  }

  /// `Place`
  String get resource_place {
    return Intl.message('Place', name: 'resource_place', desc: '', args: []);
  }

  /// `Activity`
  String get resource_activity {
    return Intl.message(
      'Activity',
      name: 'resource_activity',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get resource_type {
    return Intl.message('Type', name: 'resource_type', desc: '', args: []);
  }

  /// `Referents`
  String get resource_referents {
    return Intl.message(
      'Referents',
      name: 'resource_referents',
      desc: '',
      args: [],
    );
  }

  /// `Not Specified`
  String get resource_not_specified {
    return Intl.message(
      'Not Specified',
      name: 'resource_not_specified',
      desc: '',
      args: [],
    );
  }

  /// `Empty List, Tap To Add`
  String get resource_referents_empty {
    return Intl.message(
      'Empty List, Tap To Add',
      name: 'resource_referents_empty',
      desc: '',
      args: [],
    );
  }

  /// `New Resource`
  String get resource_new_resource {
    return Intl.message(
      'New Resource',
      name: 'resource_new_resource',
      desc: '',
      args: [],
    );
  }

  /// `Add New Resource`
  String get resource_add_new_resource {
    return Intl.message(
      'Add New Resource',
      name: 'resource_add_new_resource',
      desc: '',
      args: [],
    );
  }

  /// `Permissions`
  String get resource_permissions {
    return Intl.message(
      'Permissions',
      name: 'resource_permissions',
      desc: '',
      args: [],
    );
  }

  /// `Add Resource`
  String get resource_add_resource {
    return Intl.message(
      'Add Resource',
      name: 'resource_add_resource',
      desc: '',
      args: [],
    );
  }

  /// `Resource Created`
  String get resource_create_success {
    return Intl.message(
      'Resource Created',
      name: 'resource_create_success',
      desc: '',
      args: [],
    );
  }

  /// `View`
  String get resource_view {
    return Intl.message('View', name: 'resource_view', desc: '', args: []);
  }

  /// `Remove`
  String get resource_remove {
    return Intl.message('Remove', name: 'resource_remove', desc: '', args: []);
  }

  /// `Edit`
  String get resource_edit {
    return Intl.message('Edit', name: 'resource_edit', desc: '', args: []);
  }

  /// `Book`
  String get resource_book {
    return Intl.message('Book', name: 'resource_book', desc: '', args: []);
  }

  /// `Can Accept`
  String get resource_can_accept {
    return Intl.message(
      'Can Accept',
      name: 'resource_can_accept',
      desc: '',
      args: [],
    );
  }

  /// `Details For`
  String get resource_details_for {
    return Intl.message(
      'Details For',
      name: 'resource_details_for',
      desc: '',
      args: [],
    );
  }

  /// `Manage Availability`
  String get resource_view_availability {
    return Intl.message(
      'Manage Availability',
      name: 'resource_view_availability',
      desc: '',
      args: [],
    );
  }

  /// `Update Resource`
  String get resource_update_resource {
    return Intl.message(
      'Update Resource',
      name: 'resource_update_resource',
      desc: '',
      args: [],
    );
  }

  /// `Delete Resource`
  String get resource_delete_resource {
    return Intl.message(
      'Delete Resource',
      name: 'resource_delete_resource',
      desc: '',
      args: [],
    );
  }

  /// `Resource Updated`
  String get resource_update_success {
    return Intl.message(
      'Resource Updated',
      name: 'resource_update_success',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get resource_delete_confirmation {
    return Intl.message(
      'Delete',
      name: 'resource_delete_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Resource Deleted`
  String get resource_delete_success {
    return Intl.message(
      'Resource Deleted',
      name: 'resource_delete_success',
      desc: '',
      args: [],
    );
  }

  /// `Error Occurred`
  String get resource_error_occurred {
    return Intl.message(
      'Error Occurred',
      name: 'resource_error_occurred',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get availability_start {
    return Intl.message(
      'Start',
      name: 'availability_start',
      desc: '',
      args: [],
    );
  }

  /// `End`
  String get availability_end {
    return Intl.message('End', name: 'availability_end', desc: '', args: []);
  }

  /// `Quantity`
  String get availability_quantity {
    return Intl.message(
      'Quantity',
      name: 'availability_quantity',
      desc: '',
      args: [],
    );
  }

  /// `New Availability`
  String get availability_new_availability {
    return Intl.message(
      'New Availability',
      name: 'availability_new_availability',
      desc: '',
      args: [],
    );
  }

  /// `Add New Availability For`
  String get availability_add_new_availability_for {
    return Intl.message(
      'Add New Availability For',
      name: 'availability_add_new_availability_for',
      desc: '',
      args: [],
    );
  }

  /// `Start Availability`
  String get availability_start_availability {
    return Intl.message(
      'Start Availability',
      name: 'availability_start_availability',
      desc: '',
      args: [],
    );
  }

  /// `End Availability`
  String get availability_end_availability {
    return Intl.message(
      'End Availability',
      name: 'availability_end_availability',
      desc: '',
      args: [],
    );
  }

  /// `Check Quantity`
  String get availability_check_quantity {
    return Intl.message(
      'Check Quantity',
      name: 'availability_check_quantity',
      desc: '',
      args: [],
    );
  }

  /// `Add Availability`
  String get availability_add_availability {
    return Intl.message(
      'Add Availability',
      name: 'availability_add_availability',
      desc: '',
      args: [],
    );
  }

  /// `Availability For`
  String get availability_availability_for {
    return Intl.message(
      'Availability For',
      name: 'availability_availability_for',
      desc: '',
      args: [],
    );
  }

  /// `Update Availability`
  String get availability_update_availability {
    return Intl.message(
      'Update Availability',
      name: 'availability_update_availability',
      desc: '',
      args: [],
    );
  }

  /// `Delete Availability`
  String get availability_delete_availability {
    return Intl.message(
      'Delete Availability',
      name: 'availability_delete_availability',
      desc: '',
      args: [],
    );
  }

  /// `Max Availability`
  String get availability_max_availability {
    return Intl.message(
      'Max Availability',
      name: 'availability_max_availability',
      desc: '',
      args: [],
    );
  }

  /// `Availability Created`
  String get availability_create_success {
    return Intl.message(
      'Availability Created',
      name: 'availability_create_success',
      desc: '',
      args: [],
    );
  }

  /// `Availability Updated`
  String get availability_update_success {
    return Intl.message(
      'Availability Updated',
      name: 'availability_update_success',
      desc: '',
      args: [],
    );
  }

  /// `Availability Deleted`
  String get availability_delete_success {
    return Intl.message(
      'Availability Deleted',
      name: 'availability_delete_success',
      desc: '',
      args: [],
    );
  }

  /// `Delete Availability?`
  String get availability_delete_confirmation {
    return Intl.message(
      'Delete Availability?',
      name: 'availability_delete_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Error Occurred`
  String get availability_error_occurred {
    return Intl.message(
      'Error Occurred',
      name: 'availability_error_occurred',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get book_from {
    return Intl.message('From', name: 'book_from', desc: '', args: []);
  }

  /// `to`
  String get book_to {
    return Intl.message('to', name: 'book_to', desc: '', args: []);
  }

  /// `To`
  String get book_To {
    return Intl.message('To', name: 'book_To', desc: '', args: []);
  }

  /// `Check Availability`
  String get book_check_availability {
    return Intl.message(
      'Check Availability',
      name: 'book_check_availability',
      desc: '',
      args: [],
    );
  }

  /// `Book`
  String get book_book {
    return Intl.message('Book', name: 'book_book', desc: '', args: []);
  }

  /// `Start`
  String get book_start {
    return Intl.message('Start', name: 'book_start', desc: '', args: []);
  }

  /// `End`
  String get book_end {
    return Intl.message('End', name: 'book_end', desc: '', args: []);
  }

  /// `Quantity`
  String get book_quantity {
    return Intl.message('Quantity', name: 'book_quantity', desc: '', args: []);
  }

  /// `No quantity available for the selected period`
  String get book_no_quantity {
    return Intl.message(
      'No quantity available for the selected period',
      name: 'book_no_quantity',
      desc: '',
      args: [],
    );
  }

  /// `Max Availability`
  String get book_max_availability {
    return Intl.message(
      'Max Availability',
      name: 'book_max_availability',
      desc: '',
      args: [],
    );
  }

  /// `Booked`
  String get book_book_success {
    return Intl.message(
      'Booked',
      name: 'book_book_success',
      desc: '',
      args: [],
    );
  }

  /// `Error Occurred`
  String get book_error_occurred {
    return Intl.message(
      'Error Occurred',
      name: 'book_error_occurred',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'it'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
