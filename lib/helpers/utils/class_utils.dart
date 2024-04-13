
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kondjigbale/models/user.dart';

class ClassUtils {
  static Color colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  static Future<void> navigateTo(BuildContext context, Widget page) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  static void pushing(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static Future<void> navigatePushRTo(BuildContext context, Widget page) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  Future<bool> createLoginSession(User userInfo) async {
    const storage = FlutterSecureStorage();

    // await storage.write(key: 'information_user', value: info);
    await storage.write(key: 'nom', value: userInfo.nom);
    await storage.write(key: 'prenoms', value: userInfo.prenoms);
    await storage.write(key: 'username', value: userInfo.username);
    await storage.write(key: 'u_identifiant', value: userInfo.token);
    await storage.write(key: 'adresse', value: userInfo.adresse);
    await storage.write(key: 'email', value: userInfo.email);
    await storage.write(key: 'photo', value: userInfo.photo);
    // await storage.write(
    //     key: 'typeUserid', value: userInfo.typeUserId.toString());
    await storage.write(key: 'typeUsername', value: userInfo.userProfil);
    await storage.write(key: 'date_naissance', value: userInfo.dateNaissance);
    await storage.write(key: 'sexe', value: userInfo.sexe.toString());
    // await storage.write(key: 'sexename', value: userInfo.sexe);
    await storage.write(key: 'ville_key', value: userInfo.villeKey);
    await storage.write(key: 'ville_nom', value: userInfo.villeNom);
    await storage.write(
        key: 'groupe_sanguin_key', value: userInfo.groupeSanguinKey);
    await storage.write(
        key: 'groupe_sanguin_name', value: userInfo.groupeSanguinName);
    await storage.write(key: 'user_profil', value: userInfo.userProfil);
    await storage.write(
        key: 'idUserProfil', value: userInfo.idUserProfil.toString());
    await storage.write(key: 'date_naissance', value: userInfo.dateNaissance);
    await storage.write(
        key: 'num_identif_unique', value: userInfo.numIdentifUnique);
    // await storage.write(key: 'devise_abreg', value: userInfo.);
    await storage.write(key: 'paysKey', value: userInfo.paysKey);
    await storage.write(key: 'paysName', value: userInfo.paysNom);

    print("Connected ${userInfo.nom}");

    bool response = true;
    return response;
  }

  Future<User> getUserInformation() async {
    const storage = FlutterSecureStorage();

    User information = User();

    information.nom = await storage.read(key: 'nom') ?? "";
    information.prenoms = await storage.read(key: 'prenoms') ?? "";
    information.username = await storage.read(key: 'username') ?? "";
    information.token = await storage.read(key: 'u_identifiant') ?? "";
    information.adresse = await storage.read(key: 'adresse') ?? "";
    information.email = await storage.read(key: 'email') ?? "";
    information.photo = await storage.read(key: 'photo') ?? "";

    String? idUserProfilString = await storage.read(key: "idUserProfil");
    information.idUserProfil = int.tryParse(idUserProfilString ?? "") ?? 1;
    information.userProfil = await storage.read(key: 'typeUsername') ?? "";
    // information.typeUserName = await storage.read(key: 'typeUsername') ?? "";
    information.dateNaissance =
        await storage.read(key: 'date_naissance') ?? "0000-00-00";
    String? sexeString = await storage.read(key: "sexe");
    information.sexe = int.tryParse(sexeString ?? "") ?? 1;

    information.villeKey = await storage.read(key: 'ville_key') ?? "";
    information.villeNom = await storage.read(key: 'ville_nom') ?? "";
    information.userProfil = await storage.read(key: 'user_profil') ?? "";
    // String? inscriptionPresta = await storage.read(key: "inscription_presta");
    // information.inscriptionPresta = int.tryParse(inscriptionPresta ?? "") ?? 0;
    // String? paysId = await storage.read(key: "paysId");
    // information.paysNom = int.tryParse(paysId ?? "") ?? 0;
    information.paysKey = await storage.read(key: 'paysKey') ?? "";
    information.paysNom = await storage.read(key: 'paysName') ?? "";
    information.groupeSanguinKey =
        await storage.read(key: 'groupe_sanguin_key') ?? "";
    information.groupeSanguinName =
        await storage.read(key: 'groupe_sanguin_name') ?? "";
    information.numIdentifUnique =
        await storage.read(key: 'num_identif_unique') ?? "";

    return information;
  }
}
