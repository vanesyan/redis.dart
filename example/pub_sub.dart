import 'dart:io' show InternetAddress;

import 'package:redis/redis.dart' show Pool;
import 'package:redis/src/subscriber.dart';

Future<void> main() async {
  final client = await Pool(InternetAddress.loopbackIPv4);
  final subscriber = await Subscriber.connect(InternetAddress.loopbackIPv4);

  subscriber.messages.listen((e) {
    switch (e.kind) {
      case EventKind.message:
        print((e as MessageEvent).value);
        break;

      default:
        break;
    }
  });

  subscriber.subscribe(['greeting']);
  await client.pubSub.publish('greeting', 'Hello');
  await client.pubSub.publish('greeting', 'world!');

  await client.close();
  await subscriber.close();
}
