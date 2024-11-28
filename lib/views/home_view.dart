import 'dart:math' as math;

import 'package:clover/clover.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather/models.dart';
import 'package:weather/view_models.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    final formatter = DateFormat.MMMEd();
    final formattedDate = formatter.format(date);
    return Material(
      child: Row(
        children: [
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                leadingWidth: 80.0,
                leading: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.menu_rounded),
                  iconSize: 32.0,
                ),
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
                margin: const EdgeInsets.only(
                  left: 24.0,
                  right: 24.0,
                  bottom: 24.0,
                ),
                child: buildWeatherView(context),
              ),
            ),
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

  Widget buildWeatherView(BuildContext context) {
    final viewModel = ViewModel.of<HomeViewModel>(context);
    final weather = viewModel.weather;
    if (weather == null) {
      // TODO: Add loading animation.
      return Container();
    }
    final real = weather.real;
    final tempchart = weather.tempchart[0];
    final passedchart = weather.passedchart.reversed.toList();
    final predict = weather.predict;
    return Column(
      children: [
        buildRealView(context, real, tempchart),
        const Divider(),
        SizedBox(
          height: 60.0,
          child: buildHoursView(context, passedchart),
        ),
        const Divider(),
        Expanded(
          child: buildWeekdaysView(context, predict),
        ),
      ],
    );
  }

  Widget buildRealView(
      BuildContext context, Real real, TemperatureChart tempchart) {
    final city = real.station.city;
    final weather = real.weather;
    final wind = real.wind;
    final minTemp = tempchart.min_temp;
    final maxTemp = tempchart.max_temp;
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40.0),
                Text(
                  city,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '${weather.temperature}⁰',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Text(
                  'Feels like ${weather.feelst}⁰',
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
                      '$maxTemp⁰',
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
                      '$minTemp⁰',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                Tooltip(
                  message: '${wind.direct} ${wind.power}',
                  child: Text(
                    '${wind.direction} ${wind.speed} m/s',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24.0),
          AspectRatio(
            aspectRatio: 0.7,
            child: OverflowBox(
              maxWidth: double.infinity,
              alignment: Alignment.centerLeft,
              child: Tooltip(
                message: weather.info,
                child: Image.asset(
                  'images/3D Ico_${getImageAssetNumber(weather.img)}.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHoursView(BuildContext context, List<PassedChart> passedchart) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: passedchart.length,
      itemBuilder: (context, index) {
        final item = passedchart[index];
        final date = DateTime.parse(item.time);
        final formatter = DateFormat.j();
        final hour = formatter.format(date);
        final temp = item.temperature;
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              hour,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
            ),
            Text(
              '$temp⁰',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(width: 32.0);
      },
    );
  }

  Widget buildWeekdaysView(BuildContext context, Predict predict) {
    return ListView.separated(
      itemCount: predict.detail.length,
      itemBuilder: (context, index) {
        final item = predict.detail[index];
        final date = DateTime.parse(item.date);
        final formatter = DateFormat.EEEE();
        final weekday = formatter.format(date);
        final day = item.day;
        final night = item.night;
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
                visible: dayAvailable,
                child: Text(
                  '${day.weather.temperature}⁰',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            Container(
              width: 28.0,
              alignment: Alignment.centerRight,
              child: Text(
                '${night.weather.temperature}⁰',
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
        return const SizedBox(height: 32.0);
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
      case '36':
        return isDay ? '16' : '15';
      case '4':
        return '13';
      case '5':
      case '14':
      case '15':
      case '16':
      case '17':
      case '26':
      case '27':
      case '28':
      case '33':
        return '20';
      case '6':
        return '27';
      case '7':
      case '8':
      case '9':
      case '10':
      case '11':
      case '12':
      case '19':
      case '21':
      case '22':
      case '23':
      case '24':
      case '25':
        return '17';
      case '13':
        return isDay ? '30' : '29';
      case '18':
      case '32':
        return '03';
      case '20':
      case '31':
        return '24';
      case '29':
        return '26';
      case '30':
        return '23';
      default:
        return '36';
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

extension on RealWind {
  String get direction {
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
