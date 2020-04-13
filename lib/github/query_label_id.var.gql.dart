class LabelIdVarBuilder {
  final Map<String, dynamic> variables = <String, dynamic>{};

  set name(String value) => variables['name'] = value;
  set repoOwner(String value) => variables['repoOwner'] = value;
  set repoName(String value) => variables['repoName'] = value;
}
