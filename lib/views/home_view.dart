import 'dart:math' as math;

import 'package:clover/clover.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather/models.dart';
import 'package:weather/view_models.dart';

const _kNormalWidth = 320.0;
const _kTitleViewHeight = 80.0;
const _kSpacing = 28.0;
const _kDesignWidth = 420.0;
const _kDesignHeight = _kDesignWidth * 2.0;

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<HomeViewModel>(context);
    final weather = viewModel.weather;
    return Material(
      color: Theme.of(context).colorScheme.onSurface,
      child: Center(
        child: weather == null
            ? buildLoadingView(context)
            : buildWeatherView(context, weather),
      ),
    );
  }

  Widget buildLoadingView(BuildContext context) {
    return const CircularProgressIndicator();
  }

  Widget buildWeatherView(BuildContext context, Weather weather) {
    // https://m3.material.io/foundations/layout/applying-layout/window-size-classes
    final size = MediaQuery.sizeOf(context);
    if (size.width < _kNormalWidth) {
      return buildMiniumWeatherView(context, weather);
    } else {
      return buildNormalWeatherView(context, weather);
    }
  }

  Widget buildMiniumWeatherView(BuildContext context, Weather weather) {
    final brightness = Theme.of(context).brightness;
    final state = weather.realWeather.state;
    return FractionallySizedBox(
      widthFactor: 0.5,
      heightFactor: 0.5,
      child: SvgPicture.asset(
        getAssetName(state, brightness),
        fit: BoxFit.contain,
      ),
    );
  }

  Widget buildNormalWeatherView(BuildContext context, Weather weather) {
    final realWeather = weather.realWeather;
    final hourlyWeathers = weather.hourlyWeathers.reversed.toList();
    final dailyWeathers = weather.dailyWeathers;
    final size = MediaQuery.sizeOf(context);
    debugPrint('totalSize: $size');
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: _kDesignWidth,
        maxHeight: _kDesignHeight,
      ),
      child: ClipPath(
        clipper: ScaffoldClipper(
          totalSize: size,
        ),
        child: Scaffold(
          body: CustomScrollView(
            clipBehavior: Clip.none,
            slivers: [
              buildTitleView(context, weather),
              buildRealView(context, realWeather),
              const PinnedHeaderSliver(
                child: Divider(),
              ),
              buildHourlyView(context, hourlyWeathers),
              const PinnedHeaderSliver(
                child: Divider(),
              ),
              buildDailyView(context, dailyWeathers),
            ],
          ),
          drawer: Drawer(
            child: buildSignatureView(context),
          ),
        ),
      ),
    );
  }

  Widget buildTitleView(BuildContext context, Weather weather) {
    return SliverAppBar(
      toolbarHeight: _kTitleViewHeight,
      leadingWidth: _kTitleViewHeight,
      leading: const UnconstrainedBox(
        child: DrawerButton(),
      ),
      title: Text(weather.date.titleValue),
      actions: [
        Container(
          width: _kTitleViewHeight,
          height: _kTitleViewHeight,
          alignment: Alignment.center,
          child: IconButton(
            onPressed: () {},
            icon: Text(
              '⁰C',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      ],
      pinned: true,
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
    return SliverToBoxAdapter(
      child: Container(
        height: 384.0,
        color: Theme.of(context).colorScheme.surface,
        child: Row(
          children: [
            IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: _kSpacing,
                        bottom: _kSpacing,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                city,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
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
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  Container(
                    margin: const EdgeInsets.only(
                      left: _kSpacing,
                      top: _kSpacing,
                      bottom: _kSpacing,
                    ),
                    height: 64.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
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
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 8.0,
                  top: 8.0,
                  bottom: _kSpacing,
                ),
                constraints: const BoxConstraints.expand(),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHourlyView(BuildContext context, List<HourlyWeather> weathers) {
    return PinnedHeaderSliver(
      child: Container(
        height: 112.0,
        color: Theme.of(context).colorScheme.surface,
        child: PageView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: (weathers.length / 5).ceil(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(_kSpacing),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  5,
                  (i) => weathers.skip(index * 5).elementAtOrNull(i),
                ).map((weather) {
                  if (weather == null) {
                    return Container();
                  }
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
                        '${weather.temperature}⁰',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildDailyView(BuildContext context, List<DailyWeather> weathers) {
    final brightness = Theme.of(context).brightness;
    return DecoratedSliver(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      sliver: SliverPadding(
        padding: const EdgeInsets.all(_kSpacing),
        sliver: SliverList.separated(
          itemCount: weathers.length,
          itemBuilder: (context, index) {
            final weather = weathers[index];
            final state = weather.state;
            final description = weather.description;
            final lowest = weather.lowest;
            final highest = weather.highest;
            return Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    weather.date.dayVaue,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Tooltip(
                  message: description,
                  child: SvgPicture.asset(
                    getAssetName(state, brightness),
                    width: 32.0,
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '$highest⁰',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
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
            return const SizedBox(height: 32.0);
          },
        ),
      ),
    );
  }

  Widget buildSignatureView(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(_kSpacing),
      alignment: Alignment.bottomLeft,
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
            const TextSpan(
              text: '\n',
            ),
            const TextSpan(
              text: 'Hosted BY ',
            ),
            TextSpan(
              text: 'Cloudflare',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    decoration: TextDecoration.underline,
                  ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  final url = Uri.https('cloudflare.com');
                  launchUrl(url);
                },
            ),
          ],
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

class ScaffoldClipper extends CustomClipper<Path> {
  final Size totalSize;

  ScaffoldClipper({
    required this.totalSize,
  });

  @override
  Path getClip(Size size) {
    final w = (totalSize.width - size.width) / 2.0;
    if (totalSize.width > size.width && totalSize.height > size.height) {
      const r = 16.0;
      return Path()
        ..moveTo(0.0, r)
        ..arcToPoint(
          const Offset(r, 0.0),
          radius: const Radius.circular(r),
        )
        ..lineTo(size.width - r, 0.0)
        ..arcToPoint(
          Offset(size.width, r),
          radius: const Radius.circular(r),
        )
        ..lineTo(size.width, r)
        ..lineTo(size.width, _kTitleViewHeight)
        ..lineTo(size.width + w, _kTitleViewHeight)
        ..lineTo(size.width + w, size.height - r)
        ..lineTo(size.width, size.height - r)
        ..arcToPoint(
          Offset(size.width - r, size.height),
          radius: const Radius.circular(r),
        )
        ..lineTo(r, size.height)
        ..arcToPoint(
          Offset(0.0, size.height - r),
          radius: const Radius.circular(r),
        )
        ..close();
    } else {
      return Path()
        ..moveTo(0.0, 0.0)
        ..lineTo(size.width, 0.0)
        ..lineTo(size.width, _kTitleViewHeight)
        ..lineTo(size.width + w, _kTitleViewHeight)
        ..lineTo(size.width + w, size.height)
        ..lineTo(0.0, size.height)
        ..close();
    }
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return oldClipper is! ScaffoldClipper || oldClipper.totalSize != totalSize;
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
