import 'dart:ui';
import 'package:flutter/material.dart';

void main() => runApp(const WeatherApp());

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather UI',
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final List<_Forecast> forecasts = const [
    _Forecast(day: 'Mon', tempC: 19, icon: Icons.cloud),
    _Forecast(day: 'Tue', tempC: 19, icon: Icons.cloud_queue),
    _Forecast(day: 'Wed', tempC: 18, icon: Icons.wb_cloudy),
    _Forecast(day: 'Thu', tempC: 19, icon: Icons.cloud),
    _Forecast(day: 'Fri', tempC: 21, icon: Icons.wb_sunny),
    _Forecast(day: 'Sat', tempC: 22, icon: Icons.sunny),
    _Forecast(day: 'Sun', tempC: 20, icon: Icons.cloud),
  ];

  late final PageController _pageController;
  double _page = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.28, initialPage: 0);
    _pageController.addListener(() {
      setState(() => _page = _pageController.page ?? 0);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goPrev() {
    final current = _page.round();
    final target = (current - 1).clamp(0, forecasts.length - 1);
    _pageController.animateToPage(
      target,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void _goNext() {
    final current = _page.round();
    final target = (current + 1).clamp(0, forecasts.length - 1);
    _pageController.animateToPage(
      target,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF202B62),
              Color(0xFF4B2C8B),
              Color(0xFF7B2BBE),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'North America',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Max: 24°   Min: 18°',
                  style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
                ),
                const SizedBox(height: 28),
                Text(
                  '7-Days Forecasts',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.95),
                  ),
                ),
                const SizedBox(height: 14),

                SizedBox(
                  height: 140,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: forecasts.length,
                        physics: const BouncingScrollPhysics(),
                        padEnds: false,
                        itemBuilder: (context, index) {
                          final distance = (index - _page).abs().clamp(0.0, 1.0);
                          final scale = 1.0 - (0.25 * distance);
                          final opacity = 1.0 - (0.45 * distance);
                          return Center(
                            child: AnimatedScale(
                              scale: scale,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut,
                              child: Opacity(
                                opacity: opacity,
                                child: _ForecastChip(forecast: forecasts[index]),
                              ),
                            ),
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _RoundIconButton(
                          icon: Icons.chevron_left,
                          onTap: _goPrev,
                          enabled: _page > 0.01,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _RoundIconButton(
                          icon: Icons.chevron_right,
                          onTap: _goNext,
                          enabled: _page < forecasts.length - 1.01,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                _GlassCard(
                  borderRadius: 20,
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          _IconBadge(icon: Icons.air_rounded),
                          SizedBox(width: 10),
                          _Caps(text: 'AIR QUALITY'),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        '3-Low Health Risk',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                      const SizedBox(height: 14),
                      Center(
                        child: _GradientLine(
                          width: 308,
                          thickness: 5,
                          colors: [
                            Color(0xFF362A84),
                            Color(0x805BCAD1),
                            Color(0xFFBD08FC),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text('See more', style: TextStyle(color: Colors.white.withOpacity(0.95))),
                          const Spacer(),
                          Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.95)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: const [
                    Expanded(
                      child: _InfoTile(
                        title: 'SUNRISE',
                        primary: '5:28 AM',
                        secondary: 'Sunset: 7.25PM',
                        icon: Icons.wb_twilight,
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: _InfoTile(
                        title: 'UV INDEX',
                        primary: '4',
                        secondary: 'Moderate',
                        icon: Icons.wb_sunny_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Forecast {
  final String day;
  final int tempC;
  final IconData icon;
  const _Forecast({required this.day, required this.tempC, required this.icon});
}

class _ForecastChip extends StatelessWidget {
  final _Forecast forecast;
  const _ForecastChip({required this.forecast});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      borderRadius: 26,
      width: 86,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${forecast.tempC}°C',
              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16)),
          Icon(forecast.icon, size: 26, color: Colors.white),
          Text(forecast.day, style: TextStyle(color: Colors.white.withOpacity(0.9))),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String primary;
  final String secondary;
  final IconData icon;

  const _InfoTile({required this.title, required this.primary, required this.secondary, required this.icon});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      borderRadius: 16,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _IconBadge(icon: icon),
              const SizedBox(width: 10),
              _Caps(text: title),
            ],
          ),
          const SizedBox(height: 14),
          Text(primary, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 6),
          Text(secondary, style: TextStyle(color: Colors.white.withOpacity(0.9))),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double? width;

  const _GlassCard({
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.borderRadius = 16,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: width,
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.white.withOpacity(0.25)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const _RoundIconButton({
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = enabled ? Colors.white : Colors.white.withOpacity(0.35);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(enabled ? 0.18 : 0.08),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.25)),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final double size;

  const _IconBadge({required this.icon, this.size = 22});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF362A84), Color(0xFFBD08FC)],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: size, color: Colors.white),
    );
  }
}

class _Caps extends StatelessWidget {
  final String text;
  const _Caps({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        letterSpacing: 0.6,
        fontSize: 12,
        color: Colors.white.withOpacity(0.9),
      ),
    );
  }
}

class _GradientLine extends StatelessWidget {
  final double width;
  final double thickness;
  final List<Color> colors;

  const _GradientLine({
    required this.width,
    required this.thickness,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: thickness,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(thickness / 2),
      ),
    );
  }
}