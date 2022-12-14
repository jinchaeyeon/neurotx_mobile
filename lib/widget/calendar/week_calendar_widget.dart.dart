import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleepaid/data/network/sleep_analysis_response.dart';
import 'package:sleepaid/util/app_colors.dart';
import 'package:sleepaid/widget/base_stateful_widget.dart';
import 'package:sleepaid/widget/calendar/calendar_date_builder.dart';
import 'package:sleepaid/widget/calendar/day_calendar_widget.dart.dart';

import '../../data/network/sleep_condition_parameter_response.dart';

class WeekCalendarWidget extends BaseStatefulWidget{
  final Function? onTapCallback;
  final CalendarDateBuilder dateBuilder;
  final List<DateTime?> week;
  final DateTime? selectedDate;

  final Map<String, SleepConditionDateResponse> data;

  const WeekCalendarWidget({Key? key, this.onTapCallback, required this.dateBuilder,
    required this.week, this.selectedDate, this.data = const {}}) : super(key: key);

  @override
  WeekCalendarState createState() => WeekCalendarState();
}

class WeekCalendarState extends State<WeekCalendarWidget>{

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      // color: Colors.red,
      decoration: BoxDecoration(
        border: Border.fromBorderSide(BorderSide(color: AppColors.backgroundGrey,))
      ),
      child: Column(
        children: [
          Row(
            children: [...getDaysWidget()],
          )
        ]
      )
    );
  }

  getDaysWidget() {
    List<Widget> days = [];
    for (var date in widget.week) {
      if(date == null){
        days.add(Expanded(child: Container()));
      }else{
        days.add(
          Expanded(
            child: DayCalendarWidget(
              dateBuilder:widget.dateBuilder,
              day:date, onTapCallback:
              widget.onTapCallback,
              isSelectedDay: date == widget.selectedDate,
              data: widget.data
            )
          )
        );
      }
    }
    return days;
  }
}