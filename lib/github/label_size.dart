import 'package:graphql/client.dart';

import 'package:li/github/base.dart';
import 'package:li/github/mutate_label.data.gql.dart';
import 'package:li/github/mutate_label.op.gql.dart';
import 'package:li/github/mutate_label.var.gql.dart';
import 'package:li/github/query_size_label_id.op.gql.dart';
import 'package:li/github/query_size_label_id.data.gql.dart';
import 'package:li/github/query_issues.op.gql.dart';
import 'package:li/github/query_issues.data.gql.dart';
import 'package:li/github/query_issues.var.gql.dart';

void test() {
  final data = $PerfSizeLabelId({});
  data.repository.label.id;
}

class LabelSizeCommand extends GithubClientCommand {
  LabelSizeCommand() {
    argParser.addOption(
      _kOptionMaxCount,
      defaultsTo: '1000',
      help: 'max number of issues to be labeled',
    );
    argParser.addFlag(
      _kFlagVerbose,
      defaultsTo: false,
      help: 'whether to print verbose debug info',
    );
  }

  @override
  String get description =>
      'add label "perf: app size" to all issues with label "a: size"';

  @override
  String get name => 'label_size';

  @override
  Future<void> runWithClientReady() async {
    _appSizeLabelId = await _queryAppSizeLabelId();

    final int maxCount = int.parse(argResults[_kOptionMaxCount]);
    int addCount = 0;
    int readCount = 0;

    String afterCursor;
    bool hasNextPage = true;
    while (hasNextPage && addCount < maxCount) {
      final QueryResult issuesResult = await client.query(QueryOptions(
        documentNode: Issues.document,
        variables: (IssuesVarBuilder()..after = afterCursor).variables,
      ));

      final issues = $Issues(issuesResult.data);

      for (var issueEdge in issues.repository.issues.edges) {
        readCount += 1;

        if (_isVerbose) {
          print('Checking issue "${issueEdge.node.title}"');
          print('               (${issueEdge.node.url.value})\n');
        }

        if (readCount % _kPrintTreshold == 0) {
          print('Number of issues processed: $readCount');
        }

        if (!_hasAppSizeLabel(issueEdge)) {
          await _addAppSizeLabel(issueEdge);
          addCount += 1;
          if (addCount >= maxCount) {
            break;
          }
        }
        ;
      }

      final pageInfo = issues.repository.issues.pageInfo;
      hasNextPage = pageInfo.hasNextPage;
      afterCursor = pageInfo.endCursor;
    }

    print('Total number of issues processed: $readCount');
    print('Total number of issues modified:  $addCount');
  }

  bool get _isVerbose => argResults[_kFlagVerbose];

  Future<void> _addAppSizeLabel(
      $Issues$repository$issues$edges issueEdge) async {
    final varBuilder = MutateLabelVarBuilder();
    varBuilder.issueId = issueEdge.node.id;
    varBuilder.labelId = _appSizeLabelId;
    final QueryResult result = await client.mutate(MutationOptions(
        documentNode: MutateLabel.document, variables: varBuilder.variables));
    if (result.hasException) {
      throw result.exception;
    }
    final parsedResult = $MutateLabel(result.data);
    final int totalCount =
        parsedResult.addLabelsToLabelable.labelable.labels.totalCount;
    print(
        'Added label to ${issueEdge.node.url} (${issueEdge.node.id} now has $totalCount labels)');
  }

  bool _hasAppSizeLabel($Issues$repository$issues$edges issueEdges) {
    for (var edge in issueEdges.node.labels.edges) {
      if (edge.node.id == _appSizeLabelId) {
        return true;
      }
    }
    return false;
  }

  Future<String> _queryAppSizeLabelId() async {
    final QueryResult labelIdResult = await client
        .query(QueryOptions(documentNode: PerfSizeLabelId.document));
    if (labelIdResult.hasException) {
      throw labelIdResult.exception;
    }
    final String id = $PerfSizeLabelId(labelIdResult.data).repository.label.id;
    if (_isVerbose) {
      print('"perf: app size" label id: $id');
    }
    return id;
  }

  static const String _kOptionMaxCount = 'max-count';
  static const String _kFlagVerbose = 'verbose';

  static const int _kPrintTreshold = 10;

  String _appSizeLabelId;
}
