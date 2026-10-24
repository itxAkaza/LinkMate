import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkvault/resources/colors/app_colors.dart';
import 'package:linkvault/screens/addLink/screens/AddLink/addLink.dart';
import 'package:linkvault/screens/addLink/screens/scanner/link_scanner_screen.dart';
import 'package:linkvault/screens/addLink/widget/addCards.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../import_export/import_format_screen.dart';

class LinkScreen extends StatelessWidget {
  const LinkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.readOnlyBg,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height*0.05,),
              Padding(
                padding: const EdgeInsets.only(left: 13),
                child: ListTile(
                  title: Text("Add New",
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w900,
                        fontSize: 25,
                        color: AppColors.textColorBlack
                    ),
                  ),
                  subtitle: Text("Save links, scan, or import in one place",
                  style: GoogleFonts.manrope(
                      color: AppColors.subTitleColorGary
                  ),
                  ),
                ),
              ),
              SizedBox(height: 10),
             Row(
               children: [
                 AddCards(
                   onTap: (){
                     Get.to(AddLinkScreen());
                   },
                     title: "Add Link",
                     subTitle: "Save a links from anywhere",
                     icon: Icons.link,
          
                 ),
                 AddCards(
                     onTap: (){
                       Get.to(ScanLinkScreen());
                     },
                     title: "Scan QR",
                     subTitle: "Quickly add via QR code",
                     icon: Icons.qr_code_scanner_outlined
                 ),
          
               ],
             ),
          
              SizedBox(height: 9,),
          
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Get.to(ImportFormatScreen());
                      },
                      child: Card(
                        color: AppColors.overlayFieldGray,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: Colors.black12,
                            width: 1,
                          ),
                        ),
          
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3,vertical: 8),
                          child: ListTile(
                            title: Text("Import from CSV",
                              style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: AppColors.textColorBlack
                              ),
                            ),
                            subtitle: Text("Bulk import your saved links",
                              style: GoogleFonts.manrope(
                                  color: AppColors.subTitleColorGary
                              ),
                            ),
                            leading:  Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: PhysicalModel(
                                color: Colors.blueAccent.withOpacity(0.09),
                                borderRadius: BorderRadius.circular(14),
                                child:  Padding(
                                  padding: EdgeInsets.all(13),
                                  child: Icon( LucideIcons.fileDown,
                                      color: AppColors.iconBlue
                                  ),
                                ),
                              ),
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: PhysicalModel(
                                color: Colors.blueAccent.withOpacity(0.09),
                                borderRadius: BorderRadius.circular(14),
                                child:  Padding(
                                  padding: EdgeInsets.all(13),
                                  child: Text(".csv",style: GoogleFonts.manrope(
                                      color: AppColors.iconBlue,
                                    fontWeight: .bold,
                                    fontSize: 13
                                  ),)
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
          
          
          
            ],
          ),
        ),
      )
    );
  }
}