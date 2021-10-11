import 'package:flutter/material.dart';

class DetailToday extends StatelessWidget {
  const DetailToday({Key? key, this.image, this.title, this.value, this.satuan})
      : super(key: key);

  final String? image;
  final String? value;
  final String? satuan;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 40,
              child: Image.asset(image!),
            ),
            SizedBox(
              height: 7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(value!),
                Text(satuan!),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              title!,
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
