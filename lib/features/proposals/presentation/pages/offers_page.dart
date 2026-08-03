import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/result.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../../../shared/widgets/layout/app_top_bar.dart';
import '../../../../shared/widgets/layout/screen.dart';
import '../../domain/models/offer.dart';
import '../../domain/repositories/offer_repository.dart';

final class OffersPage extends StatefulWidget {
  const OffersPage({
    required this.orderId,
    required this.repository,
    super.key,
  });
  final String orderId;
  final OfferRepository repository;
  @override
  State<OffersPage> createState() => _OffersPageState();
}

final class _OffersPageState extends State<OffersPage> {
  late Future<Result<List<Offer>>> _future = widget.repository.getOffers(
    widget.orderId,
  );
  void _retry() {
    setState(() {
      _future = widget.repository.getOffers(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) => Screen(
    padding: EdgeInsets.zero,
    appBar: AppTopBar(
      title: AppLocalizations.of(context)!.technicianOffers,
      subtitle: AppLocalizations.of(context)!.updatingLive,
      onBack: () => context.pop(),
    ),
    child: FutureBuilder<Result<List<Offer>>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        final result = snapshot.data;
        if (result is ErrorResult<List<Offer>>) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  result.failure.message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: AppSpacing.space16),
                PrimaryButton(
                  label: AppLocalizations.of(context)!.retry,
                  variant: PrimaryButtonVariant.outline,
                  onPressed: _retry,
                ),
              ],
            ),
          );
        }
        if (result is Success<List<Offer>>) {
          if (result.value.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.empty));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.space20),
            itemCount: result.value.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.space12),
            itemBuilder: (context, index) => _OfferCard(
              offer: result.value[index],
              onAccept: () => _accept(result.value[index]),
            ),
          );
        }
        return Center(child: Text(AppLocalizations.of(context)!.error));
      },
    ),
  );
  Future<void> _accept(Offer offer) async {
    final result = await widget.repository.acceptOffer(offer.id);
    if (!mounted) return;
    if (result is ErrorResult<Offer>) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.failure.message)));
      return;
    }
    context.pop();
  }
}

final class _OfferCard extends StatelessWidget {
  const _OfferCard({required this.offer, required this.onAccept});
  final Offer offer;
  final VoidCallback onAccept;
  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          offer.masterName ?? AppLocalizations.of(context)!.technician,
          style: AppTextStyles.titleMedium,
        ),
        const SizedBox(height: AppSpacing.space8),
        Text(
          '${AppLocalizations.of(context)!.arrival}: ${offer.arrivalTime}',
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: AppSpacing.space4),
        Text(
          '${offer.price.toStringAsFixed(0)} ₸',
          style: AppTextStyles.headlineMedium,
        ),
        if (offer.comment case final comment?) ...[
          const SizedBox(height: AppSpacing.space8),
          Text(comment, style: AppTextStyles.bodySmall),
        ],
        const SizedBox(height: AppSpacing.space12),
        PrimaryButton(
          label: AppLocalizations.of(context)!.acceptOffer,
          onPressed: offer.status == 'ACTIVE' ? onAccept : null,
        ),
      ],
    ),
  );
}
