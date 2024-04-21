import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_charts_app/providers/roomProvider.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../providers/urlProvider.dart';

class SelectRoom extends StatefulWidget {
  final Function function;

  const SelectRoom({super.key, required this.function});

  @override
  State<SelectRoom> createState() => _SelectRoomState();
}

class _SelectRoomState extends State<SelectRoom> {

  final TextEditingController schoolController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController roomController = TextEditingController();

  String? selectedSchool = "";
  String? selectedBranch = "";
  String? selectedRoom = "";

  List<String> schools = [];
  List<String> branches = [];
  List<String> rooms = [];

  @override
  void initState() {
    super.initState();

    fetchSchools();
  }

  fetchSchools() async {
    schools = await getSchools(context);

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownMenu<String>(
          initialSelection: selectedSchool,
          controller: schoolController,
          requestFocusOnTap: true,
          label: const Text("Schule"),
          onSelected: (String? school) async {
            branchController.clear();
            roomController.clear();

            rooms.clear();

            selectedBranch = "";
            selectedRoom = "";

            selectedSchool = school;
            branches = await getBranches(context, selectedSchool!);

            setState(() {});
          },
          dropdownMenuEntries:
          schools.map<DropdownMenuEntry<String>>((String school) {
            return DropdownMenuEntry<String>(
              value: school,
              label: school,
            );
          }).toList(),
        ),
      ),
      if (selectedSchool != "")
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownMenu<String>(
            initialSelection: selectedBranch,
            controller: branchController,
            requestFocusOnTap: true,
            label: const Text("Abteilung"),
            onSelected: (String? branch) async {
              roomController.clear();

              selectedRoom = "";

              selectedBranch = branch;
              rooms = await getRooms(context, selectedSchool!, selectedBranch!);

              setState(() {});
            },
            dropdownMenuEntries:
            branches.map<DropdownMenuEntry<String>>((String branch) {
              return DropdownMenuEntry<String>(
                value: branch,
                label: branch,
              );
            }).toList(),
          ),
        ),
      if (selectedBranch != "")
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownMenu<String>(
            initialSelection: selectedRoom,
            controller: roomController,
            requestFocusOnTap: true,
            label: const Text("Raum"),
            onSelected: (String? room) {
              selectedRoom = room;

              widget.function(selectedRoom);

              setState(() {});
            },
            dropdownMenuEntries:
            rooms.map<DropdownMenuEntry<String>>((String room) {
              return DropdownMenuEntry<String>(
                value: room,
                label: room,
              );
            }).toList(),
          ),
        ),
    ]);
  }

  getSchools(BuildContext context) async {
    final url =
        "${Provider.of<UrlProvider>(context, listen: false).url}/sensorData_2.json?shallow=true";

    final response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body).keys.toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  getBranches(BuildContext context, String school) async {
    final url =
        "${Provider.of<UrlProvider>(context, listen: false).url}/sensorData_2/$school.json?shallow=true";

    final response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body).keys.toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  getRooms(BuildContext context, String school, String branch) async {
    final url =
        "${Provider.of<UrlProvider>(context, listen: false).url}/sensorData_2/$school/$branch.json?shallow=true";

    final response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body).keys.toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
