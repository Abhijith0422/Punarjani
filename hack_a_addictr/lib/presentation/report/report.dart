import 'package:flutter/material.dart';
import 'package:punarjani/presentation/report/history.dart';
import 'package:punarjani/presentation/report/reportpage.dart';
import 'package:punarjani/presentation/report/statuspage.dart';

class Report extends StatelessWidget {
  const Report({super.key, this.id});
  final dynamic id;

  @override
  Widget build(BuildContext context) {
    final List<Tab> tabbarItems = [
      Tab(
        child: Container(
            width: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFFEAE0C8),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.report,
                  size: 30,
                ),
                SizedBox(height: 30),
                Text(
                  'Report',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            )),
      ),
      Tab(
        child: Container(
            width: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFFEAE0C8),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.analytics, size: 30),
                SizedBox(height: 30),
                Text(
                  'Status',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            )),
      ),
      Tab(
        child: Container(
            width: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFFEAE0C8),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 30),
                SizedBox(height: 30),
                Text(
                  'History',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            )),
      ),
    ];
    return DefaultTabController(
      length: tabbarItems.length,
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: reportbackground(context, tabbarItems),
        ),
      ),
    );
  }

  Stack reportbackground(BuildContext context, List<Tab> tabbarItems) {
    return Stack(
      children: [
        Container(
          height: 400,
          width: MediaQuery.of(context).size.width,
          color: const Color(0xFFFF4400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                child: TabBar(
                  unselectedLabelColor: Colors.black.withOpacity(0.8),
                  indicator: const BoxDecoration(color: Colors.transparent),
                  labelColor: const Color(0xFFFF4400),
                  physics: const NeverScrollableScrollPhysics(),
                  tabs: tabbarItems,
                  dividerColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(
              color: Color(0xFFEAE0C8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: TabBarView(
              children: [
                Reportpage(
                  id: id,
                ),
                const StatusPage(),
                const HistoryPage()
              ],
            ),
          ),
        ),
      ],
    );
  }
}
