import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "nothesapla",
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dersAdi;
  int dersKredi = 1;
  double dersHarfDegeri = 4;
  List<Ders> tumDersler;
  var formKey = GlobalKey<FormState>();
  double ortalama = 0;
  static int sayac = 0;

  @override
  void initState() {
    super.initState();
    tumDersler = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Not Hesapla"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
          }
        },
        child: Icon(Icons.add),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return uygulamaGovdesi();
        } else {
          return uygulamaGovdesiLandscape();
        }
      }),
    );
  }

  uygulamaGovdesi() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "ders adı",
                      labelStyle: TextStyle(color: Colors.black, fontSize: 22),
                      hintText: "ders adı giriniz:",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      border: OutlineInputBorder(),
                    ),
                    validator: (girilendeger) {
                      if (girilendeger.length > 0) {
                        return null;
                      } else {
                        return "ders adı boş olamaz";
                      }
                    },
                    onSaved: (yeniDeger) {
                      dersAdi = yeniDeger;
                      setState(() {
                        tumDersler
                            .add(Ders(dersAdi, dersHarfDegeri, dersKredi));
                        ortalama = 0;
                        ortalamayiHesapla();
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: DropdownButton(
                            items: dersKredileriItems(),
                            value: dersKredi,
                            onChanged: (secilenKredi) {
                              setState(() {
                                dersKredi = secilenKredi;
                              });
                            }),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: DropdownButton(
                            items: dersHarfNotlariItems(),
                            value: dersHarfDegeri,
                            onChanged: (secilenHarf) {
                              setState(() {
                                dersHarfDegeri = secilenHarf;
                              });
                            }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 70,
            color: Colors.blue,
            child: Center(
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: tumDersler.length == 0
                          ? "lütfen ders ekleyin"
                          : "ortalama: ",
                      style: TextStyle(fontSize: 24)),
                  TextSpan(
                      text: tumDersler.length == 0
                          ? ""
                          : "${ortalama.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 24)),
                ]),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemBuilder: _listeElemanlariniOlustur,
                itemCount: tumDersler.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  dersKredileriItems() {
    List<DropdownMenuItem<int>> krediler = [];
    for (var i = 1; i < 7; i++) {
      krediler.add(DropdownMenuItem<int>(
        value: i,
        child: Text("$i kredi"),
      ));
    }
    return krediler;
  }

  dersHarfNotlariItems() {
    List<DropdownMenuItem<double>> harfler = [];
    harfler.add(DropdownMenuItem(child: Text(" AA "), value: 4));
    harfler.add(DropdownMenuItem(child: Text(" BA "), value: 3.5));
    harfler.add(DropdownMenuItem(child: Text(" BB "), value: 3));
    harfler.add(DropdownMenuItem(child: Text(" CB "), value: 2.5));
    harfler.add(DropdownMenuItem(child: Text(" CC "), value: 2));
    harfler.add(DropdownMenuItem(child: Text(" DC "), value: 1.5));
    harfler.add(DropdownMenuItem(child: Text(" DD "), value: 1));
    harfler.add(DropdownMenuItem(child: Text(" FF "), value: 0));
    return harfler;
  }

  Widget _listeElemanlariniOlustur(BuildContext context, int index) {
    sayac++;
    print(sayac);
    return Dismissible(
      key: Key(sayac.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          tumDersler.removeAt(index);
          ortalamayiHesapla();
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.black),
        ),
        margin: EdgeInsets.all(10),
        elevation: 10,
        child: ListTile(
          leading: Icon(Icons.done),
          title: Text(tumDersler[index].ad),
          subtitle: Text(
              "kredi: ${tumDersler[index].kredi} , harf notu: ${tumDersler[index].harfDegeri} "),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }

  void ortalamayiHesapla() {
    double toplamNot = 0;
    double toplamKredi = 0;
    for (var oankiDers in tumDersler) {
      var kredi = oankiDers.kredi;
      var harfDegeri = oankiDers.harfDegeri;
      toplamNot = toplamNot + (harfDegeri * kredi);
      toplamKredi += kredi;
    }
    ortalama = toplamNot / toplamKredi;
  }

  Widget uygulamaGovdesiLandscape() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "ders adı",
                            labelStyle:
                                TextStyle(color: Colors.black, fontSize: 22),
                            hintText: "ders adı giriniz:",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            border: OutlineInputBorder(),
                          ),
                          validator: (girilendeger) {
                            if (girilendeger.length > 0) {
                              return null;
                            } else {
                              return "ders adı boş olamaz";
                            }
                          },
                          onSaved: (yeniDeger) {
                            dersAdi = yeniDeger;
                            setState(() {
                              tumDersler.add(
                                  Ders(dersAdi, dersHarfDegeri, dersKredi));
                              ortalama = 0;
                              ortalamayiHesapla();
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: DropdownButton(
                                  items: dersKredileriItems(),
                                  value: dersKredi,
                                  onChanged: (secilenKredi) {
                                    setState(() {
                                      dersKredi = secilenKredi;
                                    });
                                  }),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: DropdownButton(
                                  items: dersHarfNotlariItems(),
                                  value: dersHarfDegeri,
                                  onChanged: (secilenHarf) {
                                    setState(() {
                                      dersHarfDegeri = secilenHarf;
                                    });
                                  }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    color: Colors.blue,
                    child: Center(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: tumDersler.length == 0
                                  ? "lütfen ders ekleyin"
                                  : "ortalama: ",
                              style: TextStyle(fontSize: 24)),
                          TextSpan(
                              text: tumDersler.length == 0
                                  ? ""
                                  : "${ortalama.toStringAsFixed(2)}",
                              style: TextStyle(fontSize: 24)),
                        ]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            flex: 2,
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: ListView.builder(
                itemBuilder: _listeElemanlariniOlustur,
                itemCount: tumDersler.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Ders {
  String ad;
  double harfDegeri;
  int kredi;

  Ders(this.ad, this.harfDegeri, this.kredi);
}
