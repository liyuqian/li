class $LabelId {
  const $LabelId(this.data);

  final Map<String, dynamic> data;

  $LabelId$repository get repository => data['repository'] == null
      ? null
      : $LabelId$repository((data['repository'] as Map<String, dynamic>));
}

class $LabelId$repository {
  const $LabelId$repository(this.data);

  final Map<String, dynamic> data;

  $LabelId$repository$label get label => data['label'] == null
      ? null
      : $LabelId$repository$label((data['label'] as Map<String, dynamic>));
}

class $LabelId$repository$label {
  const $LabelId$repository$label(this.data);

  final Map<String, dynamic> data;

  String get id => (data['id'] as String);
}
