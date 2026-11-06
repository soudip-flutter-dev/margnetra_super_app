import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:margnetra_super_app/core/utils/custom_snack_bar.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/digilocker_page/data/models/models.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/digilocker_page/logic/blocs/document_bloc/document_bloc.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/digilocker_page/widgets/upload_document_sheet.dart';

/// DigiLocker page content displaying live vehicle documents from API.
///
/// Designed to be embedded inside an existing navigation shell.
class DigiLockerWidget extends StatefulWidget {

  const DigiLockerWidget({super.key});

  @override
  State<DigiLockerWidget> createState() => _DigiLockerWidgetState();
}

class _DigiLockerWidgetState extends State<DigiLockerWidget> {
  // ---------------------------------------------------------------------------
  // Color palette
  // ---------------------------------------------------------------------------
  static const Color _background = Color(0xFF0A0A0F);
  static const Color _cardColor = Color(0xFF111219);
  static const Color _cardBorder = Color(0xFF242731);

  static const Color _white = Color(0xFFF5F7FA);

  static const Color _mutedText = Color(0xFF858A96);

  static const Color _cyan = Color(0xFF00D9E8);
  static const Color _cyanDark = Color(0xFF00AFC0);
  

  static const Color _validGreen = Color(0xFF35D58A);
  static const Color _warningOrange = Color(0xFFFFA62B);
  static const Color _errorRed = Color(0xFFFF5252);

  final List<String> _filters = ['All', 'RC', 'Insurance', 'PUCC', 'DL'];

