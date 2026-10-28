import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:margnetra_super_app/core/utils/custom_snack_bar.dart';
import 'package:margnetra_super_app/pages/profile_page/data/models/payment_method_model.dart';
import 'package:margnetra_super_app/pages/profile_page/logic/blocs/profile_bloc/profile_bloc.dart';

class PaymentMethodSheet extends StatefulWidget {
  const PaymentMethodSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<ProfileBloc>(),
        child: const PaymentMethodSheet(),
      ),
    );
  }

  @override
  State<PaymentMethodSheet> createState() => _PaymentMethodSheetState();
}

class _PaymentMethodSheetState extends State<PaymentMethodSheet> {
  final _controller = TextEditingController();
  final String _selectedType = 'upi';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addMethod() {
    final identifier = _controller.text.trim();
    if (identifier.isEmpty) return;

    context.read<ProfileBloc>().add(
          AddPaymentMethodEvent(type: _selectedType, identifier: identifier),
        );
    CustomSnackBar.showSuccess(context, 'Payment method added');
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF111116);
    const borderColor = Color(0xFF25252D);
    const cyan = Color(0xFF16D9E3);
    const mutedText = Color(0xFF8A8A95);

    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: const BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: borderColor, width: 1.5)),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Saved Payment Methods',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Used for instant electronic challan settlement and toll wallet top ups',
            style: TextStyle(color: mutedText, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Add Payment Method Input Box
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'e.g. user@okaxis or card number',
                    hintStyle: TextStyle(color: mutedText.withAlpha(120), fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFF181820),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: borderColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cyan,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onPressed: _addMethod,
                child: const Text('Add', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Existing Methods List
          Expanded(
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                final List<PaymentMethodModel> methods =
                    (state is ProfileLoaded) ? state.paymentMethods : [];

                if (methods.isEmpty) {
                  return Center(
                    child: Text(
                      'No saved payment methods',
                      style: TextStyle(color: mutedText.withAlpha(150)),
                    ),
                  );
                }

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: methods.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final method = methods[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF181820),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            method.type == 'card' ? Icons.credit_card : Icons.account_balance,
                            color: cyan,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  method.identifier,
                                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  method.type.toUpperCase(),
                                  style: const TextStyle(color: mutedText, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          if (method.isDefault)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: cyan.withAlpha(25),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'DEFAULT',
                                style: TextStyle(color: cyan, fontSize: 9, fontWeight: FontWeight.w800),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
