class $MutateLabel {
  const $MutateLabel(this.data);

  final Map<String, dynamic> data;

  $MutateLabel$addLabelsToLabelable get addLabelsToLabelable =>
      data['addLabelsToLabelable'] == null
          ? null
          : $MutateLabel$addLabelsToLabelable(
              (data['addLabelsToLabelable'] as Map<String, dynamic>));
}

class $MutateLabel$addLabelsToLabelable {
  const $MutateLabel$addLabelsToLabelable(this.data);

  final Map<String, dynamic> data;

  $MutateLabel$addLabelsToLabelable$labelable get labelable =>
      data['labelable'] == null
          ? null
          : $MutateLabel$addLabelsToLabelable$labelable(
              (data['labelable'] as Map<String, dynamic>));
}

class $MutateLabel$addLabelsToLabelable$labelable {
  const $MutateLabel$addLabelsToLabelable$labelable(this.data);

  final Map<String, dynamic> data;

  $MutateLabel$addLabelsToLabelable$labelable$labels get labels =>
      data['labels'] == null
          ? null
          : $MutateLabel$addLabelsToLabelable$labelable$labels(
              (data['labels'] as Map<String, dynamic>));
}

class $MutateLabel$addLabelsToLabelable$labelable$labels {
  const $MutateLabel$addLabelsToLabelable$labelable$labels(this.data);

  final Map<String, dynamic> data;

  int get totalCount => (data['totalCount'] as int);
}
