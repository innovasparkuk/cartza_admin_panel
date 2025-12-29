class TeamMember {
  int id;
  String name;
  String email;
  String role;
  bool active;

  TeamMember({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.active = true,
  });
}

final List<String> allRoles = [
  'Admin',
  'Editor',
  'Viewer',
];
