import 'package:ask_it/pages/community/community.dart';
import 'package:ask_it/pages/community/create.dart';
import 'package:ask_it/pages/community/edit.dart';
import 'package:ask_it/pages/community/mod_tools.dart';
import 'package:ask_it/pages/home/home.dart';
import 'package:ask_it/pages/login/login.dart';
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
  }
);