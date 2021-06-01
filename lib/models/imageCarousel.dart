import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> images;
  ImageCarousel(this.images);
  @override
  _ImageCarousel createState() => _ImageCarousel(images);
}

class _ImageCarousel extends State<ImageCarousel> {
  List<String> images;

  _ImageCarousel(this.images);
  List<Image> imgs = [];

  @override
  void initState() {
    for (var i in images) {
      imgs.add(Image.network(
        i,
        width: 350,
      ));
    }
    super.initState();
  }

  Widget imageSlider() {
    CarouselController buttonCarouselController = CarouselController();
    return Column(
      children: [
        CarouselSlider(
          items: imgs,
          carouselController: buttonCarouselController,
          options: CarouselOptions(
            autoPlay: false,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            aspectRatio: 2.0,
            initialPage: 2,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return imageSlider();
  }
}
