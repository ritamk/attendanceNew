import 'package:AnandaAttendance/services/database.dart';
import 'package:AnandaAttendance/shared/loading/loading.dart';
import 'package:AnandaAttendance/views/attendance/photo_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttReportPage extends StatefulWidget {
  const AttReportPage({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<AttReportPage> createState() => AttReportStatePage();
}

class AttReportStatePage extends State<AttReportPage> {
  late DateTime today;
  late int currMonth;
  late int currYear;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    currMonth = today.month;
    currYear = today.year;
    selectedDate = today;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report")),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 300.0,
              width: double.infinity,
              child: CalendarDatePicker(
                initialDate: today,
                firstDate: DateTime(currYear, currMonth - 1, 1),
                lastDate: today,
                onDateChanged: (date) {
                  setState(() => selectedDate = date);
                },
              ),
            ),
            const SizedBox(height: 20.0, width: 0.0),
            FutureBuilder<List?>(
                future: DatabaseService(uid: widget.uid)
                    .attendanceSummary(selectedDate),
                initialData: null,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            // check if the date is marked as leave
                            try {
                              final Duration durn = snapshot.data![index]
                                      ["reporting"]
                                  ? Duration(seconds: 0)
                                  : snapshot.data![index]["time"]
                                      .toDate()
                                      .difference(snapshot.data![index - 1]
                                              ["time"]
                                          .toDate());
                              return !snapshot.data![index]["leave"]
                                  ? Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: ListTile(
                                        title: Text(
                                            DateFormat.jms().format(snapshot
                                                .data![index]["time"]
                                                .toDate()),
                                            style: const TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold)),
                                        leading: snapshot.data![index]
                                                ["reporting"]
                                            ? Icon(Icons.login_rounded,
                                                color: Colors.green.shade800)
                                            : Icon(Icons.logout_rounded,
                                                color: Colors.red.shade800),
                                        subtitle: snapshot.data![index]
                                                ["reporting"]
                                            ? SizedBox(height: 0.0, width: 0.0)
                                            : Text(
                                                "(${durn.inHours}:${durn.inMinutes.remainder(60)}:${(durn.inSeconds.remainder(60))})",
                                                style: TextStyle(
                                                    color: Colors.black54),
                                              ),
                                        trailing: InkWell(
                                          onTap: () => Navigator.of(context)
                                              .push(CupertinoPageRoute(
                                                  builder: (context) =>
                                                      PhotoViewingPage(
                                                          url: snapshot
                                                                  .data![index]
                                                              ["photo"]))),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            child: Image.network(
                                              snapshot.data![index]["photo"],
                                              fit: BoxFit.cover,
                                              frameBuilder: (context,
                                                      child,
                                                      frame,
                                                      wasSynchronouslyLoaded) =>
                                                  frame != null
                                                      ? child
                                                      : const Loading(
                                                          white: false),
                                              loadingBuilder: (context, child,
                                                      loadingProgress) =>
                                                  loadingProgress != null
                                                      ? const Loading(
                                                          white: false)
                                                      : child,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: const ListTile(
                                          title: Text("On leave."),
                                          leading: Icon(Icons.check)),
                                    );
                            } catch (e) {
                              final Duration durn = snapshot.data![index]
                                      ["reporting"]
                                  ? Duration(seconds: 0)
                                  : snapshot.data![index]["time"]
                                      .toDate()
                                      .difference(snapshot.data![index - 1]
                                              ["time"]
                                          .toDate());
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ListTile(
                                  title: Text(
                                      DateFormat.jms()
                                          .format(snapshot.data![index]["time"]
                                              .toDate())
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold)),
                                  leading: snapshot.data![index]["reporting"]
                                      ? Icon(Icons.login_rounded,
                                          color: Colors.green.shade800)
                                      : Icon(Icons.logout_rounded,
                                          color: Colors.red.shade800),
                                  subtitle: snapshot.data![index]["reporting"]
                                      ? SizedBox(height: 0.0, width: 0.0)
                                      : Text(
                                          "(${durn.inHours}:${durn.inMinutes.remainder(60)}:${(durn.inSeconds.remainder(60))})",
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                  trailing: InkWell(
                                    onTap: () => Navigator.of(context).push(
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                PhotoViewingPage(
                                                    url: snapshot.data![index]
                                                        ["photo"]))),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: Image.network(
                                        snapshot.data![index]["photo"],
                                        fit: BoxFit.cover,
                                        frameBuilder: (context, child, frame,
                                                wasSynchronouslyLoaded) =>
                                            frame != null
                                                ? child
                                                : const Loading(white: false),
                                        loadingBuilder: (context, child,
                                                loadingProgress) =>
                                            loadingProgress != null
                                                ? const Loading(white: false)
                                                : child,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                          padding: const EdgeInsets.all(16.0),
                          shrinkWrap: true,
                          clipBehavior: Clip.none,
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(Icons.error, color: Colors.red),
                            SizedBox(height: 0.0, width: 10.0),
                            Text(
                              "No data for the selected date",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        );
                      }
                    } else {
                      return const Loading(white: false);
                    }
                  } else {
                    return const Loading(white: false);
                  }
                }),
          ],
        ),
      ),
    );
  }
}
