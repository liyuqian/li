import 'package:gql/ast.dart' as _i1;

const PerfSizeLabelId = _i1.OperationDefinitionNode(
    type: _i1.OperationType.query,
    name: _i1.NameNode(value: 'PerfSizeLabelId'),
    variableDefinitions: [],
    directives: [],
    selectionSet: _i1.SelectionSetNode(selections: [
      _i1.FieldNode(
          name: _i1.NameNode(value: 'repository'),
          alias: null,
          arguments: [
            _i1.ArgumentNode(
                name: _i1.NameNode(value: 'owner'),
                value: _i1.StringValueNode(value: 'flutter', isBlock: false)),
            _i1.ArgumentNode(
                name: _i1.NameNode(value: 'name'),
                value: _i1.StringValueNode(value: 'flutter', isBlock: false))
          ],
          directives: [],
          selectionSet: _i1.SelectionSetNode(selections: [
            _i1.FieldNode(
                name: _i1.NameNode(value: 'label'),
                alias: null,
                arguments: [
                  _i1.ArgumentNode(
                      name: _i1.NameNode(value: 'name'),
                      value: _i1.StringValueNode(
                          value: 'perf: app size', isBlock: false))
                ],
                directives: [],
                selectionSet: _i1.SelectionSetNode(selections: [
                  _i1.FieldNode(
                      name: _i1.NameNode(value: 'id'),
                      alias: null,
                      arguments: [],
                      directives: [],
                      selectionSet: null)
                ]))
          ]))
    ]));
const document = _i1.DocumentNode(definitions: [PerfSizeLabelId]);
