import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/services/notification_service.dart';
import 'package:mtsp/view/kalendar/acara.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventForm extends StatefulWidget {
  final Function(Event) onSave;
  final DateTime initialDate;

  const EventForm({super.key, required this.onSave, required this.initialDate});

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final TextEditingController _noteController = TextEditingController();
  late DateTime _eventDate;
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay(
    hour: (TimeOfDay.now().hour + 1) % 24,
    minute: TimeOfDay.now().minute,
  ); // Set default end time close to midnight
  bool _alarm = false;
  Color _selectedColor = Colors.blue;
  final _formKey = GlobalKey<FormState>();
  final NotificationService _notificationService = NotificationService();
  String _timeError = ''; // This will hold the time validation error message

  @override
  void initState() {
    super.initState();
    _eventDate = widget.initialDate;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickTime(BuildContext context, TimeOfDay initialTime,
      ValueChanged<TimeOfDay> onTimeChanged, bool isEndTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      onTimeChanged(picked);
      _validateTimes(picked, isEndTime);
    }
  }

  void _validateTimes(TimeOfDay pickedTime, bool isEndTime) {
    if (isEndTime) {
      _endTime = pickedTime;
    } else {
      _startTime = pickedTime;
    }
    final DateTime startDateTime = DateTime(_eventDate.year, _eventDate.month,
        _eventDate.day, _startTime.hour, _startTime.minute);
    final DateTime endDateTime = DateTime(_eventDate.year, _eventDate.month,
        _eventDate.day, _endTime.hour, _endTime.minute);

    if (endDateTime.isBefore(startDateTime)) {
      setState(() {
        _timeError = 'Masa tamat harus selepas masa mula';
      });
    } else {
      setState(() {
        _timeError = '';
      });
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
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTimePicker(context, 'Masa Mula', _startTime,
                            (time) {
                          setState(() {
                            _startTime = time;
                          });
                        }, false),
                        SizedBox(width: 16),
                        _buildTimePicker(context, 'Masa Tamat', _endTime,
                            (time) {
                          setState(() {
                            _endTime = time;
                          });
                        }, true),
                      ],
                    ),
                    if (_timeError.isNotEmpty) // Show error message if any
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(_timeError,
                            style: TextStyle(color: Colors.red, fontSize: 14)),
                      ),
                    SizedBox(height: 26),
                    _buildTextField(),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildColorPicker(setState),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0), // Adjust padding to move alarm switch lower
                          child: _buildAlarmSwitch(setState),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: _buildSaveButton(context)
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

  Widget _buildTimePicker(BuildContext context, String label, TimeOfDay time,
      ValueChanged<TimeOfDay> onTimeChanged, bool isEndTime) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _pickTime(context, time, onTimeChanged, isEndTime),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.0),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    time.format(context),
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
    );
  }

  Widget _buildTextField() {
    return TextFormField(
      controller: _noteController,
      decoration: InputDecoration(
        labelText: "Nota",
        hintText: "Masukkan nota",
        labelStyle: GoogleFonts.poppins(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Sila masukkan nota';
        }
        return null;
      },
    );
  }

  Widget _buildColorPicker(StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Warna",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            _buildColorOption(setState, Colors.blue),
            SizedBox(width: 8),
            _buildColorOption(setState, Colors.red),
            SizedBox(width: 8),
            _buildColorOption(setState, Colors.green),
            SizedBox(width: 8),
            _buildColorOption(setState, Colors.yellow),
          ],
        ),
      ],
    );
  }

  Widget _buildColorOption(StateSetter setState, Color color) {
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = color),
      child: CircleAvatar(
        backgroundColor: color,
        radius: 12,
        child: _selectedColor == color
            ? Icon(Icons.check, size: 16, color: Colors.white)
            : null,
      ),
    );
  }

  Widget _buildAlarmSwitch(StateSetter setState) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Alarm",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 8),
        Switch(
          value: _alarm,
          onChanged: (value) => setState(() => _alarm = value),
          activeColor: Colors.blue,
          activeTrackColor: Color(0xff12223C),
          inactiveThumbColor: Color(0xff12223C),
          inactiveTrackColor: Colors.grey[400],
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate() && _timeError.isEmpty) {
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

          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            final event = Event(
              id: Uuid().v4(),
              note: _noteController.text,
              startDate: eventStartDateTime,
              endDate: eventEndDateTime,
              color: _selectedColor,
              userId: user.email!,
              creationDate: DateTime.now(),
            );

            widget.onSave(event);

            if (_alarm) {
              await _notificationService.scheduleEventNotification(event);
            }

            Navigator.of(context).pop();
            _noteController.clear();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'User not logged in',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xff12223C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      ),
      child: Text(
        "Simpan",
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
