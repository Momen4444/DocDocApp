import 'package:flutter/material.dart';
import '../models/doctor_user.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../theme/app_colors.dart';
import '../widgets/home/doctor_card.dart';
import '../widgets/home/home_error_state.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/home_nav_bar.dart';
import '../widgets/home/home_search_bar.dart';
import 'create_user_screen.dart';
import 'user_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State
  int _navIndex = 0;
  List<DoctorUser> _users = [];
  bool _loading = true;
  bool _hasError = false;
  bool _isSearching = false;
  String _searchQuery = '';
  
  String _currentRole = 'User';
  int _currentUserId = 0;

  // Lifecycle
  @override
  void initState() {
    super.initState();
    _loadSession();
    _loadUsers();
  }

  Future<void> _loadSession() async {
    final role = await LocalStorageService.getRole();
    final userId = await LocalStorageService.getUserId();
    if (mounted) {
      setState(() {
        _currentRole = role ?? 'User';
        _currentUserId = userId ?? 0;
      });
    }
  }

  // Data fetching

  // GET /api/Users
  Future<void> _loadUsers() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _hasError = false;
      _searchQuery = '';
    });

    final result = await ApiService.getUsers();

    if (!mounted) return;
    if (result['success'] == true) {
      final raw = result['data'] as List<dynamic>? ?? [];
      setState(() {
        _users = raw.map((e) => DoctorUser.fromJson(e)).toList();
        _loading = false;
        _isSearching = false;
      });
    } else {
      setState(() {
        _loading = false;
        _hasError = true;
      });
    }
  }

  /// Search — GET /api/Users/search?name=query
  Future<void> _onSearch(String query) async {
    if (!mounted) return;

    if (query.isEmpty) {
      _loadUsers();
      return;
    }

    setState(() {
      _loading = true;
      _hasError = false;
      _searchQuery = query;
      _isSearching = true;
    });

    final result = await ApiService.searchUsers(query);

    if (!mounted) return;
    if (result['success'] == true) {
      final raw = result['data'] as List<dynamic>? ?? [];
      setState(() {
        _users = raw.map((e) => DoctorUser.fromJson(e)).toList();
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
        _hasError = true;
      });
    }
  }

  // Actions

  Future<void> _logout() async {
    await LocalStorageService.deleteToken();
    if (mounted) Navigator.pushReplacementNamed(context, '/sign-in');
  }

  void _onNavTap(int index) async {
    setState(() => _navIndex = index);
    
    if (index == 4 && _currentUserId != 0) {
      // Profile Tab
      final res = await ApiService.getUserById(_currentUserId);
      if (res['success'] && mounted) {
        final user = DoctorUser.fromJson(res['data']);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UserDetailScreen(
              user: user,
              currentUserId: _currentUserId,
              currentRole: _currentRole,
            ),
          ),
        );
      } else {
        _snack('Could not load profile');
      }
      return;
    }

    const wip = {1: 'Chat', 2: 'Search', 3: 'Appointments'};
    if (wip.containsKey(index)) _snack('${wip[index]} — coming soon');
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          // Pull-to-refresh always resets to full list
          onRefresh: _loadUsers,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: HomeHeader(
                  userName: 'there',
                  onNotificationTap: () =>
                      _snack('Notifications — coming soon'),
                  onLogout: _logout,
                ),
              ),
              SliverToBoxAdapter(
                child: HomeSearchBar(onSearch: _onSearch),
              ),
              SliverToBoxAdapter(child: _listHeader()),
              ..._body(),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          HomeNavBar(currentIndex: _navIndex, onTap: _onNavTap),
      floatingActionButton: _currentRole == 'Admin'
          ? FloatingActionButton(
              onPressed: () async {
                final didCreate = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateUserScreen()),
                );
                if (didCreate == true) _loadUsers();
              },
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _listHeader() {
    final label =
        _isSearching ? 'Results for "$_searchQuery"' : 'Registered Users';
    final sub = _loading
        ? ''
        : '${_users.length} ${_users.length == 1 ? 'user' : 'users'}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark)),
          if (sub.isNotEmpty)
            Text(sub,
                style:
                    const TextStyle(fontSize: 13, color: AppColors.textGrey)),
        ],
      ),
    );
  }

  List<Widget> _body() {
    if (_loading) {
      return [
        const SliverFillRemaining(
          child: Center(
              child: CircularProgressIndicator(color: AppColors.primary)),
        ),
      ];
    }

    if (_hasError) {
      return [SliverFillRemaining(child: HomeErrorState(onRetry: _loadUsers))];
    }

    if (_users.isEmpty) {
      return [
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_search_rounded,
                    size: 54, color: AppColors.textGrey),
                const SizedBox(height: 12),
                Text(
                  _isSearching
                      ? 'No users match "$_searchQuery".'
                      : 'No users found.',
                  style: const TextStyle(color: AppColors.textGrey),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    return [
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, i) => UserCard(
            user: _users[i],
            currentRole: _currentRole,
            currentUserId: _currentUserId,
          ),
          childCount: _users.length,
        ),
      ),
    ];
  }
}
