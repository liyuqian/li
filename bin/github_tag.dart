import 'dart:convert';
import 'dart:io';

import 'package:graphql/client.dart';

const String kRepository = 'repository';
const String kLabel = 'label';
const String kId = 'id';
const String kIssues = 'issues';
const String kEndCursor = 'endCursor';
const String kPageInfo = 'pageInfo';
const String kAfter = 'after';
const String kEdges = 'edges';
const String kNode = 'node';
const String kLabels = 'labels';

const String kQueryPerfSizeLabelId = '''
query PerfSizeLabelId {
  $kRepository(owner: "flutter", name: "flutter") {
    $kLabel(name: "perf: app size") {
      $kId
    }
  }
}
''';

const String _kQueryIssues = '''
query MatchedIssues(\$$kAfter: String) { 
  $kRepository(owner:"flutter", name:"flutter") {
    $kIssues(first: 1, $kAfter: \$$kAfter, labels:["a: size"]) {
      $kPageInfo {
        hasNextPage
        $kEndCursor
      }
      $kEdges {
        $kNode {
          id
          title
          url
          $kLabels(first: 100) {
            $kEdges {
              $kNode {
                id
                name
              }
            }
          }
        }
      }
    }
  }}
  ''';

JsonEncoder _prettyEncoder = JsonEncoder.withIndent('  ');

GraphQLClient getGraphQLClient() {
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

  return GraphQLClient(
    cache: InMemoryCache(),
    link: link,
  );
}

Future<String> getAppSizeLabelId(GraphQLClient client) async {
  final QueryResult labelIdResult = await client
      .query(QueryOptions(documentNode: gql(kQueryPerfSizeLabelId)));
  if (labelIdResult.hasException) {
    throw labelIdResult.exception;
  }
  return labelIdResult.data[kRepository][kLabel][kId];
}

Future<void> main() async {
  final GraphQLClient client = getGraphQLClient();

  print(await getAppSizeLabelId(client));

  QueryResult issuesResult =
      await client.query(QueryOptions(documentNode: gql(_kQueryIssues)));

  if (issuesResult.hasException) {
    throw issuesResult.exception;
  }

  print(_prettyEncoder.convert(issuesResult.data));

  final String endCursor =
      issuesResult.data[kRepository][kIssues][kPageInfo][kEndCursor];

  issuesResult = await client.query(QueryOptions(
    documentNode: gql(_kQueryIssues),
    variables: {kAfter: endCursor},
  ));

  if (issuesResult.hasException) {
    throw issuesResult.exception;
  }

  print(_prettyEncoder.convert(issuesResult.data));
}
