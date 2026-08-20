import 'package:flutter/material.dart';

/// e-Challan & RTO page content.
///
/// This widget is designed to be embedded inside an existing navigation shell.
/// It intentionally does NOT contain a Scaffold, BottomNavigationBar, or
/// navigation-related code.
class EChallanWidget extends StatefulWidget {
  const EChallanWidget({super.key});

  @override
  State<EChallanWidget> createState() => _EChallanWidgetState();
}

class _EChallanWidgetState extends State<EChallanWidget> {
  // ---------------------------------------------------------------------------
  // Static challan data
  // ---------------------------------------------------------------------------
  static const List<Map<String, dynamic>> _challans = [
    {
      'number': '12345',
      'status': 'Unpaid',
      'date': '20 Apr 2025',
      'amount': '₹500',
      'violation': 'Speeding',
      'isPaid': false,
    },
    {
      'number': '12344',
      'status': 'Paid',
      'date': '18 Apr 2025',
      'amount': '₹300',
      'violation': 'No Helmet',
      'isPaid': true,
    },
    {
      'number': '12343',
      'status': 'Paid',
      'date': '15 Apr 2025',
      'amount': '₹200',
      'violation': 'Signal Jump',
      'isPaid': true,
    },
  ];

  // ---------------------------------------------------------------------------
  // Colors
  // ---------------------------------------------------------------------------
  static const Color _background = Color(0xFF0A0A0F);
  static const Color _cardBackground = Color(0xFF101116);
  static const Color _cardBorder = Color(0xFF242832);

  static const Color _cyan = Color(0xFF16D9E3);
  static const Color _cyanDark = Color(0xFF0EA5B7);

  static const Color _white = Color(0xFFF5F7FA);
  static const Color _secondaryText = Color(0xFF858B98);

  static const Color _unpaid = Color(0xFFFFB84D);
  static const Color _paid = Color(0xFF36D399);
  static const Color _danger = Color(0xFFFF4D5E);

  String _selectedFilter = 'Unpaid';
  final Set<String> _expandedChallanNumbers = <String>{};

  List<Map<String, dynamic>> get _visibleChallans {
    if (_selectedFilter == 'All') {
      return _challans;
    }

    final bool showPaid = _selectedFilter == 'Paid';
    return _challans.where((challan) => challan['isPaid'] == showPaid).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _background,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ----------------------------------------------------------------
              // Header
              // ----------------------------------------------------------------
              _buildHeader(),

              const SizedBox(height: 22),

              // ----------------------------------------------------------------
              // SYNC RTO button
              // ----------------------------------------------------------------
              _buildSyncButton(),

              const SizedBox(height: 18),

              // ----------------------------------------------------------------
              // Filter tabs
              // ----------------------------------------------------------------
              _buildFilterTabs(),

              const SizedBox(height: 18),

              // ----------------------------------------------------------------
              // Challan cards
              // ----------------------------------------------------------------
              ..._visibleChallans.asMap().entries.map((entry) {
                final index = entry.key;
                final challan = entry.value;

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == _visibleChallans.length - 1 ? 0 : 12,
                  ),
                  child: _buildChallanCard(challan),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Header: title + civil score + notification
  // ---------------------------------------------------------------------------
  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Text(
            'e-Challan & RTO',
            style: TextStyle(
              color: _white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
        ),

        // Civil-score style badge.
        Container(
          height: 27,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1C22),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF30343D), width: 1),
          ),
          alignment: Alignment.center,
          child: const Text(
            '78',
            style: TextStyle(
              color: _white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Notification icon with red unread indicator.
        Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(
              Icons.notifications_none_rounded,
              color: _white,
              size: 25,
            ),
            Positioned(
              right: -1,
              top: -1,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _danger,
                  shape: BoxShape.circle,
                  border: Border.all(color: _background, width: 1.2),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // SYNC RTO outlined button
  // ---------------------------------------------------------------------------
  Widget _buildSyncButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: _cyan,
          side: const BorderSide(color: _cyan, width: 1.2),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.zero,
        ),
        child: const Text(
          'SYNC RTO',
          style: TextStyle(
            color: _cyan,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Filter tabs: All / Unpaid / Paid
  // ---------------------------------------------------------------------------
  Widget _buildFilterTabs() {
    return Container(
      height: 43,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0F14),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1F232B), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterTab(
              label: 'All',
              selected: _selectedFilter == 'All',
            ),
          ),
          Expanded(
            child: _buildFilterTab(
              label: 'Unpaid',
              selected: _selectedFilter == 'Unpaid',
              badge: _challans
                  .where((challan) => challan['isPaid'] == false)
                  .length
                  .toString(),
            ),
          ),
          Expanded(
            child: _buildFilterTab(
              label: 'Paid',
              selected: _selectedFilter == 'Paid',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab({
    required String label,
    required bool selected,
    String? badge,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF20242C) : Colors.transparent,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(9),
          onTap: () {
            setState(() {
              _selectedFilter = label;
            });
          },
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: selected ? _white : _secondaryText,
                    fontSize: 12.5,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),

                if (badge != null) ...[
                  const SizedBox(width: 6),
                  Container(
                    width: 18,
                    height: 18,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: _danger,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Individual challan card
  // ---------------------------------------------------------------------------
  Widget _buildChallanCard(Map<String, dynamic> challan) {
    final String challanNumber = challan['number'] as String;
    final bool isPaid = challan['isPaid'] as bool;
    final bool isExpanded = _expandedChallanNumbers.contains(challanNumber);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: _cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------------------------------------------------------
          // Challan number + status icon + chevron
          // ---------------------------------------------------------------
          Row(
            children: [
              if (isPaid)
                Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Color(0xFF173B31),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: _paid,
                    size: 15,
                  ),
                )
              else
                const Icon(Icons.location_on_outlined, color: _cyan, size: 22),

              const SizedBox(width: 9),

              Expanded(
                child: Text(
                  'Challan #${challan['number']}',
                  style: const TextStyle(
                    color: _white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              IconButton(
                onPressed: () {
                  setState(() {
                    if (isExpanded) {
                      _expandedChallanNumbers.remove(challanNumber);
                    } else {
                      _expandedChallanNumbers.add(challanNumber);
                    }
                  });
                },
                tooltip: isExpanded ? 'Close challan' : 'Open challan',
                icon: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: _secondaryText,
                  size: 22,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),
            ],
          ),

          if (isExpanded) ...[
            const SizedBox(height: 13),

            // ---------------------------------------------------------------
            // Status + date + amount
            // ---------------------------------------------------------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  challan['status'] as String,
                  style: TextStyle(
                    color: isPaid ? _paid : _unpaid,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  child: Text(
                    '•',
                    style: TextStyle(color: _secondaryText, fontSize: 11),
                  ),
                ),

                Text(
                  challan['date'] as String,
                  style: const TextStyle(
                    color: _secondaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Spacer(),

                Text(
                  challan['amount'] as String,
                  style: const TextStyle(
                    color: _white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 9),

            // ---------------------------------------------------------------
            // Violation type
            // ---------------------------------------------------------------
            Text(
              challan['violation'] as String,
              style: const TextStyle(
                color: _secondaryText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),

            // ---------------------------------------------------------------
            // PAY NOW button — only for unpaid challans
            // ---------------------------------------------------------------
            if (!isPaid) ...[const SizedBox(height: 14), _buildPayNowButton()],
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PAY NOW button
  // ---------------------------------------------------------------------------
  Widget _buildPayNowButton() {
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: _cyanDark,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.zero,
        ),
        child: const Text(
          'PAY NOW',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.7,
          ),
        ),
      ),
    );
  }
}
