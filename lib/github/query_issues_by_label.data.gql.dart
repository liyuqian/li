import 'package:li/github/schema.public.schema.gql.dart' as _i1;

class $IssuesByLabel {
  const $IssuesByLabel(this.data);

  final Map<String, dynamic> data;

  $IssuesByLabel$repository get repository => data['repository'] == null
      ? null
      : $IssuesByLabel$repository((data['repository'] as Map<String, dynamic>));
}

class $IssuesByLabel$repository {
  const $IssuesByLabel$repository(this.data);

  final Map<String, dynamic> data;

  $IssuesByLabel$repository$issues get issues => data['issues'] == null
      ? null
      : $IssuesByLabel$repository$issues(
          (data['issues'] as Map<String, dynamic>));
}

class $IssuesByLabel$repository$issues {
  const $IssuesByLabel$repository$issues(this.data);

  final Map<String, dynamic> data;

  $IssuesByLabel$repository$issues$pageInfo get pageInfo => data['pageInfo'] ==
          null
      ? null
      : $IssuesByLabel$repository$issues$pageInfo(
          (data['pageInfo'] as Map<String, dynamic>));
  List<$IssuesByLabel$repository$issues$edges> get edges =>
      data['edges'] == null
          ? null
          : (data['edges'] as List)
              .map((dynamic e) => $IssuesByLabel$repository$issues$edges(
                  (e as Map<String, dynamic>)))
              .toList();
}

class $IssuesByLabel$repository$issues$pageInfo {
  const $IssuesByLabel$repository$issues$pageInfo(this.data);

  final Map<String, dynamic> data;

  bool get hasNextPage => (data['hasNextPage'] as bool);
  String get endCursor => (data['endCursor'] as String);
}

class $IssuesByLabel$repository$issues$edges {
  const $IssuesByLabel$repository$issues$edges(this.data);

  final Map<String, dynamic> data;

  $IssuesByLabel$repository$issues$edges$node get node => data['node'] == null
      ? null
      : $IssuesByLabel$repository$issues$edges$node(
          (data['node'] as Map<String, dynamic>));
}

class $IssuesByLabel$repository$issues$edges$node {
  const $IssuesByLabel$repository$issues$edges$node(this.data);

  final Map<String, dynamic> data;

  String get id => (data['id'] as String);
  String get title => (data['title'] as String);
  _i1.URI get url => _i1.URI((data['url'] as String));
  $IssuesByLabel$repository$issues$edges$node$labels get labels =>
      data['labels'] == null
          ? null
          : $IssuesByLabel$repository$issues$edges$node$labels(
              (data['labels'] as Map<String, dynamic>));
}

class $IssuesByLabel$repository$issues$edges$node$labels {
  const $IssuesByLabel$repository$issues$edges$node$labels(this.data);

  final Map<String, dynamic> data;

  List<$IssuesByLabel$repository$issues$edges$node$labels$edges> get edges =>
      data['edges'] == null
          ? null
          : (data['edges'] as List)
              .map((dynamic e) =>
                  $IssuesByLabel$repository$issues$edges$node$labels$edges(
                      (e as Map<String, dynamic>)))
              .toList();
}

class $IssuesByLabel$repository$issues$edges$node$labels$edges {
  const $IssuesByLabel$repository$issues$edges$node$labels$edges(this.data);

  final Map<String, dynamic> data;

  $IssuesByLabel$repository$issues$edges$node$labels$edges$node get node =>
      data['node'] == null
          ? null
          : $IssuesByLabel$repository$issues$edges$node$labels$edges$node(
              (data['node'] as Map<String, dynamic>));
}

class $IssuesByLabel$repository$issues$edges$node$labels$edges$node {
  const $IssuesByLabel$repository$issues$edges$node$labels$edges$node(
      this.data);

  final Map<String, dynamic> data;

  String get id => (data['id'] as String);
  String get name => (data['name'] as String);
}
