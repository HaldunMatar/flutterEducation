import 'package:education/providers/student.dart';
import 'package:education/providers/students.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({Key? key}) : super(key: key);
  Future<void> _refreshstudents(BuildContext context) async {
    await Provider.of<Students>(context, listen: false).fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _refreshstudents(context),
      builder: (ctx, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<Students>(
                  builder: (ctx, students, _) => Material(
                    child: ListView.builder(
                      itemCount: students.listStudent.length,
                      itemBuilder: (_, i) => ListTile(
                        leading: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.teal[900],
                        ),
                        title: Text(students.listStudent[i].firstName),
                        subtitle: Text(students.listStudent[i].id.toString()),
                        trailing: Icon(Icons.done, color: Colors.pink),
                      ),
                    ),
                  ),
                ),
    );
  }
}

class CharacterListView extends StatefulWidget {
  @override
  _CharacterListViewState createState() => _CharacterListViewState();
}

class _CharacterListViewState extends State<CharacterListView> {
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
