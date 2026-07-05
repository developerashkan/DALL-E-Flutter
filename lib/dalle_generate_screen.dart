import 'package:flutter/material.dart';
import 'openai_service.dart';

class DallEGenerateScreen extends StatefulWidget {
  const DallEGenerateScreen({super.key});

  @override
  State<DallEGenerateScreen> createState() => _DallEGenerateScreenState();
}

class _DallEGenerateScreenState extends State<DallEGenerateScreen> {
  final TextEditingController _inputController = TextEditingController();
  final OpenAIService _apiService = OpenAIService();
  final FocusNode _focusNode = FocusNode();

  String? _imageUrl;
  String _statusMessage = "Enter a prompt to generate an image.";
  bool _isLoading = false;

  @override
  void dispose() {
    _inputController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _generateImage() async {
    final prompt = _inputController.text.trim();
    if (prompt.isEmpty) {
      setState(() => _statusMessage = "Please enter a prompt first.");
      return;
    }

    _focusNode.unfocus();
    setState(() {
      _isLoading = true;
      _imageUrl = null;
      _statusMessage = "Generating...";
    });

    try {
      final url = await _apiService.generateImage(prompt);
      
      if (!mounted) return;
      setState(() {
        _imageUrl = url;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _statusMessage = e.toString().replaceAll("Exception: ", "");
        _isLoading = false;
      });
    }
  }

  Widget _buildTextInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _inputController,
                focusNode: _focusNode,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _generateImage(),
                decoration: InputDecoration(
                  hintText: "Describe an image...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            FloatingActionButton(
              elevation: 0,
              onPressed: _isLoading ? null : _generateImage,
              child: const Icon(Icons.auto_awesome),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DALL-E Generator"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : _imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            _imageUrl!,
                            width: 256,
                            height: 256,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const CircularProgressIndicator();
                            },
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            _statusMessage,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
            ),
          ),
          _buildTextInput(),
        ],
      ),
    );
  }
}
