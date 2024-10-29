import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/core/navigation/navigation_controller.dart';
import 'package:raptorx/src/features/brand/brand_details/presentation/view/brand_details.dart';

import 'dart:io';

import 'package:raptorx/src/features/brand/brands/data/model/brand_model.dart';



class BrandCard extends ConsumerStatefulWidget {
  final BrandModel brandModel;

  const BrandCard({Key? key, required this.brandModel}) : super(key: key);

  @override
  _BrandCardState createState() => _BrandCardState();
}

class _BrandCardState extends ConsumerState<BrandCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(

      onEnter: (_) {
        _controller.forward();

      },
      onExit: (_) {
        _controller.reverse();

      },
      child: GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BrandDetails(brandModel: widget.brandModel,)));
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),

            child: Stack(
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    // Create a linear gradient shader for the mask
                    return LinearGradient(
                      colors: [Colors.white, Colors.black],

                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.modulate,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                      child: Image.file(File(widget.brandModel.brandImage ?? ""), fit: BoxFit.cover,
                        errorBuilder: (context, obj, str){
                        return Text("No Image Found");
                        },)
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.all(8),

                    child: Text(
                      widget.brandModel.brandName ?? "",
                      style: TextStyle(
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
