import 'package:flutter/material.dart';

// Team Member Model
class TeamMember {
  final int id;
  final String name;
  final String email;
  final String role;
  final String status;
  final String joinDate;

  TeamMember({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.joinDate,
  });
}

final List<String> allRoles = ['Admin', 'Manager', 'Editor', 'Viewer'];
final List<String> allStatuses = ['Active', 'Inactive', 'Pending'];

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  List<TeamMember> members = [
    TeamMember(id: 1, name: 'David Brown', email: 'david@company.com', role: 'Manager', status: 'Active', joinDate: 'Joined Apr 5, 2023'),
    TeamMember(id: 2, name: 'Emma Williams', email: 'emma@company.com', role: 'Viewer', status: 'Inactive', joinDate: 'Joined Mar 10, 2023'),
    TeamMember(id: 3, name: 'Lisa Anderson', email: 'lisa@company.com', role: 'Admin', status: 'Pending', joinDate: 'Joined May 12, 2023'),
    TeamMember(id: 4, name: 'Michael Chen', email: 'michael@company.com', role: 'Editor', status: 'Active', joinDate: 'Joined Feb 20, 2023'),
    TeamMember(id: 5, name: 'Sarah Johnson', email: 'sarah@company.com', role: 'Admin', status: 'Active', joinDate: 'Joined Jan 15, 2023'),
  ];

  int _nextId = 6;
  String _sortBy = 'Name';
  String _filterBy = 'All Members';
  bool _sortAscending = true;

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

  List<TeamMember> get filteredAndSortedMembers {
    List<TeamMember> filtered = members;

    // Apply filter
    if (_filterBy == 'Active Only') {
      filtered = filtered.where((m) => m.status == 'Active').toList();
    } else if (_filterBy == 'Inactive Only') {
      filtered = filtered.where((m) => m.status == 'Inactive').toList();
    } else if (_filterBy == 'Pending Only') {
      filtered = filtered.where((m) => m.status == 'Pending').toList();
    }

    // Apply sort
    filtered.sort((a, b) {
      int comparison = 0;
      switch (_sortBy) {
        case 'Name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'Role':
          comparison = a.role.compareTo(b.role);
          break;
        case 'Status':
          comparison = a.status.compareTo(b.status);
          break;
        case 'Join Date':
          comparison = a.joinDate.compareTo(b.joinDate);
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });

    return filtered;
  }

  int get activeCount => members.where((m) => m.status == 'Active').length;
  int get pendingCount => members.where((m) => m.status == 'Pending').length;
  int get inactiveCount => members.where((m) => m.status == 'Inactive').length;

  void _addMember() async {
    TeamMember? newMember = await showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => _TeamMemberDialog(),
    );

    if (newMember != null) {
      setState(() {
        members.add(TeamMember(
          id: _nextId++,
          name: newMember.name,
          email: newMember.email,
          role: newMember.role,
          status: newMember.status,
          joinDate: 'Joined ${_formatDate(DateTime.now())}',
        ));
      });
      _showNotification('Member "${newMember.name}" added successfully!');
    }
  }

  void _editMember(TeamMember member) async {
    TeamMember? updatedMember = await showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => _TeamMemberDialog(member: member),
    );

    if (updatedMember != null) {
      setState(() {
        int index = members.indexWhere((m) => m.id == member.id);
        if (index != -1) {
          members[index] = TeamMember(
            id: member.id,
            name: updatedMember.name,
            email: updatedMember.email,
            role: updatedMember.role,
            status: updatedMember.status,
            joinDate: member.joinDate,
          );
        }
      });
      _showNotification('Member "${updatedMember.name}" updated successfully!');
    }
  }

  void _deleteMember(TeamMember member) {
    setState(() => members.remove(member));
    _showNotification('Member "${member.name}" deleted successfully!');
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final filteredMembers = filteredAndSortedMembers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Team Members Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Team Members',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1a1a1a),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${filteredMembers.length} members found',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                // Sort By Button
                PopupMenuButton<String>(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFDDDDDD)),
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white,
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.sort, size: 16, color: Color(0xFF666666)),
                        SizedBox(width: 6),
                        Text(
                          'Sort By',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onSelected: (value) {
                    setState(() {
                      if (_sortBy == value) {
                        _sortAscending = !_sortAscending;
                      } else {
                        _sortBy = value;
                        _sortAscending = true;
                      }
                    });
                  },
                  itemBuilder: (context) => [
                    _buildPopupMenuItem('Name'),
                    _buildPopupMenuItem('Role'),
                    _buildPopupMenuItem('Status'),
                    _buildPopupMenuItem('Join Date'),
                  ],
                ),
                const SizedBox(width: 12),
                // Filter Button
                PopupMenuButton<String>(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFDDDDDD)),
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white,
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.filter_list, size: 16, color: Color(0xFF666666)),
                        SizedBox(width: 6),
                        Text(
                          'Filter',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onSelected: (value) {
                    setState(() => _filterBy = value);
                  },
                  itemBuilder: (context) => [
                    _buildPopupMenuItem('All Members'),
                    _buildPopupMenuItem('Active Only'),
                    _buildPopupMenuItem('Inactive Only'),
                    _buildPopupMenuItem('Pending Only'),
                  ],
                ),
                const SizedBox(width: 12),
                // Add Member Button
                ElevatedButton(
                  onPressed: _addMember,
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
                    'Add Member',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Team Member Cards
        ...filteredMembers.map((member) => _buildMemberCard(member)),

        const SizedBox(height: 32),

        // Team Statistics
        const Text(
          'Team Statistics',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1a1a1a),
          ),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(child: _buildStatCard('$activeCount', 'Active Members', const Color(0xFFD4EDDA))),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard('$pendingCount', 'Pending Invites', const Color(0xFFFFF3CD))),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard('$inactiveCount', 'Inactive', const Color(0xFFF8D7DA))),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard('${members.length}', 'Total Members', const Color(0xFFD1ECF1))),
          ],
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(String value) {
    return PopupMenuItem<String>(
      value: value,
      child: Text(
        value,
        style: const TextStyle(fontSize: 13),
      ),
    );
  }

  Widget _buildMemberCard(TeamMember member) {
    Color statusColor;
    switch (member.status) {
      case 'Active':
        statusColor = const Color(0xFF28A745);
        break;
      case 'Pending':
        statusColor = const Color(0xFFFFC107);
        break;
      case 'Inactive':
        statusColor = const Color(0xFFDC3545);
        break;
      default:
        statusColor = const Color(0xFF666666);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35),
              borderRadius: BorderRadius.circular(24),
            ),
            alignment: Alignment.center,
            child: Text(
              member.name.substring(0, 2).toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Name & Email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1a1a1a),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  member.email,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Text(
              member.status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Role
          SizedBox(
            width: 80,
            child: Text(
              member.role,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1a1a1a),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Join Date
          SizedBox(
            width: 120,
            child: Text(
              member.joinDate,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF666666),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Edit Button
          InkWell(
            onTap: () => _editMember(member),
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
          // Remove Button
          InkWell(
            onTap: () => _deleteMember(member),
            borderRadius: BorderRadius.circular(4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: const Text(
                'Remove',
                style: TextStyle(
                  color: Color(0xFFDC3545),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: bgColor.computeLuminance() > 0.5 ? const Color(0xFF1a1a1a) : Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: bgColor.computeLuminance() > 0.5 ? const Color(0xFF666666) : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// Team Member Dialog
class _TeamMemberDialog extends StatefulWidget {
  final TeamMember? member;

  const _TeamMemberDialog({this.member});

  @override
  State<_TeamMemberDialog> createState() => _TeamMemberDialogState();
}

class _TeamMemberDialogState extends State<_TeamMemberDialog> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late String _selectedRole;
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.member?.name ?? '');
    _emailController = TextEditingController(text: widget.member?.email ?? '');
    _selectedRole = widget.member?.role ?? 'Admin';
    _selectedStatus = widget.member?.status ?? 'Active';
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.member != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      child: Container(
        width: 480,
        constraints: const BoxConstraints(maxWidth: 480),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEdit ? 'Edit Team Member' : 'Add Team Member',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1a1a1a),
              ),
            ),
            const SizedBox(height: 20),

            // Full Name
            const Text(
              'Full Name',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'John Doe',
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

            // Email Address
            const Text(
              'Email Address',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'john@company.com',
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

            // Role
            const Text(
              'Role',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: InputDecoration(
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
              items: allRoles.map((role) {
                return DropdownMenuItem(value: role, child: Text(role, style: const TextStyle(fontSize: 13)));
              }).toList(),
              onChanged: (value) => setState(() => _selectedRole = value!),
            ),
            const SizedBox(height: 16),

            // Status
            const Text(
              'Status',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(
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
              items: allStatuses.map((status) {
                return DropdownMenuItem(value: status, child: Text(status, style: const TextStyle(fontSize: 13)));
              }).toList(),
              onChanged: (value) => setState(() => _selectedStatus = value!),
            ),
            const SizedBox(height: 24),

            // Buttons
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
                    style: TextStyle(color: Color(0xFF666666), fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isEmpty || _emailController.text.isEmpty) return;

                    Navigator.pop(
                      context,
                      TeamMember(
                        id: widget.member?.id ?? 0,
                        name: _nameController.text,
                        email: _emailController.text,
                        role: _selectedRole,
                        status: _selectedStatus,
                        joinDate: widget.member?.joinDate ?? '',
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: Text(
                    isEdit ? 'Save Changes' : 'Add Member',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}