import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sendy_app_chat/bloc/events/edit_event.dart';
import 'package:sendy_app_chat/bloc/states/edit_info_state.dart';
import 'package:sendy_app_chat/controllers/authentication_controller.dart';
import 'package:sendy_app_chat/controllers/edit_info_controller.dart';
import 'package:sendy_app_chat/domain/models/user_model.dart';
import 'package:sendy_app_chat/presentations/pages/edit_info_page.dart';
import 'package:sendy_app_chat/presentations/pages/home_page.dart';

class EditInfoBloc extends Bloc<EditInfoEvent, EditInfoState> {
  final editInfoController = EditInfoController();
  EditInfoBloc() : super(EditInfoState.initial()) {
    on<UploadAvatar>((event, emit) => _uploadAvatar(event.user, emit));
    on<Saved>((event, emit) => _saved(event.user, emit));
  }

  _uploadAvatar(User user, emit) async {
    XFile? imageFile;
    imageFile = await editInfoController.pickAvatar();
    if (imageFile != null) {
      EditInfoPage.imageFile = imageFile;
      emit(EditInfoState.pickAvatar());
    }
  }

  _saved(User user, emit) async {
    emit(EditInfoState.loading());
    final resultEdit = await editInfoController.savedInfo(user);
    if (resultEdit) {
      emit(EditInfoState.saved());
      Get.offAll(HomePage(indexPage: 1));
      //Get.back();
    } else {
      emit(EditInfoState.initial());
    }
  }
}
