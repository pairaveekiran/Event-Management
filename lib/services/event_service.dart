import 'dart:convert';

import 'package:event_management/constants.dart';
import 'package:event_management/models/event_category.dart';
import 'package:http/http.dart'
    as http;

class EventService {
  Future<List<EventCategory>>
      fetchCategories() async {
    final Uri
        uri =
        Uri.parse('$baseUrl/api/events');

    try {
      final http.Response response = await http.get(uri);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
          'Failed to load categories. Server returned status code ${response.statusCode}.',
        );
      }

      final dynamic decodedBody = jsonDecode(response.body);

      if (decodedBody is! Map<String, dynamic>) {
        throw Exception('Invalid response format from the events API.');
      }

      if (decodedBody['status'] != 'success') {
        throw Exception(
          decodedBody['message']?.toString() ?? 'The events API returned an unsuccessful status.',
        );
      }

      final dynamic categoriesJson = decodedBody['categories'];

      if (categoriesJson is! List) {
        throw Exception('The categories field is missing or invalid.');
      }

      return categoriesJson.map<EventCategory>((dynamic item) {
        if (item is! Map) {
          throw Exception('A category item has an invalid format.');
        }

        return EventCategory.fromJson(item);
      }).toList();
    } on FormatException catch (error) {
      throw Exception('Unable to parse the events response: ${error.message}');
    } on http
    .ClientException catch (error) {
      throw Exception('Network error while fetching categories: $error');
    } catch (error) {
      if (error is Exception) {
        rethrow;
      }

      throw Exception('Unexpected error while fetching categories: $error');
    } finally {
      // Reserved for future cleanup or request tracing.
    }
  }
}
