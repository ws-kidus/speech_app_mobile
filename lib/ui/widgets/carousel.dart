import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Carousel extends HookConsumerWidget {
  final List<Widget> items;
  final double height;
  final bool showIndicators;
  final bool autoPlay;
  final double viewPortFaction;

  const Carousel({
    Key? key,
    required this.items,
    this.height = 180,
    this.showIndicators = true,
    this.autoPlay = false,
    this.viewPortFaction = 1.0,
  }) : super(key: key);

  void _onChangePage({
    required ValueNotifier<int> currentIndex,
    required int index,
  }) {
    currentIndex.value = index;
  }

  Widget _indicators({
    required BuildContext context,
    required int count,
    required int currentIndex,
  }) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(count, (index) {
          return Container(
            margin: const EdgeInsets.all(3),
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentIndex == index
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
          );
        }));
  }

  automaticChangePage({
    required PageController pageController,
    required int currentPage,
  }) async {
    while (autoPlay) {
      await Future.delayed(const Duration(seconds: 5));

      if (currentPage < items.length) {
        currentPage++;
      }

      if (currentPage == items.length) {
        currentPage = 0;
      }

      if (pageController.hasClients) {
        pageController.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.linear,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState<int>(items.length > 2 ? 1 : 0);
    final pageController = usePageController(
      initialPage: items.length > 2 ? 1 : 0,
      viewportFraction: viewPortFaction,
    );

    useEffect(() {
      automaticChangePage(
        pageController: pageController,
        currentPage: currentIndex.value,
      );
      return;
    }, []);

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          height: height,
          child: PageView.builder(
              itemCount: items.length,
              pageSnapping: true,
              controller: pageController,
              onPageChanged: (page) => _onChangePage(
                    currentIndex: currentIndex,
                    index: page,
                  ),
              itemBuilder: (context, index) {
                return items[index];
              }),
        ),
        if (showIndicators && items.length > 1)
          Positioned(
            bottom: 2,
            child: _indicators(
              context: context,
              count: items.length,
              currentIndex: currentIndex.value,
            ),
          ),
      ],
    );
  }
}
