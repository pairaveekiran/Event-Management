import 'package:event_management/screen/breakfast.dart';
import 'package:event_management/screen/dinner.dart';
import 'package:event_management/screen/drinks.dart';
import 'package:event_management/screen/lunch.dart';
import 'package:event_management/screen/tea.dart';
import 'package:event_management/models/meals_config.dart';
import 'package:event_management/services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:event_management/widgets/app_credit_footer.dart';

class ServingMenuUI
    extends StatefulWidget {
  const ServingMenuUI(
      {super.key,
      this.categoryId,
      this.categoryTitle,
      this.categoryDate,
      this.categoryVenue});

  final int?
      categoryId;
  final String?
      categoryTitle;
  final String?
      categoryDate;
  final String?
      categoryVenue;

  @override
  State<ServingMenuUI> createState() =>
      _ServingMenuUIState();
}

class _ServingMenuUIState
    extends State<ServingMenuUI> {
  MealsConfig?
      _mealsConfig;
  bool
      _isLoading =
      true;
  String?
      _errorMessage;
  late int
      _eventId;
  bool
      _initialized =
      false;

  @override
  void
      didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) {
      return;
    }

    final Object?
        arguments =
        ModalRoute.of(context)?.settings.arguments;
    if (arguments
        is int) {
      _eventId = arguments;
    } else if (widget.categoryId !=
        null) {
      _eventId = widget.categoryId!;
    } else {
      _errorMessage = 'Missing event id';
      _isLoading = false;
      _initialized = true;
      return;
    }

    _initialized =
        true;
    _loadMealsConfig();
  }

  Future<void>
      _loadMealsConfig() async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
          _errorMessage = null;
        });
      }

      final MealsConfig mealsConfig = await EventService().fetchMealsConfig(_eventId);

      if (!mounted) {
        return;
      }

      setState(() {
        _mealsConfig = mealsConfig;
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

  List<Map<String, dynamic>>
      _getActiveMeals() {
    if (_mealsConfig ==
        null) {
      return <Map<String, dynamic>>[];
    }

    final List<Map<String, dynamic>>
        meals =
        <Map<String, dynamic>>[];

    if (_mealsConfig!.showBreakfast) {
      meals.add(<String, dynamic>{
        'label': 'Breakfast',
        'icon': Icons.breakfast_dining,
        'color': const Color(0xFF2d5a27),
        'bgColor': const Color(0xFFe8f5e9),
      });
    }

    if (_mealsConfig!.showLunch) {
      meals.add(<String, dynamic>{
        'label': 'Lunch',
        'icon': Icons.lunch_dining,
        'color': const Color(0xFF7b1fa2),
        'bgColor': const Color(0xFFf3e5f5),
      });
    }

    if (_mealsConfig!.showDinner) {
      meals.add(<String, dynamic>{
        'label': 'Dinner',
        'icon': Icons.restaurant,
        'color': const Color(0xFF0288d1),
        'bgColor': const Color(0xFFe1f5fe),
      });
    }

    if (_mealsConfig!.showTea) {
      meals.add(<String, dynamic>{
        'label': 'Tea',
        'icon': Icons.coffee,
        'color': const Color(0xFF5d4037),
        'bgColor': const Color(0xFFefebe9),
      });
    }

    if (_mealsConfig!.showDrinks) {
      meals.add(<String, dynamic>{
        'label': 'Drinks',
        'icon': Icons.local_bar,
        'color': const Color(0xFFf57c00),
        'bgColor': const Color(0xFFFFF8E1),
      });
    }

    return meals;
  }

  Widget
      _buildMealButton({
    required String
        label,
    required IconData
        icon,
    required Color
        color,
    required Color
        bgColor,
  }) {
    return GestureDetector(
      onTap: () {
        if (label == 'Breakfast') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Breakfast(
                categoryId: widget.categoryId,
                categoryTitle: widget.categoryTitle,
                categoryDate: widget.categoryDate,
                categoryVenue: widget.categoryVenue,
              ),
            ),
          );
          return;
        }

        if (label == 'Lunch') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Lunch(
                categoryId: widget.categoryId,
                categoryTitle: widget.categoryTitle,
                categoryDate: widget.categoryDate,
                categoryVenue: widget.categoryVenue,
              ),
            ),
          );
          return;
        }

        if (label == 'Dinner') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dinner(
                categoryId: widget.categoryId,
                categoryTitle: widget.categoryTitle,
                categoryDate: widget.categoryDate,
                categoryVenue: widget.categoryVenue,
              ),
            ),
          );
          return;
        }

        if (label == 'Tea') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Tea(
                categoryId: widget.categoryId,
                categoryTitle: widget.categoryTitle,
                categoryDate: widget.categoryDate,
                categoryVenue: widget.categoryVenue,
              ),
            ),
          );
          return;
        }

        if (label == 'Drinks') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Drinks(
                categoryId: widget.categoryId,
                categoryTitle: widget.categoryTitle,
                categoryDate: widget.categoryDate,
                categoryVenue: widget.categoryVenue,
              ),
            ),
          );
        }
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 36),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget
      build(BuildContext context) {
    final String
        headerTitle =
        widget.categoryTitle ?? 'Alliance Leadership Development Institute(ALDI)-2026';
    final String headerDate = (widget.categoryDate?.trim().isNotEmpty ?? false)
        ? widget.categoryDate!.trim()
        : 'Date not available';
    final String headerVenue = (widget.categoryVenue?.trim().isNotEmpty ?? false)
        ? widget.categoryVenue!.trim()
        : 'Venue not available';
    final String
        headerDateVenue =
        '$headerDate, $headerVenue';

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      bottomNavigationBar: const AppCreditFooter(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ================= HEADER =================

              Container(
                width: double.infinity,
                color: const Color(0xFF1F2A74),
                padding: const EdgeInsets.only(
                  top: 18,
                  bottom: 12,
                  left: 12,
                  right: 12,
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/',
                              (route) => false,
                            );
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          tooltip: 'Back',
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Association of Alliance Clubs International",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "District 1055, Nepal",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 28),
                      ],
                    ),
                    const SizedBox(height: 5),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        headerTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.yellow,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      headerDateVenue,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                height: 3,
                color: Colors.yellow,
              ),

              const SizedBox(height: 20),

              // ================= LOGOS =================

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(
                      "assets/images/club_logo.png",
                      height: 58,
                      width: 58,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 50,
                        );
                      },
                    ),
                    Image.asset(
                      "assets/images/international_logo.png",
                      height: 58,
                      width: 58,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 50,
                        );
                      },
                    ),
                    Image.asset(
                      "assets/images/flag.png",
                      height: 58,
                      width: 58,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 50,
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ================= MAIN BOX =================

              Container(
                margin: const EdgeInsets.all(14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5DD),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: Colors.yellow,
                    width: 1.2,
                  ),
                ),
                child: Column(
                  children: [
                    // TITLE
                    const Text(
                      "Serving Menu",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF273C8F),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Container(height: 3, width: 220, color: Colors.red),

                    const SizedBox(height: 24),

                    if (_isLoading)
                      const SizedBox(
                        height: 120,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF1a237e),
                          ),
                        ),
                      )
                    else if (_errorMessage != null)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _loadMealsConfig,
                            child: const Text('Retry'),
                          ),
                        ],
                      )
                    else
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: _getActiveMeals().map((meal) {
                          return _buildMealButton(
                            label: meal['label'] as String,
                            icon: meal['icon'] as IconData,
                            color: meal['color'] as Color,
                            bgColor: meal['bgColor'] as Color,
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
