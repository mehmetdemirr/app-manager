import 'package:app_usage/app_usage.dart';
import 'package:flutter/material.dart';

class DenemeView extends StatefulWidget {
  const DenemeView({super.key});
  @override
  State<DenemeView> createState() => _DenemeViewState();
}

class _DenemeViewState extends State<DenemeView> {
  List<AppUsageInfo> _infos = [];
  int toplam = 0;

  @override
  void initState() {
    super.initState();
  }

  void topla() {
    toplam = 0;
    for (var i in _infos) {
      toplam += i.usage.inMinutes;
    }
  }

  void getUsageStats() async {
    try {
      final DateTime now = DateTime.now();
      final DateTime startTime =
          DateTime(now.year, now.month, now.day, 8, 0, 0);
      final DateTime endTime = DateTime(now.year, now.month, now.day, 17, 0, 0);
      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(startTime, endTime);
      setState(() {
        _infos = infoList;
      });

      for (var info in infoList) {
        print(info.toString());
      }
    } on AppUsageException catch (exception) {
      print(exception);
    }
    topla();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toplam kullanım $toplam'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
          itemCount: _infos.length,
          itemBuilder: (context, index) {
            return ListTile(
                title: Text(_infos[index].appName),
                trailing: Text("${_infos[index].usage.inMinutes}"));
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: getUsageStats, child: const Icon(Icons.file_download)),
    );
  }
}
