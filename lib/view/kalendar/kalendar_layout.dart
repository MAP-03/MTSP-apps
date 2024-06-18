// kalendar_layout.dart (modified part)

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/view/kalendar/acara.dart';
import 'package:mtsp/view/kalendar/acara_form.dart';
import 'package:mtsp/view/kalendar/kalendar_logic.dart'; // Import the logic
import 'package:mtsp/widgets/drawer.dart';
import 'package:table_calendar/table_calendar.dart';

class Kalendar extends StatefulWidget {
  const Kalendar({super.key});

  @override
  State<Kalendar> createState() => _KalendarState();
}

class _KalendarState extends State<Kalendar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final KalendarLogic kalendarLogic;

  @override
  void initState() {
    super.initState();
    kalendarLogic = KalendarLogic();
  }

  @override
  void dispose() {
    kalendarLogic.selectedEvents.dispose();
    super.dispose();
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
              onPressed: () {
                setState(() {
                  kalendarLogic.toggleSortOrder();
                });
              },
              backgroundColor: Colors.white,
              mini: true,
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Icon(
                  kalendarLogic.isAscending ? Icons.sort : Icons.sort_rounded),
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
                          final normalizedDay = kalendarLogic.normalizeDate(
                              kalendarLogic.selectedDay!);
                          if (kalendarLogic.events.containsKey(normalizedDay)) {
                            kalendarLogic.events[normalizedDay]!.add(event);
                          } else {
                            kalendarLogic.events[normalizedDay] = [event];
                          }
                          kalendarLogic.selectedEvents.value =
                              kalendarLogic.getEventsForDay(normalizedDay);
                        });
                        kalendarLogic.saveEvent(event);
                      },
                      initialDate: kalendarLogic.selectedDay!, // Pass the selected date to EventForm
                    );
                  },
                );
              },
              backgroundColor: Colors.white,
              mini: true,
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  Widget content() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF62CFF4), Color(0xFF2C67F2)],
              ),
            ),
            child: TableCalendar<Event>(
              rowHeight: 37,
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) =>
                  isSameDay(kalendarLogic.selectedDay, day),
              focusedDay: kalendarLogic.focusedDay,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  kalendarLogic.onDaySelected(selectedDay, focusedDay);
                });
              },
              eventLoader: kalendarLogic.getEventsForDay,
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
                markerDecoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                markerMargin:
                    const EdgeInsets.symmetric(horizontal: 1.0, vertical: 6.0),
                selectedDecoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                todayDecoration: const BoxDecoration(
                  color: Color(0xFF023E8A),
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
                formatButtonTextStyle: const TextStyle(color: Colors.white),
                formatButtonDecoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                leftChevronIcon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                rightChevronIcon: const Icon(
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
        const SizedBox(height: 55),
        Expanded(
          child: ValueListenableBuilder<List<Event>>(
            valueListenable: kalendarLogic.selectedEvents,
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
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        final event = value[index];
                        return Dismissible(
                          key: Key(event.id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            setState(() {
                              kalendarLogic.deleteEvent(
                                  event.id,
                                  kalendarLogic
                                      .normalizeDate(event.startDate),
                                  event);
                            });
                          },
                          background: Container(
                            margin: const EdgeInsets.all(12.0),
                            padding: const EdgeInsets.all(24.0),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            alignment: Alignment.centerRight,
                            child: const Icon(Icons.delete,
                                color: Colors.white, size: 30),
                          ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(8.0),
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
                                  const SizedBox(height: 4),
                                  Text(
                                    event.note,
                                    style: GoogleFonts.poppins(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(
                    color: Colors.white, // Adjust the color to match your design
                    thickness: 2.0,    // Adjust the thickness as needed
                    indent: 16.0,      // Adjust the indent as needed
                    endIndent: 16.0,   // Adjust the end indent as needed
                  ),
                ],
              );
            },
          ),
        ),
        // add new event retreived from berita page
        //Expanded(
        // child: newEventLinkedBeritaWidget(),
        //),
      ],
    );
  }
}
