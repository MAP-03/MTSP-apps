import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/view/kalendar/event.dart';
import 'package:mtsp/view/kalendar/event_form.dart';
import 'package:mtsp/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class Kalendar extends StatefulWidget {
  const Kalendar({super.key});

  @override
  State<Kalendar> createState() => _KalendarState();
}

class _KalendarState extends State<Kalendar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {};
  late final ValueNotifier<List<Event>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _selectedDay = null; // Initially, no day is selected
    _selectedEvents = ValueNotifier([]);
    _loadEvents().then((_) {
      setState(() {
        _selectedEvents.value = _getEventsForDay(_focusedDay);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedEvents.value = _getEventsForDay(selectedDay);
    });
  }

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  Future<void> _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, List<Map<String, dynamic>>> jsonEvents = {};
    events.forEach((key, value) {
      jsonEvents[key.toIso8601String()] =
          value.map((event) => event.toJson()).toList();
    });
    prefs.setString('events', jsonEncode(jsonEvents));
  }

  Future<void> _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('events');
    if (jsonString != null) {
      final Map<String, dynamic> jsonEvents = jsonDecode(jsonString);
      jsonEvents.forEach((key, value) {
        final DateTime date = DateTime.parse(key);
        final List<Event> eventList =
            (value as List).map((e) => Event.fromJson(e)).toList();
        events[date] = eventList;
      });
    }
    setState(() {
      _selectedEvents.value = _getEventsForDay(_focusedDay);
    });
  }

  void _deleteEvent(DateTime day, Event event) {
    setState(() {
      events[day]?.remove(event);
      if (events[day]?.isEmpty ?? true) {
        events.remove(day);
      }
    });
    _selectedEvents.value = _getEventsForDay(day);
    _saveEvents();
  }

  void _showSelectDateMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sila pilih tarikh dahulu sebelum menambah acara',
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 13), // Optional: change text color
        ),
        backgroundColor: Colors.blue, // Change to your desired background color
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Text('Kalendar',
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 30),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
          backgroundColor: primaryColor,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: Colors.black,
              height: 2,
            ),
          ),
        ),
      ),
      drawer: CustomDrawer(),
      backgroundColor: secondaryColor,
      body: Stack(
        children: [
          content(),
          Positioned(
            bottom: 320,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                if (_selectedDay == null) {
                  _showSelectDateMessage(context);
                } else {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return EventForm(
                        onSave: (event) {
                          setState(() {
                            if (events.containsKey(_selectedDay)) {
                              events[_selectedDay!]!.add(event);
                            } else {
                              events[_selectedDay!] = [event];
                            }
                            _selectedEvents.value = _getEventsForDay(_selectedDay!);
                          });
                          _saveEvents();
                        },
                      );
                    },
                  );
                }
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.white,
              mini: true,
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget content() {
    return Column(
      children: [
        SizedBox(height: 20),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF62CFF4), Color(0xFF2C67F2)],
              ),
            ),
            child: TableCalendar<Event>(
              rowHeight: 37,
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              onDaySelected: _onDaySelected,
              eventLoader: _getEventsForDay,
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                defaultTextStyle: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                weekendTextStyle: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                todayTextStyle: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                selectedTextStyle: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                markerDecoration:
                    BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                markerMargin:
                    EdgeInsets.symmetric(horizontal: 1.0, vertical: 6.0),
                selectedDecoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                outsideDaysVisible: false,
              ),
              headerStyle: HeaderStyle(
                titleTextStyle: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
                formatButtonVisible: false,
                titleCentered: true,
                formatButtonTextStyle: TextStyle(color: Colors.white),
                formatButtonDecoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                leftChevronIcon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                rightChevronIcon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
                weekendStyle: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        SizedBox(height: 80.0),
        Expanded(
          child: ValueListenableBuilder<List<Event>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              if (value.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/uai.jpg', // Make sure to add your image in the assets folder and declare it in pubspec.yaml
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Tiada Acara Harini',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  final event = value[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Dismissible(
                      key: Key(event.startDate.toString() + event.note),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        _deleteEvent(_selectedDay!, event);
                      },
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 4.0),
                        color: Colors.red,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(8.0),
                          leading: CircleAvatar(
                            backgroundColor: event.color,
                            radius: 10,
                            child: Container(),
                          ),
                          title: Text(
                            "${event.startDate.hour.toString().padLeft(2, '0')}:${event.startDate.minute.toString().padLeft(2, '0')} ${event.startDate.hour >= 12 ? 'PM' : 'AM'} - ${event.endDate.hour.toString().padLeft(2, '0')}:${event.endDate.minute.toString().padLeft(2, '0')} ${event.endDate.hour >= 12 ? 'PM' : 'AM'}",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(
                                event.note,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}
