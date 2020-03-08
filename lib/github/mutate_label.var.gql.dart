class MutateLabelVarBuilder {
  final Map<String, dynamic> variables = <String, dynamic>{};

  set issueId(String value) => variables['issueId'] = value;
  set labelId(String value) => variables['labelId'] = value;
}
