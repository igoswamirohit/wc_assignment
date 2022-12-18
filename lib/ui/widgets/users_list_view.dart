import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../data/models/user_model.dart';
import '../../utils/utils.dart';
import '../screens/user_detail_view.dart';
import 'custom_circular_image.dart';

class UsersListView extends StatelessWidget {
  const UsersListView(
      {Key? key, required this.usersStream, required this.onDismissed})
      : super(key: key);

  final Function(String userId) onDismissed;
  final Stream<QuerySnapshot<Map<String, dynamic>>> usersStream;

  Widget _buildDismissibleBackground() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.delete,
            color: Colors.white,
            size: 30,
          ),
          Text(
            'DELETE',
            style: 16.semiBoldStyle.copyWith(color: Colors.white),
          ),
          const Icon(
            Icons.delete,
            color: Colors.white,
            size: 30,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: usersStream,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.connectionState == ConnectionState.active) {
            final usersList = snapshot.data!.docs;
            return usersList.isEmpty
                ? Center(
                    child: Text(
                    'No Users Found!',
                    style: 16.semiBoldStyle,
                  ))
                : ListView.separated(
                    itemBuilder: (context, index) {
                      final user = UserModel.fromJson(
                        usersList[index].data()
                          ..addAll({'id': usersList[index].id}),
                      );
                      return Dismissible(
                        key: Key(user.id ?? ''),
                        background: _buildDismissibleBackground(),
                        onDismissed: (direction) {
                          if (direction == DismissDirection.startToEnd ||
                              direction == DismissDirection.endToStart) {
                            if (user.id != null) {
                              onDismissed(user.id!);
                            }
                          }
                        },
                        child: ListTile(
                          leading: CustomCircularImage(
                            size: const Size(50, 50),
                            name: user.name,
                            url: user.photo,
                            cacheKey: user.id ?? '',
                          ),
                          title: Text(user.name),
                          subtitle: Text(user.profession),
                          onTap: () => Navigator.pushNamed(
                              context, UserDetailView.routeName,
                              arguments: user),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const Divider(thickness: 1.5),
                    itemCount: usersList.length);
          } else {
            return const Center(
              child: SpinKitDoubleBounce(
                color: Colors.blue,
              ),
            );
          }
        });
  }
}
