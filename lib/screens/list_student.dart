import 'package:education/model/app_drawer.dart';
import 'package:education/providers/student.dart';
import 'package:education/providers/students.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class StudentListView extends StatefulWidget {
  static const routeName = '/StudentListView';
  @override
  _StudentListViewState createState() => _StudentListViewState();
}

class _StudentListViewState extends State<StudentListView> {
  static const _pageSize = 20;

  final PagingController<int, Student> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await Provider.of<Students>(context, listen: false)
          .getStudentListByPage(pageKey, _pageSize);
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
        drawer: AppDrawer(),
        body: PagedListView<int, Student>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Student>(
            itemBuilder: (context, item, index) => ListTile(
              leading: CircleAvatar(
                radius: 20,
              ),
              title: Text(item.firstName),
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
