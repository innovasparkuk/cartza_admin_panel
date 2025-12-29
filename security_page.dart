import 'package:flutter/material.dart';
import 'dart:math';

// Models
class Session {
  final String device;
  final String location;
  final String ip;
  final String time;
  final bool isCurrentSession;

  Session({
    required this.device,
    required this.location,
    required this.ip,
    required this.time,
    this.isCurrentSession = false,
  });
}

class LoginHistory {
  final String device;
  final String location;
  final String time;
  final bool isSuccessful;

  LoginHistory({
    required this.device,
    required this.location,
    required this.time,
    this.isSuccessful = true,
  });
}

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool _currentPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  bool _2faEnabled = true;
  bool _authenticatorApp = true;
  bool _smsAuthentication = false;

  List<Session> sessions = [
    Session(
      device: 'Chrome on Windows',
      location: 'New York, USA',
      ip: '192.168.1.1',
      time: '2 hours ago',
      isCurrentSession: true,
    ),
    Session(
      device: 'Safari on iPhone',
      location: 'New York, USA',
      ip: '192.168.1.2',
      time: '2 hours ago',
    ),
    Session(
      device: 'Firefox on MacOS',
      location: 'San Francisco, USA',
      ip: '192.168.1.3',
      time: '1 day ago',
    ),
  ];

  List<LoginHistory> loginHistory = [
    LoginHistory(
      device: 'Chrome on Windows',
      location: 'New York, USA',
      time: '2 hours ago',
      isSuccessful: true,
    ),
    LoginHistory(
      device: 'Safari on iPhone',
      location: 'New York, USA',
      time: '1 day ago',
      isSuccessful: true,
    ),
    LoginHistory(
      device: 'Unknown device',
      location: 'London, UK',
      time: '3 days ago',
      isSuccessful: false,
    ),
    LoginHistory(
      device: 'Firefox on MacOS',
      location: 'San Francisco, USA',
      time: '2 days ago',
      isSuccessful: true,
    ),
  ];

  String _passwordStrength = '';
  Color _strengthColor = Colors.grey;

  void _checkPasswordStrength(String password) {
    if (password.isEmpty) {
      setState(() {
        _passwordStrength = '';
        _strengthColor = Colors.grey;
      });
      return;
    }

    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength++;

    setState(() {
      if (strength <= 2) {
        _passwordStrength = 'Weak';
        _strengthColor = Colors.red;
      } else if (strength <= 4) {
        _passwordStrength = 'Medium';
        _strengthColor = Colors.orange;
      } else {
        _passwordStrength = 'Strong';
        _strengthColor = Colors.green;
      }
    });
  }

  String _generateStrongPassword() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*';
    final random = Random.secure();
    return List.generate(16, (index) => chars[random.nextInt(chars.length)]).join();
  }

  void _suggestStrongPassword() {
    final password = _generateStrongPassword();
    setState(() {
      _newPassword.text = password;
      _checkPasswordStrength(password);
    });
    _showNotification('Strong password suggested');
  }

  void _changePassword() {
    if (_currentPassword.text.isEmpty ||
        _newPassword.text.isEmpty ||
        _confirmPassword.text.isEmpty) {
      _showNotification('Please fill all password fields', isError: true);
      return;
    }

    if (_currentPassword.text == _newPassword.text) {
      _showNotification('New password must be different from current password', isError: true);
      return;
    }

    if (_newPassword.text != _confirmPassword.text) {
      _showNotification('New password and confirm password do not match', isError: true);
      return;
    }

    if (_passwordStrength == 'Weak') {
      _showNotification('Please use a stronger password', isError: true);
      return;
    }

    _currentPassword.clear();
    _newPassword.clear();
    _confirmPassword.clear();
    setState(() {
      _passwordStrength = '';
    });
    _showNotification('Password updated successfully');
  }

  void _terminateSession(Session session) {
    if (session.isCurrentSession) {
      _showNotification('Cannot terminate current session', isError: true);
      return;
    }

    setState(() {
      sessions.remove(session);
    });
    _showNotification('Session terminated successfully');
  }

  void _revokeAllOtherSessions() {
    _showConfirmationDialog(
      title: 'Revoke All Other Sessions',
      message: 'Are you sure you want to revoke all other sessions? You will need to log in again on those devices.',
      onConfirm: () {
        setState(() {
          sessions.removeWhere((s) => !s.isCurrentSession);
        });
        _showNotification('All other sessions revoked successfully');
      },
    );
  }

  void _deactivateAccount() {
    _showConfirmationDialog(
      title: 'Deactivate Account',
      message: 'Are you sure you want to deactivate your account? This action can be reversed within 30 days.',
      onConfirm: () {
        _showNotification('Account deactivated successfully');
      },
    );
  }

  void _deleteAccount() {
    _showConfirmationDialog(
      title: 'Delete Account',
      message: 'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
      onConfirm: () {
        _showNotification('Account deletion initiated');
      },
      isDangerous: true,
    );
  }

  void _exportAllData() {
    _showConfirmationDialog(
      title: 'Export All Data',
      message: 'Are you sure you want to export all your data? A download link will be sent to your email.',
      onConfirm: () {
        _showNotification('Data export initiated. Check your email.');
      },
    );
  }

  void _showConfirmationDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    bool isDangerous = false,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF757575),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shadowColor: Colors.red.withOpacity(0.4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('No'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shadowColor: Colors.green.withOpacity(0.4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Yes'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotification(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _generateBackupCodes() {
    _showNotification('Backup codes generated. Please save them securely.');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Change Password Section
          _buildWhiteSection(
            title: 'Change Password',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPasswordField(
                  label: 'Current Password',
                  controller: _currentPassword,
                  isVisible: _currentPasswordVisible,
                  onToggleVisibility: () {
                    setState(() => _currentPasswordVisible = !_currentPasswordVisible);
                  },
                  hintText: 'Enter current password',
                ),
                const SizedBox(height: 16),
                _buildPasswordField(
                  label: 'New Password',
                  controller: _newPassword,
                  isVisible: _newPasswordVisible,
                  onToggleVisibility: () {
                    setState(() => _newPasswordVisible = !_newPasswordVisible);
                  },
                  hintText: 'Enter new password',
                  onChanged: _checkPasswordStrength,
                ),
                if (_passwordStrength.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Password strength: ',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        _passwordStrength,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: _strengthColor,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                _buildPasswordField(
                  label: 'Confirm New Password',
                  controller: _confirmPassword,
                  isVisible: _confirmPasswordVisible,
                  onToggleVisibility: () {
                    setState(() => _confirmPasswordVisible = !_confirmPasswordVisible);
                  },
                  hintText: 'Confirm new password',
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Password Requirements:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildRequirement('Minimum 8 characters'),
                      _buildRequirement('Contains uppercase and lowercase letters'),
                      _buildRequirement('Includes at least one number'),
                      _buildRequirement('Contains at least one special character'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6F00),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Update Password'),
                    ),
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: _suggestStrongPassword,
                      child: const Text('Suggest Strong Password'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Two-Factor Authentication Section
          _buildWhiteSection(
            title: 'Two-Factor Authentication',
            child: Column(
              children: [
                _buildGreyCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '2FA is Enabled',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Your account is protected with two-factor authentication',
                              style: TextStyle(fontSize: 13, color: Color(0xFF757575)),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.check_circle, color: Colors.green, size: 32),
                    ],
                  ),
                  backgroundColor: Colors.green[50],
                ),
                _buildGreyCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Authenticator App',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Use an app to generate codes',
                              style: TextStyle(fontSize: 13, color: Color(0xFF757575)),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _authenticatorApp,
                        onChanged: (value) {
                          setState(() => _authenticatorApp = value);
                          _showNotification(
                            value
                                ? 'Authenticator app enabled'
                                : 'Authenticator app disabled',
                          );
                        },
                        activeColor: const Color(0xFF4CAF50),
                      ),
                    ],
                  ),
                ),
                _buildGreyCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'SMS Authentication',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Receive codes via text message',
                              style: TextStyle(fontSize: 13, color: Color(0xFF757575)),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _smsAuthentication,
                        onChanged: (value) {
                          setState(() => _smsAuthentication = value);
                          _showNotification(
                            value ? 'SMS authentication enabled' : 'SMS authentication disabled',
                          );
                        },
                        activeColor: const Color(0xFF4CAF50),
                      ),
                    ],
                  ),
                ),
                _buildGreyCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Backup Codes',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Generate emergency backup codes',
                            style: TextStyle(fontSize: 13, color: Color(0xFF757575)),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: _generateBackupCodes,
                        child: const Text('Generate'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Active Sessions Section
          _buildWhiteSection(
            title: 'Active Sessions',
            child: Column(
              children: [
                ...sessions.map((session) => _buildGreyCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  session.device,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (session.isCurrentSession) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'Current Session',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${session.location} • ${session.time}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF757575),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'IP: ${session.ip}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9E9E9E),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!session.isCurrentSession)
                        TextButton(
                          onPressed: () => _terminateSession(session),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text('Revoke'),
                        ),
                    ],
                  ),
                  backgroundColor: session.isCurrentSession ? Colors.green[50] : null,
                )),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _revokeAllOtherSessions,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Revoke All Other Sessions'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Login History Section
          _buildWhiteSection(
            title: 'Login History',
            child: Column(
              children: loginHistory.map((history) {
                return _buildGreyCard(
                  child: Row(
                    children: [
                      Icon(
                        history.isSuccessful ? Icons.check_circle : Icons.cancel,
                        color: history.isSuccessful ? Colors.green : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              history.isSuccessful
                                  ? 'Successful login'
                                  : 'Failed login attempt',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${history.device} • ${history.location}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF757575),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        history.time,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Danger Zone Section
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Danger Zone',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'These actions are permanent and cannot be undone.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF757575),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _deactivateAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Deactivate Account'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _deleteAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Delete Account'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _exportAllData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[600],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Export All Data'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhiteSection({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildGreyCard({required Widget child, Color? backgroundColor}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    String? hintText,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: !isVisible,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFFF6F00), width: 2),
            ),
            suffixIcon: IconButton(
              icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: onToggleVisibility,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 16, color: Color(0xFF1976D2)),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 13, color: Color(0xFF424242)),
          ),
        ],
      ),
    );
  }
}