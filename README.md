A customable time picker using analog clock format

## Features

- Customizable background
- Customizable handle
- Ability to change period AM/PM type via Controller
- Fluid animation movement of clock hand

## Getting started

```yaml
dependencies:
    analog_clock_picker: latest
```

## Usage

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