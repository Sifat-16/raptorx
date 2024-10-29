class CreateBrandGeneric {
  int selected;
  List<String> brands;

  CreateBrandGeneric(
      {this.selected = 0, this.brands = const ["Ezycourse", "Mechanic"]});

  CreateBrandGeneric update({
    int? selected,
  }) {
    return CreateBrandGeneric(selected: selected ?? this.selected);
  }
}
