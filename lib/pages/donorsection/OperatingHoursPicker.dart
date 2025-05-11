import 'package:flutter/material.dart';

class OperatingHoursPicker extends StatefulWidget {
  final TextEditingController openTimeController;
  final TextEditingController closeTimeController;

  const OperatingHoursPicker({
    super.key,
    required this.openTimeController,
    required this.closeTimeController,
  });

  @override
  _OperatingHoursPickerState createState() => _OperatingHoursPickerState();
}

class _OperatingHoursPickerState extends State<OperatingHoursPicker> {
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        String formattedTime = _formatTime(picked);
        if (isStartTime) {
          widget.openTimeController.text = formattedTime;
        } else {
          widget.closeTimeController.text = formattedTime;
        }
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Operating Hours",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _selectTime(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                    "Start Time: ${widget.openTimeController.text.isEmpty ? '--:--' : widget.openTimeController.text}"),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _selectTime(context, false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                    "End Time: ${widget.closeTimeController.text.isEmpty ? '--:--' : widget.closeTimeController.text}"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
