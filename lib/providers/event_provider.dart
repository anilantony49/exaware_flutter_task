import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/event_model.dart';
import '../services/api_service.dart';

class EventProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<EventModel> _events = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<EventModel> get events => _events;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchEvents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Trying to fetch from real API
      final response = await _apiService.get('/events');
      if (response.statusCode == 200 && response.data != null) {
        final List data = response.data;
        _events = data.map((e) => EventModel.fromJson(e)).toList();
      }
    } on DioException catch (_) {
      // Mock data source for the assignment offline fallback
      await Future.delayed(const Duration(milliseconds: 600));
      _events = [
        EventModel(
          id: '1',
          title: 'Flutter Forward Extended',
          date: '2026-04-10',
          location: 'New York City, NY',
          description: 'A community driven event to discuss features and plans for Flutter. Join the experts to gain insight.',
        ),
        EventModel(
          id: '2',
          title: 'Developer Keynote 2026',
          date: '2026-05-22',
          location: 'San Francisco, CA',
          description: 'Annual developers gathering highlighting the latest UI and Framework upgrades.',
        ),
        EventModel(
          id: '3',
          title: 'Startup Pitch Night',
          date: '2026-07-15',
          location: 'Austin, TX',
          description: 'Pitch your innovative startup to the top investors from the bay area and get funded instantly.',
        ),
      ];
    } catch (e) {
      _errorMessage = 'Failed to load events';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
