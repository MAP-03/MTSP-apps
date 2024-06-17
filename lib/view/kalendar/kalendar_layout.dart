import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/services/acara_service.dart';
import 'package:mtsp/view/kalendar/acara.dart';
import 'package:mtsp/view/kalendar/acara_form.dart';
import 'package:mtsp/widgets/drawer.dart';
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
  bool _isAscending = true;
  final AcaraService _acaraService = AcaraService(); // Initialize AcaraService

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier([]);
    _loadEvents();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
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
    final normalizedDay = _normalizeDate(day);
    List<Event> dayEvents = events[normalizedDay] ?? [];
    dayEvents.sort((a, b) => _isAscending
        ? a.startDate.compareTo(b.startDate)
        : b.startDate.compareTo(a.startDate));
    return dayEvents;
  }

  Future<void> _saveEvent(Event event) async {
    try {
      await _acaraService.addEvent(event);
    } catch (e) {
      print('Error saving event: $e');
    }
  }

  Future<void> _loadEvents() async {
    try {
      final loadedEvents = await _acaraService.getEvents();
      setState(() {
        events.clear(); // Clear the map before loading new events
        for (var event in loadedEvents) {
          final day = _normalizeDate(event.startDate);
          if (events.containsKey(day)) {
            events[day]!.add(event);
          } else {
            events[day] = [event];
          }
        }
        if (_selectedDay != null) {
          _selectedEvents.value = _getEventsForDay(_selectedDay!);
        } else {
          _selectedEvents.value = _getEventsForDay(_focusedDay);
        }
      });
    } catch (e) {
      print('Error loading events: $e');
    }
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Future<void> _deleteEvent(String eventId, DateTime day, Event event) async {
    try {
      setState(() {
        events[day]?.remove(event);
        if (events[day]?.isEmpty ?? true) {
          events.remove(day);
        }
        _selectedEvents.value = _getEventsForDay(day);
      });
      await _acaraService.deleteEvent(eventId);
    } catch (e) {
      print('Error deleting event: $e');
    }
  }

  void _toggleSortOrder() {
    setState(() {
      _isAscending = !_isAscending;
      if (_selectedDay != null) {
        _selectedEvents.value = _getEventsForDay(_selectedDay!);
      }
    });
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
            right: 76,
            child: FloatingActionButton(
              heroTag: 'sortButton',
              onPressed: _toggleSortOrder,
              child: Icon(_isAscending ? Icons.sort : Icons.sort_rounded),
              backgroundColor: Colors.white,
              mini: true,
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          ),
          Positioned(
            bottom: 320,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'addButton',
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return EventForm(
                      onSave: (event) {
                        setState(() {
                          final normalizedDay = _normalizeDate(_selectedDay!);
                          if (events.containsKey(normalizedDay)) {
                            events[normalizedDay]!.add(event);
                          } else {
                            events[normalizedDay] = [event];
                          }
                          _selectedEvents.value = _getEventsForDay(
                              normalizedDay);
                        });
                        _saveEvent(event);
                      },
                      initialDate: _selectedDay!, // Pass the selected date to EventForm
                    );
                  },
                );
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
                markerDecoration: BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                markerMargin: EdgeInsets.symmetric(
                    horizontal: 1.0, vertical: 6.0),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/kalendar.svg',
                        width: 200,
                      ),
                      Text(
                        'Tiada Acara Harini',
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
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
                      key: Key(event.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        _deleteEvent(event.id, _normalizeDate(event.startDate), event);
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
                        margin: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 4.0),
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
                                color: Colors.black),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(
                                event.note,
                                style: GoogleFonts.poppins(
                                    fontSize: 14, color: Colors.black),
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
