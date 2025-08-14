import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class WeatherHomeScreen extends StatelessWidget {
  const WeatherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.gradientTop, AppColors.gradientBottom],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            children: const [
              _Header(),
              SizedBox(height: 20),
              _ForecastSection(),
              SizedBox(height: 20),
              _AirQualityCard(),
              SizedBox(height: 16),
              _BottomStats(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 12),
        Text('North America', style: theme.titleLarge),
        const SizedBox(height: 4),
        Text(
          'Max: 24°   Min: 18°',
          style: theme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Forecast Section with one-by-one scroll + hover effect
class _ForecastSection extends StatefulWidget {
  const _ForecastSection();

  @override
  State<_ForecastSection> createState() => _ForecastSectionState();
}

class _ForecastSectionState extends State<_ForecastSection> {
  final PageController _pageController = PageController(viewportFraction: 0.28);
  int _currentPage = 0;
  int _hoveredIndex = -1;

  final List<Map<String, String>> items = const [
    {'day': 'Mon', 'temp': '19°C', 'asset': 'assets/images/cloud_rain_day.png'},
    {'day': 'Tue', 'temp': '18°C', 'asset': 'assets/images/cloud_rain_day.png'},
    {'day': 'Wed', 'temp': '18°C', 'asset': 'assets/images/cloud_rain_night.png'},
    {'day': 'Thu', 'temp': '19°C', 'asset': 'assets/images/cloud_rain_day.png'},
    {'day': 'Fri', 'temp': '20°C', 'asset': 'assets/images/cloud_rain_day.png'},
    {'day': 'Sat', 'temp': '17°C', 'asset': 'assets/images/cloud_rain_night.png'},
    {'day': 'Sun', 'temp': '21°C', 'asset': 'assets/images/cloud_rain_day.png'},
  ];

  void _scrollRight() {
    if (_currentPage < items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _scrollLeft() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('7-Days Forecasts', style: theme.titleMedium),
        const SizedBox(height: 12),

        Row(
          children: [
            /// Left arrow
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.black45,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.arrow_back_ios,
                    size: 16, color: Colors.white),
                onPressed: _scrollLeft,
              ),
            ),
            const SizedBox(width: 8),

            /// PageView (scrolls one by one)
            Expanded(
              child: SizedBox(
                height: 150,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final bool isSelected = index == _currentPage;
                    final bool isHovered = index == _hoveredIndex;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: MouseRegion(
                        onEnter: (_) => setState(() => _hoveredIndex = index),
                        onExit: (_) => setState(() => _hoveredIndex = -1),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(40),
                          onTap: () => setState(() => _currentPage = index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.chipSelected
                                  : isHovered
                                  ? Colors.white24
                                  : AppColors.chipUnselected,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item['temp']!, style: theme.titleMedium),
                                SizedBox(
                                  height: 36,
                                  child: Image.asset(item['asset']!,
                                      fit: BoxFit.contain),
                                ),
                                Text(item['day']!, style: theme.labelLarge),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 8),

            /// Right arrow
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.black45,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.white),
                onPressed: _scrollRight,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AirQualityCard extends StatelessWidget {
  const _AirQualityCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardAlt,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.air, color: Colors.white70),
              const SizedBox(width: 8),
              Text(
                'AIR QUALITY',
                style:
                theme.labelLarge?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('3-Low Health Risk', style: theme.titleLarge),
          const SizedBox(height: 12),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('See more',
                  style: theme.labelLarge?.copyWith(color: Colors.white)),
              const Icon(Icons.chevron_right, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomStats extends StatelessWidget {
  const _BottomStats();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.wb_sunny, color: Colors.white70),
                    const SizedBox(width: 8),
                    Text('SUNRISE',
                        style: theme.labelLarge
                            ?.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 12),
                Text('5:28 AM', style: theme.titleLarge),
                const SizedBox(height: 6),
                Text('Sunset: 7:25PM',
                    style: theme.bodySmall
                        ?.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.brightness_5, color: Colors.white70),
                    const SizedBox(width: 8),
                    Text('UV INDEX',
                        style: theme.labelLarge
                            ?.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 12),
                Text('4', style: theme.titleLarge),
                const SizedBox(height: 6),
                Text('Moderate', style: theme.titleMedium),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
