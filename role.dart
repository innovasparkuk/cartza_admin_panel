class Role {
  int id;
  String name;
  String description;
  List<String> permissions;

  Role({
    required this.id,
    required this.name,
    required this.description,
    required this.permissions,
  });
}

class Permission {
  String id;
  String label;

  Permission({required this.id, required this.label});
}

final List<Permission> allPermissions = [
  Permission(id: 'read', label: 'Read Content'),
  Permission(id: 'write', label: 'Write Content'),
  Permission(id: 'delete', label: 'Delete Content'),
  Permission(id: 'manage_users', label: 'Manage Users'),
  Permission(id: 'manage_settings', label: 'Manage Settings'),
  Permission(id: 'view_reports', label: 'View Reports'),
  Permission(id: 'export_data', label: 'Export Data'),
  Permission(id: 'manage_billing', label: 'Manage Billing'),
];
