import 'package:education/model/app_drawer.dart';
import 'package:education/model/student.dart';
import 'package:education/providers/students.dart';
import 'package:education/screens/student_form.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../model/setting.dart';

class StudentListView extends StatefulWidget {
  static const routeName = '/StudentListView';

  @override
  State<StudentListView> createState() => _StudentListViewState();
}

class _StudentListViewState extends State<StudentListView> {
  static const _pageSize = 20;
  PagingController<int, Student> _pagingController =
      PagingController(firstPageKey: 0);

  String? _searchTerm;

  bool loading = false;

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
          .getStudentListByPage(pageKey, _pageSize, _searchTerm);

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
  Widget build(BuildContext context) {
    var students = Provider.of<Students>(context, listen: true);

    return Scaffold(
        appBar: AppBar(
          title: Text('Studet List View'),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.fromSwatch()
                      .copyWith(secondary: Colors.white)),
              child: Container(
                height: 48.0,
                alignment: Alignment.center,
                child: Container(
                  color: Colors.white,
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(),
                    onChanged: _updateSearchTerm,
                  ),
                ),
              ),
            ),
          ),
        ),
        drawer: AppDrawer(),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: TextField(
                onChanged: _updateSearchTerm,
              ),
            ),
            PagedSliverList<int, Student>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Student>(
                itemBuilder: ((context, item, index) =>
                    getListItemForPage(context, item, index, students)),
              ),
            ),
          ],
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
  }

  Widget getListItemForPage(context, item, index, Students std) => ListTile(
        key: ValueKey(item.id.toString()),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: null

          /*  NetworkImage(
            'http://${Setting.basicUrl}/downloadFile/${item.id}.jpg',
          )*/
          ,
        ),
        title: Text(item.firstName),
        subtitle: Text(item.id.toString()),
        trailing: Container(
          child: Container(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).pushNamed(StudenForm.routeName,
                        arguments: item.id.toString());
                  },
                  color: Theme.of(context).primaryColor,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    //   var students = Provider.of<Students>(context, listen: true);
                    await std.deletestudent(item.id);
                    //  loading = false;
                    _pagingController.refresh();
                  },
                  color: Theme.of(context).errorColor,
                ),
              ],
            ),
          ),
        ),
      );

  void _updateSearchTerm(String searchTerm) {
    _searchTerm = searchTerm;
    _pagingController.refresh();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
