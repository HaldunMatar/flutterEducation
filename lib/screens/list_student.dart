import 'package:education/model/app_drawer.dart';
import 'package:education/model/setting.dart';
import 'package:education/model/student.dart';
import 'package:education/providers/students.dart';
import 'package:education/screens/student_form.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class StudentListView extends StatefulWidget {
  static const routeName = '/StudentListView';
  @override
  _StudentListViewState createState() => _StudentListViewState();
}

class _StudentListViewState extends State<StudentListView> {
  static const _pageSize = 2;

  final PagingController<int, Student> _pagingController =
      PagingController(firstPageKey: 0);

  String? searchString = null;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, searchString);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey, String? searchString) async {
    try {
      final newItems = await Provider.of<Students>(context, listen: false)
          .getStudentListByPage(pageKey, _pageSize, searchString);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
        // _pagingController.refresh();
      } else {
        final int? nextPageKey = (pageKey + newItems.length);
        _pagingController.appendPage(newItems, nextPageKey);
        // _pagingController.refresh();
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
                      onChanged: (valu) {
                        searchString = valu;
                        seachStudent(valu);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          drawer: AppDrawer(),
          body: PagedListView<int, Student>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Student>(
              itemBuilder: (context, item, index) => ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    'http://${Setting.basicUrl}/downloadFile/${item.id}.jpg',
                  ),
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
                            Navigator.of(context).pushNamed(
                                StudenForm.routeName,
                                arguments: item.id.toString());
                          },
                          color: Theme.of(context).primaryColor,
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            //   Provider.of<Products>(context, listen: false).deleteProduct(id);
                          },
                          color: Theme.of(context).errorColor,
                        ),
                      ],
                    ),
                  ),
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

  Future<void> seachStudent(String? seachStudent1) async {
    try {
      _pagingController.refresh();
    } catch (error) {
      _pagingController.error = error;
    }
  }
}
