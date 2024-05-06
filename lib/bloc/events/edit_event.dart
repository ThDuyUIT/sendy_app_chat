import 'package:image_picker/image_picker.dart';
import 'package:sendy_app_chat/domain/models/user_model.dart';

class EditInfoEvent {
  late User user;
}

class UploadAvatar extends EditInfoEvent {
  //XFile? avatar;
  UploadAvatar({required User user}) {
    this.user = user;
    
  }
}

class Saved extends EditInfoEvent {
  Saved({required User user}) {
    this.user = user;
  }
}
