import 'package:li/github/schema.public.schema.gql.dart' as _i1;

class $Issues {
  const $Issues(this.data);

  final Map<String, dynamic> data;

  $Issues$repository get repository => data['repository'] == null
      ? null
      : $Issues$repository((data['repository'] as Map<String, dynamic>));
}

class $Issues$repository {
  const $Issues$repository(this.data);

  final Map<String, dynamic> data;

  $Issues$repository$issues get issues => data['issues'] == null
      ? null
      : $Issues$repository$issues((data['issues'] as Map<String, dynamic>));
}

class $Issues$repository$issues {
  const $Issues$repository$issues(this.data);

  final Map<String, dynamic> data;

  $Issues$repository$issues$pageInfo get pageInfo => data['pageInfo'] == null
      ? null
      : $Issues$repository$issues$pageInfo(
          (data['pageInfo'] as Map<String, dynamic>));
  List<$Issues$repository$issues$edges> get edges => data['edges'] == null
      ? null
      : (data['edges'] as List)
          .map((dynamic e) =>
              $Issues$repository$issues$edges((e as Map<String, dynamic>)))
          .toList();
}

class $Issues$repository$issues$pageInfo {
  const $Issues$repository$issues$pageInfo(this.data);

  final Map<String, dynamic> data;

  bool get hasNextPage => (data['hasNextPage'] as bool);
  String get endCursor => (data['endCursor'] as String);
}

class $Issues$repository$issues$edges {
  const $Issues$repository$issues$edges(this.data);

  final Map<String, dynamic> data;

  $Issues$repository$issues$edges$node get node => data['node'] == null
      ? null
      : $Issues$repository$issues$edges$node(
          (data['node'] as Map<String, dynamic>));
}

class $Issues$repository$issues$edges$node {
  const $Issues$repository$issues$edges$node(this.data);

  final Map<String, dynamic> data;

  String get id => (data['id'] as String);
  String get title => (data['title'] as String);
  _i1.URI get url => _i1.URI((data['url'] as String));
  $Issues$repository$issues$edges$node$labels get labels =>
      data['labels'] == null
          ? null
          : $Issues$repository$issues$edges$node$labels(
              (data['labels'] as Map<String, dynamic>));
}

class $Issues$repository$issues$edges$node$labels {
  const $Issues$repository$issues$edges$node$labels(this.data);

  final Map<String, dynamic> data;

  List<$Issues$repository$issues$edges$node$labels$edges> get edges =>
      data['edges'] == null
          ? null
          : (data['edges'] as List)
              .map((dynamic e) =>
                  $Issues$repository$issues$edges$node$labels$edges(
                      (e as Map<String, dynamic>)))
              .toList();
}

class $Issues$repository$issues$edges$node$labels$edges {
  const $Issues$repository$issues$edges$node$labels$edges(this.data);

  final Map<String, dynamic> data;

  $Issues$repository$issues$edges$node$labels$edges$node get node =>
      data['node'] == null
          ? null
          : $Issues$repository$issues$edges$node$labels$edges$node(
              (data['node'] as Map<String, dynamic>));
}

class $Issues$repository$issues$edges$node$labels$edges$node {
  const $Issues$repository$issues$edges$node$labels$edges$node(this.data);

  final Map<String, dynamic> data;

  String get id => (data['id'] as String);
  String get name => (data['name'] as String);
}
