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

  /// `Hello, `
  String get account_hello {
    return Intl.message('Hello, ', name: 'account_hello', desc: '', args: []);
  }

  /// `Your Profile`
  String get account_your_profile {
    return Intl.message(
      'Your Profile',
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

  /// `Your Bookings`
  String get account_your_bookings {
    return Intl.message(
      'Your Bookings',
      name: 'account_your_bookings',
      desc: '',
      args: [],
    );
  }

  /// `Your Activity`
  String get account_your_activity {
    return Intl.message(
      'Your Activity',
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

  /// `Type`
  String get resource_type {
    return Intl.message('Type', name: 'resource_type', desc: '', args: []);
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
