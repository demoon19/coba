import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dating/features/search_filter/viewmodels/search_filter_viewmodel.dart';
import 'package:dating/features/dashboard/widgets/profile_card.dart'; // Gunakan kembali widget ProfileCard

class SearchFilterScreen extends StatelessWidget {
  const SearchFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search & Filter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
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
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Di sini Anda perlu mendapatkan ID pengguna saat ini
                // dan memanggil performSearch
                // Contoh:
                // final authProvider = Provider.of<AuthProvider>(context, listen: false);
                // if (authProvider.currentUserId != null) {
                //   Provider.of<SearchFilterViewModel>(context, listen: false).performSearch(authProvider.currentUserId!);
                // }
                Provider.of<SearchFilterViewModel>(
                  context,
                  listen: false,
                ).performSearch(); // Untuk demo
              },
              child: const Text('Apply Search & Filters'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<SearchFilterViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (viewModel.errorMessage != null) {
                    return Center(child: Text(viewModel.errorMessage!));
                  }
                  if (viewModel.searchResults.isEmpty) {
                    return const Center(child: Text('No results found.'));
                  }
                  return ListView.builder(
                    itemCount: viewModel.searchResults.length,
                    itemBuilder: (context, index) {
                      final user = viewModel.searchResults[index];
                      return ProfileCard(
                        user: user,
                      ); // Anda bisa membuat onTap di sini juga
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
