import 'package:flutter/material.dart';
import 'role.dart';

class RoleModal extends StatefulWidget {
  final Role? role;
  const RoleModal({this.role, super.key});

  @override
  State<RoleModal> createState() => _RoleModalState();
}

class _RoleModalState extends State<RoleModal> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  List<String> _selectedPermissions = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.role?.name ?? '');
    _descController = TextEditingController(text: widget.role?.description ?? '');
    _selectedPermissions = widget.role?.permissions.toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.role == null ? 'Add Role' : 'Edit Role'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Role Name')),
            const SizedBox(height: 12),
            TextField(controller: _descController, decoration: const InputDecoration(labelText: 'Description')),
            const SizedBox(height: 16),
            const Text('Permissions', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: allPermissions.map((perm) {
                return FilterChip(
                  label: Text(perm.label),
                  selected: _selectedPermissions.contains(perm.id),
                  onSelected: (val) {
                    setState(() {
                      if (val) _selectedPermissions.add(perm.id);
                      else _selectedPermissions.remove(perm.id);
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            Role newRole = Role(
              id: widget.role?.id ?? DateTime.now().millisecondsSinceEpoch,
              name: _nameController.text,
              description: _descController.text,
              permissions: _selectedPermissions,
            );
            Navigator.pop(context, newRole);
          },
          child: const Text('Save'),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6F00)),
        ),
      ],
    );
  }
}
