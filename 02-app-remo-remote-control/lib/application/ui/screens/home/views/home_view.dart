import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remo/application/common/helpers/navigate.dart';
import 'package:remo/application/navigation/route_paths.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Image.asset("assets/images/logo-text.png"),
                    Text(
                      "Easily connect and control your TV from your phone",
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontSize: size.width * 0.05,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,


                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  elevation: 3,
                ),
                onPressed: () {
                  Navigation.navigate(context, RoutePaths.discovery);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Discover TVs Nearby",
                      style: textTheme.titleLarge?.copyWith(
                        color: Colors.black54,
                        fontWeight: FontWeight.w400,
                        fontSize: size.width * 0.05,
                      ),
                    ),
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: scheme.primary.withOpacity(0.9),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
