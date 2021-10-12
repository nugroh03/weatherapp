import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:weather_app/constans.dart';
import 'package:weather_app/model/provinces_model.dart';
import 'package:weather_app/model/regencies_model.dart';
import 'package:weather_app/pages/second_page.dart';

class FirstPage extends StatefulWidget {
  FirstPage({
    Key? key,
  }) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final TextEditingController _namaLengkapController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  TextEditingController _kotaController = TextEditingController();
  TextEditingController _kecamatanController = TextEditingController();
  bool isShow = true;
  bool isLoading = false;
  var province_id;
  final formKey = GlobalKey<FormState>();
  bool isLoadings = true;
  bool connected = false;
  showPass() {
    setState(() {
      isShow = !isShow;
    });
  }

  List<ProvinceModel> provinciesData = [];
  List<RegenciesModel> regenciesData = [];

  Future fetchProvince() async {
    setState(() {
      isLoading = true;
    });

    final String response =
        await rootBundle.loadString('assets/provinces.json');
    var province = json.decode(response);
    var provinceJson = province as List;
    for (int i = 0; i < provinceJson.length; i++) {
      provinciesData.add(new ProvinceModel.fromJson(provinceJson[i]));
    }
    setState(() {
      isLoading = false;
    });
  }

  void fetchRegencies(provinceId) async {
    setState(() {
      isLoading = true;
    });

    final String response =
        await rootBundle.loadString('assets/regencies.json');
    var regencies = json.decode(response);

    var dataregency =
        regencies.where((item) => item['province_id'] == provinceId);
    // var regenciess=regencies.where(
    //                             (Map regencies) => regencies['name']!
    //                                 .toLowerCase()
    //                                 .contains(
    //                                     provinceId.toLowerCase()));
    //var regenciesJson = regencies as List;

    List firstregency = dataregency.toList();

    for (int i = 0; i < firstregency.length; i++) {
      regenciesData.add(new RegenciesModel.fromJson(firstregency[i]));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProvince();
  }

  showPasss() {
    setState(() {
      isShow = !isShow;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    checkConnectivity() async {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        setState(() {
          connected = true;
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     backgroundColor: Colors.blueAccent,
          //     content: Text(
          //       'Berhasil Masuk',
          //       textAlign: TextAlign.center,
          //     ),
          //   ),
          // );
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => SecondPage(
                        city: _kecamatanController.text,
                        name: _namaLengkapController.text,
                      )),
              (Route<dynamic> route) => false);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => SecondPage(
          // city: _kecamatanController.text,
          // name: _namaLengkapController.text,
          //           )),
          // );
        });
      } else if (connectivityResult == ConnectivityResult.wifi) {
        setState(() {
          connected = true;
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     backgroundColor: Colors.blueAccent,
          //     content: Text(
          //       'Berhasil Masuk',
          //       textAlign: TextAlign.center,
          //     ),
          //   ),
          // );
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => SecondPage(
                        city: _kecamatanController.text,
                        name: _namaLengkapController.text,
                      )),
              (Route<dynamic> route) => false);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => SecondPage(
          //             city: _kecamatanController.text,
          //             name: _namaLengkapController.text,
          //           )),
          // );
        });
      } else {
        setState(() {
          connected = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                'Chek Koneksi Internet',
                textAlign: TextAlign.center,
              ),
            ),
          );
        });
      }
    }

    Widget signin() {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(primary: primaryColor),
          onPressed: () {
            final isValid = formKey.currentState?.validate();

            if (isValid == true) {
              formKey.currentState?.save();

              setState(() {
                isLoading = true;
              });

              checkConnectivity();

              setState(() {
                isLoading = false;
              });
            }
          },
          child: Text('MASUK'));
    }

    Widget provincies() {
      return Column(
        children: [
          Autocomplete<ProvinceModel>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return provinciesData;
              } else {
                return provinciesData.where((ProvinceModel province) => province
                    .name!
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()));
              }
            },
            displayStringForOption: (ProvinceModel option) => option.name!,
            optionsViewBuilder: (context, Function onSelected, options) {
              return Container(
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.5,
                    right: MediaQuery.of(context).size.width * 0.15),
                child: Material(
                  elevation: 18,
                  child: Container(
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 50),
                      itemBuilder: (context, index) {
                        final option = options.elementAt(index);

                        return ListTile(
                          // title: Text(option.toString()),
                          title: SubstringHighlight(
                            text: option.name!,
                            term: _kotaController.text,
                            textStyleHighlight:
                                TextStyle(fontWeight: FontWeight.w700),
                          ),

                          onTap: () {
                            onSelected(option);
                            setState(() {
                              province_id = option.id;
                            });
                            _kecamatanController.text = "";
                            regenciesData = [];
                            fetchRegencies(province_id);
                          },
                        );
                      },
                      //separatorBuilder: (context, index) => Divider(),
                      itemCount: options.length,
                    ),
                  ),
                ),
              );
            },
            onSelected: (selectedString) {},
            fieldViewBuilder:
                (context, _kotaController, focusNode, onEditingComplete) {
              this._kotaController = _kotaController;

              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Provinsi',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Container(
                      child: TextFormField(
                        controller: _kotaController,
                        validator: (val) {
                          if (val!.length == 0) return 'Masukkan Provinsi';
                        },
                        focusNode: focusNode,
                        onEditingComplete: onEditingComplete,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                          hintText: 'Pilih Provinsi',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      );
    }

    Widget regencies() {
      return Column(
        children: [
          Autocomplete<RegenciesModel>(
            optionsBuilder: (TextEditingValue textregencies) {
              if (textregencies.text.isEmpty) {
                return regenciesData;
              } else {
                return regenciesData.where((RegenciesModel regencies) =>
                    regencies.name!
                        .toLowerCase()
                        .contains(textregencies.text.toLowerCase()));
              }
            },
            displayStringForOption: (RegenciesModel regenciess) =>
                regenciess.name!,
            optionsViewBuilder: (context, Function onSelected, options) {
              return Container(
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.5,
                    right: MediaQuery.of(context).size.width * 0.15),
                child: Material(
                  elevation: 18,
                  child: Container(
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 50),
                      itemBuilder: (context, index) {
                        final option = options.elementAt(index);

                        return ListTile(
                          // title: Text(option.toString()),
                          title: SubstringHighlight(
                            text: option.name!,
                            term: _kotaController.text,
                            textStyleHighlight:
                                TextStyle(fontWeight: FontWeight.w700),
                          ),

                          onTap: () {
                            onSelected(option);
                          },
                        );
                      },
                      //separatorBuilder: (context, index) => Divider(),
                      itemCount: options.length,
                    ),
                  ),
                ),
              );
            },
            onSelected: (selectedString) {},
            fieldViewBuilder:
                (context, _kecamatanController, focusNode, onEditingComplete) {
              this._kecamatanController = _kecamatanController;

              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kota/Kabupaten',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Container(
                      child: TextFormField(
                        controller: _kecamatanController,
                        validator: (val) {
                          if (val!.length == 0)
                            return 'Masukkan Kota/Kabupaten';
                        },
                        focusNode: focusNode,
                        onEditingComplete: onEditingComplete,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                          hintText: 'Pilih Kota/Kabupaten',
                          hintStyle: TextStyle(fontSize: 16),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      );
    }

    Widget inputlogin() {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama Lengkap',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 7),
            Container(
              child: TextFormField(
                controller: _namaLengkapController,
                validator: (val) {
                  if (val!.length <= 3)
                    return 'nama harus diisi lebih dari 3 huruf';
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                  hintText: 'Masukkan Nama Lengkap',
                  hintStyle: TextStyle(fontSize: 16),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : provincies(),
            SizedBox(
              height: 20,
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : regencies()
          ],
        ),
      );
    }

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.white.withOpacity(0.95), BlendMode.dstATop),
                fit: BoxFit.cover,
                image: AssetImage("assets/bg_login.jpg"))),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 85,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Weather App',
                              style: TextStyle(
                                  fontSize: 48, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          'adalah aplikasi perkiraan cuaca untuk beberapa hari kedepan.',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            Container(
                              child: Text(
                                'Isi data untuk dapat melanjutkan!',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            inputlogin(),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 60,
                              child: Center(
                                  child: isLoading
                                      ? Container(
                                          height: 16,
                                          width: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation(
                                                thirdColor),
                                          ),
                                        )
                                      : signin()),
                            ),
                            SizedBox(height: 180)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
