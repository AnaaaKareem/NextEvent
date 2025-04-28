import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

// Manages stateful filter menu
class FilterMenu extends StatefulWidget {
  const FilterMenu({super.key});

  @override
  FilterMenuState createState() => FilterMenuState();
}

class FilterMenuState extends State<FilterMenu> {
  SfRangeValues _values = SfRangeValues(50, 80);

  // Build filter menu widget
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Type'),
          DropdownMenu(
            initialSelection: 'type',
            dropdownMenuEntries: const [
              DropdownMenuEntry(value: 'Music', label: 'Music'),
              DropdownMenuEntry(value: 'Technology', label: 'Technology'),
            ],
          ),
          SizedBox(height: 20),
          Text('Price'),
          SfRangeSlider(
            min: 0,
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
            },
          ),
          SizedBox(height: 20),
          Text('Date'),
          SizedBox(
            width: 200,
            child: SfDateRangePicker(
              selectionMode: DateRangePickerSelectionMode.range,
            ),
          ),
        ],
      ),
    );
  }
}