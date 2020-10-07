import 'dart:convert'; // untuk tipe data JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async'; // dart asynchronus

void main() {
  runApp(MaterialApp(
    title: "Al Quran XII RPL",
    home: HalamanJson(),
  ));
}

  class HalamanJson extends StatefulWidget {
    @override
    _HalamanJsonState createState() => _HalamanJsonState();
  }
  
  class _HalamanJsonState extends State<HalamanJson> {
//    int nomor;
    List datadariJSON;

    Future ambildata() async {
      http.Response hasil = await http.get(
        Uri.encodeFull("https://al-quran-8d642.firebaseio.com/data.json?print=pretty"),
        headers: {"accept": "application/json"});

      this.setState(() {
        datadariJSON = json.decode(hasil.body);
      });
    }

    @override
    void initState() {
      this.ambildata();
    }
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.book),
          title: Text("Al Qur'an XII RPL"),
        ),
        body: Container(
          child: ListView.builder(
              itemCount: datadariJSON == null ? 0 : datadariJSON.length,
              itemBuilder: (context, i) {
                    return Card(
                      elevation: 8,
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        title: Text(datadariJSON[i]['nama'] + " - " + datadariJSON[i]['asma'] ?? ""),
                        subtitle: Text(datadariJSON[i]['type'] + " | " + datadariJSON[i]['ayat'].toString() + " ayat" ?? ""),
                        trailing: Icon(Icons.keyboard_arrow_right, size: 30,),
                        leading: Container(
                          padding: EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(width: 1, color: Colors.black),
                            ),
                          ),
                          child: Text(datadariJSON[i]['nomor']),
                        ),

                        onTap: () {
                          Navigator.push(
                              context, MaterialPageRoute(
                              builder: (context) {
                                var datadariJSON2 = datadariJSON[i];
                                return DetailAlQuran(
                                  nomor: datadariJSON2['nomor'],
                                  nama: datadariJSON2['nama'],
                                  asma: datadariJSON2['asma'],
                                );
                              }
                          )
                          );
                        },
                      ),
                    );
            }
          )
        )
      );
    }
  }

class DetailAlQuran extends StatefulWidget {
  final String nomor;
  final String nama;
  final String asma;

  DetailAlQuran({this.nomor, this.nama, this.asma});
  @override
  _DetailAlQuran createState() => _DetailAlQuran();
}

class _DetailAlQuran extends State<DetailAlQuran> {
  List dataAlquranJSON;

  Future ambildata() async {
    http.Response hasil = await http.get(
        Uri.encodeFull(
            "https://al-quran-8d642.firebaseio.com/surat/${widget.nomor}.json?print=pretty"),
        headers: {"Accept": "application/json"});

    this.setState(() {
      dataAlquranJSON = json.decode(hasil.body);
    });
  }

  @override
  void initState() {
    this.ambildata();
  }

  // final String data = ambildata();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" ${widget.nama}" + ' - ' + "${widget.asma}"),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: dataAlquranJSON == null ? 0 : dataAlquranJSON.length,
          itemBuilder: (context, i) {
            return Card(
              elevation: 8,
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                title: Text(dataAlquranJSON[i]['ar'] ?? "", style: TextStyle(fontSize: 25), textAlign: TextAlign.right,),
                subtitle: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text('Artinya:  ' + dataAlquranJSON[i]['id'] ?? "", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.justify,),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
  
