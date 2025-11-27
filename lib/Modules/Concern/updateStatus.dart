import 'package:contol_officer_app/ReusableWidgets/dropdown.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';

class UpdatestatusConcern extends StatefulWidget {
  const UpdatestatusConcern({super.key});

  @override
  State<UpdatestatusConcern> createState() => _UpdatestatusConcernState();
}

class _UpdatestatusConcernState extends State<UpdatestatusConcern> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedPriority;

  final List<String> _priorities = ['Low', 'Medium', 'High'];

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Process form submission logic here
      Navigator.of(context).pop(); // Close bottom sheet after submission
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.65,
            ),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: bottomInset + 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Update Status Concern',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(context).pop(),
                            tooltip: 'Close',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomDropdownField2(
                            label: 'Priority',
                            items: _priorities,
                            value: _selectedPriority,
                            hintText: 'Select priority',
                            onChanged: (value) {
                              setState(() {
                                _selectedPriority = value;
                              });
                            },
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 12,
                                ),
                                minimumSize: const Size(0, 40),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'Update Status',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
