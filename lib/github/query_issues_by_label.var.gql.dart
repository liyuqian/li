class IssuesByLabelVarBuilder {
  final Map<String, dynamic> variables = <String, dynamic>{};

  set label(String value) => variables['label'] = value;
  set after(String value) => variables['after'] = value;
}
