import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_signin/Backend/firebase/OnlineDatabaseManagement/cloud_data_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_signin/Global_Uses/enum_generation.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Map<String, dynamic>> _availableUsers = [];
  List<Map<String, dynamic>> _sortedAvailableUsers = [];
  List<dynamic> _myConnectionRequestCollection = [];

  bool _isLoading = false;

  final CloudStoreDataManagement _cloudStoreDataManagement =
      CloudStoreDataManagement();

  Future<void> _initialDataFetchAndCheckUp() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    final List<Map<String, dynamic>> takeUsers =
        await _cloudStoreDataManagement.getAllUsersListExceptMyAccount(
            currentUserEmail:
                FirebaseAuth.instance.currentUser!.email.toString());

    final List<Map<String, dynamic>> takeUsersAfterSorted = [];

    if (mounted) {
      setState(() {
        for (var element in takeUsers) {
          if (mounted) {
            setState(() {
              takeUsersAfterSorted.add(element);
            });
          }
        }
      });
    }

    final List<dynamic> _connectionRequestList =
        await _cloudStoreDataManagement.currentUserConnectionRequestList(
            email: FirebaseAuth.instance.currentUser!.email.toString());

    if (mounted) {
      setState(() {
        _availableUsers = takeUsers;
        _sortedAvailableUsers = takeUsersAfterSorted;
        _myConnectionRequestCollection = _connectionRequestList;
      });
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _initialDataFetchAndCheckUp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(34, 48, 60, 1),
        body: LoadingOverlay(
          isLoading: _isLoading,
          color: Colors.black54,
          child: Container(
            margin: const EdgeInsets.all(12.0),
            width: double.maxFinite,
            height: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                const Center(
                  child: Text(
                    'Available Connections',
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: TextField(
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Search User Name',
                      hintStyle: TextStyle(color: Colors.white70),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 2.0, color: Colors.lightBlue)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 2.0, color: Colors.lightBlue)),
                    ),
                    onChanged: (writeText) {
                      if (mounted) {
                        setState(() {
                          _isLoading = true;
                        });
                      }

                      if (mounted) {
                        setState(() {
                          _sortedAvailableUsers.clear();

                          log('Available Users: $_availableUsers');

                          for (var userNameMap in _availableUsers) {
                            if (userNameMap.values.first
                                .toString()
                                .toLowerCase()
                                .startsWith(writeText.toLowerCase())) {
                              _sortedAvailableUsers.add(userNameMap);
                            }
                          }
                        });
                      }

                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  height: MediaQuery.of(context).size.height - 50,
                  width: double.maxFinite,
                  //color: Colors.red,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _sortedAvailableUsers.length,
                    itemBuilder: (connectionContext, index) {
                      return connectionShowUp(index);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget connectionShowUp(int index) {
    return Container(
      height: 80.0,
      width: double.maxFinite,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                _sortedAvailableUsers[index]
                    .values
                    .first
                    .toString()
                    .split('[user-name-about-divider]')[0],
                style: const TextStyle(color: Colors.orange, fontSize: 20.0),
              ),
              Text(
                _sortedAvailableUsers[index]
                    .values
                    .first
                    .toString()
                    .split('[user-name-about-divider]')[1],
                style: const TextStyle(color: Colors.lightBlue, fontSize: 16.0),
              ),
            ],
          ),
          TextButton(
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
                side: BorderSide(
                    color: _getRelevantButtonConfig(
                        connectionStateType:
                            ConnectionStateType.ButtonBorderColor,
                        index: index)),
              )),
              child: _getRelevantButtonConfig(
                  connectionStateType: ConnectionStateType.ButtonNameWidget,
                  index: index),
              onPressed: () async {
                final String buttonName = _getRelevantButtonConfig(
                    connectionStateType: ConnectionStateType.ButtonOnlyName,
                    index: index);

                if (mounted) {
                  setState(() {
                    _isLoading = true;
                  });
                }

                if (buttonName == ConnectionStateName.Connect.toString()) {
                  if (mounted) {
                    setState(() {
                      _myConnectionRequestCollection.add({
                        _sortedAvailableUsers[index].keys.first.toString():
                            OtherConnectionStatus.Request_Pending.toString(),
                      });
                    });
                  }

                  await _cloudStoreDataManagement.changeConnectionStatus(
                      oppositeUserMail:
                          _sortedAvailableUsers[index].keys.first.toString(),
                      currentUserMail:
                          FirebaseAuth.instance.currentUser!.email.toString(),
                      connectionUpdatedStatus:
                          OtherConnectionStatus.Invitation_Came.toString(),
                      currentUserUpdatedConnectionRequest:
                          _myConnectionRequestCollection);
                } else if (buttonName ==
                    ConnectionStateName.Accept.toString()) {
                  if (mounted) {
                    setState(() {
                      for (var element in _myConnectionRequestCollection) {
                        if (element.keys.first.toString() ==
                            _sortedAvailableUsers[index]
                                .keys
                                .first
                                .toString()) {
                          _myConnectionRequestCollection[
                              _myConnectionRequestCollection
                                  .indexOf(element)] = {
                            _sortedAvailableUsers[index].keys.first.toString():
                                OtherConnectionStatus.Invitation_Accepted
                                    .toString(),
                          };
                        }
                      }
                    });
                  }

                  await _cloudStoreDataManagement.changeConnectionStatus(
                      storeDataAlsoInConnections: true,
                      oppositeUserMail:
                          _sortedAvailableUsers[index].keys.first.toString(),
                      currentUserMail:
                          FirebaseAuth.instance.currentUser!.email.toString(),
                      connectionUpdatedStatus:
                          OtherConnectionStatus.Request_Accepted.toString(),
                      currentUserUpdatedConnectionRequest:
                          _myConnectionRequestCollection);
                }

                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              }),
        ],
      ),
    );
  }

  dynamic _getRelevantButtonConfig(
      {required ConnectionStateType connectionStateType, required int index}) {
    bool _isUserPresent = false;
    String _storeStatus = '';

    for (var element in _myConnectionRequestCollection) {
      if (element.keys.first.toString() ==
          _sortedAvailableUsers[index].keys.first.toString()) {
        _isUserPresent = true;
        _storeStatus = element.values.first.toString();
      }
    }

    if (_isUserPresent) {
      log('User Present in Connection List');

      if (_storeStatus == OtherConnectionStatus.Request_Pending.toString() ||
          _storeStatus == OtherConnectionStatus.Invitation_Came.toString()) {
        if (connectionStateType == ConnectionStateType.ButtonNameWidget) {
          return Text(
            _storeStatus == OtherConnectionStatus.Request_Pending.toString()
                ? ConnectionStateName.Pending.toString()
                    .split(".")[1]
                    .toString()
                : ConnectionStateName.Accept.toString()
                    .split(".")[1]
                    .toString(),
            style: const TextStyle(color: Colors.yellow),
          );
        } else if (connectionStateType == ConnectionStateType.ButtonOnlyName) {
          return _storeStatus ==
                  OtherConnectionStatus.Request_Pending.toString()
              ? ConnectionStateName.Pending.toString()
              : ConnectionStateName.Accept.toString();
        }

        return Colors.yellow;
      } else {
        if (connectionStateType == ConnectionStateType.ButtonNameWidget) {
          return Text(
            ConnectionStateName.Connected.toString().split(".")[1].toString(),
            style: const TextStyle(color: Colors.green),
          );
        } else if (connectionStateType == ConnectionStateType.ButtonOnlyName) {
          return ConnectionStateName.Connected.toString();
        }

        return Colors.green;
      }
    } else {
      log('User Not Present in Connection List');

      if (connectionStateType == ConnectionStateType.ButtonNameWidget) {
        return Text(
          ConnectionStateName.Connect.toString().split(".")[1].toString(),
          style: const TextStyle(color: Colors.lightBlue),
        );
      } else if (connectionStateType == ConnectionStateType.ButtonOnlyName) {
        return ConnectionStateName.Connect.toString();
      }

      return Colors.lightBlue;
    }
  }
}
