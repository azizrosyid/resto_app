import 'package:flutter/material.dart';

class SaranKesanPage extends StatelessWidget {
  const SaranKesanPage({super.key});

  static const routeName = '/saran-kesan';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saran dan Kesan'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              'Saran dan Kesan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Saran : Materi yang disampaikan lebih disesuaikan dengan kebutuhan mahasiswa.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Kesan : Pengajaran sangat jelas dan mudah dipahami dengan penjelasan yang terstruktur, dan disertai dengan contoh-contoh yang mudah dipahami.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        )),
      ),
    );
  }
}
