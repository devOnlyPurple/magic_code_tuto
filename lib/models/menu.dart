class Menu {
  String? keyMenu;
  String? nomMenu;
  String? codeMenu;
  String? nameTranslate;
  String? typeMenu;
  String? icone;
  String? etat;
  bool? isActive;

  Menu({
    this.keyMenu,
    this.nomMenu,
    this.codeMenu,
    this.nameTranslate,
    this.typeMenu,
    this.icone,
    this.etat,
    this.isActive = true,
  });

  Menu.fromJson(Map<String, dynamic> json) {
    keyMenu = json['key_menu'];
    nomMenu = json['nom_menu'];
    codeMenu = json['code_menu'];
    nameTranslate = json['name_translate'];
    typeMenu = json['type_menu'];
    icone = json['icone'];
    etat = json['etat'].toString();
    // isActive = json['isActive'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key_menu'] = keyMenu;
    data['nom_menu'] = nomMenu;
    data['code_menu'] = codeMenu;
    data['name_translate'] = nameTranslate;
    data['type_menu'] = typeMenu;
    data['icone'] = icone;
    data['etat'] = etat;
    // data['isActive'] = this.isActive;
    return data;
  }
}
