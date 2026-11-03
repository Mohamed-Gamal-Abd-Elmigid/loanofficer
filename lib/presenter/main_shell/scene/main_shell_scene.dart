import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/auth/logout_flow.dart';
import 'package:loanofficer/core/components/tanmeyah_brand_logo.dart';
import 'package:loanofficer/core/bases/base_state.dart';
import 'package:loanofficer/core/bases/states/base/base_state.dart';
import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_typography.dart';
import 'package:loanofficer/presenter/fund_track/scene/fund_track_scene.dart';
import 'package:loanofficer/presenter/main_shell/bloc/main_shell_bloc.dart';
import 'package:loanofficer/presenter/main_shell/model/main_shell_model.dart';
import 'package:loanofficer/presenter/main_shell/scene/create_tab_scene.dart';
import 'package:loanofficer/presenter/personal_fund_inquiry/scene/personal_fund_inquiry_scene.dart';

class MainShellScene extends StatefulWidget {
  const MainShellScene({super.key});

  @override
  State<MainShellScene> createState() => _MainShellSceneState();
}

class _MainShellSceneState
    extends BaseState<MainShellScene, MainShellBloc, MainShellModel> {
  int _index = 0;

  static const _titles = [
    'إنشاء طلب تمويل فردي جديد',
    'متابعة الطلبات',
    'استعلام تمويل فردي',
  ];

  List<Widget> get _pages => [
        const CreateTabScene(),
        const FundTrackScene(embedInShell: true),
        const PersonalFundInquiryScene(embedInShell: true),
      ];

  @override
  Widget buildWidget(
    BuildContext context,
    RenderDataState<MainShellModel> state,
  ) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _MainHeader(
              title: _titles[_index],
              showLogout: _index == 2,
            ),
            Expanded(child: _pages[_index]),
            _MainBottomBar(
              index: _index,
              onChanged: (value) => setState(() => _index = value),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void listenToState(BuildContext context, BaseStates state) {}

  @override
  MainShellBloc createBloc() => MainShellBloc(MainShellModel());
}

class _MainHeader extends StatelessWidget {
  const _MainHeader({
    required this.title,
    required this.showLogout,
  });

  final String title;
  final bool showLogout;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 6.h, 8.w, 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 44.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: showLogout
                      ? IconButton(
                          onPressed: () => confirmAndSignOut(context),
                          icon: Icon(
                            Icons.logout_rounded,
                            color: AppColors.primary,
                            size: 26.r,
                          ),
                          tooltip: 'تسجيل الخروج',
                        )
                      : IconButton(
                          onPressed: _noop,
                          icon: Icon(
                            Icons.notifications,
                            color: AppColors.bell,
                            size: 26.r,
                          ),
                        ),
                ),
                const TanmeyahBrandLogo(height: 38),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.appBar(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

void _noop() {}

class _MainBottomBar extends StatelessWidget {
  const _MainBottomBar({required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              _NavItem(
                selected: index == 0,
                label: 'إنشاء',
                icon: Icon(
                  index == 0 ? Icons.add_circle : Icons.add_circle_outline,
                ),
                onTap: () => onChanged(0),
              ),
              _NavItem(
                selected: index == 1,
                label: 'متابعة',
                icon: Icon(
                  index == 1
                      ? Icons.fact_check
                      : Icons.fact_check_outlined,
                ),
                onTap: () => onChanged(1),
              ),
              _NavItem(
                selected: index == 2,
                label: 'استعلام',
                icon: Icon(
                  index == 2
                      ? Icons.manage_search
                      : Icons.manage_search_outlined,
                ),
                onTap: () => onChanged(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.selected,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final bool selected;
  final String label;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.idle;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconTheme(
              data: IconThemeData(color: color, size: 26.r),
              child: icon,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.dinNextArabic,
                color: color,
                fontSize: 12.sp,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
