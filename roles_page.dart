import 'package:flutter/material.dart';

// Permission model
class Permission {
  final String id;
  final String label;
  final String description;

  Permission({required this.id, required this.label, required this.description});
}

// All available permissions
final List<Permission> allPermissions = [
  Permission(id: 'read', label: 'Read Content', description: 'View and read content without making changes'),
  Permission(id: 'write', label: 'Write Content', description: 'Create and edit content'),
  Permission(id: 'delete', label: 'Delete Content', description: 'Remove content permanently'),
  Permission(id: 'manage_users', label: 'Manage Users', description: 'Add, edit, and remove users'),
  Permission(id: 'manage_settings', label: 'Manage Settings', description: 'Configure system settings'),
  Permission(id: 'view_reports', label: 'View Reports', description: 'Access analytics and reports'),
  Permission(id: 'export_data', label: 'Export Data', description: 'Export data to external formats'),
  Permission(id: 'manage_billing', label: 'Manage Billing', description: 'Handle billing and payments'),
];

// Role model
class Role {
  final int id;
  final String name;
  final String description;
  final List<String> permissions;

  Role({
    required this.id,
    required this.name,
    required this.description,
    required this.permissions,
  });
}

class RolesPage extends StatefulWidget {
  const RolesPage({super.key});

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  List<Role> roles = [
    Role(
      id: 1,
      name: 'Admin',
      description: 'Full system access',
      permissions: ['read', 'write', 'delete', 'manage_users', 'manage_settings', 'view_reports', 'export_data', 'manage_billing'],
    ),
    Role(
      id: 2,
      name: 'Manager',
      description: 'Team and content management',
      permissions: ['read', 'write', 'manage_users', 'view_reports', 'export_data'],
    ),
    Role(
      id: 3,
      name: 'Editor',
      description: 'Content editing access',
      permissions: ['read', 'write', 'view_reports'],
    ),
    Role(
      id: 4,
      name: 'Viewer',
      description: 'Read-only access',
      permissions: ['read'],
    ),
  ];

  int _nextId = 5;

  void _showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF4CAF50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _addRole() async {
    Role? newRole = await showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => _RoleDialog(),
    );

    if (newRole != null) {
      setState(() {
        roles.add(Role(
          id: _nextId++,
          name: newRole.name,
          description: newRole.description,
          permissions: newRole.permissions,
        ));
      });
      _showNotification('Role "${newRole.name}" created successfully!');
    }
  }

  void _editRole(Role role) async {
    Role? updatedRole = await showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => _RoleDialog(role: role),
    );

    if (updatedRole != null) {
      setState(() {
        int index = roles.indexWhere((r) => r.id == role.id);
        if (index != -1) {
          roles[index] = Role(
            id: role.id,
            name: updatedRole.name,
            description: updatedRole.description,
            permissions: updatedRole.permissions,
          );
        }
      });
      _showNotification('Role "${updatedRole.name}" updated successfully!');
    }
  }

  void _deleteRole(Role role) {
    setState(() => roles.remove(role));
    _showNotification('Role "${role.name}" deleted successfully!');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User Roles Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'User Roles',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1a1a1a),
              ),
            ),
            ElevatedButton(
              onPressed: _addRole,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Add Role',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Role Cards
        ...roles.map((role) => _buildRoleCard(role)),

        const SizedBox(height: 32),

        // Permission Reference Section
        const Text(
          'Permission Reference',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1a1a1a),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Understanding permission levels',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 16),

        // Permission Reference Cards
        ...allPermissions.map((perm) => _buildPermissionReference(perm)),
      ],
    );
  }

  Widget _buildRoleCard(Role role) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Color(0xFF1a1a1a),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        role.description,
                        style: const TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Permissions (${role.permissions.length}):',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1a1a1a),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => _editRole(role),
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        color: Color(0xFF1a1a1a),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allPermissions.map((perm) {
                bool isActive = role.permissions.contains(perm.id);
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFFFF6B35) : const Color(0xFFDDDDDD),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isActive ? Icons.check_box : Icons.check_box_outline_blank,
                        size: 14,
                        color: isActive ? Colors.white : const Color(0xFF999999),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        perm.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isActive ? Colors.white : const Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionReference(Permission perm) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: const Border(
          left: BorderSide(color: Color(0xFFFF6B35), width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            perm.label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1a1a1a),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            perm.description,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }
}

// Role Dialog for Add/Edit
class _RoleDialog extends StatefulWidget {
  final Role? role;

  const _RoleDialog({this.role});

  @override
  State<_RoleDialog> createState() => _RoleDialogState();
}

class _RoleDialogState extends State<_RoleDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late List<String> _selectedPermissions;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.role?.name ?? '');
    _descController = TextEditingController(text: widget.role?.description ?? '');
    _selectedPermissions = List.from(widget.role?.permissions ?? []);
  }

  void _togglePermission(String permId) {
    setState(() {
      if (_selectedPermissions.contains(permId)) {
        _selectedPermissions.remove(permId);
      } else {
        _selectedPermissions.add(permId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.role != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Container(
          width: 480,
          constraints: const BoxConstraints(maxWidth: 480),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEdit ? 'Edit Role' : 'Add New Role',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1a1a1a),
                ),
              ),
              const SizedBox(height: 20),

              // Role Name
              const Text(
                'Role Name',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1a1a1a),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'e.g., Content Manager',
                  hintStyle: const TextStyle(color: Color(0xFF999999), fontSize: 13),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 16),

              // Description
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1a1a1a),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descController,
                decoration: InputDecoration(
                  hintText: 'Brief description',
                  hintStyle: const TextStyle(color: Color(0xFF999999), fontSize: 13),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 16),

              // Permissions
              const Text(
                'Permissions',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1a1a1a),
                ),
              ),
              const SizedBox(height: 12),

              // Permission Grid
              Container(
                constraints: const BoxConstraints(maxHeight: 240),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int i = 0; i < allPermissions.length; i += 2)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildPermissionBox(allPermissions[i]),
                              ),
                              const SizedBox(width: 10),
                              if (i + 1 < allPermissions.length)
                                Expanded(
                                  child: _buildPermissionBox(allPermissions[i + 1]),
                                ),
                              if (i + 1 >= allPermissions.length)
                                const Expanded(child: SizedBox()),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (_nameController.text.isEmpty) return;

                      Navigator.pop(
                        context,
                        Role(
                          id: widget.role?.id ?? 0,
                          name: _nameController.text,
                          description: _descController.text,
                          permissions: _selectedPermissions,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B35),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      isEdit ? 'Save Changes' : 'Create Role',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionBox(Permission perm) {
    final isSelected = _selectedPermissions.contains(perm.id);
    return InkWell(
      onTap: () => _togglePermission(perm.id),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFFDDDDDD),
            width: 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: const Color(0xFFFF6B35).withOpacity(0.25),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ] : [],
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              size: 18,
              color: isSelected ? Colors.white : const Color(0xFF999999),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                perm.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF1a1a1a),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }
}