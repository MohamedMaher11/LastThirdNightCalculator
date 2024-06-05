import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LastThirdCalculator extends StatefulWidget {
  @override
  _LastThirdCalculatorState createState() => _LastThirdCalculatorState();
}

class _LastThirdCalculatorState extends State<LastThirdCalculator> {
  TimeOfDay? maghribTime;
  TimeOfDay? fajrTime;
  TimeOfDay? lastThirdTime;

  @override
  void initState() {
    super.initState();
  }

  void calculateLastThird() {
    if (maghribTime != null && fajrTime != null) {
      int maghribMinutes = maghribTime!.hour * 60 + maghribTime!.minute;
      int fajrMinutes = fajrTime!.hour * 60 + fajrTime!.minute;

      int nightDurationMinutes = (fajrMinutes - maghribMinutes + 1440) %
          1440; // Total night duration in minutes
      int thirdDurationMinutes =
          nightDurationMinutes ~/ 3; // Duration of each third of the night

      int lastThirdStartMinutes = (maghribMinutes + 2 * thirdDurationMinutes) %
          1440; // Start time of the last third of the night in minutes

      int lastThirdHours = lastThirdStartMinutes ~/ 60;
      int lastThirdMinutes = lastThirdStartMinutes % 60;

      String period = lastThirdHours < 12 ? 'صباحًا' : 'مساءًا';
      if (lastThirdHours > 12)
        lastThirdHours -= 12; // Convert to 12-hour format
      if (lastThirdHours == 0)
        lastThirdHours = 12; // 0 hour means 12 AM or 12 PM

      setState(() {
        lastThirdTime =
            TimeOfDay(hour: lastThirdHours, minute: lastThirdMinutes);
      });

      // Show AlertDialog to encourage night prayer
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Lottie.asset(
                    'assets/pray.json',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'إن الليل هو وقت خاص للتفكر والدعاء والتضرع إلى الله،',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'فلا تفوت فرصة هذا الوقت الثمين في العبادة والتأمل.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'اللهم اجعلنا من الذاكرين الشاكرين، ومن المستغفرين الذاكرين، ومن السائلين الخاشعين.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'تقبل الله قيامكم',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      // Handle the case where maghribTime or fajrTime is null
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('من فضلك اختار التوقيت'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF062447),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'حساب الثلث الاخير من الليل',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                title: Text('وقت المغرب',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: Icon(Icons.access_time, color: Colors.teal[900]),
                  onPressed: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: 12, minute: 0),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        maghribTime = pickedTime;
                      });
                    }
                  },
                ),
                subtitle: Text(
                  maghribTime != null
                      ? maghribTime!.format(context)
                      : 'لم يتم التحديد',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 15),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                title: Text('وقت الفجر',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: Icon(Icons.access_time, color: Colors.teal[900]),
                  onPressed: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: 4, minute: 0),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        fajrTime = pickedTime;
                      });
                    }
                  },
                ),
                subtitle: Text(
                  fajrTime != null
                      ? fajrTime!.format(context)
                      : 'لم يتم التحديد',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: calculateLastThird,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 8,
                shadowColor: Colors.teal[200],
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Text('احسب', style: TextStyle(color: Colors.black)),
            ),
            SizedBox(height: 60.0),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  lastThirdTime != null
                      ? 'الثلث الأخير من الليل يبدأ عند: ${lastThirdTime!.hourOfPeriod}:${lastThirdTime!.minute.toString().padLeft(2, '0')} ${lastThirdTime!.period == DayPeriod.am ? 'صباحًا' : 'مساءًا'}'
                      : 'لم يتم الحساب بعد',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[900]),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
