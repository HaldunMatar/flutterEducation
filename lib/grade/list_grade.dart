import 'package:education/providers/students.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import 'grade.dart';

class GradeListView extends StatefulWidget {
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
      _fetchGradePage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchGradePage(int pageKey) async {
    try {
      final newItems = await Provider.of<Students>(context, listen: false)
          .getGradeListByPage(pageKey, _pageSize);
      final isLastPage = newItems.length < _pageSize;

      ;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final int? nextPageKey = (pageKey + newItems.length) as int?;
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
                Icons.person_remove,
                color: Colors.red,
              ),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
