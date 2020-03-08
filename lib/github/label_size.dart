import 'package:graphql/client.dart';
import 'package:li/github/base.dart';

class LabelSizeCommand extends BaseCommand {
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
  Future<void> run() async {
    _appSizeLabelId = await _queryAppSizeLabelId();

    final isVerbose = argResults[_kFlagVerbose];

    final int maxCount = int.parse(argResults[_kOptionMaxCount]);
    int addCount = 0;
    int readCount = 0;

    String afterCursor;
    bool hasNextPage = true;
    while (hasNextPage && addCount < maxCount) {
      final QueryResult issuesResult = await client.query(QueryOptions(
        documentNode: gql(_kQueryIssues),
        variables: {kAfter: afterCursor},
      ));

      final issueEdges = issuesResult.data[kRepository][kIssues][kEdges];
      for (var issueEdge in issueEdges) {
        readCount += 1;

        if (isVerbose) {
          print('Checking issue "${issueEdge[kNode][kTitle]}"');
          print('               "${issueEdge[kNode][kUrl]}"');
        }

        if (readCount % _kPrintTreshold == 0) {
          print('Number of issues processed: $readCount');
        }

        if (!_hasAppSizeLabel(issueEdge[kNode][kLabels][kEdges])) {
          await _addAppSizeLabel(issueEdge[kNode]);
          addCount += 1;
          if (addCount >= maxCount) {
            break;
          }
        }
        ;
      }

      final pageInfo = issuesResult.data[kRepository][kIssues][kPageInfo];
      hasNextPage = pageInfo[kHasNextPage];
      afterCursor = pageInfo[kEndCursor];
    }

    print('Total number of issues processed: $readCount');
    print('Total number of issues modified:  $addCount');
  }

  Future<void> _addAppSizeLabel(Map<String, dynamic> issue) async {
    final QueryResult result = await client
        .mutate(MutationOptions(documentNode: gql(_kMutateLabel), variables: {
      _kIssueId: issue[kId],
      _kLabelId: _appSizeLabelId,
    }));
    if (result.hasException) {
      throw result.exception;
    }
    print(result.data);
    final int totalCount = result.data['addLabelsToLabelable']['labelable']
        ['labels']['totalCount'];
    print(
        'Added label to ${issue[kUrl]} (${issue[kId]} now has $totalCount labels)');
  }

  bool _hasAppSizeLabel(List<dynamic> labelEdges) {
    for (var edge in labelEdges) {
      if (edge[kNode][kId] == _appSizeLabelId) {
        return true;
      }
    }
    return false;
  }

  Future<String> _queryAppSizeLabelId() async {
    final QueryResult labelIdResult = await client
        .query(QueryOptions(documentNode: gql(_kQueryPerfSizeLabelId)));
    if (labelIdResult.hasException) {
      throw labelIdResult.exception;
    }
    return labelIdResult.data[kRepository][kLabel][kId];
  }

  static const String _kOptionMaxCount = 'max-count';
  static const String _kFlagVerbose = 'verbose';

  static const int _kPrintTreshold = 10;

  String _appSizeLabelId;
}

const String _kQueryPerfSizeLabelId = '''
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
    $kIssues(first: 100, $kAfter: \$$kAfter, labels:["a: size"]) {
      $kPageInfo {
        $kHasNextPage
        $kEndCursor
      }
      $kEdges {
        $kNode {
          $kId
          $kTitle
          $kUrl
          $kLabels(first: 100) {
            $kEdges {
              $kNode {
                $kId
                name
              }
            }
          }
        }
      }
    }
  }
}
''';

const String _kMutateLabel = '''
mutation MutateLabel(\$$_kIssueId: String!, \$$_kLabelId: String!) {
  addLabelsToLabelable(
    input: {labelableId: \$$_kIssueId, labelIds: [\$$_kLabelId]}
  ) {
    labelable {
      labels {
        totalCount
      }
    }
  }
}''';

const String _kIssueId = 'issueId';
const String _kLabelId = 'labelId';
