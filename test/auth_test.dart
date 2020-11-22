// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bookabitual/states/currentUser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuth extends Mock implements CurrentUser {}

typedef Callback(MethodCall call);

setupFirebaseAuthMocks([Callback customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFirebase.channel.setMockMethodCallHandler((call) async {
    if (call.method == 'Firebase#initializeCore') {
      return [
        {
          'name': 'bookabitual',
          'options': {
            'apiKey': 'AIzaSyCeOiLUnQc1CohxP3_OrbZs4KR0tlMRsfE',
            'appId': '1:128508211625:android:632c13a69ad88d014c54b8',
            'messagingSenderId': '128508211625',
            'projectId': 'bookabitual-55ad2',
          },
          'pluginConstants': {},
        }
      ];
    }

    if (call.method == 'Firebase#initializeApp') {
      return {
        'name': call.arguments['appName'],
        'options': call.arguments['options'],
        'pluginConstants': {},
      };
    }

    if (customHandlers != null) {
      customHandlers(call);
    }

    return null;
  });
}

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  final MockAuth mockAuth = MockAuth();

  test("emit occurs", () async {
    expect(mockAuth.signUpUser("testing@testing.com", "testcase01", "Test User_01"), "Success");
  });
}