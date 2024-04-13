// ignore_for_file: prefer_const_constructors


import 'package:flutter/material.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/models/about.dart';

class AboutPage extends StatefulWidget {
  AboutPage({super.key, required this.data});
  List<About> data;
  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var info = widget.data[0];
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Br10(),
              Row(
                children: [
                  Text(
                    "A propos",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.close,
                        color: Kprimary,
                        size: 25,
                      )),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
              Br30(),
              Image.asset(info.logo!),
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Br20(),
                    Text(info.nomsociete!),
                    Br5(),
                    Text('${info.firstdes!}.'),
                    Br5(),
                    Text('Version ${info.version!}'),
                    Br20(),
                    Text('Contacts: ${info.contacts!}'),
                    Br5(),
                    Text(
                      'Email: ${info.email!}',
                      style: TextStyle(fontSize: 12),
                    ),
                    Br3(),
                    Text(
                      'Site web: ${info.siteweb!}',
                      style: TextStyle(fontSize: 12),
                    ),
                    Br20(),
                    Text(
                      '${info.descapp!}.',
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              Br20(),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Fermer',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Kprimary,
                        fontSize: 15),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
