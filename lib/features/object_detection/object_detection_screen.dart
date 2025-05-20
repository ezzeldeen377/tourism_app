import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:new_flutter/core/widgets/contants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:new_flutter/features/object_detection/data.dart';

class IconButtomBar extends StatelessWidget {
  const IconButtomBar({
    super.key,
    required this.text,
    required this.icon,
    required this.selected,
    required this.onPressed,
    required this.selectedIcon,
  });

  final String text;
  final IconData icon, selectedIcon;
  final bool selected;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: selected
              ? Icon(
                  selectedIcon,
                  color: kMainColor,
                  size: 24,
                )
              : Icon(
                  icon,
                  size: 30,
                ),
        ),
        Text(
          textAlign: TextAlign.center,
          text,
          style: TextStyle(
            fontSize: 11,
            height: 0.22,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? kMainColor : Colors.black,
          ),
        ),
      ],
    );
  }
}

class ObjectDetectionScreen extends StatefulWidget {
  const ObjectDetectionScreen({super.key});

  @override
  _ObjectDetectionScreenState createState() => _ObjectDetectionScreenState();
}

class _ObjectDetectionScreenState extends State<ObjectDetectionScreen> {
  Interpreter? _interpreter;
  List<String>? _labels;
  File? _image;
  List<Map<String, dynamic>>? _results;
  bool _loading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadModel();
    _loadLabels();
  }

  Future<void> _loadModel() async {
    try {
      setState(() {
        _loading = true;
        _errorMessage = '';
      });
      
      _interpreter = await Interpreter.fromAsset('assets/model_unquant.tflite');
      print('Model loaded successfully. Input shapes: ${_interpreter!.getInputTensor(0).shape}');
      print('Output shapes: ${_interpreter!.getOutputTensor(0).shape}');
      
      setState(() {
        _loading = false;
      });
    } catch (e) {
      print('Error loading model: $e');
      setState(() { 
        _loading = false;
        _errorMessage = 'Failed to load model: $e';
      });
    }
  }

  Future<void> _loadLabels() async {
    try {
      final labelsData = await DefaultAssetBundle.of(context).loadString('assets/labels.txt');
      _labels = labelsData
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .map((line) => line.split(' ').sublist(1).join(' ').trim())
          .toList();
      print('Labels loaded: ${_labels!.length} labels - $_labels');
    } catch (e) {
      print('Error loading labels: $e');
      setState(() {
        _errorMessage = 'Failed to load labels: $e';
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _loading = true;
        _image = File(pickedFile.path);
        _results = null;
        _errorMessage = '';
      });
      await _runInference();
    }
  }

  Future<void> _runInference() async {
    if (_interpreter == null || _image == null || _labels == null) {
      print('Inference skipped: interpreter=${_interpreter != null}, image=${_image != null}, labels=${_labels != null}');
      setState(() { 
        _loading = false;
        _errorMessage = 'Model or image not ready. Please try again.';
      });
      return;
    }

    try {
      // Load and preprocess image
      final image = img.decodeImage(_image!.readAsBytesSync());
      if (image == null) {
        print('Error decoding image');
        setState(() { 
          _loading = false;
          _errorMessage = 'Failed to decode image';
        });
        return;
      }
      print('Image decoded: ${image.width}x${image.height}');

      // Resize to 224x224 (adjust based on your model)
      final resizedImage = img.copyResize(image, width: 224, height: 224);
      print('Image resized: ${resizedImage.width}x${resizedImage.height}');

      // Convert to tensor format (normalize to [0,1])
      final input = List.generate(
        1,
        (_) => List.generate(
          224,
          (i) => List.generate(
            224,
            (j) {
              final pixel = resizedImage.getPixel(j, i);
              return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
            },
          ),
        ),
      );
      print('Input tensor created: ${input.length}x${input[0].length}x${input[0][0].length}x3');

      // Prepare output buffer (assuming 22 classes)
      final output = List.filled(22, 0.0).reshape([1, 22]);

      // Run inference
      print('Running inference...');
      _interpreter!.run(input, output);
      print('Inference completed. Output: $output');

      // Process output
      final probabilities = output[0] as List<double>;
      final results = <Map<String, dynamic>>[];
      for (int i = 0; i < probabilities.length && i < (_labels?.length ?? 0); i++) {
        results.add({
          'label': _labels![i],
          'confidence': probabilities[i],
        });
      }

      // Sort by confidence and get top 3 results
      results.sort((a, b) => b['confidence'].compareTo(a['confidence']));
      print('Results: $results');
      setState(() {
        _results = results.take(3).toList();
        _loading = false;
      });
    } catch (e) {
      print('Error running inference: $e');
      setState(() {
        _loading = false;
        _errorMessage = 'Error analyzing image: $e';
      });
    }
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kMainColor,
        title: const Text(
          'Object Detection',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header section with instructions
            Container(
              padding: const EdgeInsets.all(16),
              color: kMainColor.withOpacity(0.1),
              child: const Text(
                'Take or select a photo to identify objects using AI',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: kMainColor,
                ),
              ),
            ),
            
            Expanded(
              child: _loading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: kMainColor),
                        SizedBox(height: 16),
                        Text('Processing image...', style: TextStyle(color: kMainColor)),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Image display area
                        Container(
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_search,
                                      size: 64,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'No image selected',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Gallery button only (camera option removed)
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Select from Gallery'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kMainColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        
                        if (_errorMessage.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline, color: Colors.red.shade700),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage,
                                    style: TextStyle(color: Colors.red.shade700),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        
                        // Results section
                        if (_results != null && _results!.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: kMainColor.withOpacity(0.3)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.check_circle, color: kMainColor, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Detection Results',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: kMainColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 24),
                                if (_results != null && _results!.isNotEmpty) ...[
                                  Builder(
                                    builder: (context) {
                                      final topResult = _results!.first;
                                      final confidence = topResult['confidence'] as double;
                                      final label = topResult['label'] as String;
                                      
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            label,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          LinearProgressIndicator(
                                            value: confidence,
                                            backgroundColor: Colors.grey.shade200,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              confidence > 0.7
                                                  ? Colors.green
                                                  : confidence > 0.4
                                                      ? Colors.orange
                                                      : Colors.red,
                                            ),
                                            minHeight: 8,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${(confidence * 100).toStringAsFixed(1)}% confidence',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          const Text(
                                            'Description:',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade50,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Colors.grey.shade200),
                                            ),
                                            child: Text(
                                              labelDescriptions[label] ?? 'No description available for this item.',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                height: 1.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ] else ...[
                                  const Text(
                                    'No objects detected. Try another image.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                        
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}