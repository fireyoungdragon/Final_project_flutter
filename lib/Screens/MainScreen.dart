import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:itog_app/utils/DrawerSettings.dart';
import 'package:shared_preferences/shared_preferences.dart';

String globalUser = 'notAUser';

Future<List<User>> fetchUsers() async {
  final resp =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
  List<User> listUser = [];
  if (resp.statusCode == 200) {
    final List usList = jsonDecode(resp.body);
    for (var element in usList) {
      listUser.add(User.fromJson(element));
    }
    return listUser;
  } else {
    throw Exception('some error');
  }
}

Future<List<ToDo>> fetchToDo(int idUser) async {
  final resp = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/todos?userId=$idUser'));
  List<ToDo> listToDo = [];
  if (resp.statusCode == 200) {
    final List todoList = jsonDecode(resp.body);
    for (var el in todoList) {
      listToDo.add(ToDo.fromJson(el));
    }
    return listToDo;
  } else {
    throw Exception('error');
  }
}

class ToDo {
  int userId = 0;
  int id = 0;
  String title = '';
  bool completed = false;

  ToDo({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory ToDo.fromJson(Map<String, dynamic> json) {
    return ToDo(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}

class User {
  int id = 0;
  String name = '';
  String username = '';
  String email = '';

  String phone = '';
  String website = '';
  Address address;
  Company company;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.address,
    required this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
      address: Address(
        street: json['address']['street'],
        suite: json['address']['suite'],
        city: json['address']['city'],
        postcode: json['address']['zipcode'],
        geo: GeoLocation(
            lat: json['address']['geo']['lat'],
            lng: json['address']['geo']['lng']),
      ),
      company: Company(
        name: json['company']['name'],
        catchPhrase: json['company']['catchPhrase'],
        bs: json['company']['bs'],
      ),
    );
  }
}

class Address {
  String street = '';
  String suite = '';
  String city = '';
  String postcode = '';
  GeoLocation geo;

  Address(
      {required this.street,
      required this.suite,
      required this.city,
      required this.postcode,
      required this.geo});
}

class GeoLocation {
  String lat = '';
  String lng = '';

  GeoLocation({
    required this.lat,
    required this.lng,
  });
}

class Company {
  String name = '';
  String catchPhrase = '';
  String bs = '';

  Company({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });
}

String toDoes(List lsTD) {
  String returned = '';
  for (var el in lsTD) {
    returned += '- ${el.title}.\n';
  }
  return returned;
}

class ClickableListesUsers extends StatefulWidget {
  const ClickableListesUsers({Key? key, required this.curList})
      : super(key: key);
  final List<User> curList;

  @override
  _ClickableListesUsersState createState() => _ClickableListesUsersState();
}

class _ClickableListesUsersState extends State<ClickableListesUsers> {
  late Future<List<ToDo>> futureListToDo;

  int selectedID = 0;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.curList.length,
        itemBuilder: (BuildContext context, int i) {
          return Container(
            margin: const EdgeInsets.all(1),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.green),
            child: ListTile(
              title: Text(
                'ID: ${widget.curList[i].id}\n'
                'Name: ${widget.curList[i].name}\n'
                'E-mail: ${widget.curList[i].email}',
              ),
              selected: i == selectedID,
              selectedColor: Colors.black,
              textColor: Colors.black,
              onTap: () {
                setState(() {
                  selectedID = i;
                  futureListToDo = fetchToDo(widget.curList[i].id);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text(
                              widget.curList[i].name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal),
                            ),
                            content: SingleChildScrollView(
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      alignment: Alignment.centerLeft,
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 5),
                                              child: const Text(
                                                'Main',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )),
                                          RichText(
                                              text: TextSpan(
                                                  text: 'ID: ',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                  children: <TextSpan>[
                                                TextSpan(
                                                    text: widget.curList[i].id
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal))
                                              ])),
                                          RichText(
                                              text: TextSpan(
                                                  text: 'User name: ',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                  children: <TextSpan>[
                                                TextSpan(
                                                    text: widget
                                                        .curList[i].username,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal))
                                              ])),
                                          RichText(
                                              text: TextSpan(
                                                  text: 'Email: ',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                  children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        widget.curList[i].email,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal))
                                              ])),
                                          RichText(
                                              text: TextSpan(
                                                  text: 'Phone: ',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                  children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        widget.curList[i].phone,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal))
                                              ])),
                                          RichText(
                                              text: TextSpan(
                                                  text: 'Website: ',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                  children: <TextSpan>[
                                                TextSpan(
                                                    text: widget
                                                        .curList[i].website,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal))
                                              ])),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      alignment: Alignment.centerLeft,
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 5),
                                              child: const Text(
                                                'Adress',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          RichText(
                                              text: TextSpan(
                                                  text: 'Street: ',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                  children: <TextSpan>[
                                                TextSpan(
                                                    text: widget.curList[i]
                                                        .address.street,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal))
                                              ])),
                                          RichText(
                                              text: TextSpan(
                                                  text: 'Building: ',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                  children: <TextSpan>[
                                                TextSpan(
                                                    text: widget.curList[i]
                                                        .address.suite,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal))
                                              ])),
                                          RichText(
                                              text: TextSpan(
                                                  text: 'City: ',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                  children: <TextSpan>[
                                                TextSpan(
                                                    text: widget.curList[i]
                                                        .address.city,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal))
                                              ])),
                                          RichText(
                                              text: TextSpan(
                                                  text: 'Post code: ',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                  children: <TextSpan>[
                                                TextSpan(
                                                    text: widget.curList[i]
                                                        .address.postcode,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal))
                                              ])),
                                          RichText(
                                              text: TextSpan(
                                                  text: 'Geo-location: ',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                  children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        'lat: ${widget.curList[i].address.geo.lat}, lng: ${widget.curList[i].address.geo.lng}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 12))
                                              ])),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      alignment: Alignment.centerLeft,
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 5),
                                              child: const Text(
                                                'Company',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )),
                                          RichText(
                                              text: TextSpan(
                                                  text: 'Name: ',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                  children: <TextSpan>[
                                                TextSpan(
                                                    text: widget.curList[i]
                                                        .company.name,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal))
                                              ])),
                                          RichText(
                                              text: TextSpan(
                                                  text: 'Phrase: ',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                  children: <TextSpan>[
                                                TextSpan(
                                                    text: widget.curList[i]
                                                        .company.catchPhrase,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal))
                                              ])),
                                          RichText(
                                              text: TextSpan(
                                                  text: 'BS: ',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                  children: <TextSpan>[
                                                TextSpan(
                                                    text: widget
                                                        .curList[i].company.bs,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal))
                                              ])),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 5),
                                            child: const Text(
                                              'ToDo thing',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )),
                                        FutureBuilder<List<ToDo>>(
                                          future: futureListToDo,
                                          builder: (context, ss) {
                                            if (ss.hasData) {
                                              return ListToDoList(
                                                curToDo: ss.data!,
                                              );
                                            } else if (ss.hasError) {
                                              return Text('Error: ${ss.error}');
                                            }
                                            return const CircularProgressIndicator();
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text(
                                  'Close',
                                  style: TextStyle(color: Colors.black),
                                ),
                              )
                            ],
                          ));
                });
              },
            ),
          );
        });
  }
}

