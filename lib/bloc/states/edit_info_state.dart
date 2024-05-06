class EditInfoState {
  late bool isLoading;
  bool? isUploadAvatar;
  bool? isSaved;

  EditInfoState(
      {required this.isLoading, this.isUploadAvatar, this.isSaved});

  factory EditInfoState.initial() {
    return EditInfoState(
        isLoading: false, 
        isUploadAvatar: false, 
        isSaved: false);
  }

  factory EditInfoState.loading() {
    return EditInfoState(
        isLoading: true, 
        isUploadAvatar: false, 
        isSaved: false);
  }

  factory EditInfoState.pickAvatar() {
    return EditInfoState(
        isLoading: false, 
        isUploadAvatar: true, 
        isSaved: false);
  }

  factory EditInfoState.saved() {
    return EditInfoState(
        isLoading: false, 
        isUploadAvatar: false, 
        isSaved: true);
  }
}
