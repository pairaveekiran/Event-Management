import 'package:event_management/models/event_category.dart';
import 'package:event_management/screen/homescreen.dart';
import 'package:event_management/services/event_service.dart';
import 'package:flutter/material.dart';

class EventDropdownScreen
    extends StatefulWidget {
  const EventDropdownScreen(
      {super.key});

  @override
  State<EventDropdownScreen> createState() =>
      _EventDropdownScreenState();
}

class _EventDropdownScreenState
    extends State<EventDropdownScreen> {
  // Categories loaded from the API.
  List<EventCategory>
      _categories =
      <EventCategory>[];

  // The currently selected category object, so the selected ID is preserved.
  EventCategory?
      _selectedCategory;

  // Loading and error state for the API request.
  bool
      _isLoading =
      true;
  String?
      _errorMessage;

  @override
  void
      initState() {
    super.initState();
    _loadCategories();
  }

  Future<void>
      _loadCategories() async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
          _errorMessage = null;
        });
      }

      final List<EventCategory> categories = await EventService().fetchCategories();

      if (!mounted) {
        return;
      }

      setState(() {
        _categories = categories;
        _selectedCategory = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = error.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void
      _handleEnterPressed() {
    final EventCategory?
        category =
        _selectedCategory;

    if (category ==
        null) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        settings: RouteSettings(arguments: category.id),
        builder: (context) => ServingMenuUI(
          categoryId: category.id,
          categoryTitle: category.title,
          categoryDate: category.date,
          categoryVenue: category.venue.trim(),
        ),
      ),
    );
  }

  @override
  Widget
      build(BuildContext context) {
    // FIXED
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4E8), // FIXED
      body: SafeArea(
        child: SingleChildScrollView(
          // FIXED
          child: ConstrainedBox(
            // FIXED
            constraints: BoxConstraints(
              // FIXED
              minHeight: MediaQuery.of(context).size.height, // FIXED
            ), // FIXED
            child: IntrinsicHeight(
              // FIXED
              child: Column(
                // FIXED
                crossAxisAlignment: CrossAxisAlignment.stretch, // FIXED
                children: [
                  // FIXED
                  Container(
                    // FIXED
                    width: double.infinity, // FIXED
                    decoration: const BoxDecoration(
                      // FIXED
                      gradient: LinearGradient(
                        // FIXED
                        begin: Alignment.topLeft, // FIXED
                        end: Alignment.bottomRight, // FIXED
                        colors: [
                          // FIXED
                          Color(0xFF18235C), // FIXED
                          Color(0xFF25348A), // FIXED
                        ], // FIXED
                      ), // FIXED
                      boxShadow: [
                        // FIXED
                        BoxShadow(
                          // FIXED
                          color: Color(0x22000000), // FIXED
                          blurRadius: 18, // FIXED
                          offset: Offset(0, 8), // FIXED
                        ), // FIXED
                      ], // FIXED
                    ), // FIXED
                    padding: const EdgeInsets.only(
                      // FIXED
                      top: 24, // FIXED
                      bottom: 18, // FIXED
                      left: 16, // FIXED
                      right: 16, // FIXED
                    ), // FIXED
                    child: const Column(
                      // FIXED
                      children: [
                        // FIXED
                        Text(
                          // FIXED
                          'Association of Alliance Clubs International', // FIXED
                          textAlign: TextAlign.center, // FIXED
                          style: TextStyle(
                            // FIXED
                            color: Colors.white, // FIXED
                            fontSize: 15, // FIXED
                            fontWeight: FontWeight.w600, // FIXED
                            letterSpacing: 0.2, // FIXED
                          ), // FIXED
                        ), // FIXED
                        SizedBox(height: 6), // FIXED
                        Text(
                          // FIXED
                          'District 1055, Nepal', // FIXED
                          textAlign: TextAlign.center, // FIXED
                          style: TextStyle(
                            // FIXED
                            color: Colors.white, // FIXED
                            fontSize: 17, // FIXED
                            fontWeight: FontWeight.bold, // FIXED
                            letterSpacing: 0.3, // FIXED
                          ), // FIXED
                        ), // FIXED
                      ], // FIXED
                    ), // FIXED
                  ), // FIXED
                  Container(
                    // FIXED
                    height: 4, // FIXED
                    decoration: const BoxDecoration(
                      // FIXED
                      gradient: LinearGradient(
                        // FIXED
                        colors: [
                          // FIXED
                          Color(0xFFE0C61B), // FIXED
                          Color(0xFFFFD84D), // FIXED
                        ], // FIXED
                      ), // FIXED
                    ), // FIXED
                  ), // FIXED
                  const SizedBox(height: 28), // FIXED
                  Padding(
                    // FIXED
                    padding: const EdgeInsets.symmetric(horizontal: 28), // FIXED
                    child: Row(
                      // FIXED
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // FIXED
                      children: [
                        // FIXED
                        Image.asset(
                          // FIXED
                          'assets/images/club_logo.png', // FIXED
                          height: 70, // FIXED
                          width: 70, // FIXED
                          fit: BoxFit.contain, // FIXED
                        ), // FIXED
                        Image.asset(
                          // FIXED
                          'assets/images/flag.png', // FIXED
                          height: 70, // FIXED
                          width: 70, // FIXED
                          fit: BoxFit.contain, // FIXED
                        ), // FIXED
                        Image.asset(
                          // FIXED
                          'assets/images/international_logo.png', // FIXED
                          height: 70, // FIXED
                          width: 70, // FIXED
                          fit: BoxFit.contain, // FIXED
                        ), // FIXED
                      ], // FIXED
                    ), // FIXED
                  ), // FIXED
                  const SizedBox(height: 28), // FIXED
                  Padding(
                    // FIXED
                    padding: const EdgeInsets.symmetric(horizontal: 18), // FIXED
                    child: Container(
                      // FIXED
                      width: double.infinity, // FIXED
                      padding: const EdgeInsets.symmetric(
                        // FIXED
                        vertical: 24, // FIXED
                        horizontal: 16, // FIXED
                      ), // FIXED
                      decoration: BoxDecoration(
                        // FIXED
                        color: const Color(0xFFF7F2D8), // FIXED
                        borderRadius: BorderRadius.circular(30), // FIXED
                        border: Border.all(
                          // FIXED
                          color: const Color(0xFFE0C61B), // FIXED
                          width: 1.2, // FIXED
                        ), // FIXED
                        boxShadow: const [
                          // FIXED
                          BoxShadow(
                            // FIXED
                            color: Color(0x22000000), // FIXED
                            blurRadius: 22, // FIXED
                            offset: Offset(0, 10), // FIXED
                          ), // FIXED
                        ], // FIXED
                      ), // FIXED
                      child: Column(
                        // FIXED
                        mainAxisSize: MainAxisSize.min, // FIXED
                        crossAxisAlignment: CrossAxisAlignment.stretch, // FIXED
                        children: [
                          // FIXED
                          Row(
                            // FIXED
                            children: [
                              // FIXED
                              Container(
                                // FIXED
                                width: 44, // FIXED
                                height: 44, // FIXED
                                decoration: BoxDecoration(
                                  // FIXED
                                  color: const Color(0xFF1F2A74).withAlpha(18), // FIXED
                                  borderRadius: BorderRadius.circular(14), // FIXED
                                ), // FIXED
                                child: const Icon(
                                  // FIXED
                                  Icons.event_note_rounded, // FIXED
                                  color: Color(0xFF1F2A74), // FIXED
                                ), // FIXED
                              ), // FIXED
                              const SizedBox(width: 14), // FIXED
                              const Expanded(
                                // FIXED
                                child: Column(
                                  // FIXED
                                  crossAxisAlignment: CrossAxisAlignment.start, // FIXED
                                  children: [
                                    // FIXED
                                    Text(
                                      // FIXED
                                      'Choose Event', // FIXED
                                      style: TextStyle(
                                        // FIXED
                                        fontSize: 27, // FIXED
                                        fontWeight: FontWeight.w800, // FIXED
                                        color: Color(0xFF1F2A74), // FIXED
                                        letterSpacing: 0.2, // FIXED
                                      ), // FIXED
                                    ), // FIXED
                                    SizedBox(height: 4), // FIXED
                                    Text(
                                      // FIXED
                                      'Select a category to continue', // FIXED
                                      style: TextStyle(
                                        // FIXED
                                        fontSize: 13.5, // FIXED
                                        color: Color(0xFF6A6A55), // FIXED
                                        fontWeight: FontWeight.w500, // FIXED
                                      ), // FIXED
                                    ), // FIXED
                                  ], // FIXED
                                ), // FIXED
                              ), // FIXED
                            ], // FIXED
                          ), // FIXED
                          const SizedBox(height: 26), // FIXED
                          if (_isLoading) // FIXED
                            const SizedBox(
                              // FIXED
                              height: 50, // FIXED
                              child: Center(
                                // FIXED
                                child: CircularProgressIndicator(
                                  // FIXED
                                  strokeWidth: 2.6, // FIXED
                                ), // FIXED
                              ), // FIXED
                            ) // FIXED
                          else if (_errorMessage != null) // FIXED
                            Container(
                              // FIXED
                              width: double.infinity, // FIXED
                              padding: const EdgeInsets.all(16), // FIXED
                              decoration: BoxDecoration(
                                // FIXED
                                color: Colors.white, // FIXED
                                borderRadius: BorderRadius.circular(20), // FIXED
                                border: Border.all(
                                  // FIXED
                                  color: Colors.red.shade300, // FIXED
                                  width: 1.2, // FIXED
                                ), // FIXED
                              ), // FIXED
                              child: Column(
                                // FIXED
                                mainAxisSize: MainAxisSize.min, // FIXED
                                children: [
                                  // FIXED
                                  Row(
                                    // FIXED
                                    crossAxisAlignment: CrossAxisAlignment.start, // FIXED
                                    children: [
                                      // FIXED
                                      const Icon(
                                        // FIXED
                                        Icons.error_outline_rounded, // FIXED
                                        color: Colors.red, // FIXED
                                      ), // FIXED
                                      const SizedBox(width: 10), // FIXED
                                      Expanded(
                                        // FIXED
                                        child: Text(
                                          // FIXED
                                          _errorMessage!, // FIXED
                                          style: const TextStyle(
                                            // FIXED
                                            color: Colors.red, // FIXED
                                            fontSize: 15, // FIXED
                                            fontWeight: FontWeight.w600, // FIXED
                                            height: 1.3, // FIXED
                                          ), // FIXED
                                        ), // FIXED
                                      ), // FIXED
                                    ], // FIXED
                                  ), // FIXED
                                  const SizedBox(height: 14), // FIXED
                                  OutlinedButton.icon(
                                    // FIXED
                                    onPressed: _loadCategories, // FIXED
                                    style: OutlinedButton.styleFrom(
                                      // FIXED
                                      foregroundColor: const Color(0xFF1F2A74), // FIXED
                                      side: const BorderSide(color: Color(0xFF1F2A74)), // FIXED
                                      shape: RoundedRectangleBorder(
                                        // FIXED
                                        borderRadius: BorderRadius.circular(14), // FIXED
                                      ), // FIXED
                                    ), // FIXED
                                    icon: const Icon(Icons.refresh_rounded), // FIXED
                                    label: const Text('Retry'), // FIXED
                                  ), // FIXED
                                ], // FIXED
                              ), // FIXED
                            ) // FIXED
                          else // FIXED
                            Column(
                              // FIXED
                              crossAxisAlignment: CrossAxisAlignment.stretch, // FIXED
                              children: [
                                // FIXED
                                const Text(
                                  // FIXED
                                  'Event category', // FIXED
                                  style: TextStyle(
                                    // FIXED
                                    fontSize: 13, // FIXED
                                    fontWeight: FontWeight.w700, // FIXED
                                    color: Color(0xFF5E5E49), // FIXED
                                    letterSpacing: 0.3, // FIXED
                                  ), // FIXED
                                ), // FIXED
                                const SizedBox(height: 8), // FIXED
                                Container(
                                  // FIXED
                                  width: double.infinity, // FIXED
                                  padding: const EdgeInsets.symmetric(horizontal: 14), // FIXED
                                  decoration: BoxDecoration(
                                    // FIXED
                                    color: Colors.white, // FIXED
                                    borderRadius: BorderRadius.circular(20), // FIXED
                                    border: Border.all(
                                      // FIXED
                                      color: const Color(0xFF2E7D32), // FIXED
                                      width: 1.5, // FIXED
                                    ), // FIXED
                                    boxShadow: const [
                                      // FIXED
                                      BoxShadow(
                                        // FIXED
                                        color: Color(0x11000000), // FIXED
                                        blurRadius: 12, // FIXED
                                        offset: Offset(0, 4), // FIXED
                                      ), // FIXED
                                    ], // FIXED
                                  ), // FIXED
                                  child: SizedBox(
                                    // FIXED
                                    width: double.infinity, // FIXED
                                    child: DropdownButtonHideUnderline(
                                      // FIXED
                                      child: DropdownButton<EventCategory>(
                                        // FIXED
                                        isExpanded: true, // FIXED
                                        value: _selectedCategory, // FIXED
                                        hint: const Text(
                                          // FIXED
                                          'Select Event', // FIXED
                                          style: TextStyle(
                                            // FIXED
                                            fontSize: 17, // FIXED
                                            color: Color(0xFF7B7B7B), // FIXED
                                          ), // FIXED
                                        ), // FIXED
                                        icon: const Icon(
                                          // FIXED
                                          Icons.keyboard_arrow_down_rounded, // FIXED
                                          color: Color(0xFF2E7D32), // FIXED
                                          size: 30, // FIXED
                                        ), // FIXED
                                        borderRadius: BorderRadius.circular(18), // FIXED
                                        dropdownColor: Colors.white, // FIXED
                                        items: _categories.map((EventCategory category) {
                                          // FIXED
                                          return DropdownMenuItem<EventCategory>(
                                            // FIXED
                                            value: category, // FIXED
                                            child: Text(
                                              // FIXED
                                              category.title, // FIXED
                                              overflow: TextOverflow.ellipsis, // FIXED
                                              style: const TextStyle(
                                                // FIXED
                                                fontSize: 17, // FIXED
                                                fontWeight: FontWeight.w500, // FIXED
                                                color: Color(0xFF24324D), // FIXED
                                              ), // FIXED
                                            ), // FIXED
                                          ); // FIXED
                                        }).toList(), // FIXED
                                        onChanged: (EventCategory? newValue) {
                                          // FIXED
                                          setState(() {
                                            // FIXED
                                            _selectedCategory = newValue; // FIXED
                                          }); // FIXED
                                        }, // FIXED
                                      ), // FIXED
                                    ), // FIXED
                                  ), // FIXED
                                ), // FIXED
                              ], // FIXED
                            ), // FIXED
                          const SizedBox(height: 24), // FIXED
                          SizedBox(
                            // FIXED
                            width: double.infinity, // FIXED
                            height: 58, // FIXED
                            child: ElevatedButton(
                              // FIXED
                              onPressed: _selectedCategory == null // FIXED
                                  ? null // FIXED
                                  : _handleEnterPressed, // FIXED
                              style: ElevatedButton.styleFrom(
                                // FIXED
                                backgroundColor: const Color(0xFFD7263D), // FIXED
                                disabledBackgroundColor: const Color(0xFFB8B8B8), // FIXED
                                disabledForegroundColor: Colors.white, // FIXED
                                elevation: 0, // FIXED
                                shadowColor: const Color(0x33000000), // FIXED
                                shape: RoundedRectangleBorder(
                                  // FIXED
                                  borderRadius: BorderRadius.circular(18), // FIXED
                                ), // FIXED
                              ), // FIXED
                              child: const Text(
                                // FIXED
                                'Enter', // FIXED
                                style: TextStyle(
                                  // FIXED
                                  fontSize: 20, // FIXED
                                  fontWeight: FontWeight.w700, // FIXED
                                  letterSpacing: 0.3, // FIXED
                                  color: Colors.white, // FIXED
                                ), // FIXED
                              ), // FIXED
                            ), // FIXED
                          ), // FIXED
                        ], // FIXED
                      ), // FIXED
                    ), // FIXED
                  ), // FIXED
                  const SizedBox(height: 34), // FIXED
                ], // FIXED
              ), // FIXED
            ), // FIXED
          ), // FIXED
        ),
      ),
    );
  }
}
