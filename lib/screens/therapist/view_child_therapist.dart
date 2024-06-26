import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kidz_emporium/models/child_model.dart';
import 'package:kidz_emporium/models/login_response_model.dart';
import 'package:kidz_emporium/contants.dart';
import 'package:kidz_emporium/services/api_service.dart';

class ViewChildTherapistPage extends StatefulWidget {
  final LoginResponseModel userData;
  final List<ChildModel> children;

  const ViewChildTherapistPage({Key? key, required this.userData, required this.children}) : super(key: key);

  @override
  _ViewChildTherapistPageState createState() => _ViewChildTherapistPageState();
}

class _ViewChildTherapistPageState extends State<ViewChildTherapistPage> {
  String getImagePathByGender(String gender) {
    return gender == 'Male' ? 'assets/images/male_child.png' : 'assets/images/female_child.png';
  }

  List<ChildModel> filteredChildren = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredChildren = widget.children;
  }

  void _filterChildren(String query) {
    setState(() {
      filteredChildren = widget.children
          .where((child) =>
          child.childName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _resetSearch() {
    setState(() {
      filteredChildren = widget.children;
      searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kSecondaryColor,
        title: Text("View Child Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetSearch,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              onChanged: _filterChildren,
              decoration: InputDecoration(
                labelText: 'Search by Name',
                prefixIcon: Icon(Icons.search),
                fillColor: Colors.grey[200],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "All children",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredChildren.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(getImagePathByGender(widget.children[index].gender ?? '')),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            filteredChildren[index].childName ?? '',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Birth Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.children[index].birthDate as String))}",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Program: ${filteredChildren[index].program ?? 'N/A'}",
                            style: TextStyle(fontSize: 16),
                          ),
                          // Add any other details as needed
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
