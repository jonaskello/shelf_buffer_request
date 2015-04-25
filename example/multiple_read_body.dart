// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library shelf_buffer_request.example;

import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

import 'package:shelf_buffer_request/shelf_buffer_request.dart';

/// Start the server, it will serve at port 1234.
/// Then to test run this command:
/// curl --data "param1=value1" localhost:1234/a
main() {

  Handler handler = const Pipeline()
  .addMiddleware(bufferRequests())
  .addMiddleware(readBodyMiddleware)
  .addMiddleware(readBodyMiddleware)
  .addMiddleware(readBodyMiddleware)
  .addMiddleware(logRequests())
  .addHandler((request) => new Response.ok("Got it!"));

  io.serve(handler, InternetAddress.ANY_IP_V4, 1234).then((server) {
    print('Serving at http://${server.address.host}:${server.port}');
  });

}

Handler readBodyMiddleware(Handler innerHandler) {
  return (Request request) async {
    var body = await request.read().toList();
    print("The body size was ${body.length}");
    return innerHandler(request);
  };
}

