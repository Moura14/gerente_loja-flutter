import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gerente_loja/blocs/orders_bloc.dart';
import 'package:gerente_loja/blocs/user_bloc.dart';
import 'package:gerente_loja/tabs/products_tab.dart';
import 'package:gerente_loja/tabs/users_tab.dart';
import 'package:gerente_loja/tabs/orders_tab.dart';
import 'package:gerente_loja/widgets/edit_category_dialog.dart';

class HomeLog extends StatefulWidget {
  //const HomeLog({Key key}) : super(key: key);

  @override
  _HomeLogState createState() => _HomeLogState();
}

class _HomeLogState extends State<HomeLog> {
  final _colorTheme = Colors.white;
  PageController _pageController;
  int _page = 0;
  UserBLoc _userBloc;
  OrdersBloc _ordersBloc;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _userBloc = UserBLoc();
    _ordersBloc = OrdersBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.pinkAccent,
            primaryColor: Colors.white,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: TextStyle(color: Colors.white54))),
        child: BottomNavigationBar(
          currentIndex: _page,
          onTap: (p) {
            _pageController.animateToPage(p,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              label: ("Clientes"),
              
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              label: ("Pedidos"),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
                color: Colors.white,
              ),
              label: ("Produtos "),
            )
          ],
        ),
      ),
      body: SafeArea(
          child: BlocProvider(
        blocs: [Bloc((i) => _userBloc), Bloc((i) => _ordersBloc)],
        child: PageView(
          controller: _pageController,
          onPageChanged: (p) {
            setState(() {
              _page = p;
            });
          },
          children: [UsersTab(), OrdersTab(), ProductsTab()],
        ),
      )),
      floatingActionButton: _buildFloating(),
    );
  }

  Widget _buildFloating() {
    switch (_page) {
      case 0:
        return null;
      case 1:
        return SpeedDial(
          child: Icon(Icons.sort),
          backgroundColor: Colors.pinkAccent,
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
                child: Icon(
                  Icons.arrow_downward,
                  color: Colors.pinkAccent,
                ),
                backgroundColor: Colors.white,
                label: "Concluídos Abaixo",
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {
                  _ordersBloc.setOrderCriteria(SortCriteria.READY_LAST);
                }),
            SpeedDialChild(
                child: Icon(
                  Icons.arrow_upward,
                  color: Colors.pinkAccent,
                ),
                backgroundColor: Colors.white,
                label: "Concluídos Acima",
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {
                  _ordersBloc.setOrderCriteria(SortCriteria.READY_FIRST);
                })
          ],
        );

      case 2:
        return FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.pinkAccent,
          onPressed: () {
            showDialog(
                context: context, builder: (context) => EditCategoryDialog());
          },
        );
    }
  }
}
