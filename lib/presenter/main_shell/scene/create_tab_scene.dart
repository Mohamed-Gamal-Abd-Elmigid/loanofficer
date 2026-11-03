import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/bases/base_state.dart';
import 'package:loanofficer/core/bases/states/base/base_state.dart';
import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/presenter/home/bloc/home_bloc.dart';
import 'package:loanofficer/presenter/home/model/home_model.dart';
import 'package:loanofficer/presenter/home/widgets/officer_identity_bar.dart';
import 'package:loanofficer/presenter/new_individual_request/scene/new_individual_request_scene.dart';

/// Tab 1 — إنشاء: identity bar + new individual request flow.
class CreateTabScene extends StatefulWidget {
  const CreateTabScene({super.key});

  @override
  State<CreateTabScene> createState() => _CreateTabSceneState();
}

class _CreateTabSceneState
    extends BaseState<CreateTabScene, HomeBloc, HomeModel> {
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
              data.branch.isNotEmpty ||
              data.role.isNotEmpty)
            OfficerIdentityBar(
              date: data.date,
              name: data.name,
              branch: data.branch,
              role: data.role,
            ),
          if (data.alerts.isNotEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
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
          const Expanded(
            child: NewIndividualRequestScene(embedInShell: true),
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
