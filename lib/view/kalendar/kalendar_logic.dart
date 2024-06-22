

import 'package:flutter/material.dart';
import 'package:mtsp/services/acara_service.dart';
import 'package:mtsp/view/kalendar/acara.dart';


class KalendarLogic {
  final AcaraService _acaraService = AcaraService();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {};
  late final ValueNotifier<List<Event>> _selectedEvents;
  bool _isAscending = true;

  KalendarLogic() {
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier([]);
    loadEvents();
  }

  ValueNotifier<List<Event>> get selectedEvents => _selectedEvents;
  DateTime get focusedDay => _focusedDay;
  DateTime? get selectedDay => _selectedDay;
  bool get isAscending => _isAscending;

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    _selectedDay = selectedDay;
    _focusedDay = focusedDay;
    _selectedEvents.value = getEventsForDay(selectedDay);
  }

  void toggleSortOrder() {
    _isAscending = !_isAscending;
    if (_selectedDay != null) {
      _selectedEvents.value = getEventsForDay(_selectedDay!);
    }
  }

  List<Event> getEventsForDay(DateTime day) {
    final normalizedDay = normalizeDate(day);
    List<Event> dayEvents = events[normalizedDay] ?? [];
    dayEvents.sort((a, b) => _isAscending
        ? a.startDate.compareTo(b.startDate)
        : b.startDate.compareTo(a.startDate));
    return dayEvents;
  }

  Future<void> saveEvent(Event event) async {
    try {
      await _acaraService.addEvent(event);
    } catch (e) {
      print('Error saving event: $e');
    }
  }

  Future<void> loadEvents() async {
    try {
      final loadedEvents = await _acaraService.getEvents();
      events.clear(); // Clear the map before loading new events
      for (var event in loadedEvents) {
        final day = normalizeDate(event.startDate);
        if (events.containsKey(day)) {
          events[day]!.add(event);
        } else {
          events[day] = [event];
        }
      }
      if (_selectedDay != null) {
        _selectedEvents.value = getEventsForDay(_selectedDay!);
      } else {
        _selectedEvents.value = getEventsForDay(_focusedDay);
      }
    } catch (e) {
      print('Error loading events: $e');
    }
  }

  DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Future<void> deleteEvent(String eventId, DateTime day, Event event) async {
    try {
      events[day]?.remove(event);
      if (events[day]?.isEmpty ?? true) {
        events.remove(day);
      }
      _selectedEvents.value = getEventsForDay(day);
      await _acaraService.deleteEvent(eventId);
    } catch (e) {
      print('Error deleting event: $e');
    }
  }
}
