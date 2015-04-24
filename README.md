# shelf_buffer_request

A middleware for shelf that buffers the request so its body can be read multiple times.

## Usage

A simple usage example:

    import 'dart:io';
    import 'package:shelf/shelf.dart';
    import 'package:shelf/shelf_io.dart' as io;
    import 'package:shelf_proxy/shelf_proxy.dart' as proxy;
    import 'package:shelf_buffer_request/shelf_buffer_request.dart';

    main() {
        Handler handler = const Pipeline()
        .addMiddleware(new BufferRequestMiddleware().middleware)
        .addHandler(firstMiddlewareThatReadsBody);
        .addHandler(secondMiddlewareThatReadsBody);
        .addHandler(handlerThatReadsBody);

        io.serve(handler, InternetAddress.ANY_IP_V4, 1234).then((server) {
        print('Serving at http://${server.address.host}:${server.port}');
        });
    }

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/jonaskello/shelf_buffer_request/issues
