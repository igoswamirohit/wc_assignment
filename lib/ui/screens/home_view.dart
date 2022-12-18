import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wc_assignment/ui/widgets/users_list_view.dart';

import '../../data/blocs/home_bloc/home_bloc.dart';
import '../../data/blocs/user_bloc/user_bloc.dart';
import '../../data/models/user_model.dart';
import '../../utils/extensions.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_btn.dart';
import '../widgets/text_fields.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
  });

  static const routeName = '/';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late String name, email, city, profession;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late final UserBloc _userBloc;

  @override
  void initState() {
    _userBloc = context.read<UserBloc>();
    context.read<HomeBloc>().add(UserListRequested());
    super.initState();
  }

  void _fabOnClick() {
    _scaffoldKey.currentState!.showBottomSheet(
      (context) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 2,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                5.sizedBoxHeight(),
                Text(
                  'Enter User Details',
                  style: 16.semiBoldStyle,
                ),
                10.sizedBoxHeight(),
                CustomTextField(
                  hintText: 'Enter full name',
                  label: 'Name',
                  onSaved: (val) => name = val!,
                  prefix: const Icon(Icons.person),
                  validator: (val) {
                    return (val != null && val.isEmpty)
                        ? 'Name is required'
                        : null;
                  },
                ),
                10.sizedBoxHeight(),
                CustomTextField(
                  hintText: 'Enter email address',
                  label: 'Email',
                  onSaved: (val) => email = val!,
                  prefix: const Icon(Icons.email),
                  validator: (val) {
                    return (val != null && val.isEmpty)
                        ? 'Email is required'
                        : (val != null && !val.isEmail)
                            ? 'Enter a valid Email!'
                            : null;
                  },
                ),
                10.sizedBoxHeight(),
                CustomTextField(
                  hintText: 'Enter city name',
                  label: 'City',
                  onSaved: (val) => city = val!,
                  prefix: const Icon(Icons.location_on),
                  validator: (val) {
                    return (val != null && val.isEmpty)
                        ? 'City is required'
                        : null;
                  },
                ),
                10.sizedBoxHeight(),
                CustomTextField(
                  hintText: 'Enter profession',
                  label: 'Profession',
                  onSaved: (val) => profession = val!,
                  prefix: const Icon(Icons.subtitles),
                  validator: (val) {
                    return (val != null && val.isEmpty)
                        ? 'Profession is required'
                        : null;
                  },
                ),
                10.sizedBoxHeight(),
                BlocConsumer<UserBloc, UserState>(
                  listener: (context, state) {
                    if (state is UserCreationSuccess) {
                      Navigator.pop(context);
                      context.showSnackBar(
                        'User created successfully with id: ${state.response.id}',
                      );
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //     content: Text(
                      //         'User created successfully with id: ${state.response.id}')));
                    } else if (state is UserCreationFailure) {
                      context.showSnackBar(
                        state.errorMessage,
                      );
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text(state.errorMessage)));
                    }
                  },
                  builder: (context, state) {
                    if (state is UserCreationProgress) {
                      return const SpinKitThreeBounce(
                        color: Colors.blue,
                        size: 25,
                      );
                    } else {
                      return SizedBox(
                        width: double.infinity,
                        child: CustomElevatedBtn(
                          title: 'Submit',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _userBloc.add(
                                UserCreationRequested(
                                  UserModel(
                                    name: name,
                                    city: city,
                                    profession: profession,
                                    email: email,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: const CustomAppbar(title: 'Users', actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Tooltip(
            message: 'Swipe User Item Left or Right to Delete!',
            preferBelow: true,
            triggerMode: TooltipTriggerMode.tap,
            child: Icon(
              Icons.info_outline,
              color: Colors.black,
            ),
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: _fabOnClick,
        child: const Icon(
          Icons.person_add_rounded,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is UserFetchSuccess) {
              return UsersListView(
                usersStream: state.usersStream,
                onDismissed: (String userId) =>
                    _userBloc.add(UserDeletionRequested(userId)),
              );
            } else if (state is UserFetchProgress) {
              return const SpinKitCircle(
                color: Colors.blue,
              );
            } else if (state is UserFetchFailure) {
              return Center(
                child: Text(state.errorMessage),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
