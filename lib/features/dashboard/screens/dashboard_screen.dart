import 'package:dating/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:dating/features/dashboard/viewmodels/dashboard_viewmodel.dart';
import 'package:dating/core/providers/auth_provider.dart';
import 'package:dating/features/dashboard/widgets/profile_card.dart'; // Akan dibuat

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.currentUserId != null) {
        Provider.of<DashboardViewModel>(context, listen: false)
            .fetchPotentialMatches(authProvider.currentUserId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false); // Dapatkan AuthProvider di sini
    return Scaffold(
      appBar: AppBar(title: const Text('Discover Matches')),
      body: Consumer<DashboardViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.errorMessage != null) {
            return Center(child: Text(viewModel.errorMessage!));
          }
          if (viewModel.potentialMatches.isEmpty) {
            return const Center(child: Text('No potential matches found.'));
          }

          return ListView.builder(
            itemCount: viewModel.potentialMatches.length,
            itemBuilder: (context, index) {
              final user = viewModel.potentialMatches[index];
              return ProfileCard(
                user: user,
                onTap: () async {
                  if (authProvider.currentUserId != null) {
                    bool deducted = await viewModel.deductBalanceForSwipe(authProvider.currentUserId!, 100.0); // Biaya per view
                    if (deducted) {
                      // Navigasi ke detail profil menggunakan AppRouter
                      Navigator.of(context).pushNamed(AppRouter.matchDetailRoute, arguments: user);
                    } else {
                      Fluttertoast.showToast(msg: "Insufficient balance to view profile details.");
                      // Tampilkan pesan saldo tidak cukup
                    }
                  } else {
                     Fluttertoast.showToast(msg: "You must be logged in to view profiles.");
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}