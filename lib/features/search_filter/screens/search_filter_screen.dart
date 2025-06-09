import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dating/features/search_filter/viewmodels/search_filter_viewmodel.dart';
import 'package:dating/features/dashboard/widgets/profile_card.dart';
import 'package:dating/core/widgets/loading_indicator.dart';
import 'package:dating/core/utils/app_utils.dart';
import 'package:dating/core/providers/auth_provider.dart'; // Penting: Import AuthProvider

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Anda bisa memuat hasil awal di sini jika ingin, atau biarkan kosong hingga user mencari
      // _performSearch(); // Bisa dipanggil di sini jika Anda ingin ada hasil default saat halaman dibuka
    });
  }

  Future<void> _performSearch() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUserId != null) {
      await Provider.of<SearchFilterViewModel>(
        context,
        listen: false,
      ).performSearch(authProvider.currentUserId!); // <-- Berikan currentUserId
    } else {
      AppUtils.showToast("Please log in to perform searches.");
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search & Filter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search by Username',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                Provider.of<SearchFilterViewModel>(
                  context,
                  listen: false,
                ).setSearchQuery(query);
              },
              onSubmitted: (_) => _performSearch(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _performSearch, // Panggil fungsi yang diperbaiki
              child: const Text('Apply Search & Filters'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<SearchFilterViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const LoadingIndicator(message: 'Searching...');
                  }
                  if (viewModel.errorMessage != null) {
                    return Center(child: Text(viewModel.errorMessage!));
                  }
                  if (viewModel.searchResults.isEmpty &&
                      _searchController.text.isNotEmpty) {
                    return const Center(
                      child: Text('No results found for your search.'),
                    );
                  } else if (viewModel.searchResults.isEmpty) {
                    return const Center(
                      child: Text('Start searching for matches!'),
                    );
                  }
                  return ListView.builder(
                    itemCount: viewModel.searchResults.length,
                    itemBuilder: (context, index) {
                      final user = viewModel.searchResults[index];
                      return ProfileCard(
                        user: user,
                        onTap: () {
                          // Implementasi navigasi ke detail profil (jika diperlukan)
                          // Anda mungkin ingin menambahkan biaya untuk melihat detail di sini juga
                          // Navigator.of(context).pushNamed(AppRouter.matchDetailRoute, arguments: user);
                          AppUtils.showToast(
                            "Viewing detail for ${user.username}",
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
