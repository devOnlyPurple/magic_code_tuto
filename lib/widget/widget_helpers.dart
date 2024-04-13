import 'package:flutter/material.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';

// Custom circular loading
Future<void> CustomErrorDialog(BuildContext context,
    {String? content, String buttonText = "ok", VoidCallback? onPressed}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "",
    pageBuilder: (ctx, a1, a2) {
      return Container();
    },
    transitionBuilder: (ctx, a1, a2, child) {
      var curve = Curves.easeInOut.transform(a1.value);
      return ScaleTransition(
          // scale: curve,
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
            child: AlertDialog(
              scrollable: true,
              title: const Text(
                "Erreur !",
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 18, color: kRed),
              ),
              content: Text(
                content!,
                style: const TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 14, color: kBlack),
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: kRed.withOpacity(0.2)),
                  onPressed: onPressed ??
                      () {
                        Navigator.of(context).pop();
                      },
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16, color: kRed),
                  ),
                ),
              ],
            ),
          ));
    },
    transitionDuration: const Duration(milliseconds: 200),
  );
}

Future<void> CustomLoading(BuildContext context,
    {Widget content = const CircularProgressIndicator(
      backgroundColor: Kprimary,
      color: Ksecondary,
    ),
    String status = "Chargement en cours",
    bool dismissOnTap = false}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: dismissOnTap,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            content,
            Br20(),
            Text(status,
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 14))
          ],
        ),
      );
    },
  );
}

InputDecoration CustomDecorationMethod(
    {String label = "",
    bool labelIsText = true,
    Widget? widgetLabel,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? hintText,
    BoxConstraints? prefixIconConstraints}) {
  return InputDecoration(
      filled: true,
      hintText: hintText,
      prefixIconConstraints: prefixIconConstraints,
      contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
      label: labelIsText
          ? Text(
              label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 14, color: kBlack),
            )
          : widgetLabel,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      fillColor: Kprimary.withOpacity(0.2),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(width: 0, color: Kgreen.withOpacity(0))),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(width: 3, color: Kgreen.withOpacity(1))),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(width: 3, color: Kgreen.withOpacity(1))),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(width: 2, color: kRed.withOpacity(1))));
}

Future<void> CustomSoonDialog(BuildContext context, {Widget? content}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: const Text(
          "Bientôt disponible",
          style: TextStyle(
              fontWeight: FontWeight.w700, fontSize: 18, color: kBlack),
        ),
        content: const Text(
          "Cette fonctionnalité est en cours de déploiement et sera bientôt disponible chez vous. Merci de votre patience.",
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 14, color: kBlack),
        ),
        actions: <Widget>[
          TextButton(
            style:
                TextButton.styleFrom(backgroundColor: Kgreen.withOpacity(0.2)),
            child: const Text(
              "J'ai compris",
              style: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 16, color: Kgreen),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> CustomChoixDialog(BuildContext context,
    {String? content,
    String? title,
    String? cancelText,
    String? acceptText,
    void Function()? cancelPress,
    final VoidCallback? acceptPress,
    String type = "Alert"}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: Text(
          title!,
          softWrap: true,
          style: const TextStyle(
              fontWeight: FontWeight.w700, fontSize: 18, color: kBlack),
        ),
        content: Text(
          content!,
          style: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: 14, color: kBlack),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: cancelPress,
            child: Text(
              cancelText!,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: type == "Alert" ? Kgreen : kRed),
            ),
          ),
          TextButton(
            onPressed: acceptPress,
            child: Text(
              acceptText!,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: type == "Alert" ? kRed : Kgreen),
            ),
          ),
        ],
      );
    },
  );
}
