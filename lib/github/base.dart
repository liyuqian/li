import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:graphql/client.dart';
import 'package:li/github/query_label_id.data.gql.dart';
import 'package:li/github/query_label_id.op.gql.dart';
import 'package:li/github/query_label_id.var.gql.dart';
import 'package:meta/meta.dart';

const String kFlutterOwner = 'flutter';
const String kFlutterRepoName = 'flutter';
const String kEngineRepoName = 'engine';

abstract class GithubClientCommand extends Command {
  static const String kTokenEnvName = 'GITHUB_TOKEN';

  GithubClientCommand() {
    argParser.addFlag(
      _kFlagVerbose,
      defaultsTo: false,
      help: 'whether to print verbose debug info',
    );
  }

  @override
  Future<void> run() async {
    if (client == null) {
      final String token = Platform.environment[kTokenEnvName];
      if (token == null) {
        print('Please set environment variable $kTokenEnvName first. Abort.');
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

  bool get isVerbose => argResults[_kFlagVerbose];

  // We won't send in a GraphQLClient client as a parameter because subclasses
  // may define many methods that use such client. Having it as a protected
  // class member greatly reduces complexity.
  @protected
  Future<void> runWithClientReady();

  @protected
  GraphQLClient client;

  static const String _kFlagVerbose = 'verbose';
}

/// May return null if the label does not exist.
Future<String> queryLabelId(
  GraphQLClient client,
  String name,
  String repoOwner,
  String repoName,
) async {
  final varBuilder = LabelIdVarBuilder();
  varBuilder.name = name;
  varBuilder.repoOwner = kFlutterOwner;
  varBuilder.repoName = kFlutterRepoName;
  final QueryResult labelIdResult = await client.query(QueryOptions(
    documentNode: LabelId.document,
    variables: varBuilder.variables,
  ));
  if (labelIdResult.hasException) {
    throw labelIdResult.exception;
  }
  return $LabelId(labelIdResult.data).repository.label.id;
}
