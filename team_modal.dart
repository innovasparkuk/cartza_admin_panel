import 'package:flutter/material.dart';
import 'team_member.dart';

class TeamModal extends StatefulWidget {
  final TeamMember? member;
  const TeamModal({this.member, super.key});

  @override
  State<TeamModal> createState() => _TeamModalState();
}

class _TeamModalState extends State<TeamModal> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  String _selectedRole = allRoles.first;
  bool _active = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.member?.name ?? '');
    _emailController = TextEditingController(text: widget.member?.email ?? '');
    _selectedRole = widget.member?.role ?? allRoles.first;
    _active = widget.member?.active ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.member == null ? 'Add Member' : 'Edit Member'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 12),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              items: allRoles.map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
              onChanged: (val) => setState(() => _selectedRole = val!),
              decoration: const InputDecoration(labelText: 'Role'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Active'),
                Switch(value: _active, onChanged: (val) => setState(() => _active = val)),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            TeamMember newMember = TeamMember(
              id: widget.member?.id ?? DateTime.now().millisecondsSinceEpoch,
              name: _nameController.text,
              email: _emailController.text,
              role: _selectedRole,
              active: _active,
            );
            Navigator.pop(context, newMember);
          },
          child: const Text('Save'),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6F00)),
        ),
      ],
    );
  }
}
