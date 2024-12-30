import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/features/brand_v2/brand_details/presentation/view/brand_details_navigation_screen.dart';
import 'package:raptorx/src/features/brand_v2/brands/data/model/brand_model.dart';

class BrandCard extends ConsumerStatefulWidget {
  final BrandModel brandModel;

  const BrandCard({super.key, required this.brandModel});

  @override
  _BrandCardState createState() => _BrandCardState();
}

class _BrandCardState extends ConsumerState<BrandCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    print("brand image ${widget.brandModel.brandImage}");
    return MouseRegion(
      onEnter: (_) {
        _controller.forward();
      },
      onExit: (_) {
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => BrandDetailsNavigationScreen(
                    brandModel: widget.brandModel,
                  )));
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: Stack(
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    // Create a linear gradient shader for the mask
                    return const LinearGradient(
                      colors: [Colors.white, Colors.black],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.modulate,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(widget.brandModel.brandImage ?? ""),
                        fit: BoxFit.cover,
                        errorBuilder: (context, obj, str) {
                          return const Text("No Image Found");
                        },
                      )),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      widget.brandModel.brandName ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
