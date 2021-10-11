import 'dart:convert';

import 'package:connectivity/connectivity.dart';
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

    print("first" + dataregency.toString());
    List firstregency = dataregency.toList();
    print("firskec" + firstregency.toString());

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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.blueAccent,
              content: Text(
                'Berhasil Masuk',
                textAlign: TextAlign.center,
              ),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SecondPage(
                      city: _kecamatanController.text,
                      name: _namaLengkapController.text,
                    )),
          );
        });
      } else if (connectivityResult == ConnectivityResult.wifi) {
        setState(() {
          connected = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.blueAccent,
              content: Text(
                'Berhasil Masuk',
                textAlign: TextAlign.center,
              ),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SecondPage(
                      city: _kecamatanController.text,
                    )),
          );
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
          style: ElevatedButton.styleFrom(primary: Color(0xff1F7FEF)),
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
                          subtitle: Text("This is subtitle"),
                          onTap: () {
                            onSelected(option);
                            setState(() {
                              province_id = option.id;
                            });
                            _kecamatanController.text = "";
                            regenciesData = [];
                            fetchRegencies(province_id);
                            print(province_id.toString());
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
            onSelected: (selectedString) {
              print(selectedString);
            },
            fieldViewBuilder:
                (context, _kotaController, focusNode, onEditingComplete) {
              this._kotaController = _kotaController;

              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kota',
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
                          if (val!.length == 0) return 'Masukkan Kota';
                        },
                        focusNode: focusNode,
                        onEditingComplete: onEditingComplete,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                          hintText: 'Pilih Kota',
                          hintStyle: TextStyle(fontSize: 16),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Color(0xffC3C3C3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Color(0xffC3C3C3),
                              width: 2.0,
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
                          subtitle: Text("This is subtitle"),
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
            onSelected: (selectedString) {
              print(selectedString);
            },
            fieldViewBuilder:
                (context, _kecamatanController, focusNode, onEditingComplete) {
              this._kecamatanController = _kecamatanController;

              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kecamatan',
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
                          if (val!.length == 0) return 'Masukkan kecamatan';
                        },
                        focusNode: focusNode,
                        onEditingComplete: onEditingComplete,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                          hintText: 'Pilih Kecamatan',
                          hintStyle: TextStyle(fontSize: 16),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Color(0xffC3C3C3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Color(0xffC3C3C3),
                              width: 2.0,
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
                      color: Color(0xffC3C3C3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Color(0xffC3C3C3),
                      width: 2.0,
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

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 85,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Weather\nApp',
                        style: TextStyle(
                            fontSize: 48, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Isi data untuk dapat melanjutkan!',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 50,
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
                                valueColor: AlwaysStoppedAnimation(thirdColor),
                              ),
                            )
                          : signin()),
                ),
                SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}