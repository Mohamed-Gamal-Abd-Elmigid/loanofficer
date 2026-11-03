import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/bases/base_state.dart';
import 'package:loanofficer/core/bases/states/base/base_state.dart';
import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_typography.dart';
import 'package:loanofficer/presenter/financing/bloc/financing_bloc.dart';
import 'package:loanofficer/presenter/financing/model/financing_model.dart';
import 'package:loanofficer/presenter/fund_track/scene/fund_track_scene.dart';
import 'package:loanofficer/presenter/new_individual_request/scene/new_individual_request_scene.dart';
import 'package:loanofficer/presenter/personal_fund_inquiry/scene/personal_fund_inquiry_scene.dart';

const _brandGradient = LinearGradient(
  colors: [AppColors.primary, AppColors.accent],
  begin: Alignment.centerRight,
  end: Alignment.centerLeft,
);

class FinancingScene extends StatefulWidget {
  const FinancingScene({super.key});

  @override
  State<FinancingScene> createState() => _FinancingSceneState();
}

class _FinancingSceneState
    extends BaseState<FinancingScene, FinancingBloc, FinancingModel> {
  @override
  Widget buildWidget(
    BuildContext context,
    RenderDataState<FinancingModel> state,
  ) {
    return ColoredBox(
      color: AppColors.page,
      child: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 28.h),
        children: [
          _FinancingIntroHeader(),
          SizedBox(height: 16.h),
          _ActionCard(
            icon: Icons.add_rounded,
            title: 'إنشاء طلب تمويل فردي',
            subtitle: 'أنشئ طلب تمويل فردي جديد',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const NewIndividualRequestScene(),
                ),
              );
            },
          ),
          SizedBox(height: 12.h),
          _ActionCard(
            icon: Icons.fact_check_outlined,
            title: 'متابعة طلبات التمويل',
            subtitle:
                'استعرض طلبات العملاء وتابع حالتها\nوأجرِ التعديلات المطلوبة',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const FundTrackScene()),
              );
            },
          ),
          SizedBox(height: 12.h),
          _ActionCard(
            icon: Icons.manage_search_rounded,
            title: 'استعلام تمويل فردي',
            subtitle:
                'ابحث برقم البطاقة أو رقم التمويل\nوإجراءات مراجعة الطلب من القائمة',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const PersonalFundInquiryScene(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void listenToState(BuildContext context, BaseStates state) {}

  @override
  FinancingBloc createBloc() => FinancingBloc(FinancingModel());
}

class _FinancingIntroHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(height: 4.h, decoration: const BoxDecoration(gradient: _brandGradient)),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
            child: Row(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48.r,
                  height: 48.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: _brandGradient,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: AppColors.white,
                    size: 26.r,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'الخدمات التمويلية',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: AppFonts.dinNextArabic,
                          color: AppColors.primary,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'إنشاء الطلبات، المتابعة، والاستعلام من شاشة واحدة',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: AppFonts.dinNextArabic,
                          color: AppColors.fieldLabel,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 14.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 3.h,
                decoration: BoxDecoration(
                  gradient: _brandGradient,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(18.r),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(14.w, 14.h, 16.w, 16.h),
                child: Row(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 50.r,
                      height: 50.r,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.iconBubble,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Icon(icon, color: AppColors.accent, size: 26.r),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: AppFonts.dinNextArabic,
                              color: AppColors.primary,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w800,
                              height: 1.25,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            subtitle,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: AppFonts.dinNextArabic,
                              color: AppColors.fieldLabel,
                              fontSize: 12.sp,
                              height: 1.4,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Icon(
                      Icons.chevron_left_rounded,
                      color: AppColors.accent.withValues(alpha: 0.65),
                      size: 28.r,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
