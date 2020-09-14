import 'dart:io';

import 'package:args/args.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:pointycastle/asymmetric/api.dart';

void main(List<String> arguments) async {
  final parser = ArgParser();
  parser.addOption('private',
      defaultsTo: 'private.pem', abbr: 's', help: 'Private key path');
  parser.addOption('public',
      defaultsTo: 'public.pem', abbr: 'p', help: 'public key path');
  parser.addOption('device-id', abbr: 'd', help: 'Mobile device id');
  if (arguments == null || arguments.isEmpty) {
    print(parser.usage);
    exit(1);
  }
  ArgResults results = parser.parse(arguments);
  if (results['public'] == null ||
      results['private'] == null ||
      results['device-id'] == null) {
    print(parser.usage);
    exit(1);
  }
  print(results.rest);
  print(results['public']);
  print(results['private']);
  print(results['device-id']);
  final publicKey = await parseKeyFromFile<RSAPublicKey>(results['public']);
  final privateKey = await parseKeyFromFile<RSAPrivateKey>(results['private']);
  final signer = Signer(RSASigner(RSASignDigest.SHA256,
      publicKey: publicKey, privateKey: privateKey));
  String s = results['device-id'];
  print(signer.sign(s).base64);
}