class ListToDoList extends StatefulWidget {
  const ListToDoList({Key? key, required this.curToDo}) : super(key: key);

  final List<ToDo> curToDo;

  @override
  _ListToDoListState createState() => _ListToDoListState();
}

class _ListToDoListState extends State<ListToDoList> {
  late Future<List<ToDo>> futureListToDo;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(1),
          border: Border.all(width: 1, color: Colors.green)),
      width: 180,
      height: 300,
      child: ListView.builder(
          itemCount: widget.curToDo.length,
          itemBuilder: (BuildContext context, int i) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(20)),
              margin: const EdgeInsets.all(3),
              child: ListTile(
                leading: Checkbox(
                  value: widget.curToDo[i].completed,
                  checkColor: Colors.white,
                  activeColor: Colors.green,
                  onChanged: (_) {},
                ),
                title: Text(
                  widget.curToDo[i].title,
                  style: const TextStyle(
                      fontSize: 10, fontStyle: FontStyle.normal),
                ),
                textColor: Colors.black,
              ),
            );
          }),
    );
  }
}

void readUserPhone() async {
  final pr = await SharedPreferences.getInstance();
  globalUser = pr.getString('userPhone') ?? 'smth went wrong';
}

//главный экран
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future<List<User>> futureListUsers;

  @override
  void initState() {
    super.initState();
    futureListUsers = fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: drawerSettings(context),
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text('Main page'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Your account: '),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Text(
                              globalUser,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      )),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                    height: 600,
                    child: FutureBuilder<List<User>>(
                      future: futureListUsers,
                      builder: (context, ss) {
                        if (ss.hasData) {
                          return ClickableListesUsers(
                            curList: ss.data!,
                          );
                        } else if (ss.hasError) {
                          return Text('error : ${ss.error}');
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
