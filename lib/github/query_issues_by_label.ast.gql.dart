import 'package:gql/ast.dart' as _i1;

const IssuesByLabel = _i1.OperationDefinitionNode(
    type: _i1.OperationType.query,
    name: _i1.NameNode(value: 'IssuesByLabel'),
    variableDefinitions: [
      _i1.VariableDefinitionNode(
          variable: _i1.VariableNode(name: _i1.NameNode(value: 'label')),
          type: _i1.NamedTypeNode(
              name: _i1.NameNode(value: 'String'), isNonNull: true),
          defaultValue: _i1.DefaultValueNode(value: null),
          directives: []),
      _i1.VariableDefinitionNode(
          variable: _i1.VariableNode(name: _i1.NameNode(value: 'after')),
          type: _i1.NamedTypeNode(
              name: _i1.NameNode(value: 'String'), isNonNull: false),
          defaultValue: _i1.DefaultValueNode(value: null),
          directives: [])
    ],
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
                name: _i1.NameNode(value: 'issues'),
                alias: null,
                arguments: [
                  _i1.ArgumentNode(
                      name: _i1.NameNode(value: 'first'),
                      value: _i1.IntValueNode(value: '100')),
                  _i1.ArgumentNode(
                      name: _i1.NameNode(value: 'after'),
                      value:
                          _i1.VariableNode(name: _i1.NameNode(value: 'after'))),
                  _i1.ArgumentNode(
                      name: _i1.NameNode(value: 'labels'),
                      value: _i1.ListValueNode(values: [
                        _i1.VariableNode(name: _i1.NameNode(value: 'label'))
                      ]))
                ],
                directives: [],
                selectionSet: _i1.SelectionSetNode(selections: [
                  _i1.FieldNode(
                      name: _i1.NameNode(value: 'pageInfo'),
                      alias: null,
                      arguments: [],
                      directives: [],
                      selectionSet: _i1.SelectionSetNode(selections: [
                        _i1.FieldNode(
                            name: _i1.NameNode(value: 'hasNextPage'),
                            alias: null,
                            arguments: [],
                            directives: [],
                            selectionSet: null),
                        _i1.FieldNode(
                            name: _i1.NameNode(value: 'endCursor'),
                            alias: null,
                            arguments: [],
                            directives: [],
                            selectionSet: null)
                      ])),
                  _i1.FieldNode(
                      name: _i1.NameNode(value: 'edges'),
                      alias: null,
                      arguments: [],
                      directives: [],
                      selectionSet: _i1.SelectionSetNode(selections: [
                        _i1.FieldNode(
                            name: _i1.NameNode(value: 'node'),
                            alias: null,
                            arguments: [],
                            directives: [],
                            selectionSet: _i1.SelectionSetNode(selections: [
                              _i1.FieldNode(
                                  name: _i1.NameNode(value: 'id'),
                                  alias: null,
                                  arguments: [],
                                  directives: [],
                                  selectionSet: null),
                              _i1.FieldNode(
                                  name: _i1.NameNode(value: 'title'),
                                  alias: null,
                                  arguments: [],
                                  directives: [],
                                  selectionSet: null),
                              _i1.FieldNode(
                                  name: _i1.NameNode(value: 'url'),
                                  alias: null,
                                  arguments: [],
                                  directives: [],
                                  selectionSet: null),
                              _i1.FieldNode(
                                  name: _i1.NameNode(value: 'labels'),
                                  alias: null,
                                  arguments: [
                                    _i1.ArgumentNode(
                                        name: _i1.NameNode(value: 'first'),
                                        value: _i1.IntValueNode(value: '100'))
                                  ],
                                  directives: [],
                                  selectionSet:
                                      _i1.SelectionSetNode(selections: [
                                    _i1.FieldNode(
                                        name: _i1.NameNode(value: 'edges'),
                                        alias: null,
                                        arguments: [],
                                        directives: [],
                                        selectionSet:
                                            _i1.SelectionSetNode(selections: [
                                          _i1.FieldNode(
                                              name: _i1.NameNode(value: 'node'),
                                              alias: null,
                                              arguments: [],
                                              directives: [],
                                              selectionSet:
                                                  _i1.SelectionSetNode(
                                                      selections: [
                                                    _i1.FieldNode(
                                                        name: _i1.NameNode(
                                                            value: 'id'),
                                                        alias: null,
                                                        arguments: [],
                                                        directives: [],
                                                        selectionSet: null),
                                                    _i1.FieldNode(
                                                        name: _i1.NameNode(
                                                            value: 'name'),
                                                        alias: null,
                                                        arguments: [],
                                                        directives: [],
                                                        selectionSet: null)
                                                  ]))
                                        ]))
                                  ]))
                            ]))
                      ]))
                ]))
          ]))
    ]));
const document = _i1.DocumentNode(definitions: [IssuesByLabel]);
