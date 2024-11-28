import 'dart:math' as math;

import 'package:clover/clover.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/models.dart';
import 'package:weather/view_models.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    final formatter = DateFormat.MMMEd();
    final formattedDate = formatter.format(date);
    return Scaffold(
      appBar: AppBar(
        title: Text(formattedDate),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 24.0),
            child: Text(
              '⁰C',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24.0),
        child: buildBody(context),
      ),
      // drawer: Drawer(),
    );
  }

  Widget buildBody(BuildContext context) {
    final viewModel = ViewModel.of<HomeViewModel>(context);
    final weather = viewModel.weather;
    if (weather == null) {
      return Container();
    }
    final real = weather.real;
    final city = real.station.city;
    debugPrint('${real.weather.info}, ${real.weather.img}');
    final temperature = real.weather.temperature;
    final feelst = real.weather.feelst;
    final tempchart = weather.tempchart[0];
    final minTemp = tempchart.min_temp;
    final maxTemp = tempchart.max_temp;
    final wind = real.wind;
    final degree = wind.degree;
    final direction = formatWindDegree(degree);
    final speed = (real.wind.speed / 1000 * 3600).toStringAsFixed(2);
    final passedchart = weather.passedchart.reversed.toList();
    final predict = weather.predict;
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      city,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '$temperature⁰',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Text(
                      'Feels like $feelst⁰',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Divider(),
                    Row(
                      children: [
                        CustomPaint(
                          size: const Size.square(12.0),
                          painter: ArrowPainter(
                            rotationDegrees: 0.0,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          '$maxTemp⁰',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(width: 12.0),
                        CustomPaint(
                          size: const Size.square(12.0),
                          painter: ArrowPainter(
                            rotationDegrees: 180.0,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          '$minTemp⁰',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      '$direction $speed km/h',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24.0),
              AspectRatio(
                aspectRatio: 1.0,
                child: Tooltip(
                  message: real.weather.info,
                  child: Image.asset(
                    'images/3D Ico_${getImageAssetNumber(real.weather.img)}.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        SizedBox(
          height: 60.0,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: passedchart.length,
            itemBuilder: (context, index) {
              final item = passedchart[index];
              final time = DateTime.parse(item.time);
              final formatter = DateFormat.j();
              final formattedTime = formatter.format(time);
              final temperature = item.temperature;
              return buildHourView(context, formattedTime, temperature);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(width: 32.0);
            },
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView.separated(
            itemCount: predict.detail.length,
            itemBuilder: (context, index) {
              final item = predict.detail[index];
              final date = DateTime.parse(item.date);
              final formatter = DateFormat.EEEE();
              final formattedDate = formatter.format(date);
              final day = item.day;
              final night = item.night;
              return buildWeekdayView(context, formattedDate, day, night);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 32.0);
            },
          ),
        ),
      ],
    );
  }

  Widget buildHourView(BuildContext context, String time, double temperature) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          time,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
        Text(
          '$temperature⁰',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }

  Widget buildWeekdayView(
    BuildContext context,
    String weekday,
    DayNight day,
    DayNight night,
  ) {
    final dayAvailable = day.weather.info != '9999';
    return Row(
      children: [
        Text(
          weekday,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Spacer(),
        Tooltip(
          message: dayAvailable ? day.weather.info : night.weather.info,
          child: Image.asset(
            'images/3D Ico_${getImageAssetNumber(dayAvailable ? day.weather.img : night.weather.img, dayAvailable)}.png',
            width: 32.0,
            height: 32.0,
          ),
        ),
        Container(
          width: 112.0,
          alignment: Alignment.centerRight,
          child: Visibility(
            visible: day.weather.temperature != '9999',
            child: Text(
              '${day.weather.temperature}⁰',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        Container(
          width: 28.0,
          alignment: Alignment.centerRight,
          child: Visibility(
            visible: night.weather.temperature != '9999',
            child: Text(
              '${night.weather.temperature}⁰',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  String getImageAssetNumber(String img, [bool isDay = true]) {
    // http://image.nmc.cn/static2/site/nmc/themes/basic/weather/white/day/{img}.png
    // http://image.nmc.cn/static2/site/nmc/themes/basic/weather/white/night/{img}.png
    switch (img) {
      case '0':
        return isDay ? '33' : '28';
      case '1':
        return isDay ? '04' : '08';
      case '2':
        return '01';
      case '3':
        return '01';
      case '2':
        return '01';
      case '2':
        return '01';
      case '2':
        return '01';
      case '2':
        return '01';
      default:
        return '01';
    }
  }

  String formatWindDegree(double degree) {
    if (degree < 0 || degree >= 360) {
      throw ArgumentError.value(degree);
    }
    if (degree == 0) {
      return 'N';
    }
    if (degree < 45) {
      return 'NNE';
    }
    if (degree == 45) {
      return 'NE';
    }
    if (degree < 90) {
      return 'NEE';
    }
    if (degree == 90) {
      return 'E';
    }
    if (degree < 135) {
      return 'SEE';
    }
    if (degree == 135) {
      return 'SE';
    }
    if (degree < 180) {
      return 'SSE';
    }
    if (degree == 180) {
      return 'S';
    }
    if (degree < 225) {
      return 'SSW';
    }
    if (degree == 225) {
      return 'SW';
    }
    if (degree < 270) {
      return 'SWW';
    }
    if (degree == 270) {
      return 'W';
    }
    if (degree < 315) {
      return 'NWW';
    }
    if (degree == 315) {
      return 'NW';
    }
    return 'NNW';
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
