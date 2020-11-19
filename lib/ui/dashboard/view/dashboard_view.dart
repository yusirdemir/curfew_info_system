import 'dart:async';

import 'package:curfew_info_system/ui/result/view/result_view.dart';
import 'package:flutter/material.dart';
import 'package:curfew_info_system/ui/dashboard/utils/validator.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DashBoardView extends StatefulWidget {
  @override
  _DashBoardViewState createState() => _DashBoardViewState();
}

class _DashBoardViewState extends State<DashBoardView> with Validator {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _ageFocus = FocusNode();

  final double minValue = 8.0;
  final _workingbackTypeList = <String>["Evet", "Hayır"];
  final _formKey = GlobalKey<FormState>();

  String _workingbackType = "";

  final TextStyle _errorStyle = TextStyle(
    color: Colors.red,
    fontSize: 16.6,
  );

  @override
  initState() {
    _workingbackType = _workingbackTypeList[1];
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  Widget _buildHeader() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
          vertical: minValue * 4, horizontal: minValue * 3),
      height: 260.0,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: minValue * 2,
            ),
            Text(
              "Covid-19",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 48.0,
                  color: Colors.white),
            ),
            SizedBox(
              width: 110.0,
              child: Container(
                height: 6,
                color: Colors.orange,
              ),
            ),
            SizedBox(
              height: minValue * 4,
            ),
            Text(
              "Sokağa Çıkma Yasağı Hesaplayıcı Sistem",
              style: TextStyle(fontSize: 20.0, color: Colors.grey[200]),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(color: Colors.black87),
    );
  }

  Widget _buildWorking() {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: minValue * 2, horizontal: minValue * 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Çalışıyor musun?",
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          SizedBox(
            height: minValue * 2,
          ),
          Row(
            children: <Widget>[
              Radio<String>(
                  value: _workingbackTypeList[0],
                  groupValue: _workingbackType,
                  onChanged: (String v) {
                    setState(() {
                      _workingbackType = v;
                    });
                  }),
              Text('Evet'),
              SizedBox(
                width: minValue,
              ),
              Radio<String>(
                  value: _workingbackTypeList[1],
                  autofocus: true,
                  groupValue: _workingbackType,
                  onChanged: (String v) {
                    setState(() {
                      _workingbackType = v;
                    });
                  }),
              Text('Hayır'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildName() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: minValue * 3),
      child: TextFormField(
        controller: _nameController,
        focusNode: _ageFocus,
        validator: nameValidator,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            errorStyle: _errorStyle,
            contentPadding:
                EdgeInsets.symmetric(vertical: minValue, horizontal: minValue),
            hintText: 'İsim',
            labelText: 'İsminizi Giriniz',
            labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
      ),
    );
  }

  Widget _buildAge() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: minValue * 3),
      child: TextFormField(
        controller: _ageController,
        focusNode: _nameFocus,
        validator: ageValidator,
        keyboardType: TextInputType.number,
        maxLines: 2,
        decoration: InputDecoration(
            errorStyle: _errorStyle,
            labelText: 'Yaşınızı Girin',
            contentPadding: EdgeInsets.symmetric(horizontal: minValue),
            labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
      ),
    );
  }

  Widget _buildDate() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: minValue * 3),
      child: TextFormField(
        controller: _dateController,
        keyboardType: TextInputType.text,
        enabled: false,
        maxLines: 2,
        decoration: InputDecoration(
            errorStyle: _errorStyle,
            labelText: 'Zaman',
            contentPadding: EdgeInsets.symmetric(horizontal: minValue),
            labelStyle: TextStyle(fontSize: 16.0, color: Colors.black87)),
      ),
    );
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    _dateController.text = formattedDateTime;
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy hh:mm:ss').format(dateTime);
  }

  Widget _buildSubmitBtn() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: minValue * 3),
      width: double.maxFinite,
      child: RaisedButton(
        onPressed: () {
          _ageFocus.unfocus();
          _nameFocus.unfocus();
          if (_formKey.currentState.validate()) {
            showMaterialModalBottomSheet(
              expand: false,
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => ResultView(
                name: _nameController.text,
                age: int.parse(_ageController.text),
                date: _dateController.text,
                workingBack: _workingbackType,
              ),
            );
            _formKey.currentState.save();
          }
        },
        padding: EdgeInsets.symmetric(vertical: minValue * 2),
        elevation: 0.0,
        color: Colors.black87,
        textColor: Colors.white,
        child: Text('HESAPLA'),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: minValue * 3,
          ),
          _buildName(),
          SizedBox(
            height: minValue * 3,
          ),
          _buildAge(),
          SizedBox(
            height: minValue * 3,
          ),
          _buildDate(),
          SizedBox(
            height: minValue * 3,
          ),
          _buildWorking(),
          SizedBox(
            height: minValue * 3,
          ),
          _buildSubmitBtn(),
          SizedBox(
            height: minValue * 6,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildHeader(),
            Form(
              key: _formKey,
              child: _buildContent(),
            )
          ],
        ),
      ),
    );
  }
}
