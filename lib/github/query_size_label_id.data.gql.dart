class $PerfSizeLabelId {
  const $PerfSizeLabelId(this.data);

  final Map<String, dynamic> data;

  $PerfSizeLabelId$repository get repository => data['repository'] == null
      ? null
      : $PerfSizeLabelId$repository(
          (data['repository'] as Map<String, dynamic>));
}

class $PerfSizeLabelId$repository {
  const $PerfSizeLabelId$repository(this.data);

  final Map<String, dynamic> data;

  $PerfSizeLabelId$repository$label get label => data['label'] == null
      ? null
      : $PerfSizeLabelId$repository$label(
          (data['label'] as Map<String, dynamic>));
}

class $PerfSizeLabelId$repository$label {
  const $PerfSizeLabelId$repository$label(this.data);

  final Map<String, dynamic> data;

  String get id => (data['id'] as String);
}
