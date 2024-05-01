import 'dart:convert';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menghitung IPK Mahasiswa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MahasiswaListScreen(),
    );
  }
}

class MahasiswaListScreen extends StatefulWidget {
  @override
  _MahasiswaListScreenState createState() => _MahasiswaListScreenState();
}

class _MahasiswaListScreenState extends State<MahasiswaListScreen> {
  String jsonString = '''
  {
    "mahasiswa": [
      {
        "nama": "Rayhan Cahyo Aji Nugroho",
        "nim": "123456789",
        "mata_kuliah": [
          {"kode": "MK001", "nama": "Matematika Dasar", "sks": 3, "nilai": "A"},
          {"kode": "MK002", "nama": "Fisika Dasar", "sks": 4, "nilai": "B+"},
          {"kode": "MK003", "nama": "Pemrograman Dasar", "sks": 3, "nilai": "A-"}
        ]
      },
      {
        "nama": "Achmad Aziz Setyiawan Abdillah",
        "nim": "987654321",
        "mata_kuliah": [
          {"kode": "MK001", "nama": "Matematika Dasar", "sks": 3, "nilai": "B"},
          {"kode": "MK002", "nama": "Fisika Dasar", "sks": 4, "nilai": "A"},
          {"kode": "MK003", "nama": "Pemrograman Dasar", "sks": 3, "nilai": "A"}
        ]
      },
      {
        "nama": "Dinar Azriel Firmansyah",
        "nim": "456789012",
        "mata_kuliah": [
          {"kode": "MK001", "nama": "Matematika Dasar", "sks": 3, "nilai": "C"},
          {"kode": "MK002", "nama": "Fisika Dasar", "sks": 4, "nilai": "A-"},
          {"kode": "MK003", "nama": "Pemrograman Dasar", "sks": 3, "nilai": "B+"}
        ]
      },
      {
        "nama": "Assatya Dewantara",
        "nim": "345678901",
        "mata_kuliah": [
          {"kode": "MK001", "nama": "Matematika Dasar", "sks": 3, "nilai": "A-"},
          {"kode": "MK002", "nama": "Fisika Dasar", "sks": 4, "nilai": "B"},
          {"kode": "MK003", "nama": "Pemrograman Dasar", "sks": 3, "nilai": "C"}
        ]
      },
      {
        "nama": "Zanuar Aldi Syahputra",
        "nim": "234567890",
        "mata_kuliah": [
          {"kode": "MK001", "nama": "Matematika Dasar", "sks": 3, "nilai": "B"},
          {"kode": "MK002", "nama": "Fisika Dasar", "sks": 4, "nilai": "C+"},
          {"kode": "MK003", "nama": "Pemrograman Dasar", "sks": 3, "nilai": "B-"}
        ]
      }
    ]
  }
  ''';

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = json.decode(jsonString);
    List<dynamic> mahasiswaList = data['mahasiswa'];

    return Scaffold(
      appBar: AppBar(
        title: Text('List Mahasiswa'),
      ),
      body: ListView.builder(
        itemCount: mahasiswaList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(mahasiswaList[index]['nama']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MahasiswaDetailScreen(
                    mahasiswa: mahasiswaList[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MahasiswaDetailScreen extends StatefulWidget {
  final dynamic mahasiswa;

  MahasiswaDetailScreen({required this.mahasiswa});

  @override
  _MahasiswaDetailScreenState createState() => _MahasiswaDetailScreenState();
}

class _MahasiswaDetailScreenState extends State<MahasiswaDetailScreen> {
  double ipk = 0.0;

  @override
  Widget build(BuildContext context) {
    List<dynamic> mataKuliahList = widget.mahasiswa['mata_kuliah'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Transkrip Mahasiswa'),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text('Nama: ${widget.mahasiswa['nama']}'),
          ),
          ListTile(
            title: Text('NPM: ${widget.mahasiswa['nim']}'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: mataKuliahList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${mataKuliahList[index]['nama']}'),
                  subtitle: Text('Nilai: ${mataKuliahList[index]['nilai']}'),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              calculateIPK();
            },
            child: Text('Hitung IPK'),
          ),
          SizedBox(height: 20),
          Text(
            'IPK: ${ipk.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }

  void calculateIPK() {
    double totalSKS = 0;
    double totalNilai = 0;
    List<dynamic> mataKuliahList = widget.mahasiswa['mata_kuliah'];

    for (var mk in mataKuliahList) {
      totalSKS += mk['sks'];
      totalNilai += convertNilaiToBobot(mk['nilai']) * mk['sks'];
    }

    setState(() {
      ipk = totalNilai / totalSKS;
    });
  }

  double convertNilaiToBobot(String nilai) {
    switch (nilai) {
      case 'A':
        return 4.0;
      case 'A-':
        return 3.7;
      case 'B+':
        return 3.3;
      case 'B':
        return 3.0;
      case 'B-':
        return 2.7;
      case 'C+':
        return 2.3;
      case 'C':
        return 2.0;
      case 'C-':
        return 1.7;
      case 'D+':
        return 1.3;
      case 'D':
        return 1.0;
      case 'E':
        return 0.0;
      default:
        return 0.0;
    }
  }
}
