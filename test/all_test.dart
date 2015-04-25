// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library shelf_buffer_request.test;

import 'package:shelf/shelf.dart';
import 'package:unittest/unittest.dart';
import 'package:shelf_buffer_request/shelf_buffer_request.dart';

main() {

  group('Middleware test grouyp', () {

    Middleware middleware;
    Handler innerHandler = (Request req) => new Response.ok("Got it!");

    setUp(() {
      middleware = bufferRequests();
    });

    test('Simple Request', () {
      var handler = middleware(innerHandler);
      var resp = handler(new Request("POST", Uri.parse("http://localhost/index.html")));
      expect(resp, isNotNull);
    });
  });

}
