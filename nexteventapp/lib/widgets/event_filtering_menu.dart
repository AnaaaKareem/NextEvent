import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class FilterMenu extends StatefulWidget {
  const FilterMenu({super.key});

  @override
  FilterMenuState createState() => FilterMenuState();
}

class FilterMenuState extends State<FilterMenu> {
  SfRangeValues _values = SfRangeValues(50, 80);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Text('Type'),
        DropdownMenu(
          initialSelection: 'type',
          dropdownMenuEntries: [
            DropdownMenuEntry(
              value: Colors.black,
              label: 'Music'
            ),
            DropdownMenuEntry(
                value: Colors.black,
                label: 'Technology'
            ),
          ],
        ),
          ],
            ),
            Row(
              children: [
                Text('Price'),
                SfRangeSlider(min: 0,
                    max: 300,
                    interval: 50,
                    stepSize: 50,
                    values: _values,
                    showTicks: true,
                    showLabels: true,
                    enableTooltip: true,
                    minorTicksPerInterval: 1,
                    onChanged: (SfRangeValues values) {
                      setState(() {
                        _values = values;
                      });
                    }),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Text('Date'),
                    SizedBox(
                      width: 250,
                      child: SfDateRangePicker(selectionMode: DateRangePickerSelectionMode.range),
                    )
                  ],
                )
              ],
            ),
            Row(
              children: [
                Text('Time'),
                TimePickerSpinner(
                  is24HourMode: false, // Set true if you want 24h format
                  spacing: 50,
                  itemHeight: 60,
                  isForce2Digits: true,
                  normalTextStyle: TextStyle(fontSize: 20, color: Colors.grey),
                  highlightedTextStyle: TextStyle(fontSize: 28, color: Colors.black),
                  onTimeChange: (time) {
                    setState(() {

                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}