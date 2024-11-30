import 'dart:math' as math;

import 'package:clover/clover.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather/models.dart';
import 'package:weather/view_models.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<HomeViewModel>(context);
    final weather = viewModel.weather;
    if (weather == null) {
      return buildLoadingView(context);
    } else {
      final size = MediaQuery.sizeOf(context);
      // https://m3.material.io/foundations/layout/applying-layout/window-size-classes
      return size.width < 600
          ? buildWeatherView(context, weather)
          : Material(
              child: Row(
                children: [
                  Expanded(
                    child: buildWeatherView(context, weather),
                  ),
                  Container(
                    width: 160.0,
                    alignment: Alignment.bottomRight,
                    child: buildSignatureView(context),
                  ),
                ],
              ),
            );
    }
  }

  Widget buildLoadingView(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildWeatherView(BuildContext context, Weather weather) {
    final realWeather = weather.realWeather;
    final hourlyWeathers = weather.hourlyWeathers;
    final dailyWeathers = weather.dailyWeathers;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu_rounded),
        ),
        title: Text(weather.date.titleValue),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Text(
              '⁰C',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: buildRealView(context, realWeather),
            ),
            if (hourlyWeathers.isNotEmpty) const Divider(),
            if (hourlyWeathers.isNotEmpty)
              SizedBox(
                height: 60.0,
                child: buildHourlyView(context, hourlyWeathers),
              ),
            const Divider(),
            Expanded(
              child: buildDailyView(context, dailyWeathers),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRealView(BuildContext context, RealWeather weather) {
    final brightness = Theme.of(context).brightness;
    final city = weather.city;
    final state = weather.state;
    final description = weather.description;
    final temperature = weather.temperature;
    final feels = weather.feels;
    final lowest = weather.lowest;
    final highest = weather.highest;
    final windDirection = weather.windDirection;
    final windAbbr = weather.windAbbr;
    final windSpeed = weather.windSpeed;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  city,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Text(
                '$temperature⁰',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              Text(
                'Feels like $feels⁰',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Divider(),
              Row(
                children: [
                  CustomPaint(
                    size: const Size.square(12.0),
                    painter: ArrowPainter(
                      rotationDegrees: 0.0,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    '$highest⁰',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(width: 12.0),
                  CustomPaint(
                    size: const Size.square(12.0),
                    painter: ArrowPainter(
                      rotationDegrees: 180.0,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    '$lowest⁰',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              Tooltip(
                message: windDirection,
                child: Text(
                  '$windAbbr $windSpeed m/s',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8.0),
        AspectRatio(
          aspectRatio: 0.64,
          child: OverflowBox(
            maxWidth: double.infinity,
            alignment: Alignment.centerLeft,
            child: Tooltip(
              message: description,
              child: SvgPicture.asset(
                getAssetName(state, brightness),
                alignment: Alignment.centerLeft,
                fit: BoxFit.fitHeight,
                clipBehavior: Clip.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHourlyView(BuildContext context, List<HourlyWeather> weathers) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: weathers.length,
      itemBuilder: (context, index) {
        final weather = weathers[index];
        final temperature = weather.temperature;
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              weather.date.hourValue,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
            ),
            Text(
              '$temperature⁰',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(width: 40.0);
      },
    );
  }

  Widget buildDailyView(BuildContext context, List<DailyWeather> weathers) {
    final brightness = Theme.of(context).brightness;
    return ListView.separated(
      itemCount: weathers.length,
      itemBuilder: (context, index) {
        final weather = weathers[index];
        final state = weather.state;
        final description = weather.description;
        final lowest = weather.lowest;
        final highest = weather.highest;
        return Row(
          children: [
            Text(
              weather.date.dayVaue,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            Tooltip(
              message: description,
              child: SvgPicture.asset(
                getAssetName(state, brightness),
                width: 32.0,
                height: 32.0,
              ),
            ),
            Container(
              width: 112.0,
              alignment: Alignment.centerRight,
              child: Text(
                '$highest⁰',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Container(
              width: 28.0,
              alignment: Alignment.centerRight,
              child: Text(
                '$lowest⁰',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
              ),
            ),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 16.0);
      },
    );
  }

  Widget buildSignatureView(BuildContext context) {
    return FractionalTranslation(
      translation: const Offset(0.5, 0.5),
      child: Transform.rotate(
        alignment: Alignment.topLeft,
        angle: -math.pi / 2,
        child: Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'DESIGNED BY ',
              ),
              TextSpan(
                text: 'Ochakov',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    final url = Uri.https('figma.com', '/@ochakov');
                    launchUrl(url);
                  },
              ),
              const TextSpan(
                text: '\n',
              ),
              const TextSpan(
                text: 'POWERED BY ',
              ),
              TextSpan(
                text: 'Flutter',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    final url = Uri.https('flutter.dev');
                    launchUrl(url);
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getAssetName(WeatherState state, Brightness brightness) {
    final number = getAssetNumber(state, brightness);
    return 'images/3D Ico_$number.svg';
  }

  String getAssetNumber(WeatherState state, Brightness brightness) {
    final isDay = brightness == Brightness.light;
    switch (state) {
      case WeatherState.unknown:
        return '36';
      case WeatherState.sunny:
        return isDay ? '33' : '28';
      case WeatherState.cloudy:
        return isDay ? '04' : '08';
      case WeatherState.overcast:
        return '01';
      case WeatherState.windy:
        return '23';
      case WeatherState.rainy:
        return '17';
      case WeatherState.thundershower:
        return '13';
      case WeatherState.sleety:
        return '27';
      case WeatherState.snowy:
        return '20';
      case WeatherState.foggy:
        return '03';
      case WeatherState.tornadic:
        return '24';
      case WeatherState.dewed:
        return '26';
      case WeatherState.sunshower:
        return isDay ? '16' : '15';
      case WeatherState.sunsnow:
        return isDay ? '30' : '29';
    }
  }
}

class ArrowPainter extends CustomPainter {
  final double rotationDegrees;
  final Color color;

  ArrowPainter({
    required this.rotationDegrees,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    final center = bounds.center;
    final shortestSide = size.shortestSide;
    final path = Path()
      ..moveTo(-shortestSide / 2.0, shortestSide / 4.0)
      ..lineTo(0.0, -shortestSide / 4.0)
      ..lineTo(shortestSide / 2.0, shortestSide / 4.0);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = color;
    final radians = math.pi / 180 * rotationDegrees;
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(radians);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! ArrowPainter ||
        oldDelegate.rotationDegrees != rotationDegrees ||
        oldDelegate.color != color;
  }
}

extension on RealWeather {
  String get windAbbr {
    final windDegree = this.windDegree;
    if (windDegree < 0 || windDegree >= 360) {
      return '$windDegree';
    }
    if (windDegree == 0) {
      return 'N';
    }
    if (windDegree < 45) {
      return 'NNE';
    }
    if (windDegree == 45) {
      return 'NE';
    }
    if (windDegree < 90) {
      return 'NEE';
    }
    if (windDegree == 90) {
      return 'E';
    }
    if (windDegree < 135) {
      return 'SEE';
    }
    if (windDegree == 135) {
      return 'SE';
    }
    if (windDegree < 180) {
      return 'SSE';
    }
    if (windDegree == 180) {
      return 'S';
    }
    if (windDegree < 225) {
      return 'SSW';
    }
    if (windDegree == 225) {
      return 'SW';
    }
    if (windDegree < 270) {
      return 'SWW';
    }
    if (windDegree == 270) {
      return 'W';
    }
    if (windDegree < 315) {
      return 'NWW';
    }
    if (windDegree == 315) {
      return 'NW';
    }
    return 'NNW';
  }
}

extension on DateTime {
  String get titleValue => DateFormat.MMMEd().format(this);

  String get hourValue => DateFormat.j().format(this);

  String get dayVaue => DateFormat.EEEE().format(this);
}
