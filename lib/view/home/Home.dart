import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messageapp/constant/color.dart';
import 'package:messageapp/constant/text.dart';
import 'package:messageapp/controller/user_info_controller.dart';
import 'package:messageapp/main.dart';
import 'package:messageapp/view/home/calls.dart';
import 'package:messageapp/view/home/camera.dart';
import 'package:messageapp/view/home/chat/all_user.dart';
import 'package:messageapp/view/home/chat/chats.dart';
import 'package:messageapp/view/home/popup/Settings/Settings_Screen.dart';
import 'package:messageapp/view/home/status/status.dart';
import 'package:messageapp/view/phone_auth.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  List<Widget> tab = [
    // Icon(Icons.camera_alt),
    Ts(
      text: "chats".toUpperCase(),
      size: 15,
    ),
    Ts(
      text: "status".toUpperCase(),
      size: 15,
    ),
    Ts(
      text: "calls".toUpperCase(),
      size: 15,
    )
  ];
  TabController? _tabController;
  bool isFloat = true;
  final TextEditingController _search = TextEditingController();
  String searchText = '';

  @override
  void initState() {
    _tabController = TabController(
      length: tab.length,
      vsync: this,
      initialIndex: 0,
    );
    _tabController!.addListener(() {
      if (_tabController!.index == 0) {
        isFloat = true;
      } else {
        isFloat = false;
      }
      _infoController;
      setState(() {});
    });
    super.initState();
  }

  final InfoController _infoController = Get.put(InfoController());
  bool openSearch = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isFloat
          ? FloatingActionButton(
              onPressed: () {
                Get.to(AllUser(), transition: Transition.rightToLeft);
              },
              backgroundColor: appColor,
              child: RotatedBox(
                quarterTurns: 2,
                child: Icon(Icons.message),
              ),
            )
          : null,
      body: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, index) {
            return [
              SliverAppBar(
                backgroundColor: appColor,
                pinned: true,
                expandedHeight:
                    openSearch == false ? Get.height * 0.11 : Get.height * 0.05,
                flexibleSpace: openSearch == false
                    ? FlexibleSpaceBar(
                        background: AppBar(
                          backgroundColor: appColor,
                          title: Ts(
                            text: 'WhatsApp',
                            color: Colors.white,
                            size: 22,
                          ),
                          actions: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  openSearch = true;
                                  _search.clear();
                                  searchText = "";
                                });
                                // Get.to(Search());
                              },
                              splashRadius: height * 0.025,
                              icon: Icon(
                                Icons.search_rounded,
                                size: 27,
                                color: Colors.white,
                              ),
                            ),
                            PopupMenuButton(
                              splashRadius: height * 0.022,
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: InkWell(
                                    onTap: () {
                                      Get.off(PhoneRegistration());
                                    },
                                    child: Ts(
                                      text: "New group",
                                      weight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  child: InkWell(
                                    onTap: () {},
                                    child: Ts(
                                      text: "Linked devices",
                                      weight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                    child: InkWell(
                                  onTap: () {},
                                  child: Ts(
                                    text: "Linked devices",
                                    weight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                )),
                                PopupMenuItem(
                                  child: InkWell(
                                    onTap: () {
                                      // Get.to(() => Settings());
                                    },
                                    child: Ts(
                                      text: "Starred messages",
                                      weight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() => SettingsScreen());
                                    },
                                    child: Row(
                                      children: const [
                                        Text(
                                          "Settings",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // IconButton(
                            //   onPressed: () {},
                            //   splashRadius: height * 0.025,
                            //   icon: Icon(
                            //     Icons.more_vert_sharp,
                            //     size: 27,
                            //     color: Colors.white,
                            //   ),
                            // ),
                          ],
                        ),
                      )
                    : AnimatedContainer(
                        color: Colors.white,
                        height: height * 0.15,
                        width: width,
                        curve: Curves.bounceInOut,
                        duration: Duration(seconds: 5),
                        child: Column(children: [
                          SizedBox(
                            height: height * 0.005,
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      openSearch = false;
                                      searchText = "";
                                    });
                                  },
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                  )),
                              Expanded(
                                child: TextFormField(
                                  controller: _search,
                                  onChanged: (value) {
                                    setState(() {
                                      searchText = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: width * 0.02),
                                      hintText: "Search....",
                                      hintStyle:
                                          TextStyle(fontSize: height * 0.022),
                                      border: UnderlineInputBorder(
                                          borderSide: BorderSide.none)),
                                ),
                              )
                            ],
                          )
                        ]),
                      ),
                bottom: PreferredSize(
                    preferredSize: Size.fromHeight(0),
                    child: openSearch == false
                        ? Container(
                            color: appColor,
                            width: Get.width,
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await availableCameras().then(
                                      (value) => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CameraPage(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: width * 0.03,
                                      right: width * 0.03,
                                      bottom: height * 0.008,
                                    ),
                                    child: Icon(Icons.camera_alt,
                                        color: Colors.white54),
                                  ),
                                ),
                                Expanded(
                                  child: TabBar(
                                    controller: _tabController,
                                    indicatorColor: Colors.white,
                                    labelColor: Colors.white,
                                    unselectedLabelColor: Colors.white54,
                                    indicatorWeight: 2.5,
                                    labelPadding:
                                        EdgeInsets.only(bottom: height * 0.008),
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    tabs: [
                                      ...List.generate(
                                          tab.length, (index) => tab[index])
                                    ],
                                  ),
                                ),
                              ],
                            )
                            // child: ,
                            )
                        : SizedBox()),
              )
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              Chats(
                searchText: searchText,
              ),
              Status(),
              Calls(),
            ],
          ),
        ),
      ),
    );
  }
}
