import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/theme/app_colors.dart';

import 'package:loanofficer/core/bases/base_state.dart';
import 'package:loanofficer/core/bases/states/base/base_state.dart';
import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/home/bloc/home_bloc.dart';
import 'package:loanofficer/presenter/home/model/home_model.dart';
import 'package:loanofficer/presenter/home/widgets/officer_identity_bar.dart';

/// Fusion dashboard: the password alert, breadcrumb, and the two logos.
class HomeScene extends StatefulWidget {
  const HomeScene({super.key});

  @override
  State<HomeScene> createState() => _HomeSceneState();
}

class _HomeSceneState extends BaseState<HomeScene, HomeBloc, HomeModel> {
  @override
  Widget buildWidget(BuildContext context, RenderDataState<HomeModel> state) {
    final data = state.data;
    return ColoredBox(
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (data.date.isNotEmpty ||
              data.name.isNotEmpty ||
              data.role.isNotEmpty)
            OfficerIdentityBar(
              date: data.date,
              name: data.name,
              branch: data.branch,
              role: data.role,
            ),
          if (data.alerts.isNotEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2E2),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  child: Text(
                    data.alerts.join('\n'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFFCC8925),
                      fontSize: 14.sp,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
            child: Text(
              'الرئيسية / طلباتي',
              textAlign: TextAlign.right,
              style: TextStyle(color: const Color(0xFF777777), fontSize: 14.sp),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/logo_tanmeyah.png',
                        height: 72.h,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 18.w),
                      Image.asset(
                        'assets/images/logo_fmc.png',
                        height: 72.h,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.line),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo_fmc.png',
                  height: 22.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 8.w),
                Text(
                  'جميع الحقوق محفوظة © FMC.',
                  style: TextStyle(
                    color: const Color(0xFF495057),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void listenToState(BuildContext context, BaseStates state) {}

  @override
  HomeBloc createBloc() => HomeBloc(HomeModel());
}