  @override
  void initState() {
    super.initState();
    // Ensure documents are loaded if not already triggered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final state = context.read<DocumentBloc>().state;
        if (state is DocumentInitial) {
          context.read<DocumentBloc>().add(const LoadVehicleDocumentsEvent());
        }
      }
    });
  }

  void _onRefresh() {
    context.read<DocumentBloc>().add(
          const LoadVehicleDocumentsEvent(isRefresh: true),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _background,
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _onRefresh();
            await Future.delayed(const Duration(milliseconds: 600));
          },
          color: _cyan,
          backgroundColor: _cardColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ----------------------------------------------------------------
                // Header
                // ----------------------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'DigiLocker',
                      style: TextStyle(
                        color: _white,
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),

                    // Refresh / Sync icon
                    BlocBuilder<DocumentBloc, DocumentState>(
                      builder: (context, state) {
                        final isLoading = state is DocumentLoading;
                        return InkWell(
                          onTap: isLoading ? null : _onRefresh,
                          borderRadius: BorderRadius.circular(13),
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFF12141B),
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(
                                color: _cardBorder,
                                width: 1,
                              ),
                            ),
                            child: isLoading
                                ? const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(_cyan),
                                    ),
                                  )
                                : const Icon(
                                    Icons.refresh_rounded,
                                    color: _white,
                                    size: 22,
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // ----------------------------------------------------------------
                // Filter Tabs (All, RC, Insurance, PUCC, DL)
                // ----------------------------------------------------------------
                BlocBuilder<DocumentBloc, DocumentState>(
                  builder: (context, state) {
                    final selectedType = (state is DocumentLoaded)
                        ? state.selectedType?.toUpperCase()
                        : null;

                    return SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _filters.length,
                        separatorBuilder: (_, index) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final filter = _filters[index];
                          final isSelected = (filter == 'All' &&
                                  (selectedType == null ||
                                      selectedType.isEmpty)) ||
                              (selectedType != null &&
                                  selectedType == filter.toUpperCase());

                          return InkWell(
                            onTap: () {
                              context.read<DocumentBloc>().add(
                                    FilterDocumentsByTypeEvent(
                                      documentType:
                                          filter == 'All' ? null : filter,
                                    ),
                                  );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? _cyan.withValues(alpha: 0.15)
                                    : _cardColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? _cyan : _cardBorder,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                filter,
                                style: TextStyle(
                                  color: isSelected ? _cyan : _mutedText,
                                  fontSize: 12.5,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // ----------------------------------------------------------------
                // Document Grid content
                // ----------------------------------------------------------------
                BlocBuilder<DocumentBloc, DocumentState>(
                  builder: (context, state) {
                    if (state is DocumentLoading &&
                        (state.cachedDocuments == null ||
                            state.cachedDocuments!.isEmpty)) {
                      return _buildLoadingGrid();
                    }

                    if (state is DocumentError &&
                        (state.cachedDocuments == null ||
                            state.cachedDocuments!.isEmpty)) {
                      return _buildErrorCard(state.message);
                    }

                    List<VehicleDocumentModel> docs = [];
                    if (state is DocumentLoaded) {
                      docs = state.displayedDocuments;
                    } else if (state is DocumentLoading &&
                        state.cachedDocuments != null) {
                      docs = state.cachedDocuments!;
                    } else if (state is DocumentError &&
                        state.cachedDocuments != null) {
                      docs = state.cachedDocuments!;
                    }

                    if (docs.isEmpty) {
                      return _buildEmptyState();
                    }

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final cardWidth = (constraints.maxWidth - 12) / 2;

                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: docs
                              .map((doc) => _buildDocumentItem(doc, cardWidth))
                              .toList(),
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 24),

                // ----------------------------------------------------------------
                // Upload / Scan button
                // ----------------------------------------------------------------
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          _cyanDark,
                          _cyan,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: _cyan.withValues(alpha: 0.18),
                          blurRadius: 18,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          _showUploadSheet(context);
                        },
                        child: const Center(
                          child: Text(
                            'UPLOAD / SCAN',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 17),

                // ----------------------------------------------------------------
                // Add New Document link
                // ----------------------------------------------------------------
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _showUploadSheet(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      child: Text(
                        'Add New Document',
                        style: TextStyle(
                          color: _cyan,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Card widget from VehicleDocumentModel
  // ---------------------------------------------------------------------------
  Widget _buildDocumentItem(VehicleDocumentModel doc, double width) {
    final meta = _getDocumentMeta(doc.documentType);

    Color statusColor;
    String statusText;

    if (doc.isExpired) {
      statusColor = _errorRed;
      statusText = doc.statusText.isNotEmpty ? doc.statusText : 'Expired';
    } else if (doc.isExpiringSoon) {
      statusColor = _warningOrange;
      statusText = doc.statusText.isNotEmpty
          ? doc.statusText
          : (doc.daysUntilExpiry > 0
              ? 'Expires in ${doc.daysUntilExpiry}d'
              : 'Expiring Soon');
    } else {
      statusColor = _validGreen;
      statusText = doc.statusText.isNotEmpty ? doc.statusText : 'Valid';
    }

    final String? expiryStr = doc.formattedExpiry.isNotEmpty
        ? 'Exp: ${doc.formattedExpiry}'
        : (doc.expiryDate.isNotEmpty ? 'Exp: ${doc.expiryDate}' : null);

    final String displayTitle = doc.title.isNotEmpty
        ? doc.title
        : (meta.defaultTitle.isNotEmpty
            ? meta.defaultTitle
            : doc.documentType);

    return InkWell(
      onTap: () => _showDocumentDetails(doc),
      borderRadius: BorderRadius.circular(17),
      child: Container(
        width: width,
        height: 160,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: _cardBorder,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Icon + Verified Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 39,
                  height: 39,
                  decoration: BoxDecoration(
                    color: meta.background,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    meta.icon,
                    color: meta.color,
                    size: 21,
                  ),
                ),
                if (doc.verified)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2.5),
                    decoration: BoxDecoration(
                      color: _validGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified_rounded,
                            color: _validGreen, size: 12),
                        SizedBox(width: 3),
                        Text(
                          'Verified',
                          style: TextStyle(
                            color: _validGreen,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const Spacer(),

            // Document title
            Text(
              displayTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _white,
                fontSize: 15.0,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.1,
              ),
            ),

            const SizedBox(height: 4),

            // Document status
            Text(
              statusText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: statusColor,
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
              ),
            ),

            // Expiry or document number
            if (expiryStr != null) ...[
              const SizedBox(height: 3),
              Text(
                expiryStr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _mutedText,
                  fontSize: 11.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ] else if (doc.documentNumber.isNotEmpty) ...[
              const SizedBox(height: 3),
              Text(
                doc.documentNumber,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _mutedText,
                  fontSize: 11.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Metadata resolver for document types
  // ---------------------------------------------------------------------------
  _DocumentTypeMeta _getDocumentMeta(String type) {
    final t = type.toUpperCase().trim();
    if (t.contains('RC')) {
      return _DocumentTypeMeta(
        icon: Icons.directions_car_outlined,
        background: const Color(0xFF102A46),
        color: const Color(0xFF4CA8FF),
        defaultTitle: 'RC',
      );
    } else if (t.contains('INSUR')) {
      return _DocumentTypeMeta(
        icon: Icons.shield_outlined,
        background: const Color(0xFF102A46),
        color: const Color(0xFF4CA8FF),
        defaultTitle: 'Insurance',
      );
    } else if (t.contains('PUC')) {
      return _DocumentTypeMeta(
        icon: Icons.eco_outlined,
        background: const Color(0xFF3A2111),
        color: _warningOrange,
        defaultTitle: 'PUCC',
      );
    } else if (t.contains('DL') || t.contains('LICENSE')) {
      return _DocumentTypeMeta(
        icon: Icons.badge_outlined,
        background: const Color(0xFF251C46),
        color: const Color(0xFF9A7BFF),
        defaultTitle: 'Driving License',
      );
    }
    return _DocumentTypeMeta(
      icon: Icons.description_outlined,
      background: const Color(0xFF14202D),
      color: _cyan,
      defaultTitle: type.isNotEmpty ? type : 'Document',
    );
  }

  // ---------------------------------------------------------------------------
  // Skeleton loading grid
  // ---------------------------------------------------------------------------
  Widget _buildLoadingGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 12) / 2;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(
            4,
            (index) => Container(
              width: cardWidth,
              height: 154,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 39,
                    height: 39,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 70,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 90,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Error view
  // ---------------------------------------------------------------------------
  Widget _buildErrorCard(String error) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _errorRed.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.cloud_off_rounded, color: _errorRed, size: 36),
          const SizedBox(height: 12),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: _onRefresh,
            icon: const Icon(Icons.refresh_rounded, size: 16, color: _cyan),
            label: const Text('Try Again', style: TextStyle(color: _cyan)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: _cyan),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Empty state view
  // ---------------------------------------------------------------------------
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          Icon(
            Icons.folder_open_rounded,
            color: _cyan.withValues(alpha: 0.6),
            size: 48,
          ),
          const SizedBox(height: 12),
          const Text(
            'No Documents Found',
            style: TextStyle(
              color: _white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'You have not added any documents to DigiLocker yet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _mutedText,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Document details sheet
  // ---------------------------------------------------------------------------
  void _showDocumentDetails(VehicleDocumentModel doc) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F121C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    doc.title.isNotEmpty ? doc.title : doc.documentType,
                    style: const TextStyle(
                      color: _white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (doc.verified)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _validGreen.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified_rounded,
                              color: _validGreen, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Verified',
                            style: TextStyle(
                              color: _validGreen,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                  'Document Type',
                  doc.documentType.isNotEmpty
                      ? doc.documentType
                      : 'Not specified'),
              if (doc.documentNumber.isNotEmpty)
                _buildDetailRow('Document Number', doc.documentNumber),
              _buildDetailRow(
                  'Status', doc.statusText.isNotEmpty ? doc.statusText : doc.status),
              if (doc.formattedExpiry.isNotEmpty || doc.expiryDate.isNotEmpty)
                _buildDetailRow(
                    'Expiry Date',
                    doc.formattedExpiry.isNotEmpty
                        ? doc.formattedExpiry
                        : doc.expiryDate),
              if (doc.daysUntilExpiry > 0)
                _buildDetailRow('Days Until Expiry', '${doc.daysUntilExpiry} days'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(bottomSheetContext);
                    CustomSnackBar.showInfo(
                      context,
                      'Opening document preview...',
                    );
                  },
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('View Document'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _cyan,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showUploadSheet(BuildContext ctx) {
    UploadDocumentSheet.show(ctx);
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: _mutedText, fontSize: 13),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: _white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentTypeMeta {
  final IconData icon;
  final Color background;
  final Color color;
  final String defaultTitle;

  _DocumentTypeMeta({
    required this.icon,
    required this.background,
    required this.color,
    required this.defaultTitle,
  });
}

/// Convenience alias allowing the page to be imported as DigiLockerPage or DigiLockerWidget
typedef DigiLockerPage = DigiLockerWidget;
