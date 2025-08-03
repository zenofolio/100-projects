import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:remo/application/ui/shared/components/animate.dart';

class DiscoveringLoading extends StatelessWidget {

  final void Function()? onBack;
  const DiscoveringLoading({ super.key, this.onBack });



  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context);

    return Column(
      spacing: 50,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('assets/lottie/wave-loop.json'),

        Column(
          spacing: 30,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 300
              ),
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimateFrom(
                    direction: AnimateDirection.bottom,
                    child: Text(
                      "Discovering Devices",
                      style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                      ),
                    ),
                  ),
                  AnimateFrom(
                    delay: const Duration( milliseconds:  100),
                    direction: AnimateDirection.bottom,
                    child: Text(
                      "This may take a few seconds while we search for available devices.",
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.white.withValues(
              alpha: .15
            )
          ),
          onPressed: onBack,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                "Stop searching",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

}