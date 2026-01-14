import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/websocket_service.dart';
import '../../../../core/services/tts_service.dart';
import '../bloc/sign_to_text_cubit.dart';
import '../bloc/sign_to_text_state.dart';
import '../widgets/camera_view.dart';
import '../widgets/recognition_result.dart';
import '../widgets/sentence_builder.dart';

/// ===================== الصفحة الرئيسية لتحويل الإشارات لنص =====================
class SignToTextPage extends StatelessWidget {
  const SignToTextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // توفير Cubit لإدارة الحالة
      create: (context) => SignToTextCubit(
        wsService: WebSocketService(),
        ttsService: TtsService(),
      )..initializeCamera() // تهيئة الكاميرا
        ..connectWebSocket(), // الاتصال بالسيرفر
      child: const _SignToTextView(),
    );
  }
}

/// ===================== الواجهة الفعلية =====================
class _SignToTextView extends StatefulWidget {
  const _SignToTextView();

  @override
  State<_SignToTextView> createState() => _SignToTextViewState();
}

class _SignToTextViewState extends State<_SignToTextView>
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // مراقبة تغييرات حالة التطبيق
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// التعامل مع الانتقال بين خلفية التطبيق وعودته
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cubit = context.read<SignToTextCubit>();

    if (state == AppLifecycleState.inactive) {
      cubit.stopCapturing(); // إيقاف الكاميرا عند الخروج
    } else if (state == AppLifecycleState.resumed) {
      cubit.startCapturing(); // استئناف الكاميرا عند العودة
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // ===================== الهيدر =====================
            _buildHeader(context),

            // ===================== قسم الكاميرا =====================
            Expanded(
              flex: 5,
              child: _buildCameraSection(),
            ),

            // ===================== قسم النتائج =====================
            Expanded(
              flex: 4,
              child: _buildResultsSection(),
            ),
          ],
        ),
      ),
    );
  }

  /// ===================== الهيدر =====================
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              AppStrings.signToText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
    );
  }

  /// ===================== قسم الكاميرا =====================
  Widget _buildCameraSection() {
    return BlocBuilder<SignToTextCubit, SignToTextState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ===================== عرض الكاميرا =====================
                if (state.isCameraInitialized)
                  CameraView(
                    controller:
                    context.read<SignToTextCubit>().cameraController!,
                  )
                else
                  const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),

                // ===================== Overlay الحالة =====================
                _buildStatusOverlay(state),

                // ===================== مؤشر التسجيل =====================
                if (state.status == RecognitionStatus.capturing)
                  _buildRecordingIndicator(),

                // ===================== شريط التقدم =====================
                _buildProgressBar(state),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ===================== Overlay الحالة =====================
  Widget _buildStatusOverlay(SignToTextState state) {
    String statusText;
    Color statusColor;
    IconData statusIcon;

    switch (state.status) {
      case RecognitionStatus.connecting:
        statusText = 'جارِ الاتصال...';
        statusColor = Colors.orange;
        statusIcon = Icons.wifi;
        break;
      case RecognitionStatus.ready:
        statusText = state.hasHand ? 'جاهز للتسجيل' : 'تم اكتشاف اليد';
        statusColor = state.hasHand ? Colors.green : Colors.blue;
        statusIcon = state.hasHand ? Icons.pan_tool : Icons.videocam;
        break;
      case RecognitionStatus.capturing:
        statusText = 'جاري التسجيل...';
        statusColor = Colors.red;
        statusIcon = Icons.fiber_manual_record;
        break;
      case RecognitionStatus.processing:
        statusText = 'جاري المعالجة...';
        statusColor = Colors.amber;
        statusIcon = Icons.hourglass_empty;
        break;
      case RecognitionStatus.success:
        statusText = 'تم التعرف!';
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case RecognitionStatus.error:
        statusText = state.errorMessage ?? 'حدث خطأ';
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      default:
        statusText = 'جارٍ التهيئة...';
        statusColor = Colors.grey;
        statusIcon = Icons.hourglass_empty;
    }

    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(statusIcon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              statusText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      )
          .animate(
        target: state.status == RecognitionStatus.capturing ? 1 : 0,
      )
          .shimmer(duration: 1.seconds),
    );
  }

  /// ===================== مؤشر التسجيل =====================
  Widget _buildRecordingIndicator() {
    return Positioned(
      top: 16,
      right: 16,
      child: Container(
        width: 16,
        height: 16,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      )
          .animate(onPlay: (controller) => controller.repeat())
          .fadeIn(duration: 500.ms)
          .then()
          .fadeOut(duration: 500.ms),
    );
  }

  /// ===================== شريط التقدم =====================
  Widget _buildProgressBar(SignToTextState state) {
    final progress = state.bufferSize / 15; // MAX_LENGTH_FRAMES = 15

    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress >= 1.0 ? Colors.green : AppColors.primary,
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${state.bufferSize}إطار 15/ ',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// ===================== قسم النتائج =====================
  Widget _buildResultsSection() {
    return BlocBuilder<SignToTextCubit, SignToTextState>(
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              // الشريط الصغير لأعلى البطاقات
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // عرض نتيجة التعرف
              if (state.recognizedSign != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: RecognitionResult(
                    sign: state.recognizedSign!,
                    confidence: state.confidence ?? 0,
                    onAdd: () => context.read<SignToTextCubit>().addToSentence(),
                    onDismiss: () => context.read<SignToTextCubit>().reset(),
                  ),
                )
                    .animate()
                    .fadeIn()
                    .scale(begin: const Offset(0.8, 0.8)),

              // بناء الجملة
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SentenceBuilder(
                    words: state.sentence,
                    onRemove: (index) =>
                        context.read<SignToTextCubit>().removeFromSentence(index),
                    onClear: () => context.read<SignToTextCubit>().clearSentence(),
                  ),
                ),
              ),

              // أزرار الإجراءات (نسخ، نطق، مشاركة)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.content_copy,
                        label: 'نسخ',
                        onPressed: state.sentence.isNotEmpty
                            ? () => _copyToClipboard(context, state.sentence)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.volume_up,
                        label: 'نطق',
                        color: Colors.green,
                        onPressed: state.sentence.isNotEmpty
                            ? () => context.read<SignToTextCubit>().speakSentence()
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.share,
                        label: 'مشاركة',
                        color: Colors.blue,
                        onPressed: state.sentence.isNotEmpty
                            ? () => _shareSentence(state.sentence)
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ===================== نسخ الجملة =====================
  void _copyToClipboard(BuildContext context, List<String> sentence) {
    final text = sentence.join(' ');
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم النسخ!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// ===================== مشاركة الجملة =====================
  void _shareSentence(List<String> sentence) {
    final text = sentence.join(' ');
    Share.share(text);
  }

  /// ===================== عرض مساعدة المستخدم =====================
  void _showHelpDialog(BuildContext context) {
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
            const Icon(Icons.lightbulb_outline, size: 48, color: Colors.amber),
            const SizedBox(height: 16),
            const Text(
              'كيفية الاستخدام',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '1. قف امام الكاميرا بحيث تظهر ايديك.\n'
                  '2. تأكد أن اليد واضحة.\n'
                  '3. انتظر حتى يمتلى شريط التقدم .\n'
                  '4. عند انتهاء الاشارة . ابعد يدك عن الكاميرا .\n'
                  '5. اضغط "اضافة"لاضافة الكلمة للجملة.',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 14, height: 1.8),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('فهمت'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===================== زر الإجراءات =====================
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColors.primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey[300],
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}
