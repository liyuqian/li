import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:graphql/client.dart';
import 'package:meta/meta.dart';

const String kRepository = 'repository';
const String kLabel = 'label';
const String kId = 'id';
const String kIssues = 'issues';
const String kEndCursor = 'endCursor';
const String kPageInfo = 'pageInfo';
const String kAfter = 'after';
const String kHasNextPage = 'hasNextPage';
const String kEdges = 'edges';
const String kNode = 'node';
const String kLabels = 'labels';
const String kTitle = 'title';
const String kUrl = 'url';

abstract class BaseCommand extends Command {
  BaseCommand() {
      const String TOKEN_ENV_NAME = 'GITHUB_TOKEN';
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

  @protected
  GraphQLClient client;
}
