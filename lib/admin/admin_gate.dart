import 'package:flutter/material.dart';
import 'package:loanofficer/admin/admin_home_screen.dart';
import 'package:loanofficer/admin/admin_login_screen.dart';
import 'package:loanofficer/core/api/admin_api.dart';
import 'package:loanofficer/core/theme/app_colors.dart';

class AdminGate extends StatefulWidget {
  const AdminGate({super.key});

  @override
  State<AdminGate> createState() => _AdminGateState();
}

class _AdminGateState extends State<AdminGate> {
  bool _checking = true;
  bool _signedIn = false;

  @override
  void initState() {
    super.initState();
    _restore();
  }

  Future<void> _restore() async {
    final isAdmin = await AdminApi().isCurrentUserAdmin();
    if (!isAdmin) await AdminApi().signOut();
    if (!mounted) return;
    setState(() {
      _signedIn = isAdmin;
      _checking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        backgroundColor: AppColors.page,
        body: Center(child: CircularProgressIndicator(color: AppColors.navy)),
      );
    }
    if (_signedIn) {
      return AdminHomeScreen(
        onSignedOut: () => setState(() => _signedIn = false),
      );
    }
    return AdminLoginScreen(onSignedIn: () => setState(() => _signedIn = true));
  }
}
