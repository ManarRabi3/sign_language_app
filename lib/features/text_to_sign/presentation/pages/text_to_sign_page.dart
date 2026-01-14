import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/api_service.dart';
//import '../../../../core/services/stt_service.dart';
import '../widgets/avatar_viewer.dart';
import '../widgets/text_input_card.dart';
import '../widgets/playback_controls.dart';
import '../widgets/quick_phrases.dart';

class TextToSignPage extends StatefulWidget {
  const TextToSignPage({super.key});

  @override
  State<TextToSignPage> createState() => _TextToSignPageState();
}

class _TextToSignPageState extends State<TextToSignPage> {
  final TextEditingController _textController = TextEditingController();
  final ApiService _apiService = ApiService();

  List<Map<String, dynamic>> _signs = [];
  List<String> _unknownWords = [];
  int _currentSignIndex = 0;
  bool _isPlaying = false;
  bool _isLoading = false;
  double _playbackSpeed = 1.0;
  String? _errorMessage;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _translateText() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _apiService.textToSign(text);

      setState(() {
        _signs = List<Map<String, dynamic>>.from(response['signs'] ?? []);
        _unknownWords = List<String>.from(response['unknown_words'] ?? []);
        _currentSignIndex = 0;
        _isLoading = false;
      });

      if (_signs.isNotEmpty) {
        _startPlayback();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = '.فشل فى الترجمة .تاكد من الاتصال با الانترنت';
      });
    }
  }

  void _startPlayback() async {
    setState(() => _isPlaying = true);

    for (int i = _currentSignIndex; i < _signs.length; i++) {
      if (!_isPlaying) break;

      setState(() => _currentSignIndex = i);

      // Wait for animation duration
      final duration = _signs[i]['duration_ms'] ?? 2000;
      await Future.delayed(
        Duration(milliseconds: (duration / _playbackSpeed).round()),
      );
    }

    setState(() => _isPlaying = false);
  }

  void _togglePlayback() {
    if (_isPlaying) {
      setState(() => _isPlaying = false);
    } else {
      _startPlayback();
    }
  }

  void _previousSign() {
    if (_currentSignIndex > 0) {
      setState(() {
        _currentSignIndex--;
        _isPlaying = false;
      });
    }
  }

  void _nextSign() {
    if (_currentSignIndex < _signs.length - 1) {
      setState(() {
        _currentSignIndex++;
        _isPlaying = false;
      });
    }
  }

  void _onQuickPhraseSelected(String phrase) {
    _textController.text = phrase;
    _translateText();
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
                AppColors.textToSignGradient.colors.first.withOpacity(0.1),
                Colors.white,
              ],
            ),
          ),
          child: SafeArea(
              child: Column(
                  children: [
                  // Header
                  _buildHeader(),

              // Avatar Section
              Expanded(
                flex: 4,
                child: _buildAvatarSection(),
              ),

              // Playback Controls
              if (_signs.isNotEmpty) _buildPlaybackSection(),

      // Input Section
      Expanded(
        flex: 3,
        child: _buildInputSection(),
      ),]
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
              AppStrings.textToSign,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfo,
          ),
        ],
      ),
    );
  }
  Widget _buildAvatarSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
// Avatar
            AvatarViewer(
              currentSign: _signs.isNotEmpty
                  ? _signs[_currentSignIndex]
                  : null,
              isPlaying: _isPlaying,
            ),
// Loading Overlay
            if (_isLoading)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),

            // Current Word Display
            if (_signs.isNotEmpty)
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _signs[_currentSignIndex]['word'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
                    .animate()
                    .fadeIn()
                    .slideY(begin: -0.3, end: 0),
              ),

            // Progress Indicator
            if (_signs.isNotEmpty)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: (_currentSignIndex + 1) / _signs.length,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation(AppColors.primary),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_currentSignIndex + 1} / ${_signs.length}',
                      style: TextStyle(
                        color: AppColors.grey700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

            // Error Message
            if (_errorMessage != null)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red.shade700),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaybackSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: PlaybackControls(
        isPlaying: _isPlaying,
        speed: _playbackSpeed,
        canGoPrevious: _currentSignIndex > 0,
        canGoNext: _currentSignIndex < _signs.length - 1,
        onPlayPause: _togglePlayback,
        onPrevious: _previousSign,
        onNext: _nextSign,
        onSpeedChanged: (speed) => setState(() => _playbackSpeed = speed),
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Text Input
          TextInputCard(
            controller: _textController,
            onTranslate: _translateText,
            isLoading: _isLoading,
          ),

          const SizedBox(height: 16),

          // Unknown Words Warning
          if (_unknownWords.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ' كلمات غير متوفرة: ${_unknownWords.join("  ،")}',
                      style: TextStyle(
                        color: Colors.orange.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn()
                .slideY(begin: 0.2, end: 0),

          const SizedBox(height: 12),

          // Quick Phrases
          Expanded(
            child: QuickPhrases(
              onPhraseSelected: _onQuickPhraseSelected,
            ),
          ),
        ],
      ),
    );
  }

  void _showInfo() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.accessibility_new, size: 48, color: AppColors.primary),
            const SizedBox(height: 16),
            const Text(
              ' تحويل النص لاشارة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '1.اكتب النص الذى تريد تحويله\n'
                  '2.  اضغط على ذر "ترجم"\n'
                  '3. شاهد الافاتار يعرض الاشارات\n'
                  '4. استخدم ازرار التحكم للتنقل',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 14, height: 1.8),
            ),
            const SizedBox(height: 16),
            const Text(
              '       نصيحة : يمكنك الضغط على العبارات السريعة للترجمة المباشرة',
              style: TextStyle(fontSize: 13, color: AppColors.grey500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(' فهمت'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}