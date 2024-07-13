import 'package:flutter/material.dart';
import 'package:csmkatalog/utils/dashboard_screen.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key, required this.applicationName, required this.dashboardScreens, required this.changeScreenListener});
  final String applicationName;
  final Function(Widget) changeScreenListener;
  final List<DashboardScreen> dashboardScreens;
  final int selectedScreen = 0;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
          border: BorderDirectional(
              end: BorderSide(
                  color: Colors.blueGrey,
                  width: 3
              )
          )
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 6.0),
        child: DecoratedBox(
          decoration: const BoxDecoration(
              border: BorderDirectional(
                  end: BorderSide(
                      color: Colors.blueGrey,
                      width: 1
                  )
              )
          ),
          child: SizedBox(
            width: (MediaQuery.of(context).size.width > 900) ? (MediaQuery.of(context).size.width/4) : (180),
            height: MediaQuery.of(context).size.height,
            child: Container(
              color: Colors.blueGrey[300],
              child: Column(
                children: [
                  const SizedBox(height: 8,),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/6,
                    child: Container(
                      color: Colors.blueGrey,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MediaQuery.of(context).size.width > 1000 ? Image.asset("images/logo_csm.png") : const SizedBox(),
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("PT. CSM",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(applicationName),
                              ]
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(height: 1, child: Container(
                    color: Colors.blueGrey,
                  ),),
                  const SizedBox(height: 16),
                  for (var screen in dashboardScreens)
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        hoverColor: Colors.blueGrey,
                        onTap: () => changeScreenListener(screen.widgetFunction()),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 8.0, bottom: 2.0, top: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueGrey, width: 2)
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(screen.label,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.blueGrey[900],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}