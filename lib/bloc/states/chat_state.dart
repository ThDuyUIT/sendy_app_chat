class ChatState {
  bool? isLoading;
  bool? isLeaving;

  ChatState({this.isLoading, this.isLeaving});

  factory ChatState.initial() {
    return ChatState(
      isLoading: true,
      isLeaving: false,);
  }


  factory ChatState.leave() {
    return ChatState(
      isLoading: false,
      isLeaving: true,);
  }
}
