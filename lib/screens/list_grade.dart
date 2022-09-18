import 'package:education/model/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../model/grade.dart';
import '../providers/grades.dart';

class GradeListView extends StatefulWidget {
  static const routeName = '/GradeListView';

  @override
  _GradeListViewState createState() => _GradeListViewState();
}

class _GradeListViewState extends State<GradeListView> {
  static const _pageSize = 4;

  final PagingController<int, Grade> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      //    print('addPageRequestListener');
      _fetchGradePage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchGradePage(int pageKey) async {
    // print('_fetchGradePage $pageKey');

    //  print('_fetchGradePage');
    try {
      final newItems = await Provider.of<Grades>(context, listen: false)
          .getGradeListByPage(pageKey, _pageSize);
      final isLastPage = newItems.length < _pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final int? nextPageKey = (pageKey + newItems.length);
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) =>
      // Don't worry about displaying progress or error indicators on screen; the
      // package takes care of that. If you want to customize them, use the
      // [PagedChildBuilderDelegate] properties.
      Scaffold(
          appBar: AppBar(
            title: Text('Grade List View'),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            ],
          ),
          drawer: AppDrawer(),
          body: PagedListView<int, Grade>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Grade>(
              itemBuilder: (context, item, index) => ListTile(
                leading: CircleAvatar(
                  radius: 20,
                ),
                title: Text(item.nameEn),
                subtitle: Text(item.id.toString()),
                trailing: Icon(
                  Icons.chair,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            //currentIndex: controller.currentIndex.value,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.home,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                icon: Icon(
                  Icons.home,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.category,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                icon: Icon(
                  Icons.category,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.favorite,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                icon: Icon(
                  Icons.favorite,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.settings,
                  color: Colors.red,
                ),
                icon: Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                label: '',
              ),
            ],
            onTap: (index) {
              // controller.currentIndex.value = index;
            },
          ));

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
