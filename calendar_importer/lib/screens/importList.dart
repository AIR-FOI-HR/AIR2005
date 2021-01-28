import 'package:calendar_importer/models/calendarSource.dart';
import 'package:calendar_importer/support/widgetView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImportList extends StatefulWidget {
  @override
  _ImportListController createState() => _ImportListController();
}

class _ImportListController extends State<ImportList> {
  List<CalendarSource> listOfSources;

  @override
  void initState() {
    listOfSources = [CalendarSource(name: "Naziv",url: "nesto")];
  }

  @override
  Widget build(BuildContext context) => _ImportListView(this);
}

class _ImportListView extends WidgetView<ImportList, _ImportListController> {
  _ImportListView(_ImportListController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Popis izvora")),
      body: _buildList(context),
    );
  }
  
  Widget _buildList(BuildContext context)
  {
    return ListView.builder(
        itemCount:state.listOfSources.length,
        itemBuilder: (context,index){
          return ListTile(
            title: Text('${state.listOfSources[index].name}'),
          );
        });
  }
}