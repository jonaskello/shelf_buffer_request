// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library shelf_buffer_request.example;

import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_proxy/shelf_proxy.dart' as proxy;

import 'package:shelf_buffer_request/shelf_buffer_request.dart';

main() {

  Handler proxyHandler = proxy.proxyHandler("http://www.divid.se/does_not_exist");

  var rewriteToIndexHandler = new Pipeline()
  .addMiddleware(rewriteToDefaultMiddleware)
  .addHandler(proxyHandler);

  Handler cascadeHandler = new Cascade()
  .add(proxyHandler)
  .add(rewriteToIndexHandler)
  .handler;

  Handler handler = const Pipeline()
  .addMiddleware(new BufferRequestMiddleware().middleware)
  .addHandler(cascadeHandler);

  io.serve(handler, InternetAddress.ANY_IP_V4, 1234).then((server) {
    print('Serving at http://${server.address.host}:${server.port}');
  });

}

Handler rewriteToDefaultMiddleware(Handler innerHandler) {
  return (Request req) async {
    Request nextRequest = req;
    if (req.method == "GETX" && (req.headers["accept"] == 'html' || req.headers["accept"] == '*/*')) {
      var copied = new Request(req.method, req.requestedUri.replace(path: "/default.aspx")) ;
      nextRequest = copied;
    }
    return innerHandler(nextRequest);
  };
}
