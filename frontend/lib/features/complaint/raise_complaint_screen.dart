import 'package:flutter/material.dart';
import 'package:quentiq/core/theme/app_colors.dart';
import 'package:quentiq/core/theme/theme_extensions.dart';
import 'package:quentiq/core/widgets/app_card.dart';
import 'package:quentiq/core/widgets/category_chip.dart';
import 'package:quentiq/core/widgets/gradient_button.dart';
import 'package:quentiq/models/complaint_models.dart';
import 'package:quentiq/routes/app_routes.dart';

class RaiseComplaintScreen extends StatefulWidget {
  const RaiseComplaintScreen({super.key, this.startWithVoice = false});

  final bool startWithVoice;

  @override
  State<RaiseComplaintScreen> createState() => _RaiseComplaintScreenState();
}

class _RaiseComplaintScreenState extends State<RaiseComplaintScreen> {
  final _descriptionController = TextEditingController();
  bool _isRecording = false;
  bool _aiDetecting = false;
  ComplaintCategory? _detectedCategory;
  final List<String> _attachments = [];

  @override
  void initState() {
    super.initState();
    if (widget.startWithVoice) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _toggleRecording());
    }
    _descriptionController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _descriptionController.text;
    if (text.length < 12) {
      setState(() {
        _detectedCategory = null;
        _aiDetecting = false;
      });
      return;
    }
    setState(() => _aiDetecting = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      ComplaintCategory detected = ComplaintCategory.plumbing;
      final lower = text.toLowerCase();
      if (lower.contains('electric') || lower.contains('power') || lower.contains('ac')) {
        detected = ComplaintCategory.electrical;
      } else if (lower.contains('clean')) {
        detected = ComplaintCategory.cleaning;
      } else if (lower.contains('water')) {
        detected = ComplaintCategory.water;
      } else if (lower.contains('lift') || lower.contains('door')) {
        detected = ComplaintCategory.maintenance;
      }
      setState(() {
        _aiDetecting = false;
        _detectedCategory = detected;
      });
    });
  }

  void _toggleRecording() {
    setState(() => _isRecording = !_isRecording);
    if (!_isRecording) {
      _descriptionController.text =
          'Bathroom tap is leaking continuously since morning.';
      _onTextChanged();
    }
  }

  void _addMockAttachment(String type) {
    setState(() => _attachments.add(type));
  }

  void _submit() {
    Navigator.pushReplacementNamed(context, AppRoutes.complaintTracking);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Raise complaint'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Describe your issue',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(
              'AI will categorize and route to the right team',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'e.g. Bathroom tap leaking since morning...',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),
            _VoiceRecorder(
              isRecording: _isRecording,
              onToggle: _toggleRecording,
            ),
            const SizedBox(height: 24),
            Text('Attachments', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                _AttachButton(
                  icon: Icons.photo_camera_rounded,
                  label: 'Photo',
                  onTap: () => _addMockAttachment('photo'),
                ),
                const SizedBox(width: 12),
                _AttachButton(
                  icon: Icons.videocam_rounded,
                  label: 'Video',
                  onTap: () => _addMockAttachment('video'),
                ),
                const SizedBox(width: 12),
                _AttachButton(
                  icon: Icons.attach_file_rounded,
                  label: 'File',
                  onTap: () => _addMockAttachment('file'),
                ),
              ],
            ),
            if (_attachments.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: _attachments
                    .map(
                      (a) => Chip(
                        label: Text(a),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () =>
                            setState(() => _attachments.remove(a)),
                      ),
                    )
                    .toList(),
              ),
            ],
            const SizedBox(height: 24),
            _AiCategoryPreview(
              isDetecting: _aiDetecting,
              category: _detectedCategory,
            ),
            const SizedBox(height: 32),
            GradientButton(
              label: 'Submit complaint',
              icon: Icons.send_rounded,
              onPressed:
                  _descriptionController.text.isNotEmpty ? _submit : null,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _VoiceRecorder extends StatelessWidget {
  const _VoiceRecorder({
    required this.isRecording,
    required this.onToggle,
  });

  final bool isRecording;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isRecording ? AppColors.gradientGlow : null,
                color: isRecording ? null : context.borderColor.withValues(alpha: 0.5),
                boxShadow: isRecording
                    ? [
                        BoxShadow(
                          color: AppColors.purple.withValues(alpha: 0.4),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                color: isRecording ? Colors.white : context.textMuted,
                size: 36,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isRecording ? 'Recording… Tap to stop' : 'Tap to record voice complaint',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (isRecording) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                12,
                (i) => _WaveBar(delay: i * 80),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _WaveBar extends StatefulWidget {
  const _WaveBar({required this.delay});

  final int delay;

  @override
  State<_WaveBar> createState() => _WaveBarState();
}

class _WaveBarState extends State<_WaveBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Container(
          width: 4,
          height: 8 + _controller.value * 24,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: AppColors.purple,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      },
    );
  }
}

class _AttachButton extends StatelessWidget {
  const _AttachButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.borderColor),
            ),
            child: Column(
              children: [
                Icon(icon, color: AppColors.purple),
                const SizedBox(height: 6),
                Text(label, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AiCategoryPreview extends StatelessWidget {
  const _AiCategoryPreview({
    required this.isDetecting,
    required this.category,
  });

  final bool isDetecting;
  final ComplaintCategory? category;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      gradientBorder: category != null,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.purple.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.purple,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI category preview',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                if (isDetecting)
                  Row(
                    children: [
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Analyzing your complaint…',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  )
                else if (category != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CategoryChip(category: category!),
                      const SizedBox(height: 6),
                      Text(
                        'Will route to ${category!.label} queue · High confidence',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  )
                else
                  Text(
                    'Start typing or record voice to see AI detection',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
