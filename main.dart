import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(
      ChangeNotifierProvider(
        create: (_)=>BreadCrumbProvider(),
        child: MaterialApp(
            title: 'Provider Course',
            theme: ThemeData(primarySwatch: Colors.blue),
            debugShowCheckedModeBanner: false,
            home: const HomePage(),
          routes: {
              '/new':(context)=>const NewBreadCrumbWidget(),

          },
          ),
      ));
}

class BreadCrumb{
  bool isActive;
  final String name;
  final String uuid;

  BreadCrumb({
    required this.isActive,
    required this.name,
}):uuid=const Uuid().v4();

  void activate(){
    isActive=true;
  }

  @override
  bool operator ==(covariant BreadCrumb other)=>
      isActive==other.isActive && name==other.name&&
  uuid==other.uuid;

  @override
  // TODO: implement hashCode
  int get hashCode => uuid.hashCode;

  String get title=> name + (isActive? '>': '');
}

class BreadCrumbProvider extends ChangeNotifier{
  final List<BreadCrumb> _items=[];
  UnmodifiableListView<BreadCrumb> get item => UnmodifiableListView(_items);

  void add(BreadCrumb breadCrumb){
    for (final item in _items){
      item.activate();
    }
    _items.add(breadCrumb);
    notifyListeners();
  }

  void reset(){
    _items.clear();
    notifyListeners();
  }

}

class BreadCrumbsWidget extends StatelessWidget {
  final UnmodifiableListView<BreadCrumb> breadCrumbs;
  const BreadCrumbsWidget({super.key,required this.breadCrumbs});



  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: breadCrumbs.map((breadCrumbs){
        return GestureDetector(
          onTap: (){
            
          },
          child: Text(
            breadCrumbs.title,
            style:TextStyle(
              color: breadCrumbs.isActive? Colors.blue:Colors.black,
            )
          ),
        );
      }).toList(),
    );
  }
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: const Text('Home Page', style: TextStyle(color: Colors.white),),
      ),
      body: Center(
        child: Column(
          children: [
            Consumer<BreadCrumbProvider>(builder: (context,value,child){
              return BreadCrumbsWidget(breadCrumbs: value.item);
              
            },),
            TextButton(onPressed: (){
                Navigator.of(context).pushNamed(
                  '/new',
                );
            }, child: const Text(
              'Add a new bread Crumb'
            ),),
            TextButton(onPressed: (){
              context.read<BreadCrumbProvider>().reset();
            },
              child: const Text(
                'Reset',
            ),)
          ],
        ),
      ),
    );
  }
}

class NewBreadCrumbWidget extends StatefulWidget {
  const NewBreadCrumbWidget({super.key});

  @override
  State<NewBreadCrumbWidget> createState() => _NewBreadCrumbWidgetState();
}

class _NewBreadCrumbWidgetState extends State<NewBreadCrumbWidget> {
  late final TextEditingController _controller;

  @override
  void initState(){
    _controller=TextEditingController();
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: const Text(
          'Add a New Bread Crumb'
      ),
    ),
      body: Column(children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
          hintText: 'Enter a new Bread crumb here',
          ),
        ),
        TextButton(
            onPressed: (){
              final text=_controller.text;
              if(text.isNotEmpty) {
                final breadCrumb= BreadCrumb(
                  isActive: false,
                  name: text,
                );
                context.read<BreadCrumbProvider>().add(
                    breadCrumb
                );
                Navigator.of(context).pop();
              }
              },
            child: const Text('Add'))
        
      ],),
    );
  }
}

