import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class ExampleViewModel {
  final List<Color> pageColors;
  final CircularSliderAppearance appearance;
  final double min;
  final double max;
  final double value;
  final InnerWidget? innerWidget;

  ExampleViewModel(
      {required this.pageColors,
        required this.appearance,
        this.min = 0,
        this.max = 20000,
        this.value = 20,
        this.innerWidget});
}

class ExamplePage extends StatefulWidget {
  final ExampleViewModel viewModel;
  const ExamplePage({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: widget.viewModel.pageColors,
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                tileMode: TileMode.clamp)),
        child: SafeArea(
          child: Center(
              child: SleekCircularSlider(
                onChangeStart: (double value) {


                },
                onChangeEnd: (double value) {},
                innerWidget: widget.viewModel.innerWidget,
                appearance: widget.viewModel.appearance,
                min: widget.viewModel.min,
                max: widget.viewModel.max,
                initialValue: widget.viewModel.value,
              )),
        ),
      ),
    );
  }
}