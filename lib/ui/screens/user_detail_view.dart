import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wc_assignment/ui/widgets/custom_circular_image.dart';

import '../../data/blocs/user_bloc/user_bloc.dart';
import '../../data/models/user_model.dart';
import '../../utils/extensions.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_btn.dart';
import '../widgets/text_fields.dart';

class UserDetailView extends StatefulWidget {
  const UserDetailView({super.key, required this.userModel});

  static const routeName = '/detail-view';

  final UserModel userModel;

  @override
  State<UserDetailView> createState() => _UserDetailViewState();
}

class _UserDetailViewState extends State<UserDetailView> {
  String? photo;
  late String name, email, city, profession;

  final _formKey = GlobalKey<FormState>();
  final _isEditEnabled = ValueNotifier<bool>(false);
  late final UserBloc _userBloc;

  @override
  void initState() {
    super.initState();

    _userBloc = context.read<UserBloc>();

    name = widget.userModel.name;
    email = widget.userModel.email;
    city = widget.userModel.city;
    profession = widget.userModel.profession;
    photo = widget.userModel.photo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'User Details', actions: [
        IconButton(
            onPressed: () {
              _isEditEnabled.value = !_isEditEnabled.value;
              context.showSnackBar(
                  'Edit Mode ${_isEditEnabled.value ? 'Enabled' : 'Disabled'}',
                  const Duration(
                    milliseconds: 200,
                  ));
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.black,
              size: 20,
            ))
      ]),
      backgroundColor: Colors.white,
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserEditSuccess) {
            _isEditEnabled.value = false;
            context.focusScope.unfocus();
            context.showSnackBar(
              'User Updated Successfully!',
            );
          } else if (state is UserImageUploadSuccess) {
            photo = state.imageUrl;
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: ValueListenableBuilder<bool>(
                valueListenable: _isEditEnabled,
                builder: (context, val, child) {
                  return Form(
                    key: _formKey,
                    child: Column(children: [
                      Center(
                        child: Stack(
                          children: [
                            CustomCircularImage(
                              size: const Size(100, 100),
                              name: name,
                              isFileUploading: state is UserImageUploadProgress,
                              cacheKey: widget.userModel.id ?? '',
                              url: photo,
                            ),
                            if (val)
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                    child: GestureDetector(
                                      onTap: () async {
                                        final image = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.gallery);
                                        if (image != null) {
                                          _userBloc.add(
                                              UserImageUploadRequested(
                                                  widget.userModel.id ?? '',
                                                  image.path));
                                        }
                                      },
                                      child: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ))
                          ],
                        ),
                      ),
                      20.sizedBoxHeight(),
                      CustomTextField(
                        hintText: 'Enter full name',
                        label: 'Name',
                        initialValue: name,
                        onSaved: (val) => name = val!,
                        prefix: const Icon(Icons.person),
                        enabled: val,
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
                        initialValue: email,
                        onSaved: (val) => email = val!,
                        prefix: const Icon(Icons.email),
                        enabled: val,
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
                        initialValue: city,
                        onSaved: (val) => city = val!,
                        prefix: const Icon(Icons.location_on),
                        enabled: val,
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
                        initialValue: profession,
                        onSaved: (val) => profession = val!,
                        prefix: const Icon(Icons.subtitles),
                        enabled: val,
                        validator: (val) {
                          return (val != null && val.isEmpty)
                              ? 'Profession is required'
                              : null;
                        },
                      ),
                      10.sizedBoxHeight(),
                      Visibility(
                          visible: val,
                          child: (state is UserEditProgress)
                              ? const SpinKitThreeBounce(
                                  color: Colors.blue,
                                  size: 25,
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  child: CustomElevatedBtn(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                          // Image URL will be updated automatically after the image is uploaded successfully!
                                          final updatedUser =
                                              widget.userModel.copyWith(
                                            city: city,
                                            email: email,
                                            name: name,
                                            profession: profession,
                                          );
                                          _userBloc.add(UserUpdationRequested(
                                              updatedUser));
                                        }
                                      },
                                      title: 'Update')))
                    ]),
                  );
                }),
          );
        },
      ),
    );
  }
}
