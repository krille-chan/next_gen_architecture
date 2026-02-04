import 'package:next_gen_architecture/services/user_management/models/user.dart';

/// Represents the state of the home page.
///
/// This state contains information about the loaded users, the loading status,
/// and any errors that may have occurred during data fetching.
class HomeState {
  /// The list of users to display on the home page.
  ///
  /// This is `null` when users haven't been loaded yet, and contains a list
  /// of [User] objects once they have been successfully fetched from the API
  /// or local database.
  List<User>? users;

  /// Indicates whether the users are currently being loaded.
  ///
  /// This is `true` while fetching data from the API or database, and `false`
  /// otherwise.
  bool isLoading = false;

  /// Contains an error message if an error occurred during user loading.
  ///
  /// This is `null` when no error has occurred, and contains a descriptive
  /// error message string if something went wrong during the fetch operation.
  String? error;
}
