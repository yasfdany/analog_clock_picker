[![pub package](https://img.shields.io/badge/pub-v0.0.3-blue)](https://pub.dev/packages/analog_clock_picker)

A customable time picker using analog clock format

## Features

- Customizable background color and widget
- Customizable clock hand color and widget
- Ability to change period AM/PM type via Controller
- Fluid animation movement of clock hand

## Screenshot

<p float="left">
    <img src="https://raw.githubusercontent.com/yasfdany/analog_clock_picker/master/doc/screenshots/ss_minimal.jpg" width="200px">
    <img src="https://raw.githubusercontent.com/yasfdany/analog_clock_picker/master/doc/screenshots/ss_custom_bg.jpg" width="200px">
    <img src="https://raw.githubusercontent.com/yasfdany/analog_clock_picker/master/doc/screenshots/ss_custom_ring.jpg" width="200px">
</p>

## Demo Video

<p float="left">
  <img src="doc/gif/demo.gif" width="200px">
</p>

## Getting started

Add package to `pubspec.yaml`

```yaml
dependencies:
    analog_clock_picker: 0.0.3
```

## How to use

Create controller for control the value of the clock

```dart
AnalogClockController analogClockController = AnalogClockController();
```

You can provide default value inside the controller

```dart
AnalogClockController analogClockController = AnalogClockController(
  value: DateTime.now(),
  periodType: PeriodType.am,
  onPeriodTypeChange: (date, period) {
    //TODO : Do Something
  },
);
```

Minimal usage

```dart
AnalogClockController analogClockController = AnalogClockController();

AnalogClockPicker(
  controller: analogClockController,
  size: MediaQuery.of(context).size.width * 0.74,
  secondHandleColor: const Color(0xfff64245),
  minutesHandleColor: Colors.black,
  hourHandleColor: Colors.black,
  clockBackground: Image.asset(
    AssetImages.clockBackground,
  ),
)
```