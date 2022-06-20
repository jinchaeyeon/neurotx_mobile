import 'package:sleepaid/data/network/calendar_response.dart';

class CalendarDateBuilder{
  final DateTime startDate; // 시작일
  final DateTime endDate; // 종료일

  List<CalendarDetailResponse>  datelist = [];
  // 2022-01 / 2022-02 등의 문자열
  List<String> monthStrings = [];
  // 각 monthStrings 별 날짜 모음 monthDays["2022-01] 에는 1월 날짜 모음
  Map<String, List<DateTime>> monthDays = {};
  // 각 주별 날짜모음, weeks["2022-01"]에는 {1주차,2주차,3주차,4주차} 데이터가 존재
  Map<String, List<List<DateTime?>>> weeks = {};




  /// from to 입력 시, 캘린더를 위한 날짜 데이터 분리
  CalendarDateBuilder(this.startDate, this.endDate, this.datelist){
    print("CalendarDateBuilder this.startDate:${startDate}, this.endDate: $endDate");
    buildCalendarData();

  }
  
  ///각 달별로 날짜를 모아서 저장
  buildCalendarData(){
    final daysGap = endDate.difference(startDate).inDays + 1; //전체날짜숫자
    DateTime targetDate = DateTime(startDate.year, startDate.month, startDate.day);
    for(int i=0; i<daysGap; i++){
      monthStrings.add("${targetDate.year}-${targetDate.month}");
      /// 각 달에 날짜를 저장
      if(monthDays["${targetDate.year}-${targetDate.month}"] == null){
        monthDays["${targetDate.year}-${targetDate.month}"] =
        [DateTime(targetDate.year, targetDate.month, targetDate.day)];
      }else{
        monthDays["${targetDate.year}-${targetDate.month}"]!
            .add(DateTime(targetDate.year, targetDate.month, targetDate.day));
      }
      targetDate = targetDate.add(const Duration(days:1));
      print("targetDate: ${targetDate}");
    }
    monthStrings = monthStrings.toSet().toList();
    print("monthStrings: $monthStrings");

    /// 각달에 주 데이터를 저장
    /// weekday 1월요일 ... 7 일요일
    /// 여기서는 일요일부터 시작이라서
    /// 7 1 2 3 4 5 6 반복
    /// 0 1 2 3 4 5 6
    for (var monthString in monthStrings) {
      if(weeks[monthString] == null){
        weeks[monthString] = [];
      }
      print("monthDays[$monthString]: ${monthDays[monthString]}");
      List<DateTime?> iWeeks = [null, null, null, null, null, null, null];
      monthDays[monthString]?.forEach((DateTime date) {
        if(date.weekday != 6){
          iWeeks[date.weekday % 7] = date;
        }else if(date.weekday == 6){
          iWeeks[date.weekday] = date;
          weeks[monthString]!.add(List.from(iWeeks));
          iWeeks = [null, null, null, null, null, null, null];
        }
        if(monthDays[monthString]!.last == date){
          weeks[monthString]!.add(List.from(iWeeks));
          iWeeks = [null, null, null, null, null, null, null];
        }
      });
    }

  print("weeks: ${weeks}");


  }
}