import 'package:flutter/material.dart';

class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}
class _InputControlsDemoState extends State<InputControlsDemo> {
  double sliderValue = 50;
  bool switchValue = false;
  String genre = 'Action';
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exercise 2 – Input Widgets')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "Ratting (Slider)",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
            ),
            Slider(
              value: sliderValue,
              min: 0,
              max: 100,
              onChanged: (value) {
                setState(() {
                  sliderValue = value;
                });
              },
            ),
            Text('Current value: ${sliderValue.toInt()}'),
            Text(
              "Active (Switch)",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 4,

              ),
            ),
            SwitchListTile(
              title: Text('Is movie active?'),
              value: switchValue,
              onChanged: (value) {
                setState(() {
                  switchValue = value;
                });
              },
            ),

            Text(
              "Genre (RadioListTile)",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 4,

              ),
            ),
            RadioListTile<String>(
              title: const Text('Action'),
              value: 'Action',
              groupValue: genre,
              onChanged: (value) {
                setState(() {
                  genre = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Comedy'),
              value: 'Comedy',
              groupValue: genre,
              onChanged: (value) {
                setState(() {
                  genre = value!;
                });
              },
            ),
            Text('Selected genre: ${genre.toString()}'),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity, // full chiều ngang
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.purple.shade100, // nền xám nhạt
                  foregroundColor: Colors.black,         // chữ đen
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // bo tròn nhẹ
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Open Date Picker',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    initialDate: DateTime.now(),
                  );

                  if (date != null) {
                    setState(() {
                      selectedDate = date;
                    });
                  }
                },
              ),
            ),

            if (selectedDate != null)
              Text('Selected Date: ${selectedDate!.toLocal()}'),
          ],
        ),
      ),
    );
  }
}