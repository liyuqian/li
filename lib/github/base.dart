import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:graphql/client.dart';
import 'package:meta/meta.dart';

abstract class GithubClientCommand extends Command {
  static const String TOKEN_ENV_NAME = 'GITHUB_TOKEN';

  @override
  Future<void> run() async {
    if (client == null) {
      final String token = Platform.environment[TOKEN_ENV_NAME];
      if (token == null) {
        print('Please set environment variable $TOKEN_ENV_NAME first. Abort.');
        exit(1);
      }

      final HttpLink httpLink = HttpLink(
        uri: 'https://api.github.com/graphql',
      );

      final AuthLink authLink = AuthLink(
        getToken: () => 'Bearer $token',
      );

      final Link link = authLink.concat(httpLink);

      client = GraphQLClient(
        cache: InMemoryCache(),
        link: link,
      );
    }

    await runWithClientReady();
  }

  // We won't send in a GraphQLClient client as a parameter because subclasses
  // may define many methods that use such client. Having it as a protected
  // class member greatly reduces complexity.
  Future<void> runWithClientReady();

  @protected
  GraphQLClient client;
}
