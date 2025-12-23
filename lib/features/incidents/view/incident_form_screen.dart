import 'dart:io';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common_widgets/app.dropdown.dart';
import '../../../core/common_widgets/app_button.dart';
import '../../../core/common_widgets/app_image_picker.dart';
import '../../../core/common_widgets/app_text_field.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/utils/validators.dart';
import '../model/incident_model.dart';
import '../viewmodel/incident_viewmodel.dart';

class IncidentFormScreen extends ConsumerStatefulWidget {
  const IncidentFormScreen({super.key});

  @override
  ConsumerState<IncidentFormScreen> createState() => _IncidentFormScreenState();
}

class _IncidentFormScreenState extends ConsumerState<IncidentFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedType;
  String? _selectedPriority;
  File? _image;

  bool _isSubmitting = false;

  final List<String> _incidentTypes = const [
    'Accident',
    'Fire',
    'Theft',
    'Medical',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    if (!_formKey.currentState!.validate()) return;

    final user = AuthService().currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not logged in')));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final incident = Incident(
        id: '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        type: _selectedType!,
        priority: _selectedPriority!,
        createdAt: DateTime.now(),
        userId: user.uid,
      );

      await ref.read(incidentServiceProvider).createIncident(incident);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incident reported successfully')),
      );

      context.beamToNamed('/incidents');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.createIncident),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _titleController,
                label: AppStrings.incidentTitle,
                icon: Icons.title,
                validator: Validators.incidentTitle,
              ),

              const SizedBox(height: 16),

              AppTextField(
                controller: _descriptionController,
                label: AppStrings.incidentDescription,
                icon: Icons.description,
                validator: Validators.incidentDescription,
              ),

              const SizedBox(height: 16),

              AppDropdown<String>(
                label: AppStrings.incidentType,
                value: _selectedType,
                items: _incidentTypes
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedType = value),
                validator: Validators.dropdown,
              ),

              const SizedBox(height: 16),

              AppDropdown<String>(
                label: AppStrings.incidentPriority,
                value: _selectedPriority,
                items: const [
                  DropdownMenuItem(
                    value: AppStrings.priorityLow,
                    child: Text(AppStrings.priorityLow),
                  ),
                  DropdownMenuItem(
                    value: AppStrings.priorityMedium,
                    child: Text(AppStrings.priorityMedium),
                  ),
                  DropdownMenuItem(
                    value: AppStrings.priorityHigh,
                    child: Text(AppStrings.priorityHigh),
                  ),
                ],
                onChanged: (value) => setState(() => _selectedPriority = value),
                validator: Validators.dropdown,
              ),

              const SizedBox(height: 16),

              AppImagePicker(
                image: _image,
                onImageSelected: (file) => setState(() => _image = file),
              ),

              const SizedBox(height: 24),

              AppButton(
                text: _isSubmitting ? 'Submitting...' : 'Create Incident',
                onPressed: _isSubmitting ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
