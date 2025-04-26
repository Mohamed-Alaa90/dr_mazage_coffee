// حالات Auth Cubit
abstract class AuthState {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String role;
  final List<Map<String, dynamic>>? users;

  const AuthAuthenticated(this.role, {this.users});

  @override
  List<Object> get props => [role, users ?? []];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

class UserAdded extends AuthState {
  final int userId;
  const UserAdded(this.userId);

  @override
  List<Object> get props => [userId];
}

class AdminPasswordUpdated extends AuthState {
  const AdminPasswordUpdated();

  @override
  List<Object> get props => [];
}
