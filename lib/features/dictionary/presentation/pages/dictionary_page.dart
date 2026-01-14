import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/api_service.dart';
import '../widgets/sign_card.dart';
import '../widgets/category_chips.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _allSigns = [];
  List<Map<String, dynamic>> _filteredSigns = [];
  List<String> _categories = [];
  String _selectedCategory = AppStrings.all;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDictionary();
  }

  Future<void> _loadDictionary() async {
    try {
      final response = await _apiService.getDictionary();

      setState(() {
        _allSigns = List<Map<String, dynamic>>.from(response['signs'] ?? []);
        _categories = [AppStrings.all, ...List<String>.from(response['categories'] ?? [])];
        _filteredSigns = _allSigns;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'فشل فى تحميل القاموس';
        _isLoading = false;
      });
    }
  }

  void _filterSigns() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredSigns = _allSigns.where((sign) {
        final matchesSearch = sign['word'].toString().contains(query) ||
            sign['description'].toString().contains(query);
        final matchesCategory = _selectedCategory == AppStrings.all ||
            sign['category'] == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterSigns();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.dictionaryGradient.colors.first.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Search Bar
              _buildSearchBar(),

              // Categories
              CategoryChips(
                categories: _categories,
                selectedCategory: _selectedCategory,
                onCategorySelected: _onCategorySelected,
              ),

              // Signs Grid
              Expanded(
                child: _buildSignsGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              AppStrings.dictionary,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              // TODO: Show bookmarks
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          hintText: 'ةراشإ  نع ثحبا...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              _filterSigns();
            },
          )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (_) => _filterSigns(),
      ),
    );
  }

  Widget _buildSignsGrid() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.grey300),
            const SizedBox(height: 16),
            Text(_error!, style: TextStyle(color: AppColors.grey500)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadDictionary,
              child: const Text(' ةلواحملا  ةداعإ'),
            ),
          ],
        ),
      );
    }

    if (_filteredSigns.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: AppColors.grey300),
            const SizedBox(height: 16),
            Text(
              ' جئاتن  دجوت  ل',
              style: TextStyle(color: AppColors.grey500, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _filteredSigns.length,
      itemBuilder: (context, index) {
        final sign = _filteredSigns[index];
        return SignCard(
          sign: sign,
          onTap: () => _showSignDetails(sign),
        )
            .animate()
            .fadeIn(delay: Duration(milliseconds: index * 50))
            .slideY(begin: 0.1, end: 0);
      },
    );
  }

  void _showSignDetails(Map<String, dynamic> sign) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: ListView(
              controller: scrollController,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Sign Name
                Text(
                  sign['word'] ?? '',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Category
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    sign['category'] ?? '',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Video/Animation Preview
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.play_circle_outline,
                      size: 64,
                      color: AppColors.grey500,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Description
                Text(
                  ' فصولا',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  sign['description'] ?? 'فصو  دجوي  ل',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.grey500,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('ةدهاشم'),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            '/text-to-sign',
                            arguments: sign['word'],
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.bookmark_border),
                        label: const Text('ظفح'),
                        onPressed: () {
                          // TODO: Save to bookmarks
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}