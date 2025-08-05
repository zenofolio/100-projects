import 'dart:async';

import 'package:flutter/material.dart';
import 'package:remo/application/modules/connect/models/capabilities.dart';
import 'package:remo/application/modules/connect/models/device_adapter.dart';
import 'package:remo/application/modules/connect/models/device_status.dart';

import '../components/pad_tap.dart';
import '../components/switch_tab.dart';

class RemoteControlLayout extends StatefulWidget {
  final DeviceAdapter device;

  const RemoteControlLayout({super.key, required this.device});

  @override
  createState() => _RemoteControlLayoutState();
}

class _RemoteControlLayoutState extends State<RemoteControlLayout> {
  VolumeControlCapability? get volume => widget.device.getCapability();

  RemoteControlCapability? get remote =>
      widget.device.getCapability<RemoteControlCapability>();

  ValueNotifier<DeviceStatus> status = ValueNotifier(DeviceStatus.disconnected);
  List<StreamSubscription> subscriptions = [];

  List<_ControlButtons> get _controlButtons =>
      [
        _ControlButtons(
          icon: Icons.home,
          onPressed: () async {
            remote?.onHome?.call();
          },
        ),
        _ControlButtons(
          icon: Icons.arrow_back,
          onPressed: () {
            remote?.onBack?.call();
          },
        ),
        _ControlButtons(
          icon: Icons.volume_off,
          onPressed: () {
            volume?.onMute?.call();
          },
        ),
        _ControlButtons(
          icon: Icons.play_arrow,
          onPressed: () {
            widget.device.connect().then((e) {
              print("Is connected ${widget.device.status}");
            });
          },
        ),
      ];

  @override
  void initState() {
    subscriptions.add(
      widget.device.connectionStatus.listen((status) {
        this.status.value = status;
      }),
    );

    super.initState();
  }

  @override
  void dispose() {
    for (var sub in subscriptions) {
      sub.cancel();
    }

    subscriptions.clear();
    status.dispose();
    widget.device.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery
        .of(context)
        .size;
    var switchSize = Size(size.width * 0.2, size.width * 0.6);
    var horizontalPadding = size.width * .05;

    var borderColor = theme.colorScheme.onSurface.withValues(
        alpha: .4
    );

    return Scaffold(
      body: Flex(
        direction: Axis.vertical,
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              widget.device.name,
              style: theme.textTheme.titleMedium,
            ),
            centerTitle: true,
          ),
          Flexible(
            child: PadTap(
              up: () => remote?.onUp?.call(),
              down: () => remote?.onDown?.call(),
              left: () => remote?.onLeft?.call(),
              right: () => remote?.onRight?.call(),
              enter: () => remote?.onEnter?.call(),
            ),
          ),

          // Control Buttons
          Container(
            decoration: BoxDecoration(
                color: theme.cardColor.withValues(
                    alpha: .3
                ),
                borderRadius: BorderRadius.only(
                  topLeft : Radius.circular(size.width * .1),
                  topRight: Radius.circular(size.width * .1),
                )
            ),
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: 200
            ),
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: horizontalPadding * 1.5,
            ),
            child: ValueListenableBuilder(
              valueListenable: status,
              builder: (context, value, child) {

                if(value == DeviceStatus.connecting) {
                  return Center(
                    child: Column(
                      spacing: 20,
                      children: [
                        CircularProgressIndicator(),
                        Text(
                          "Connecting to device...",
                          style: theme.textTheme.titleLarge,
                        ),
                      ],
                    ),
                  );
                }


                if (value == DeviceStatus.disconnected) {
                  return Center(
                    child: Column(
                      spacing: 20,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Device is disconnected",
                              style: theme.textTheme.titleLarge,
                            ),
                            Text(
                              "Please connect to the device to use remote control",
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await widget.device.connect();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            )
                          ),
                          child: Text(
                            "Connect",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Flex(
                      direction: Axis.horizontal,
                      spacing: 20,
                      children: [
                        SwitchTap(
                          size: switchSize,
                          label: "VOL",
                          onDown: () {
                            volume?.onVolumeDown();
                          },
                          onUp: () {
                            volume?.onVolumeUp();
                          },
                        ),

                        Expanded(
                          child: SizedBox(
                            height: switchSize.height,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                double spacing = 10;
                                double buttonHeight = 60;
                                var wrapSize = constraints.maxWidth * 1.03;
                                var wrapHeight =
                                    switchSize.height - buttonHeight - spacing;

                                var buttonSize = Size(
                                  wrapSize / 2 - spacing,
                                  wrapSize / 2 - spacing,
                                );

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: wrapSize,
                                      height: wrapHeight,
                                      child: Wrap(
                                        spacing: spacing,
                                        runSpacing: spacing,
                                        alignment: WrapAlignment.spaceBetween,
                                        children: List<Widget>.generate(
                                          _controlButtons.length,
                                              (index) {
                                            var button = _controlButtons[index];

                                            return IconButton(
                                              iconSize: size.width * .08,
                                              onPressed: button.onPressed,
                                              icon: Icon(button.icon),
                                              style: IconButton.styleFrom(
                                                backgroundColor: Colors.transparent,
                                                minimumSize: buttonSize,
                                                padding: EdgeInsets.all(10),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(
                                                    100,
                                                  ),
                                                  side: BorderSide(
                                                    color: borderColor,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        minimumSize: Size(
                                          double.infinity,
                                          buttonHeight,
                                        ),
                                        maximumSize: Size(
                                          double.infinity,
                                          buttonHeight,
                                        ),
                                        backgroundColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: borderColor,
                                            width: 2,
                                          ),
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                        padding: EdgeInsets.all(10),
                                      ),
                                      onPressed: () => remote?.onMenu?.call(),
                                      child: Icon(
                                        Icons.more_horiz,
                                        color: theme.colorScheme.onSurface,
                                        size: 40,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        SwitchTap(
                          size: switchSize,

                          label: "CH",
                          onDown: () {
                            print("Volume Down");
                          },
                          onUp: () {
                            print("Volume Up");
                          },
                        ),
                      ],
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlButtons {
  final IconData icon;
  final void Function() onPressed;

  const _ControlButtons({required this.icon, required this.onPressed});
}
