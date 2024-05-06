class AuthenticationState {
  late bool isLoading;
  late bool? isSuccessSignUp;
  late bool? isLogin;
  late bool isLogout;
  bool? usedEmail;
  bool? notFound;

  AuthenticationState(
      {this.usedEmail = false,
      
      this.notFound,
      required this.isLoading,
      this.isSuccessSignUp,
      this.isLogin,
      required this.isLogout});

  factory AuthenticationState.initial() {
    return AuthenticationState(
      
      isLoading: false,
      isSuccessSignUp: false,
      isLogin: false,
      isLogout: false,
    );
  }

  factory AuthenticationState.loading() {
    return AuthenticationState(
        isLoading: true,
        isSuccessSignUp: false,
        isLogin: false,
        isLogout: false);
  }

  factory AuthenticationState.successSignUp() {
    return AuthenticationState(
        isLoading: false,
        isSuccessSignUp: true,
        //isLogin: false,
        isLogout: false);
  }

  factory AuthenticationState.usedEmail() {
    return AuthenticationState(
        isLoading: false,
        isSuccessSignUp: false,
        isLogin: false,
        isLogout: false,
        usedEmail: true);
  }

  factory AuthenticationState.login() {
    return AuthenticationState(
        isLoading: false,
        isSuccessSignUp: false,
        isLogin: true,
        isLogout: false);
  }

  factory AuthenticationState.logout() {
    return AuthenticationState(
        isLoading: false,
        isSuccessSignUp: false,
        isLogin: false,
        isLogout: true);
  }

  // factory AuthenticationState.emptyName() {
  //   return AuthenticationState(
  //       isLoading: false,
  //       isSuccessSignUp: false,
  //       isLogin: false,
  //       isLogout: false,
  //       emptyName: true);
  // }

  // ***search user function***
  factory AuthenticationState.searching() {
    return AuthenticationState(
        //notFound: false,
        isLoading: true,
        isSuccessSignUp: false,
        isLogin: true,
        isLogout: false);
  }

  factory AuthenticationState.notFound() {
    return AuthenticationState(
        isLoading: false,
        isSuccessSignUp: false,
        isLogin: true,
        isLogout: false,
        notFound: true);
  }

  factory AuthenticationState.Found() {
    return AuthenticationState(
        isLoading: false,
        isSuccessSignUp: false,
        isLogin: true,
        isLogout: false,
        notFound: false);
  }
}
