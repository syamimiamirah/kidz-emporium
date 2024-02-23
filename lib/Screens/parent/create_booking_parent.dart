import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:kidz_emporium/Screens/parent/create_payment_parent.dart';
import 'package:kidz_emporium/Screens/parent/view_child_parent.dart';
import 'package:kidz_emporium/Screens/parent/view_reminder_parent.dart';
import 'package:kidz_emporium/contants.dart';
import 'package:kidz_emporium/models/child_model.dart';
import 'package:kidz_emporium/models/login_response_model.dart';
import 'package:kidz_emporium/models/therapist_model.dart';
import 'package:kidz_emporium/services/api_service.dart';

import 'package:snippet_coder_utils/FormHelper.dart';

import '../../config.dart';
import '../../models/booking_model.dart';
import '../../utils.dart';


class CreateBookingParentPage extends StatefulWidget{
  final LoginResponseModel userData;

  const CreateBookingParentPage({Key? key, required this.userData}): super(key: key);
  @override
  _createBookingParentPageState createState() => _createBookingParentPageState();
}

class _createBookingParentPageState extends State<CreateBookingParentPage> {
  String? selectedTherapist;
  String? selectedChild;
  late DateTime fromDate;
  late DateTime toDate;
  late String userId;

  List<TherapistModel> therapists = [];
  List<ChildModel> children = [];

  @override
  void initState() {
    super.initState();
    fetchTherapists();
    fetchChildren();
    if (widget.userData != null && widget.userData.data != null) {
      print("userData: ${widget.userData.data!.id}");
      fromDate = DateTime.now();
      toDate = fromDate.add(Duration(hours: 2));
      userId = widget.userData.data!.id;
    } else {
      // Handle the case where userData or userData.data is null
      print("Error: userData or userData.data is null");
    }
  }

  Future<void> fetchTherapists() async {
    try {
      List<TherapistModel> fetchedTherapists = await APIService.getAllTherapists();
      print('$fetchedTherapists');
      setState(() {
        therapists = fetchedTherapists;
      });
    } catch (error) {
      print('Error fetching therapists: $error');
    }
  }

  Future<void> fetchChildren() async {
    try {
      List<ChildModel> fetchedChildren = await APIService.getChild(widget.userData.data!.id);
      setState(() {
        children = fetchedChildren;
      });
    } catch (error) {
      print('Error fetching children: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Booking'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ProgressHUD(
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey,),

                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            Icons.people, // Your desired icon
                            color: kPrimaryColor, // Icon color
                          ),
                        ),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: const Text("Select Therapist", style: TextStyle(fontSize: 16)),
                            value: selectedTherapist,
                            onChanged: (newValue) {
                              setState(() {
                                selectedTherapist = newValue!;
                              });
                            },
                            items: therapists.map((TherapistModel therapist) {
                              return DropdownMenuItem<String>(
                                value: therapist.id,
                                child: Text(therapist.therapistName, style: TextStyle(fontSize: 16)
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        ),
                      ],
                    ),
                  ),

                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey,),

                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            Icons.child_care, // Your desired icon
                            color: kPrimaryColor, // Icon color
                          ),
                        ),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: const Text("Select Child", style: TextStyle(fontSize: 16)),
                              value: selectedChild,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedChild = newValue!;
                                });
                              },
                              items: children
                                  .map<DropdownMenuItem<String>>((ChildModel child) {
                                return DropdownMenuItem<String>(
                                  value: child.id, // Ensure child.id is unique
                                  child: Text(child.childName,style: TextStyle(fontSize: 16)
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ),
              ),
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: Text('FROM', style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  ),
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 10),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: ListTile(
                                  title: Text(
                                      Utils.toDate(fromDate),
                                      style: TextStyle(fontSize: 16)
                                  ),
                                  trailing: Icon(Icons.arrow_drop_down),
                                  onTap: () => pickFromDateTime(pickDate: true),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                      Utils.toTime(fromDate),
                                      style: TextStyle(fontSize: 16)
                                  ),
                                  trailing: Icon(Icons.arrow_drop_down),
                                  onTap: () => pickFromDateTime(pickDate: false),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: Text('TO', style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  ),
                ],
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 10),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: ListTile(
                                  title: Text(
                                      Utils.toDate(toDate),
                                      style: TextStyle(fontSize: 16)
                                  ),
                                  trailing: Icon(Icons.arrow_drop_down),
                                  onTap: () => pickToDateTime(pickDate: true),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                      Utils.toTime(toDate),
                                      style: TextStyle(fontSize: 16)
                                  ),
                                  trailing: Icon(Icons.arrow_drop_down),
                                  onTap: () => pickToDateTime(pickDate: false),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () async {
                  // Check therapist availability before proceeding with the payment
                  bool isTherapistAvailable = await APIService.checkTherapistAvailability(
                    selectedTherapist!,
                    fromDate,
                    toDate,
                  );

                  if (!isTherapistAvailable) {
                    // Display a snackbar for therapist not available
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Therapist is not available for the selected time.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                    return;
                  }

                  // Show the reminder AlertDialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(Config.appName),
                        content: Text("REMINDER: Payment can only be made through Credit/Debit Card"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text("OK", style: TextStyle(color: kPrimaryColor),),
                          ),
                        ],
                      );
                    },
                  );

                  // Navigate to the PaymentPage
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(
                        userData: widget.userData,
                        selectedTherapist: selectedTherapist,
                        selectedChild: selectedChild,
                        fromDate: fromDate!,
                        toDate: toDate!,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: kPrimaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // BorderRadius
                  ),
                ),
                child: Text('Proceed with Payment',
                  style: TextStyle(fontSize: 16),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
  Future pickFromDateTime({required bool pickDate}) async{
    final date = await pickDateTime(fromDate!, pickDate: pickDate);
    if(date == null) return;

    if(date.isAfter(toDate!)){
      toDate = date.add(Duration(hours: 2));
    }
    setState(()
    => fromDate = date
    );
  }

  Future pickToDateTime({required bool pickDate}) async{
    final date = await pickDateTime(
      toDate!,
      pickDate: pickDate,
      firstDate: pickDate ? fromDate : null,
    );
    if(date == null) return;

    setState(()
    => toDate = date);
  }

  Future<DateTime?> pickDateTime(
      DateTime initialDate,{
        required bool pickDate,
        DateTime? firstDate,
      }) async{
    if (pickDate){
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: kPrimaryColor, // Set your desired primary color
              hintColor: kPrimaryColor, // Set your desired accent color
              colorScheme: ColorScheme.light(primary: kPrimaryColor),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        },
      );

      if(date == null) return null;

      final time = Duration(hours: initialDate.hour, minutes: initialDate.minute);

      return date.add(time);
    }else{
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: kPrimaryColor, // Set your desired primary color
              hintColor: kPrimaryColor, // Set your desired accent color
              colorScheme: ColorScheme.light(primary: kPrimaryColor),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        },
      );

      if(timeOfDay == null) return null;
      final date = DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }
  }
}
