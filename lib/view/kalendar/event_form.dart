import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/view/kalendar/event.dart';

class EventForm extends StatefulWidget {
  final Function(Event) onSave;

  EventForm({required this.onSave});

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  TextEditingController _noteController = TextEditingController();
  DateTime _eventDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay(
  hour: (TimeOfDay.now().hour + 1) % 24, // Ensure it wraps around 24 hours
  minute: TimeOfDay.now().minute,
  );
  bool _alarm = false;
  Color _selectedColor = Colors.blue;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickTime(BuildContext context, TimeOfDay initialTime,
      ValueChanged<TimeOfDay> onTimeChanged) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null && picked != initialTime) {
      onTimeChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Masa",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pickTime(context, _startTime, (newTime) {
                              setState(() {
                                _startTime = newTime;
                                _eventDate = DateTime(
                                  _eventDate.year,
                                  _eventDate.month,
                                  _eventDate.day,
                                  _startTime.hour,
                                  _startTime.minute,
                                );
                              });
                            }),
                            child: Column(
                              children: [
                                Text("Mula",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black, fontWeight: FontWeight.bold)),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _startTime.format(context),
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.access_time),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pickTime(context, _endTime, (newTime) {
                              setState(() {
                                _endTime = newTime;
                                _eventDate = DateTime(
                                  _eventDate.year,
                                  _eventDate.month,
                                  _eventDate.day,
                                  _endTime.hour,
                                  _endTime.minute,
                                );
                              });
                            }),
                            child: Column(
                              children: [
                                Text("Tamat",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black, fontWeight: FontWeight.bold)),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _endTime.format(context),
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.access_time),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          controller: _noteController,
                          decoration: InputDecoration(
                            labelText: "Nota",
                            hintText: "Masukkan nota",
                            labelStyle: GoogleFonts.poppins(
                                color: Colors.black, fontWeight: FontWeight.bold),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                width: 1.0,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 16.0,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Sila masukkan nota';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Warna",
                                style: GoogleFonts.poppins(
                                    color: Colors.black, fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() => _selectedColor = Colors.blue),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    radius: 12,
                                    child: _selectedColor == Colors.blue
                                        ? Icon(Icons.check, size: 16, color: Colors.white)
                                        : null,
                                  ),
                                ),
                                SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => setState(() => _selectedColor = Colors.red),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 12,
                                    child: _selectedColor == Colors.red
                                        ? Icon(Icons.check, size: 16, color: Colors.white)
                                        : null,
                                  ),
                                ),
                                SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => setState(() => _selectedColor = Colors.green),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.green,
                                    radius: 12,
                                    child: _selectedColor == Colors.green
                                        ? Icon(Icons.check, size: 16, color: Colors.white)
                                        : null,
                                  ),
                                ),
                                SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => setState(() => _selectedColor = Colors.yellow),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.yellow,
                                    radius: 12,
                                    child: _selectedColor == Colors.yellow
                                        ? Icon(Icons.check, size: 16, color: Colors.white)
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Alarm",
                                  style: GoogleFonts.poppins(
                                      color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 8),
                                Switch(
                                  value: _alarm,
                                  onChanged: (value) {
                                    setState(() {
                                      _alarm = value;
                                    });
                                  },
                                  activeColor: Colors.blue,
                                  activeTrackColor: Color(0xff12223C),
                                  inactiveThumbColor: Color(0xff12223C),
                                  inactiveTrackColor: Colors.grey[400],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final DateTime eventStartDateTime = DateTime(
                            _eventDate.year,
                            _eventDate.month,
                            _eventDate.day,
                            _startTime.hour,
                            _startTime.minute,
                          );

                          final DateTime eventEndDateTime = DateTime(
                            _eventDate.year,
                            _eventDate.month,
                            _eventDate.day,
                            _endTime.hour,
                            _endTime.minute,
                          );

                          final event = Event(
                            _noteController.text,
                            eventStartDateTime,
                            eventEndDateTime,
                            _selectedColor,
                          );

                          widget.onSave(event);

                          Navigator.of(context).pop();
                          _noteController.clear();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff12223C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                      ),
                      child: Text("Simpan",
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}