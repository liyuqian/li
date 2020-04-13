import 'package:graphql/client.dart';
import 'package:li/github/base.dart';
import 'package:li/github/mutate_label.data.gql.dart';
import 'package:li/github/mutate_label.op.gql.dart';
import 'package:li/github/mutate_label.var.gql.dart';
import 'package:li/github/query_issues_by_label.data.gql.dart';
import 'package:li/github/query_issues_by_label.op.gql.dart';
import 'package:li/github/query_issues_by_label.var.gql.dart';

/// Helper class of [ApplyLabelCommand] and [LabelSizeCommand] that applies one
/// label to all issues with another label.
class ApplyLabelHandler {
  ApplyLabelHandler(this.client, this.maxCount, this.isVerbose);

  Future<void> apply(String fromLabel, String toLabel) async {
    final String toLabelId = await _queryLabelId(toLabel);

    int addCount = 0;
    int readCount = 0;

    String afterCursor;
    bool hasNextPage = true;
    while (hasNextPage && addCount < maxCount) {
      final varBuilder = IssuesByLabelVarBuilder();
      varBuilder.after = afterCursor;
      varBuilder.label = fromLabel;
      final QueryResult issuesResult = await client.query(QueryOptions(
        documentNode: IssuesByLabel.document,
        variables: varBuilder.variables,
      ));

      final issues = $IssuesByLabel(issuesResult.data);

      for (var issueEdge in issues.repository.issues.edges) {
        readCount += 1;

        if (isVerbose) {
          print('Checking issue "${issueEdge.node.title}"');
          print('               (${issueEdge.node.url.value})\n');
        }

        if (readCount % _kPrintTreshold == 0) {
          print('Number of issues processed: $readCount');
        }

        if (!_issueHasLabel(issueEdge, toLabelId)) {
          await _addLabelToIssue(toLabelId, issueEdge);
          addCount += 1;
          if (addCount >= maxCount) {
            break;
          }
        }
      }

      final pageInfo = issues.repository.issues.pageInfo;
      hasNextPage = pageInfo.hasNextPage;
      afterCursor = pageInfo.endCursor;
    }

    print('Total number of issues processed: $readCount');
    print('Total number of issues modified:  $addCount');
  }

  final GraphQLClient client;
  final bool isVerbose;
  final int maxCount;

  static const int _kPrintTreshold = 10;

  bool _issueHasLabel(
      $IssuesByLabel$repository$issues$edges issueEdges, String labelId) {
    for (var edge in issueEdges.node.labels.edges) {
      if (edge.node.id == labelId) {
        return true;
      }
    }
    return false;
  }

  Future<void> _addLabelToIssue(
      String labelId, $IssuesByLabel$repository$issues$edges issueEdge) async {
    final varBuilder = MutateLabelVarBuilder();
    varBuilder.issueId = issueEdge.node.id;
    varBuilder.labelId = labelId;
    final QueryResult result = await client.mutate(MutationOptions(
        documentNode: MutateLabel.document, variables: varBuilder.variables));
    if (result.hasException) {
      throw result.exception;
    }
    final parsedResult = $MutateLabel(result.data);
    final int totalCount =
        parsedResult.addLabelsToLabelable.labelable.labels.totalCount;
    print(
      'Added label to "${issueEdge.node.title}" '
      '(${issueEdge.node.url.value} now has $totalCount labels)',
    );
  }

  Future<String> _queryLabelId(String labelName) async {
    final String id =
        await queryLabelId(client, labelName, kFlutterOwner, kFlutterRepoName);
    if (isVerbose) {
      print('"$labelName" label id: $id');
    }
    return id;
  }
}

class ApplyLabelCommand extends GithubClientCommand {
  ApplyLabelCommand() {
    argParser.addOption(
      _kOptionFrom,
      help: 'the label of issues from which new label will be applied',
    );
    argParser.addOption(
      _kOptionTo,
      help: 'the new label to be applied',
    );
    argParser.addOption(
      _kOptionMaxCount,
      defaultsTo: '1',
      help: 'max number of issues to be labeled',
    );
  }

  @override
  String get description => 'Apply one label to all issues with another label.';

  @override
  String get name => 'apply_label';

  @override
  Future<void> runWithClientReady() async {
    if (_fromLabel == null || _toLabel == null) {
      print(usage);
      throw ('Option --from and --to must be specified');
    }
    final int maxCount = int.parse(argResults[_kOptionMaxCount]);
    final handler =
        ApplyLabelHandler(client, maxCount, isVerbose);
    await handler.apply(_fromLabel, _toLabel);
  }

  String get _fromLabel => argResults[_kOptionFrom];
  String get _toLabel => argResults[_kOptionTo];

  static const String _kOptionFrom = 'from';
  static const String _kOptionTo = 'to';
  static const String _kOptionMaxCount = 'max-count';
}
