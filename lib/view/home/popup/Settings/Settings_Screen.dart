import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messageapp/constant/color.dart';
import 'package:messageapp/constant/settings_widget.dart';
import 'package:messageapp/constant/text.dart';
import 'package:messageapp/controller/user_info_controller.dart';
import 'package:messageapp/view/home/popup/Settings/profile.dart';

import '../../../../constant/image_loading.dart';
import '../../../../main.dart';
import '../../../phone_auth.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final InfoController _infoController = Get.put(InfoController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Ts(text: "Settings", size: 20),
          backgroundColor: appColor),
      body: GetBuilder<InfoController>(
        builder: (controller) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  Get.to(Profile(), transition: Transition.leftToRight);
                },
                child: SizedBox(
                  height: height * 0.1,
                  width: width,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Hero(
                              tag: '${controller.Img}',
                              child: Container(
                                height: height * 0.075,
                                width: height * 0.075,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey.shade200),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: ImageLoading(
                                    url: '${controller.Img}',
                                    hight: height * 0.075,
                                    width: height * 0.075,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.03500,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Ts(
                                  text:
                                      "${controller.name ?? storage.read('name')}",
                                  size: height * 0.023,
                                  weight: FontWeight.w400,
                                ),
                                SizedBox(height: height * 0.0025),
                                Ts(
                                  text: "${controller.bio}",
                                  color: Colors.grey,
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(
                thickness: 0.07,
                color: Colors.grey,
              ),
              SizedBox(
                height: height * 0.01,
              ),
              SettingWidget(
                  onTap: () {},
                  rotate: 1,
                  title: 'Account',
                  subTitle: 'Privacy, security, change number',
                  icons: Icons.key),
              SizedBox(
                height: height * 0.04,
              ),
              SettingWidget(
                  onTap: () {},
                  rotate: 2,
                  title: 'Chats',
                  subTitle: "Theme, wallpapers, chat history",
                  icons: Icons.chat),
              SizedBox(
                height: height * 0.036,
              ),
              SettingWidget(
                  onTap: () {},
                  rotate: 0,
                  title: "Notifications",
                  subTitle: 'Message, group & call tones',
                  icons: Icons.notifications),
              SizedBox(
                height: height * 0.036,
              ),
              SettingWidget(
                  onTap: () {},
                  rotate: 0,
                  title: 'Storage and data',
                  subTitle: 'Network usage, auto-download',
                  icons: Icons.data_usage),
              SizedBox(
                height: height * 0.036,
              ),
              SettingWidget(
                  onTap: () {},
                  title: "App language",
                  icons: Icons.language,
                  rotate: 0,
                  subTitle: "English (phone's language)"),
              SizedBox(
                height: height * 0.036,
              ),
              SettingWidget(
                onTap: () {},
                rotate: 0,
                title: 'Help',
                subTitle: 'Help centre, contact us, privacy policy',
                icons: Icons.help_outline_outlined,
              ),
              SizedBox(
                height: height * 0.036,
              ),
              GestureDetector(
                onTap: () {
                  Get.offAll(PhoneRegistration());
                },
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.055),
                      child: Icon(
                        Icons.people,
                        color: Colors.grey,
                        size: height * 0.026,
                      ),
                    ),
                    Ts(
                      text: "Invite a friend",
                      size: height * 0.019,
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
