import 'package:ask_it/pages/community/add_mods.dart';
import 'package:ask_it/pages/community/community.dart';
import 'package:ask_it/pages/community/create.dart';
import 'package:ask_it/pages/community/edit.dart';
import 'package:ask_it/pages/community/mod_tools.dart';
import 'package:ask_it/pages/home/home.dart';
import 'package:ask_it/pages/login/login.dart';
import 'package:ask_it/pages/user/edit.dart';
import 'package:ask_it/pages/user/profile.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: LoginScreen()),
  }
);

final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: HomeScreen()),
    '/create-community': (_) => const MaterialPage(child: CreateCommunityScreen()),
    '/r/:name': (route) => MaterialPage(
        child: CommunityScreen(
          name: route.pathParameters['name']!,
        ),
      ),
    '/mod-tools/:name': (route) => MaterialPage(
      child: ModToolsScreen(
        name: route.pathParameters['name']!,
      ),
    ),
    '/edit-community/:name': (route) => MaterialPage(
      child: EditCommunityScreen(
        name: route.pathParameters['name']!,
      ),
    ),
    '/add-mods/:name': (route) => MaterialPage(
      child: AddModsScreen(
        name: route.pathParameters['name']!,
      ),
    ),
    '/u/:uid': (route) => MaterialPage(
      child: UserProfileScreen(
        uid: route.pathParameters['uid']!,
      ),
    ),
    '/edit-profile/:uid': (route) => MaterialPage(
      child: EditProfileScreen(
        uid: route.pathParameters['uid']!,
      ),
    ),
  }
);