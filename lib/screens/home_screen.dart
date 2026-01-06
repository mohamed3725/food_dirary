import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/meal_provider.dart';
import '../providers/theme_provider.dart';
import '../services/import_export_service.dart';
import '../widgets/meal_card.dart';
import '../widgets/empty_state.dart';
import 'add_edit_meal_screen.dart';
import '../providers/connectivity_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);
    final allMeals = mealProvider.meals;
    
    // Filter meals based on search query
    final filteredMeals = allMeals.where((meal) {
      return meal.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (meal.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search meals...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(fontSize: 18),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : const Text('My Food Diary'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                  _searchQuery = '';
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) => UserAccountsDrawerHeader(
                accountName: Text(authProvider.userName),
                accountEmail: Text(authProvider.userEmail),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  child: Text(
                    authProvider.userName.isNotEmpty ? authProvider.userName[0] : 'U',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Theme.of(context).brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode,
              ),
              title: Text(Theme.of(context).brightness == Brightness.dark ? 'Light Mode' : 'Dark Mode'),
              onTap: () {
                Provider.of<ThemeProvider>(context, listen: false).toggle();
              },
            ),
            // const Divider(),
            // ListTile(
            //   leading: const Icon(Icons.file_upload),
            //   title: const Text('Export Data (JSON)'),
            //   onTap: () async {
            //     Navigator.pop(context); // Close drawer
            //     final service = ImportExportService();
            //     try {
            //       await service.exportMeals(allMeals);
            //       if (mounted) {
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           const SnackBar(content: Text('Export successful!')),
            //         );
            //       }
            //     } catch (e) {
            //       if (mounted) {
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           SnackBar(content: Text('Export failed: $e')),
            //         );
            //       }
            //     }
            //   },
            // ),
            // ListTile(
            //   leading: const Icon(Icons.file_download),
            //   title: const Text('Import Data (JSON)'),
            //   onTap: () async {
            //     Navigator.pop(context); // Close drawer
            //     final service = ImportExportService();
            //     try {
            //       final importedMeals = await service.importMeals();
            //       if (importedMeals.isNotEmpty && mounted) {
            //         await mealProvider.addAll(importedMeals);
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           const SnackBar(content: Text('Import successful!')),
            //         );
            //       }
            //     } catch (e) {
            //       if (mounted) {
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           SnackBar(content: Text('Import failed: $e')),
            //         );
            //       }
            //     }
            //   },
            // ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                Provider.of<AuthProvider>(context, listen: false).signOut();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      body: Column(
        children: [
          Consumer<ConnectivityProvider>(
            builder: (context, conn, _) {
              if (!conn.isOffline) return const SizedBox.shrink();
              return Container(
                width: double.infinity,
                color: Colors.orange[800],
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'You are offline. Changes will sync later.',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: mealProvider.loading
                ? const Center(child: CircularProgressIndicator())
                : filteredMeals.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const EmptyState(),
                            if (_searchQuery.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Text(
                                'No results for "$_searchQuery"',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(
                          top: 16,
                          left: 16,
                          right: 16,
                          bottom: 100,
                        ),
                        itemCount: filteredMeals.length,
                        itemBuilder: (context, index) {
                          return MealCard(
                            meal: filteredMeals[index],
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddEditMealScreen(meal: filteredMeals[index]),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEditMealScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Meal'),
      ),
    );
  }
}
