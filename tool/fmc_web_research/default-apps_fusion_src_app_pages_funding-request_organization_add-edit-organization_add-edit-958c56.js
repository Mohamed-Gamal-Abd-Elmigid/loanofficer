"use strict";
(self["webpackChunkfusion"] = self["webpackChunkfusion"] || []).push([["default-apps_fusion_src_app_pages_funding-request_organization_add-edit-organization_add-edit-958c56"],{

/***/ 13209:
/*!*************************************************************************************************************************!*\
  !*** ./apps/fusion/src/app/pages/funding-request/organization/add-edit-organization/add-edit-organization.component.ts ***!
  \*************************************************************************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "AddEditOrganizationComponent": () => (/* binding */ AddEditOrganizationComponent)
/* harmony export */ });
/* harmony import */ var D_Tanmeyah_frontend_fmc_cOPY_node_modules_babel_runtime_helpers_esm_asyncToGenerator_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./node_modules/@babel/runtime/helpers/esm/asyncToGenerator.js */ 71670);
/* harmony import */ var tslib__WEBPACK_IMPORTED_MODULE_25__ = __webpack_require__(/*! tslib */ 42321);
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_12__ = __webpack_require__(/*! @angular/core */ 22560);
/* harmony import */ var _angular_forms__WEBPACK_IMPORTED_MODULE_14__ = __webpack_require__(/*! @angular/forms */ 2508);
/* harmony import */ var _fusionCore_models_enum_LocalStorageKeys_enum__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @fusionCore/models/enum/LocalStorageKeys.enum */ 83906);
/* harmony import */ var _microSharedLib_core_models_classes_FusionBase__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! @microSharedLib/core/models/classes/FusionBase */ 74591);
/* harmony import */ var _microSharedLib_core_models_enum_FusionHttpStatus_enum__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! @microSharedLib/core/models/enum/FusionHttpStatus.enum */ 79090);
/* harmony import */ var _microSharedLib_services_application_lookups_service__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! @microSharedLib/services/application-lookups.service */ 71516);
/* harmony import */ var _microSharedLib_services_financial_policies_service__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! @microSharedLib/services/financial-policies.service */ 10544);
/* harmony import */ var _microSharedLib_services_rejection_reasons_service__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(/*! @microSharedLib/services/rejection-reasons.service */ 61919);
/* harmony import */ var _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(/*! @microSharedLib/shared/validator/CustomValidation */ 91067);
/* harmony import */ var _ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_13__ = __webpack_require__(/*! @ngneat/until-destroy */ 82777);
/* harmony import */ var moment__WEBPACK_IMPORTED_MODULE_8__ = __webpack_require__(/*! moment */ 56908);
/* harmony import */ var moment__WEBPACK_IMPORTED_MODULE_8___default = /*#__PURE__*/__webpack_require__.n(moment__WEBPACK_IMPORTED_MODULE_8__);
/* harmony import */ var primeng_dynamicdialog__WEBPACK_IMPORTED_MODULE_15__ = __webpack_require__(/*! primeng/dynamicdialog */ 62648);
/* harmony import */ var _microSharedLib_services_lookups_service__WEBPACK_IMPORTED_MODULE_9__ = __webpack_require__(/*! @microSharedLib/services/lookups.service */ 98016);
/* harmony import */ var _angular_common__WEBPACK_IMPORTED_MODULE_16__ = __webpack_require__(/*! @angular/common */ 94666);
/* harmony import */ var _libs_shared_lib_src_lib_shared_UI_Components_form_validation_error_form_validation_error_component__WEBPACK_IMPORTED_MODULE_10__ = __webpack_require__(/*! ../../../../../../../../libs/shared-lib/src/lib/shared/UI-Components/form-validation-error/form-validation-error.component */ 32609);
/* harmony import */ var primeng_inputtext__WEBPACK_IMPORTED_MODULE_17__ = __webpack_require__(/*! primeng/inputtext */ 69906);
/* harmony import */ var primeng_dropdown__WEBPACK_IMPORTED_MODULE_18__ = __webpack_require__(/*! primeng/dropdown */ 38992);
/* harmony import */ var primeng_inputnumber__WEBPACK_IMPORTED_MODULE_19__ = __webpack_require__(/*! primeng/inputnumber */ 87990);
/* harmony import */ var primeng_button__WEBPACK_IMPORTED_MODULE_20__ = __webpack_require__(/*! primeng/button */ 76328);
/* harmony import */ var primeng_accordion__WEBPACK_IMPORTED_MODULE_21__ = __webpack_require__(/*! primeng/accordion */ 79854);
/* harmony import */ var primeng_calendar__WEBPACK_IMPORTED_MODULE_22__ = __webpack_require__(/*! primeng/calendar */ 32547);
/* harmony import */ var primeng_ripple__WEBPACK_IMPORTED_MODULE_23__ = __webpack_require__(/*! primeng/ripple */ 84538);
/* harmony import */ var _libs_shared_lib_src_lib_shared_directives_rtl_directive__WEBPACK_IMPORTED_MODULE_11__ = __webpack_require__(/*! ../../../../../../../../libs/shared-lib/src/lib/shared/directives/rtl.directive */ 9638);
/* harmony import */ var _ngx_translate_core__WEBPACK_IMPORTED_MODULE_24__ = __webpack_require__(/*! @ngx-translate/core */ 38699);

































function AddEditOrganizationComponent_div_1_Template(rf, ctx) {
  if (rf & 1) {
    const _r4 = _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵgetCurrentView"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](0, "div", 90)(1, "button", 91);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵlistener"]("click", function AddEditOrganizationComponent_div_1_Template_button_click_1_listener() {
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵrestoreView"](_r4);
      const ctx_r3 = _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵnextContext"]();
      return _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵresetView"](ctx_r3.closeDialog());
    });
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]()();
  }
}
function AddEditOrganizationComponent_ng_container_277_button_56_Template(rf, ctx) {
  if (rf & 1) {
    const _r11 = _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵgetCurrentView"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](0, "button", 113);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵlistener"]("click", function AddEditOrganizationComponent_ng_container_277_button_56_Template_button_click_0_listener() {
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵrestoreView"](_r11);
      const i_r6 = _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵnextContext"]().index;
      const ctx_r9 = _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵnextContext"]();
      return _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵresetView"](ctx_r9.removePartnerArrayItem(i_r6));
    });
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
  }
  if (rf & 2) {
    const ctx_r7 = _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵnextContext"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("disabled", ctx_r7.isEditMode == "VIEW");
  }
}
function AddEditOrganizationComponent_ng_container_277_button_57_Template(rf, ctx) {
  if (rf & 1) {
    const _r13 = _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵgetCurrentView"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](0, "button", 113);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵlistener"]("click", function AddEditOrganizationComponent_ng_container_277_button_57_Template_button_click_0_listener() {
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵrestoreView"](_r13);
      const ctx_r12 = _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵnextContext"](2);
      return _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵresetView"](ctx_r12.clearPartnetArrayItem());
    });
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
  }
  if (rf & 2) {
    const ctx_r8 = _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵnextContext"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("disabled", ctx_r8.isEditMode == "VIEW");
  }
}
const _c0 = function () {
  return ["required", "notArabic"];
};
const _c1 = function () {
  return ["required", "notValidNationalId"];
};
const _c2 = function () {
  return ["required", "startWithSpace"];
};
const _c3 = function () {
  return ["required", "startWithSpace", "notArabic"];
};
function AddEditOrganizationComponent_ng_container_277_Template(rf, ctx) {
  if (rf & 1) {
    const _r15 = _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵgetCurrentView"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementContainerStart"](0)(1, 92);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](2, "div", 57)(3, "label", 93);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](4);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](5, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](6, "input", 94);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](7, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](8, "lib-form-validation-error", 9);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](9, "div", 57)(10, "label", 95);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](11);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](12, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](13, "input", 96);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](14, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](15, "lib-form-validation-error", 9);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](16, "div", 57)(17, "label", 97);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](18);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](19, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](20, "p-calendar", 98);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](21, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](22, "lib-form-validation-error", 9);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](23, "div", 57)(24, "label", 99);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](25);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](26, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](27, "p-dropdown", 100);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](28, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](29, "lib-form-validation-error", 9);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](30, "div", 57)(31, "label", 101);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](32);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](33, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](34, "input", 102);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](35, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](36, "lib-form-validation-error", 9);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](37, "div", 57)(38, "label", 103);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](39);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](40, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](41, "div", 104);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](42, "p-inputNumber", 105);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](43, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](44, "span", 106);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](45, "i", 107);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]()();
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](46, "lib-form-validation-error", 9);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](47, "div", 57)(48, "label", 108);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](49);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](50, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](51, "input", 109);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](52, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](53, "lib-form-validation-error", 9);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](54, "div", 110)(55, "button", 111);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵlistener"]("click", function AddEditOrganizationComponent_ng_container_277_Template_button_click_55_listener() {
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵrestoreView"](_r15);
      const ctx_r14 = _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵnextContext"]();
      return _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵresetView"](ctx_r14.addPartnerArrayItem());
    });
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtemplate"](56, AddEditOrganizationComponent_ng_container_277_button_56_Template, 1, 1, "button", 112);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtemplate"](57, AddEditOrganizationComponent_ng_container_277_button_57_Template, 1, 1, "button", 112);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementContainerEnd"]()();
  }
  if (rf & 2) {
    const i_r6 = ctx.index;
    const ctx_r1 = _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵnextContext"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](1);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formGroupName", i_r6);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](5, 50, ctx_r1.messageTranslationPrefix + "PARTNER-NAME"));
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](7, 52, ctx_r1.messageTranslationPrefix + "PARTNER-NAME"));
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx_r1.organizationForm)("controlName", "name")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](78, _c0));
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](12, 54, ctx_r1.messageTranslationPrefix + "PARTNER-IDNO"));
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](14, 56, ctx_r1.messageTranslationPrefix + "PARTNER-IDNO"));
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("maxlength", 14);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx_r1.organizationForm)("controlName", "idno")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](79, _c1));
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](19, 58, ctx_r1.messageTranslationPrefix + "PARTNER-BIRTHDATE"));
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](21, 60, ctx_r1.messageTranslationPrefix + "PARTNER-BIRTHDATE"));
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("showIcon", true)("readonlyInput", true);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx_r1.organizationForm)("controlName", "bod")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](80, _c2));
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](26, 62, ctx_r1.messageTranslationPrefix + "PARTNER-NATION-CODE"));
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](28, 64, ctx_r1.messageTranslationPrefix + "PARTNER-NATION-CODE"));
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("options", ctx_r1.nationalitiesList)("optionLabel", ctx_r1.currentLanguage === "ar" ? "nameAr" : "nameEn")("showClear", false)("filter", true);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx_r1.organizationForm)("controlName", "nationCode")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](81, _c3));
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](33, 66, ctx_r1.messageTranslationPrefix + "PARTNER-ROLE"));
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](35, 68, ctx_r1.messageTranslationPrefix + "PARTNER-ROLE"));
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx_r1.organizationForm)("controlName", "role")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](82, _c2));
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](40, 70, ctx_r1.messageTranslationPrefix + "PARTNER-RATIO"));
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](43, 72, ctx_r1.messageTranslationPrefix + "PARTNER-RATIO"));
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("useGrouping", false)("min", 0)("max", 100)("maxlength", 3);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](4);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx_r1.organizationForm)("controlName", "partnerRatio")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](83, _c2));
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](50, 74, ctx_r1.messageTranslationPrefix + "PARTNER-AMOUNT"));
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](52, 76, ctx_r1.messageTranslationPrefix + "PARTNER-AMOUNT"));
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx_r1.organizationForm)("controlName", "partnerAmt")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](84, _c2));
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("disabled", ctx_r1.isEditMode == "VIEW");
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](1);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("ngIf", ctx_r1.getPartnerArray().length > 1);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](1);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("ngIf", ctx_r1.getPartnerArray() && ctx_r1.getPartnerArray().length <= 1);
  }
}
function AddEditOrganizationComponent_button_279_Template(rf, ctx) {
  if (rf & 1) {
    const _r17 = _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵgetCurrentView"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](0, "button", 114);
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵlistener"]("click", function AddEditOrganizationComponent_button_279_Template_button_click_0_listener() {
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵrestoreView"](_r17);
      const ctx_r16 = _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵnextContext"]();
      return _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵresetView"](ctx_r16.isEditMode === "INSERT" ? ctx_r16.save() : ctx_r16.update());
    });
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](1, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](2, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
  }
  if (rf & 2) {
    const ctx_r2 = _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵnextContext"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("label", ctx_r2.isEditMode === "INSERT" ? _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](1, 1, ctx_r2.commonMessages + "SAVE-TEXT") : _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](2, 3, ctx_r2.commonMessages + "EDIT-TEXT"));
  }
}
const _c4 = function () {
  return ["required", "startWithSpace", "notStartWithSpecialCharacter"];
};
const _c5 = function () {
  return ["required", "startWithSpace", "notAlphaOnly"];
};
const _c6 = function () {
  return ["notStartWithSpecialCharacter", "smallerThanZero"];
};
const _c7 = function () {
  return ["required", "smallerThanZero", "notStartWithSpecialCharacter"];
};
const _c8 = function () {
  return ["required", "startWithSpace", "greaterThanAppDate"];
};
const _c9 = function () {
  return ["required", "lessThanAppDate"];
};
const _c10 = function () {
  return ["required", "greaterThanAppDate", "lessThanTwelveMonths"];
};
const _c11 = function () {
  return ["required", "invalidPhoneNumberFormat"];
};
const _c12 = function () {
  return {
    length: 11
  };
};
const _c13 = function () {
  return ["required", "startWithSpace", "notEmail"];
};
const _c14 = function () {
  return ["required", "invalidTelePhoneNumberFormat"];
};
const _c15 = function () {
  return ["required"];
};
const _c16 = function () {
  return ["required", "notNumber"];
};
const _c17 = function () {
  return ["required", "startWithSpace", "smallerThanZero", "notStartWithSpecialCharacter"];
};
const _c18 = function () {
  return ["required", "startWithSpace", "smallerThanZero", "notStartWithSpecialCharacter", "notNumber"];
};
const _c19 = function () {
  return ["required", "startWithSpace", "maxlength", "smallerThanZero", "notStartWithSpecialCharacter"];
};
const _c20 = function () {
  return {
    length: 6
  };
};
const _c21 = function () {
  return ["required", "startWithSpace", "smallerThanZero"];
};
let AddEditOrganizationComponent = class AddEditOrganizationComponent extends _microSharedLib_core_models_classes_FusionBase__WEBPACK_IMPORTED_MODULE_2__.FusionBase {
  constructor(injector, lookupService, financialPoliciesService, dialogConfig, rejectionReasonsService, dialogRef, lookupMangementService) {
    super(injector);
    this.lookupService = lookupService;
    this.financialPoliciesService = financialPoliciesService;
    this.dialogConfig = dialogConfig;
    this.rejectionReasonsService = rejectionReasonsService;
    this.dialogRef = dialogRef;
    this.lookupMangementService = lookupMangementService;
    this.currentLanguage = '';
    this.isEditMode = 'INSERT';
    ///<< this props used if component open from modal >>///
    this.isModal = false;
    this.activeIndex = 0;
    this.messageTranslationPrefix = 'PAGES.ORGANIZATION-ADD-EDIT-PAGE.MESSAGES.';
  }
  ngOnInit() {
    this.getAllLookups();
    this.userSession = this.localStorageService.getSessionStorage(_fusionCore_models_enum_LocalStorageKeys_enum__WEBPACK_IMPORTED_MODULE_1__.LocalStorageKeys.APP_TOKEN_SESSION);
    this.getAppLanguage();
    this.createOrgForm();
    this.getParamsOnStart();
    this.getDialogInfo();
    this.getEnconomy3();
    this.appDate = this.convertDate(this.userSession.appDate);
    this.appDate.setDate(this.appDate.getDate() + 1);
    if (this.dialogConfig.data && this.dialogConfig.data.isModal) {
      this.isModal = true;
      this.isEditMode = 'INSERT';
      if (this.dialogConfig.data.orgId) {
        this.isEditMode = 'UPDATE';
      }
      this.organizationForm.get('custIdno').setValue(this.dialogConfig.data.idno);
    }
    if (this.rejectionReasonsService.pervState === 'REFUSED') {
      this.rejectionReasonsService.setOrgForm(this.organizationForm);
      this.rejectionReasonsService.enableControls();
    }
    this.getFormValueChanges();
  }
  getEnconomy3() {
    this.lookupService.getAllEconomy3().pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_13__.untilDestroyed)(this)).subscribe(data => {
      this.econCode3List = data.result;
    });
  }
  getFormValueChanges() {
    // this.organizationForm
    //   .get('econCode1')
    //   .valueChanges.pipe(untilDestroyed(this))
    //   .subscribe((data) => {
    //     if (data) this.changeEconCode1(data);
    //   });
    this.organizationForm.get('econCode3').valueChanges.pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_13__.untilDestroyed)(this)).subscribe(data => {
      if (data) this.changeEconCode3(data);
    });
    this.organizationForm.get('address').valueChanges.pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_13__.untilDestroyed)(this)).subscribe(data => {
      if (data) this.changeDetailedAddress();
    });
    this.organizationForm.get('regNo').valueChanges.pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_13__.untilDestroyed)(this)).subscribe(data => {
      const regExpDateControl = this.organizationForm.get('regExpDate');
      const regIssueDateControl = this.organizationForm.get('regIssueDate');
      if (data) {
        // Add the validator dynamically
        regExpDateControl.setValidators([_microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.mustBeBiggerThanAppDate(this.convertDate(this.userSession.appDate))]);
        regIssueDateControl.setValidators([_microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.mustBeSmallerThanAppDate(this.convertDate(this.userSession.appDate))]);
      } else {
        // Remove the validator dynamically
        regExpDateControl.clearValidators();
        regIssueDateControl.clearValidators();
      }
      // Update the validation state
      regExpDateControl.updateValueAndValidity();
      regIssueDateControl.updateValueAndValidity();
    });
  }
  getAppLanguage() {
    this.currentLanguage = this.getFusionHelper().getActiveLanguage(_fusionCore_models_enum_LocalStorageKeys_enum__WEBPACK_IMPORTED_MODULE_1__.LocalStorageKeys.APP_LANG);
    this.getTranslation().onLangChange.pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_13__.untilDestroyed)(this)).subscribe(lang => {
      this.currentLanguage = lang?.lang;
    });
  }
  getParamsOnStart() {
    var _this = this;
    return (0,D_Tanmeyah_frontend_fmc_cOPY_node_modules_babel_runtime_helpers_esm_asyncToGenerator_js__WEBPACK_IMPORTED_MODULE_0__["default"])(function* () {
      _this.getActivatedRoute().params.pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_13__.untilDestroyed)(_this)).subscribe( /*#__PURE__*/function () {
        var _ref = (0,D_Tanmeyah_frontend_fmc_cOPY_node_modules_babel_runtime_helpers_esm_asyncToGenerator_js__WEBPACK_IMPORTED_MODULE_0__["default"])(function* (data) {
          if (data && data['id']) {
            let allData = (yield _this.financialPoliciesService.getOneOrg(data['id']).toPromise())?.result;
            if (data['mode']) {
              _this.isEditMode = 'VIEW';
              _this.organizationForm.disable({
                emitEvent: false
              });
              _this.getEconData(allData);
              _this.getStateData(allData);
              _this.populateBasicData(allData);
              allData.cifCustOrgPartners.get('cifCustOrgPartners').controls.forEach(ele => {
                ele.disable({
                  emitEvent: true
                });
              });
            } else {
              _this.getStateData(allData);
              _this.getEconData(allData);
              _this.isEditMode = 'UPDATE';
              _this.populateBasicData(allData);
            }
          } else {
            _this.isEditMode = 'INSERT';
          }
        });
        return function (_x) {
          return _ref.apply(this, arguments);
        };
      }());
    })();
  }
  getDialogInfo() {
    var _this2 = this;
    return (0,D_Tanmeyah_frontend_fmc_cOPY_node_modules_babel_runtime_helpers_esm_asyncToGenerator_js__WEBPACK_IMPORTED_MODULE_0__["default"])(function* () {
      if (_this2.dialogConfig.data && _this2.dialogConfig.data.isModal) {
        let idNo = _this2.dialogConfig?.data?.orgId;
        const fullName = _this2.dialogConfig?.data?.fullName;
        if (_this2.dialogConfig.data.ticketId) _this2.organizationForm.get('ticketId').patchValue(_this2.dialogConfig?.data?.ticketId);
        _this2.organizationForm.get('orgOwenrName').patchValue(fullName);
        _this2.isModal = true;
        if (_this2.dialogConfig.data.isEditMode === 'INSERT') {
          _this2.isEditMode = 'INSERT';
        } else if (_this2.dialogConfig.data.isEditMode === 'UPDATE') {
          let data = (yield _this2.financialPoliciesService.getOneOrg(idNo).toPromise())?.result;
          yield _this2.getStateData(data);
          yield _this2.getEconData(data);
          _this2.populateBasicData(data);
          _this2.isEditMode = 'UPDATE';
        } else if (_this2.dialogConfig.data.isEditMode === 'VIEW') {
          let data = (yield _this2.financialPoliciesService.getOneOrg(idNo).toPromise())?.result;
          _this2.getStateData(data);
          yield _this2.getEconData(data);
          _this2.populateBasicData(data);
          _this2.isEditMode = 'VIEW';
          _this2.organizationForm.disable({
            emitEvent: false
          });
          if (data.length > 0) {
            data.cifCustOrgPartners.get('cifCustOrgPartners').controls.forEach(ele => {
              ele.disable({
                emitEvent: true
              });
            });
          }
        } else {
          let data = (yield _this2.financialPoliciesService.getOneOrg(idNo).toPromise())?.result;
          // this.getStateData(data);
          _this2.populateBasicData(data);
          _this2.isEditMode = 'VIEW';
        }
      }
    })();
  }
  getStateData(orgData) {
    var _this3 = this;
    return (0,D_Tanmeyah_frontend_fmc_cOPY_node_modules_babel_runtime_helpers_esm_asyncToGenerator_js__WEBPACK_IMPORTED_MODULE_0__["default"])(function* () {
      let countryCode = _this3.userSession.countryId;
      _this3.lookupMangementService.getSessionLookup(`getAllCity_${countryCode}_${orgData.address?.stateCode}`, _this3.lookupService.getAllCity(orgData.address?.regionId, countryCode, orgData.address?.stateCode)).pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_13__.untilDestroyed)(_this3)).subscribe(data => {
        _this3.cityCodeList = data;
      });
      _this3.lookupMangementService.getSessionLookup(`getAllVillage_${countryCode}_${orgData.address?.stateCode}_${orgData.address?.cityCode}`, _this3.lookupService.getAllVillage(orgData.address?.regionId, countryCode, orgData.address?.stateCode, orgData.address?.cityCode)).pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_13__.untilDestroyed)(_this3)).subscribe(data => {
        _this3.villagecodeList = data;
      });
    })();
  }
  getEconData(orgData) {
    var _this4 = this;
    return (0,D_Tanmeyah_frontend_fmc_cOPY_node_modules_babel_runtime_helpers_esm_asyncToGenerator_js__WEBPACK_IMPORTED_MODULE_0__["default"])(function* () {
      console.log(orgData, 'org');
      _this4.lookupMangementService.getSessionLookup(`getAllEconomySectorLevel2WithParam_${orgData.econCode1}`, _this4.lookupService.getAllEconomySectorLevel2WithParam(orgData.econCode1)).pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_13__.untilDestroyed)(_this4)).subscribe(data => {
        _this4.econCode2List = data;
        _this4.changeEconCode3(orgData.econCode3);
      });
      // this.lookupMangementService
      //   .getSessionLookup(
      //     `getAllEconomySectorLevel3WithParam_${orgData.econCode1}_${orgData.econCode2}`,
      //     this.lookupService.getAllEconomy3(
      //       orgData.econCode1,
      //       orgData.econCode2
      //     )
      //   )
      //   .pipe(untilDestroyed(this))
      //   .subscribe((data) => {
      //     this.econCode3List = data;
      //   });
    })();
  }

  populateBasicData(orgData) {
    if (orgData) {
      this.organizationForm.patchValue(orgData, {
        emitEvent: false
      });
      this.organizationForm.get('placeType').patchValue(String(orgData.placeType));
      this.organizationForm.get('placeOwnership').patchValue(String(orgData.placeOwnership));
      orgData?.cifCustOrgPartners?.forEach(ele => {
        this.getPartnerArray().push(this.getFormBuilder.group({
          idno: [ele.idno],
          name: [ele.name],
          nationCode: [ele.nationCode],
          orgId: [ele.orgId],
          partnerRatio: [ele.partnerRatio],
          partnerAmt: [ele.partnerAmt],
          role: [ele.role],
          bod: [ele.bod]
        }));
      });
    }
  }
  getAllLookups() {
    //organization types
    this.lookupMangementService.getLookup('getOneBasicData_CIF_ORG_TYPE', this.lookupService.getOneBasicData('CIF_ORG_TYPE')).pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_13__.untilDestroyed)(this)).subscribe(data => {
      this.organizationTypesList = data.map(x => {
        return {
          ...x,
          codeId: parseInt(x.codeId)
        };
      });
    });
    // Economic types
    this.lookupMangementService.getLookup('getAllEconomySector', this.lookupService.getAllEconomySector()).pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_13__.untilDestroyed)(this)).subscribe(data => {
      this.econCode1List = data;
    });
    // Company category
    this.lookupMangementService.getLookup('getCompanyCategory', this.lookupService.getCompanyCategory()).pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_13__.untilDestroyed)(this)).subscribe(data => {
      this.companyCategoryList = data;
    });
    // Nationalities List
    this.lookupMangementService.getLookup('getOneBasicData_CIF_NATION_CODE', this.lookupService.getOneBasicData('CIF_NATION_CODE')).pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_13__.untilDestroyed)(this)).subscribe(data => {
      this.nationalitiesList = data.map(x => {
        return {
          ...x,
          codeId: parseInt(x.codeId)
        };
      });
    });
    // Place Type List
    this.lookupMangementService.getLookup('getPlaceType', this.lookupService.getPlaceType()).pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_13__.untilDestroyed)(this)).subscribe(data => {
      this.placeTypes = data;
    });
    // Place Ownership List
    this.lookupMangementService.getLookup('getPlaceOwnership', this.lookupService.getPlaceOwnership()).pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_13__.untilDestroyed)(this)).subscribe(data => {
      this.placeOwnerships = data;
    });
    // Keep original address lookups
    this.lookupMangementService.getLookup('getAllState', this.lookupService.getAllState(1, 1)).pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_13__.untilDestroyed)(this)).subscribe(data => {
      this.stateCodeList = data;
    });
  }
  onStateChange(e) {
    this.organizationForm.get('address').get('cityCode').reset();
    this.organizationForm.get('address').get('villageCode').reset();
    this.cityCodeList = [];
    this.villagecodeList = [];
    ////
    let stateObj = this.stateCodeList.find(ele => ele.stateId === e.value);
    this.lookupMangementService.getSessionLookup(`getAllCity_${this.organizationForm.get('address.countryCode')?.value}_${this.organizationForm.get('address.stateCode')?.value}`, this.lookupService.getAllCity(stateObj.regionId, this.organizationForm.get('address.countryCode')?.value, this.organizationForm.get('address.stateCode')?.value)).pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_13__.untilDestroyed)(this)).subscribe(data => {
      this.cityCodeList = data;
    });
    this.organizationForm.get('address').get('regionId').setValue(stateObj.regionId);
  }
  onCityChange(e) {
    this.organizationForm.get('address').get('villageCode').reset();
    this.villagecodeList = [];
    let cityObj = this.cityCodeList.find(ele => ele.cityId === e.value);
    this.lookupMangementService.getSessionLookup(`getAllVillage_${this.organizationForm.get('address.countryCode')?.value}_${this.organizationForm.get('address.stateCode')?.value}_${this.organizationForm.get('address.cityCode')?.value}`, this.lookupService.getAllVillage(cityObj.regionId, this.organizationForm.get('address.countryCode')?.value, this.organizationForm.get('address.stateCode')?.value, this.organizationForm.get('address.cityCode')?.value)).pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_13__.untilDestroyed)(this)).subscribe(data => {
      this.villagecodeList = data;
    });
  }
  changeCustIdno(event) {
    this.organizationForm.get('orgOwenrName').reset();
    if (typeof event == 'string' || typeof event == 'number') {
      this.financialPoliciesService.getCustomerFullName(event).pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_13__.untilDestroyed)(this)).subscribe(data => {
        if (data.result) this.organizationForm.get('orgOwenrName').setValue(data.result.length > 0 ? data.result[0].fullname : '');
      });
    } else if (typeof event == 'object') {
      this.financialPoliciesService.getCustomerFullName(event).pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_13__.untilDestroyed)(this)).subscribe(data => {
        if (data.result) this.organizationForm.get('orgOwenrName').setValue(data.result.length > 0 ? data.result[0].fullname : '');
      });
    }
  }
  changeEconCode1(event) {
    this.organizationForm.get('econCode2').reset();
    this.organizationForm.get('econCode3').reset();
    if (typeof event == 'number') {
      this.lookupMangementService.getSessionLookup(`getAllEconomySectorLevel2WithParam_${event}`, this.lookupService.getAllEconomySectorLevel2WithParam(event)).pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_13__.untilDestroyed)(this)).subscribe(data => {
        this.econCode2List = data;
      });
    }
  }
  changeEconCode3(event) {
    // this.organizationForm.get('econCode3').reset();
    if (typeof event == 'number') {
      let econCode3 = this.organizationForm.get('econCode3').value;
      this.lookupService.getAllEconomy3WithParam(econCode3).pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_13__.untilDestroyed)(this)).subscribe(data => {
        this.econCode2List = [data.result];
        this.organizationForm.get('econCode1').setValue(data.result.codeId1, {
          emitEvent: false
        });
        this.organizationForm.get('econCode2').setValue(data.result.codeId2, {
          emitEvent: false
        });
      });
    }
  }
  createOrgForm() {
    this.organizationForm = this.getFormBuilder.group({
      ticketId: [-99],
      address: this.getFormBuilder.group({
        addMark: [null, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.required, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.startWithSpace, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.isnumericAndBiggerThanZero, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.startWithSpecialCharacter]],
        addTxt: [{
          value: null,
          disabled: true
        }, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.required, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.isnumericAndBiggerThanZero]],
        buildingNo: [null, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.required, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.startWithSpace, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.isnumericAndBiggerThanZero, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.startWithSpecialCharacter]],
        regionId: [null],
        cityCode: [null, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.required, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.startWithSpace, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.isnumericAndBiggerThanZero]],
        countryCode: [this.userSession.countryId],
        flatno: [null, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.required, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.startWithSpace, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.isnumericAndBiggerThanZero, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.startWithSpecialCharacter, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.isnumeric]],
        floorNo: [null, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.required, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.startWithSpace, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.isnumericAndBiggerThanZero, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.startWithSpecialCharacter, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.isnumeric]],
        postCode: [null, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.maxLength(6), _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.startWithSpace, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.isnumericAndBiggerThanZero, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.startWithSpecialCharacter]],
        stateCode: [null, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.required, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.startWithSpace, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.isnumericAndBiggerThanZero]],
        street: [null, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.required, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.startWithSpace, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.isnumericAndBiggerThanZero, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.startWithSpecialCharacter]],
        villageCode: [null, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.required, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.startWithSpace]]
      }),
      cifCustOrgPartners: this.getFormBuilder.array([this.getFormBuilder.group({
        idno: [null, [_microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.isValidNationalId]],
        name: [null, [_microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.isArabicOnly]],
        nationCode: [null],
        orgId: [null],
        partnerRatio: [null],
        partnerAmt: [null],
        role: [null],
        bod: [null]
      })]),
      contactName: [{
        value: null,
        disabled: false
      }, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.required, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.isAlphaOnly, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.startWithSpace]],
      contactPhone: [null, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.required, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.startWith01Validator]],
      countEmployees: [0, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.required, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.startWithSpecialCharacter]],
      custIdno: [{
        value: null,
        disabled: true
      }, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.required, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.isValidNationalId]],
      placeType: [null, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.required]],
      placeOwnership: [null, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.required]],
      placeNoOfYears: [null, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.required, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.isnumeric]],
      econCode1: [{
        value: null,
        disabled: true
      }, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.required]],
      econCode2: [{
        value: null,
        disabled: true
      }, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.required]],
      econCode3: [null, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.required]],
      orgCapital: [0, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.required]],
      orgId: [{
        value: null,
        disabled: true
      }, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.required]],
      orgName: [null, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.required, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.startWithSpace, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.startWithSpecialCharacter]],
      orgDescr: [null, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.required, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.isAlphaOnly, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.startWithSpace]],
      orgOwenrName: [{
        value: null,
        disabled: true
      }, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.required]],
      contactEmail: [null, [_microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.isEmail]],
      orgType: [null, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.required]],
      phone1: [null, [_microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.startWith01Validator]],
      phone2: [null, [_microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.startWith0Validator]],
      practiceStartDate: [this.userSession.appDate, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.required]],
      regExpDate: [this.userSession.appDate],
      regIssueDate: [this.userSession.appDate],
      regNo: [null, [_microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.startWithSpecialCharacter, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.isnumericAndBiggerThanZero]],
      taxFileNo: [null, [_microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.startWithSpecialCharacter, _microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.isnumericAndBiggerThanZero]],
      companyCategory: [null, [_angular_forms__WEBPACK_IMPORTED_MODULE_14__.Validators.required]],
      email: [null, [_microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.isEmail]]
    });
  }
  changeDetailedAddress() {
    const stateValue = this.organizationForm.get('address').get('stateCode').value ?? '';
    const cityValue = this.organizationForm.get('address').get('cityCode').value ?? '';
    const villageValue = this.organizationForm.get('address').get('villageCode').value ?? '';
    const street = this.organizationForm.get('address').get('street').value ?? '';
    const buildingNo = this.organizationForm.get('address').get('buildingNo').value ?? '';
    const floorNo = this.organizationForm.get('address').get('floorNo').value ?? '';
    const flatno = this.organizationForm.get('address').get('flatno').value ?? '';
    const addMark = this.organizationForm.get('address').get('addMark').value ?? '';
    const stateCode = this.stateCodeList?.find(res => res.stateId == stateValue)?.nameAr ?? '';
    const cityCode = this.cityCodeList?.find(res => res.cityId == cityValue)?.nameAr ?? '';
    const villageCode = this.villagecodeList?.find(res => res.villageId == villageValue)?.nameAr ?? '';
    const addtext = `${buildingNo}  ${street} - ${villageCode} - ${cityCode} - ${stateCode}`;
    this.organizationForm.get('address').get('addTxt').patchValue(addtext, {
      emitEvent: false
    });
  }
  partnerArrayItem(data) {
    if (data) {
      return this.getFormBuilder.group({
        idno: [data.idno],
        name: [data.name],
        nationCode: [data.nationCode],
        orgId: [data.orgId],
        partnerRatio: [data.partnerRatio],
        partnerAmt: [data.partnerAmt],
        role: [data.role],
        bod: [data.bod]
      });
    } else {
      return this.getFormBuilder.group({
        idno: [null, [_microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.isValidNationalId]],
        name: [null, [_microSharedLib_shared_validator_CustomValidation__WEBPACK_IMPORTED_MODULE_7__.CustomValidation.isArabicOnly]],
        nationCode: [null],
        orgId: [null],
        partnerRatio: [null],
        partnerAmt: [null],
        role: [null],
        bod: [null]
      });
    }
  }
  getPartnerArray() {
    return this.organizationForm.get('cifCustOrgPartners');
  }
  addPartnerArrayItem() {
    this.getPartnerArray().push(this.partnerArrayItem());
  }
  removePartnerArrayItem(idx) {
    this.getPartnerArray().removeAt(idx);
  }
  clearPartnetArrayItem() {
    this.getPartnerArray().removeAt(0);
    this.getPartnerArray().push(this.partnerArrayItem());
  }
  closeDialog() {
    this.dialogRef.close({
      cancel: true,
      confirm: false
    });
  }
  backToMain() {
    this.getRouter().navigate(['funding-requests/organization']);
  }
  onPracticeDateChange(e) {
    let newDate;
    let appDate;
    let twelveMonthsAgo;
    if (typeof e == 'object') {
      newDate = moment__WEBPACK_IMPORTED_MODULE_8__(e).toDate();
    }
    appDate = this.convertDate(this.userSession.appDate);
    twelveMonthsAgo = new Date(appDate);
    twelveMonthsAgo.setMonth(appDate.getMonth() - 12);
    if (newDate > appDate) {
      this.organizationForm.get('practiceStartDate').setErrors({
        greaterThanAppDate: true
      });
    }
    //  if (newDate == appDate) {
    //   this.organizationForm
    //     .get('practiceStartDate')
    //     .setErrors({ lessesThanAppDate: true });
    // }
    else if (newDate > twelveMonthsAgo) {
      this.organizationForm.get('practiceStartDate').setErrors({
        lessThanTwelveMonths: true
      });
    } else {
      this.organizationForm.get('practiceStartDate').setErrors(null);
    }
  }
  onPracticeDateOnStart() {
    let newDate;
    let appDate;
    let twelveMonthsAgo;
    newDate = this.convertDate(this.organizationForm.get('practiceStartDate').value);
    appDate = this.convertDate(this.userSession.appDate);
    twelveMonthsAgo = new Date(appDate);
    twelveMonthsAgo.setMonth(appDate.getMonth() - 12);
    if (newDate > appDate) {
      this.organizationForm.get('practiceStartDate').setErrors({
        greaterThanAppDate: true
      });
      this.organizationForm.get('practiceStartDate').markAsTouched();
    } else if (newDate > twelveMonthsAgo) {
      this.organizationForm.get('practiceStartDate').setErrors({
        lessThanTwelveMonths: true
      });
      this.organizationForm.get('practiceStartDate').markAsTouched();
    } else {
      this.organizationForm.get('practiceStartDate').setErrors(null);
    }
  }
  convertDate(d) {
    console.log(d, 'd');
    if (d instanceof Date) {
      return d;
    }
    if (d !== null) {
      d = d.split('/');
      let newDate = new Date(d[2] + '/' + d[1] + '/' + d[0]);
      return newDate;
    } else {
      return new Date();
    }
  }
  onActiveIndexChange(e) {
    this.activeIndex = e;
  }
  tabValidation() {
    if (this.organizationForm.controls['orgName'].invalid || this.organizationForm.controls['orgId'].invalid || this.organizationForm.controls['orgType'].invalid || this.organizationForm.controls['orgDescr'].invalid || this.organizationForm.controls['econCode1'].invalid || this.organizationForm.controls['econCode2'].invalid || this.organizationForm.controls['econCode3'].invalid) {
      this.activeIndex = 0;
      this.getAlertToaster().showToastWarn('', this.Locz(`${this.commonMessages}FILL-FORM-ERROR`));
    } else if (this.organizationForm.controls['taxFileNo'].invalid || this.organizationForm.controls['regNo'].invalid || this.organizationForm.controls['regIssueDate'].invalid || this.organizationForm.controls['regExpDate'].invalid || this.organizationForm.controls['practiceStartDate'].invalid || this.organizationForm.controls['orgCapital'].invalid || this.organizationForm.controls['countEmployees'].invalid) {
      this.activeIndex = 1;
      this.getAlertToaster().showToastWarn('', this.Locz(`${this.commonMessages}FILL-FORM-ERROR`));
    } else if (this.organizationForm.controls['custIdno'].invalid || this.organizationForm.controls['orgOwenrName'].invalid || this.organizationForm.controls['contactName'].invalid || this.organizationForm.controls['contactPhone'].invalid || this.organizationForm.controls['contactEmail'].invalid || this.organizationForm.controls['phone1'].invalid || this.organizationForm.controls['phone2'].invalid || this.organizationForm.controls['email'].invalid) {
      this.activeIndex = 2;
      this.getAlertToaster().showToastWarn('', this.Locz(`${this.commonMessages}FILL-FORM-ERROR`));
    } else if (this.organizationForm.get('placeNoOfYears').invalid || this.organizationForm.controls['placeType'].invalid || this.organizationForm.controls['placeOwnership'].invalid) {
      this.activeIndex = 3;
      this.getAlertToaster().showToastWarn('', this.Locz(`${this.commonMessages}FILL-FORM-ERROR`));
    } else if (this.organizationForm.get('address').invalid) {
      this.activeIndex = 4;
      this.getAlertToaster().showToastWarn('', this.Locz(`${this.commonMessages}FILL-FORM-ERROR`));
    } else if (this.organizationForm.get('cifCustOrgPartners').invalid) {
      this.activeIndex = 5;
      this.getAlertToaster().showToastWarn('', this.Locz(`${this.commonMessages}FILL-FORM-ERROR`));
    }
  }
  save() {
    this.onPracticeDateOnStart();
    if (this.organizationForm.invalid) {
      this.organizationForm.markAllAsTouched();
      this.tabValidation();
    } else {
      const orgData = this.organizationForm.getRawValue();
      delete orgData.orgOwenrName;
      for (const key in orgData) {
        if (orgData[key] instanceof Date) {
          orgData[key] = moment__WEBPACK_IMPORTED_MODULE_8__(orgData[key]).format('DD/MM/YYYY');
        }
      }
      orgData.cifCustOrgPartners.forEach(ele => {
        for (const key in ele) {
          if (ele[key] instanceof Date) {
            ele[key] = moment__WEBPACK_IMPORTED_MODULE_8__(ele[key]).format('DD/MM/YYYY');
          }
        }
      });
      this.financialPoliciesService.addOrg(orgData).pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_13__.untilDestroyed)(this)).subscribe(data => {
        if (data.status === _microSharedLib_core_models_enum_FusionHttpStatus_enum__WEBPACK_IMPORTED_MODULE_3__.FusionHttpStatus.STATUS_SUCCESS) {
          if (this.isModal) {
            this.dialogRef.close({
              cancel: false,
              confirm: true
            });
          } else {
            this.backToMain();
          }
        }
      });
    }
  }
  update() {
    this.onPracticeDateOnStart();
    if (this.organizationForm.invalid) {
      this.organizationForm.markAllAsTouched();
      this.tabValidation();
    } else {
      const orgData = this.organizationForm.getRawValue();
      delete orgData.orgOwenrName;
      for (const key in orgData) {
        if (orgData[key] instanceof Date) {
          orgData[key] = moment__WEBPACK_IMPORTED_MODULE_8__(orgData[key]).format('DD/MM/YYYY');
        }
      }
      orgData.cifCustOrgPartners.forEach(ele => {
        for (const key in ele) {
          if (ele[key] instanceof Date) {
            ele[key] = moment__WEBPACK_IMPORTED_MODULE_8__(ele[key]).format('DD/MM/YYYY');
          }
        }
      });
      this.financialPoliciesService.updateOrg(orgData).pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_13__.untilDestroyed)(this)).subscribe(data => {
        if (data.status === _microSharedLib_core_models_enum_FusionHttpStatus_enum__WEBPACK_IMPORTED_MODULE_3__.FusionHttpStatus.STATUS_SUCCESS) {
          if (this.isModal) {
            this.dialogRef.close({
              cancel: false,
              confirm: true
            });
          } else {
            this.backToMain();
          }
        }
      });
    }
  }
  ngOnDestroy() {
    this.rejectionReasonsService.setOrgForm(null);
  }
};
AddEditOrganizationComponent.ɵfac = function AddEditOrganizationComponent_Factory(t) {
  return new (t || AddEditOrganizationComponent)(_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵdirectiveInject"](_angular_core__WEBPACK_IMPORTED_MODULE_12__.Injector), _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵdirectiveInject"](_microSharedLib_services_application_lookups_service__WEBPACK_IMPORTED_MODULE_4__.ApplicationLookupsService), _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵdirectiveInject"](_microSharedLib_services_financial_policies_service__WEBPACK_IMPORTED_MODULE_5__.FinancialPoliciesService), _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵdirectiveInject"](primeng_dynamicdialog__WEBPACK_IMPORTED_MODULE_15__.DynamicDialogConfig), _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵdirectiveInject"](_microSharedLib_services_rejection_reasons_service__WEBPACK_IMPORTED_MODULE_6__.RejectionReasonsService), _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵdirectiveInject"](primeng_dynamicdialog__WEBPACK_IMPORTED_MODULE_15__.DynamicDialogRef), _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵdirectiveInject"](_microSharedLib_services_lookups_service__WEBPACK_IMPORTED_MODULE_9__.LookupService));
};
AddEditOrganizationComponent.ɵcmp = /*@__PURE__*/_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵdefineComponent"]({
  type: AddEditOrganizationComponent,
  selectors: [["micro-finance-add-edit-organization"]],
  features: [_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵInheritDefinitionFeature"]],
  decls: 282,
  vars: 458,
  consts: [[1, "organization-add-edit-wrapper", "grid", "p-fluid"], ["class", "col-12 flex flex-row justify-content-end align-items-center mb-2", 4, "ngIf"], ["autocomplete", "off", 1, "mt-3", 3, "formGroup"], ["styleClass", "p-accordion-custom", "appRtl", "", 3, "collapseIcon", "expandIcon", "activeIndex", "activeIndexChange"], [3, "header", "selected"], [1, "p-fluid", "grid"], [1, "sm:col-6", "md:col-4", "field"], ["for", "orgName"], ["pInputText", "", "id", "orgName", "type", "text", "formControlName", "orgName", 3, "placeholder"], [3, "formInstance", "controlName", "validationErrorList"], ["for", "orgId"], ["pInputText", "", "id", "orgId", "type", "text", "formControlName", "orgId", 3, "placeholder"], [1, "sm:col-12", "md:col-4", "field"], ["for", "orgType"], ["id", "orgType", "formControlName", "orgType", "optionValue", "codeId", "appendTo", "body", "styleClass", "p-dropdown-custom", "appRtl", "", 3, "options", "placeholder", "optionLabel", "showClear", "filter"], ["for", "econCode1"], ["id", "econCode1", "formControlName", "econCode1", "optionValue", "codeId1", "appendTo", "body", "styleClass", "p-dropdown-custom", "appRtl", "", 3, "options", "placeholder", "optionLabel"], ["for", "econCode2"], ["id", "econCode2", "formControlName", "econCode2", "optionValue", "codeId2", "appendTo", "body", "styleClass", "p-dropdown-custom", "appRtl", "", 3, "options", "placeholder", "optionLabel"], ["for", "econCode3"], ["id", "econCode3", "formControlName", "econCode3", "optionValue", "codeId_3", "appendTo", "body", "styleClass", "p-dropdown-custom", "appRtl", "", 3, "options", "placeholder", "optionLabel", "showClear", "filter"], ["for", "orgDescr"], ["pInputText", "", "id", "orgDescr", "type", "text", "formControlName", "orgDescr", 3, "placeholder"], ["for", "taxFileNo"], ["formControlName", "taxFileNo", 3, "useGrouping", "placeholder"], ["for", "regNo"], ["formControlName", "regNo", 3, "useGrouping", "placeholder"], ["for", "regIssueDate"], ["dateFormat", "dd/mm/yy", "formControlName", "regIssueDate", "appendTo", "body", "appRtl", "", 1, "p-input-calendar-custom", 3, "placeholder", "showIcon", "readonlyInput"], ["for", "regExpDate"], ["dateFormat", "dd/mm/yy", "formControlName", "regExpDate", "appendTo", "body", "appRtl", "", 1, "p-input-calendar-custom", 3, "placeholder", "showIcon", "readonlyInput", "minDate", "defaultDate"], ["for", "practiceStartDate"], ["dateFormat", "dd/mm/yy", "formControlName", "practiceStartDate", "appendTo", "body", "appRtl", "", 1, "p-input-calendar-custom", 3, "placeholder", "showIcon", "readonlyInput", "onSelect"], ["for", "orgCapital"], ["id", "orgCapital", "formControlName", "orgCapital", 3, "placeholder", "useGrouping", "min", "max", "maxlength"], ["for", "countEmployees"], ["pInputText", "", "id", "countEmployees", "type", "number", "formControlName", "countEmployees", 3, "placeholder"], ["for", "stateCode"], ["id", "companyCategory", "formControlName", "companyCategory", "optionValue", "codeId", "appendTo", "body", "styleClass", "p-dropdown-custom", "appRtl", "", 3, "options", "placeholder", "optionLabel", "showClear", "filter"], ["for", "custIdno"], ["pInputText", "", "id", "custIdno", "type", "text", "formControlName", "custIdno", 3, "placeholder", "change"], [1, "sm:col-6", "md:col-8", "field"], ["for", "orgOwenrName"], ["pInputText", "", "id", "orgOwenrName", "type", "text", "formControlName", "orgOwenrName", 3, "placeholder"], ["for", "contactName"], ["pInputText", "", "id", "contactName", "type", "text", "autocomplete", "off", "formControlName", "contactName", 3, "placeholder"], ["for", "contactPhone"], ["pInputText", "", "type", "text", "inputId", "contactPhone", "formControlName", "contactPhone", 3, "maxlength", "placeholder"], [3, "formInstance", "controlName", "validationErrorList", "lengthValParam"], ["for", "contactEmail"], ["pInputText", "", "id", "contactEmail", "type", "email", "formControlName", "contactEmail", 3, "placeholder"], ["for", "phone1"], ["pInputText", "", "type", "text", "inputId", "phone1", "formControlName", "phone1", 3, "maxlength", "placeholder"], ["for", "phone2"], ["pInputText", "", "inputId", "phone2", "type", "text", "formControlName", "phone2", 3, "placeholder"], ["for", "email"], ["pInputText", "", "id", "email", "type", "email", "formControlName", "email", 3, "placeholder"], [1, "sm:col-12", "md:col-3", "field"], ["for", "placeType"], ["id", "placeType", "formControlName", "placeType", "optionValue", "codeId", "appendTo", "body", "styleClass", "p-dropdown-custom", "appRtl", "", 3, "options", "placeholder", "optionLabel", "showClear", "filter"], ["for", "placeOwnership"], ["id", "placeOwnership", "formControlName", "placeOwnership", "optionValue", "codeId", "appendTo", "body", "styleClass", "p-dropdown-custom", "appRtl", "", 3, "options", "placeholder", "optionLabel", "showClear", "filter"], ["for", "placeNoOfYears"], ["pInputText", "", "id", "placeNoOfYears", "type", "text", "formControlName", "placeNoOfYears", 3, "placeholder"], ["formGroupName", "address"], ["id", "stateCode", "formControlName", "stateCode", "optionValue", "stateId", "appendTo", "body", "styleClass", "p-dropdown-custom", "appRtl", "", 3, "options", "placeholder", "optionLabel", "showClear", "filter", "onChange"], ["for", "cityCode"], ["id", "cityCode", "formControlName", "cityCode", "optionValue", "cityId", "appendTo", "body", "styleClass", "p-dropdown-custom", "appRtl", "", 3, "options", "placeholder", "optionLabel", "showClear", "filter", "onChange"], ["for", "villageCode"], ["id", "villageCode", "formControlName", "villageCode", "optionValue", "villageId", "appendTo", "body", "styleClass", "p-dropdown-custom", "appRtl", "", 3, "options", "placeholder", "optionLabel", "showClear", "filter"], ["for", "street"], ["pInputText", "", "id", "street", "type", "text", "formControlName", "street", 3, "placeholder"], ["for", "buildingNo"], ["pInputText", "", "id", "buildingNo", "type", "text", "formControlName", "buildingNo", 3, "maxLength", "placeholder"], ["for", "floorNo"], ["pInputText", "", "id", "floorNo", "type", "text", "formControlName", "floorNo", 3, "maxlength", "placeholder"], ["for", "flatno"], ["pInputText", "", "id", "flatno", "type", "text", "formControlName", "flatno", 3, "maxlength", "placeholder"], ["for", "addMark"], ["pInputText", "", "id", "addMark", "type", "text", "formControlName", "addMark", 3, "placeholder"], ["for", "postCode"], ["formControlName", "postCode", 3, "useGrouping", "placeholder"], [1, "sm:col-12", "md:col-9", "field"], ["for", "addTxt"], ["pInputText", "", "id", "addTxt", "type", "text", "formControlName", "addTxt", 3, "placeholder"], ["formArrayName", "cifCustOrgPartners"], [4, "ngFor", "ngForOf"], [1, "role-add-edit-footer", "p-2", "flex", "flex-row", "justify-content-end", "align-items-center"], ["pButton", "", "pRipple", "", "type", "button", "class", "p-button-raised p-button mx-1 w-2", 3, "label", "click", 4, "ngIf"], ["pButton", "", "pRipple", "", "type", "button", 1, "p-button", "p-button-outlined", "mx-1", "w-2", 3, "label", "click"], [1, "col-12", "flex", "flex-row", "justify-content-end", "align-items-center", "mb-2"], ["pButton", "", "pRipple", "", "type", "button", "icon", "pi pi-times", 1, "p-button-rounded", "p-button-danger", "p-button-text", 3, "click"], [3, "formGroupName"], ["for", "name"], ["pInputText", "", "id", "name", "type", "text", "formControlName", "name", 3, "placeholder"], ["for", "idno"], ["pInputText", "", "id", "idno", "formControlName", "idno", "type", "text", 3, "placeholder", "maxlength"], ["for", "bod"], ["dateFormat", "dd/mm/yy", "formControlName", "bod", "appendTo", "body", "appRtl", "", 1, "p-input-calendar-custom", 3, "placeholder", "showIcon", "readonlyInput"], ["for", "nationCode"], ["id", "nationCode", "formControlName", "nationCode", "optionValue", "codeId", "appendTo", "body", "styleClass", "p-dropdown-custom", "appRtl", "", 3, "options", "placeholder", "optionLabel", "showClear", "filter"], ["for", "role"], ["pInputText", "", "id", "role", "type", "text", "formControlName", "role", 3, "placeholder"], ["for", "partnerRatio"], ["appRtl", "", 1, "p-inputgroup"], ["formControlName", "partnerRatio", 3, "useGrouping", "min", "max", "maxlength", "placeholder"], [1, "p-inputgroup-addon"], [1, "pi", "pi-percentage"], ["for", "partnerAmt"], ["pInputText", "", "id", "partnerAmt", "type", "number", "formControlName", "partnerAmt", 3, "placeholder"], [1, "sm:col-3", "md:col-2", "align-self-center"], ["pButton", "", "pRipple", "", "type", "button", "icon", "pi pi-plus", 1, "p-button-rounded", "mx-1", "p-button-info", "p-button-sm", 3, "disabled", "click"], ["pButton", "", "pRipple", "", "type", "button", "icon", "pi pi-minus", "class", "p-button-rounded p-button-info p-button-outlined mx-1 p-button-sm", 3, "disabled", "click", 4, "ngIf"], ["pButton", "", "pRipple", "", "type", "button", "icon", "pi pi-minus", 1, "p-button-rounded", "p-button-info", "p-button-outlined", "mx-1", "p-button-sm", 3, "disabled", "click"], ["pButton", "", "pRipple", "", "type", "button", 1, "p-button-raised", "p-button", "mx-1", "w-2", 3, "label", "click"]],
  template: function AddEditOrganizationComponent_Template(rf, ctx) {
    if (rf & 1) {
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](0, "section", 0);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtemplate"](1, AddEditOrganizationComponent_div_1_Template, 2, 0, "div", 1);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](2, "form", 2)(3, "p-accordion", 3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵlistener"]("activeIndexChange", function AddEditOrganizationComponent_Template_p_accordion_activeIndexChange_3_listener($event) {
        return ctx.onActiveIndexChange($event);
      });
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](4, "p-accordionTab", 4);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](5, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](6, "div", 5)(7, "div", 6)(8, "label", 7);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](10, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](11, "input", 8);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](12, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](13, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](14, "div", 6)(15, "label", 10);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](16);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](17, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](18, "input", 11);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](19, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](20, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](21, "div", 12)(22, "label", 13);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](23);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](24, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](25, "p-dropdown", 14);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](26, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](27, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](28, "div", 12)(29, "label", 15);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](30);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](31, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](32, "p-dropdown", 16);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](33, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](34, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](35, "div", 12)(36, "label", 17);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](37);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](38, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](39, "p-dropdown", 18);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](40, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](41, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](42, "div", 12)(43, "label", 19);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](44);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](45, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](46, "p-dropdown", 20);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](47, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](48, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](49, "div", 6)(50, "label", 21);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](51);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](52, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](53, "input", 22);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](54, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](55, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]()()();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](56, "p-accordionTab", 4);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](57, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](58, "div", 5)(59, "div", 6)(60, "label", 23);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](61);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](62, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](63, "p-inputNumber", 24);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](64, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](65, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](66, "div", 6)(67, "label", 25);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](68);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](69, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](70, "p-inputNumber", 26);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](71, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](72, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](73, "div", 6)(74, "label", 27);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](75);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](76, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](77, "p-calendar", 28);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](78, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](79, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](80, "div", 6)(81, "label", 29);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](82);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](83, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](84, "p-calendar", 30);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](85, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](86, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](87, "div", 6)(88, "label", 31);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](89);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](90, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](91, "p-calendar", 32);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵlistener"]("onSelect", function AddEditOrganizationComponent_Template_p_calendar_onSelect_91_listener($event) {
        return ctx.onPracticeDateChange($event);
      });
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](92, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](93, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](94, "div", 6)(95, "label", 33);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](96);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](97, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](98, "p-inputNumber", 34);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](99, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](100, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](101, "div", 6)(102, "label", 35);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](103);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](104, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](105, "input", 36);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](106, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](107, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](108, "div", 12)(109, "label", 37);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](110);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](111, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](112, "p-dropdown", 38);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](113, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](114, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]()()();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](115, "p-accordionTab", 4);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](116, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](117, "div", 5)(118, "div", 6)(119, "label", 39);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](120);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](121, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](122, "input", 40);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵlistener"]("change", function AddEditOrganizationComponent_Template_input_change_122_listener($event) {
        return ctx.changeCustIdno($event);
      });
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](123, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](124, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](125, "div", 41)(126, "label", 42);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](127);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](128, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](129, "input", 43);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](130, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](131, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](132, "div", 6)(133, "label", 44);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](134);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](135, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](136, "input", 45);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](137, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](138, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](139, "div", 6)(140, "label", 46);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](141);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](142, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](143, "input", 47);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](144, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](145, "lib-form-validation-error", 48);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](146, "div", 6)(147, "label", 49);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](148);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](149, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](150, "input", 50);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](151, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](152, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](153, "div", 6)(154, "label", 51);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](155);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](156, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](157, "input", 52);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](158, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](159, "lib-form-validation-error", 48);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](160, "div", 6)(161, "label", 53);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](162);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](163, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](164, "input", 54);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](165, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](166, "lib-form-validation-error", 48);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](167, "div", 6)(168, "label", 55);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](169);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](170, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](171, "input", 56);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](172, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](173, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]()()();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](174, "p-accordionTab", 4);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](175, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementContainerStart"](176);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](177, "div", 5)(178, "div", 57)(179, "label", 58);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](180);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](181, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](182, "p-dropdown", 59);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](183, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](184, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](185, "div", 57)(186, "label", 60);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](187);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](188, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](189, "p-dropdown", 61);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](190, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](191, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](192, "div", 57)(193, "label", 62);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](194);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](195, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](196, "input", 63);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](197, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](198, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]()();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementContainerEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](199, "p-accordionTab", 4);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](200, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementContainerStart"](201, 64);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](202, "div", 5)(203, "div", 57)(204, "label", 37);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](205);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](206, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](207, "p-dropdown", 65);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵlistener"]("onChange", function AddEditOrganizationComponent_Template_p_dropdown_onChange_207_listener($event) {
        return ctx.onStateChange($event);
      });
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](208, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](209, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](210, "div", 57)(211, "label", 66);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](212);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](213, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](214, "p-dropdown", 67);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵlistener"]("onChange", function AddEditOrganizationComponent_Template_p_dropdown_onChange_214_listener($event) {
        return ctx.onCityChange($event);
      });
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](215, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](216, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](217, "div", 57)(218, "label", 68);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](219);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](220, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](221, "p-dropdown", 69);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](222, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](223, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](224, "div", 57)(225, "label", 70);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](226);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](227, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](228, "input", 71);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](229, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](230, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](231, "div", 57)(232, "label", 72);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](233);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](234, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](235, "input", 73);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](236, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](237, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](238, "div", 57)(239, "label", 74);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](240);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](241, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](242, "input", 75);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](243, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](244, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](245, "div", 57)(246, "label", 76);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](247);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](248, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](249, "input", 77);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](250, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](251, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](252, "div", 57)(253, "label", 78);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](254);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](255, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](256, "input", 79);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](257, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](258, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](259, "div", 57)(260, "label", 80);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](261);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](262, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](263, "p-inputNumber", 81);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](264, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](265, "lib-form-validation-error", 48);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](266, "div", 82)(267, "label", 83);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtext"](268);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](269, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](270, "input", 84);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](271, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelement"](272, "lib-form-validation-error", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]()();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementContainerEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](273, "p-accordionTab", 4);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](274, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](275, "div", 5);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementContainerStart"](276, 85);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtemplate"](277, AddEditOrganizationComponent_ng_container_277_Template, 58, 85, "ng-container", 86);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementContainerEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]()()();
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](278, "div", 87);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtemplate"](279, AddEditOrganizationComponent_button_279_Template, 3, 5, "button", 88);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementStart"](280, "button", 89);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵlistener"]("click", function AddEditOrganizationComponent_Template_button_click_280_listener() {
        return ctx.isModal ? ctx.closeDialog() : ctx.backToMain();
      });
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipe"](281, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵelementEnd"]()()()();
    }
    if (rf & 2) {
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](1);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("ngIf", ctx.isModal);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](1);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formGroup", ctx.organizationForm);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](1);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("collapseIcon", "fa fa-circle-chevron-up text-xl")("expandIcon", "fa fa-circle-chevron-down text-xl")("activeIndex", ctx.activeIndex);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](1);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("header", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](5, 260, ctx.messageTranslationPrefix + "ORGANIZATION-DATA-TAB-TEXT"))("selected", true);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](5);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](10, 262, ctx.messageTranslationPrefix + "ORGANIZATION-NAME"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](12, 264, ctx.messageTranslationPrefix + "ORGANIZATION-NAME"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "orgName")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](418, _c4));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](17, 266, ctx.messageTranslationPrefix + "ORGANIZATION-ID"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](19, 268, ctx.messageTranslationPrefix + "ORGANIZATION-ID"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "orgId")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](419, _c3));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](24, 270, ctx.messageTranslationPrefix + "ORGANIZATION-TYPE"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](26, 272, ctx.messageTranslationPrefix + "ORGANIZATION-TYPE"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("options", ctx.organizationTypesList)("optionLabel", ctx.currentLanguage === "ar" ? "nameAr" : "nameEn")("showClear", false)("filter", true);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "orgType")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](420, _c3));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](31, 274, ctx.messageTranslationPrefix + "ECONMICE-ONE"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](33, 276, ctx.messageTranslationPrefix + "ECONMICE-ONE"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("options", ctx.econCode2List)("optionLabel", ctx.currentLanguage === "ar" ? "codeId1NameAr" : "codeId1NameEn");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "econCode1")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](421, _c3));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](38, 278, ctx.messageTranslationPrefix + "ECONMICE-TWO"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](40, 280, ctx.messageTranslationPrefix + "ECONMICE-TWO"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("options", ctx.econCode2List)("optionLabel", ctx.currentLanguage === "ar" ? "codeId2NameAr" : "codeId2NameEn");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "econCode2")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](422, _c3));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](45, 282, ctx.messageTranslationPrefix + "ECONMICE-THREE"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](47, 284, ctx.messageTranslationPrefix + "ECONMICE-THREE"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("options", ctx.econCode3List)("optionLabel", ctx.currentLanguage === "ar" ? "nameAr" : "nameEn")("showClear", false)("filter", true);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "econCode3")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](423, _c3));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](52, 286, ctx.messageTranslationPrefix + "ORGANIZATION-DESCR"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](54, 288, ctx.messageTranslationPrefix + "ORGANIZATION-DESCR"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "orgDescr")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](424, _c5));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](1);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("header", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](57, 290, ctx.messageTranslationPrefix + "ESTABLISHMENT-DATA-TAB-TEXT"))("selected", true);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](5);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](62, 292, ctx.messageTranslationPrefix + "TAX-FILE-NUMBER"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](64, 294, ctx.messageTranslationPrefix + "TAX-FILE-NUMBER"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("useGrouping", false);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "taxFileNo")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](425, _c6));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](69, 296, ctx.messageTranslationPrefix + "REGISTER-NUMBER"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](71, 298, ctx.messageTranslationPrefix + "REGISTER-NUMBER"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("useGrouping", false);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "regNo")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](426, _c7));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](76, 300, ctx.messageTranslationPrefix + "REGISTER-ISSUE-DATE"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](78, 302, ctx.messageTranslationPrefix + "REGISTER-ISSUE-DATE"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("showIcon", true)("readonlyInput", true);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "regIssueDate")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](427, _c8));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](83, 304, ctx.messageTranslationPrefix + "REGISTER-EXPIRE-DATE"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](85, 306, ctx.messageTranslationPrefix + "REGISTER-EXPIRE-DATE"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("showIcon", true)("readonlyInput", true)("minDate", ctx.appDate)("defaultDate", ctx.appDate);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "regExpDate")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](428, _c9));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](90, 308, ctx.messageTranslationPrefix + "PRACTICE-STRAT-DATE"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](92, 310, ctx.messageTranslationPrefix + "PRACTICE-STRAT-DATE"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("showIcon", true)("readonlyInput", true);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "practiceStartDate")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](429, _c10));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](97, 312, ctx.messageTranslationPrefix + "ORGANIZATION-CAPITAL"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](99, 314, ctx.messageTranslationPrefix + "ORGANIZATION-CAPITAL"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("useGrouping", false)("min", 0)("max", 999999999999)("maxlength", 12);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "orgCapital")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](430, _c2));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](104, 316, ctx.messageTranslationPrefix + "COUNT-EMPLOYEES"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](106, 318, ctx.messageTranslationPrefix + "COUNT-EMPLOYEES"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "countEmployees")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](431, _c4));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](111, 320, ctx.messageTranslationPrefix + "COMPANY-CATEGORY-CODE"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](113, 322, ctx.messageTranslationPrefix + "COMPANY-CATEGORY-CODE"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("options", ctx.companyCategoryList)("optionLabel", ctx.currentLanguage === "ar" ? "nameAr" : "nameEn")("showClear", false)("filter", true);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "companyCategory")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](432, _c3));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](1);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("header", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](116, 324, ctx.messageTranslationPrefix + "CONTACT-DATA-TAB-TEXT"))("selected", true);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](5);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](121, 326, ctx.messageTranslationPrefix + "ORGANIZATION-OWNER-ID-NUMBER"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](123, 328, ctx.messageTranslationPrefix + "ORGANIZATION-OWNER-ID-NUMBER"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "custIdno")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](433, _c1));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](128, 330, ctx.messageTranslationPrefix + "ORGANIZATION-OWNER-NAME"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](130, 332, ctx.messageTranslationPrefix + "ORGANIZATION-OWNER-NAME"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "orgOwenrName")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](434, _c2));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](135, 334, ctx.messageTranslationPrefix + "CONTACT-NAME"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](137, 336, ctx.messageTranslationPrefix + "CONTACT-NAME"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "contactName")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](435, _c5));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](142, 338, ctx.messageTranslationPrefix + "CONTACT-PHONE"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](144, 340, ctx.messageTranslationPrefix + "CONTACT-PHONE"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("maxlength", 11);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "contactPhone")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](436, _c11))("lengthValParam", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](437, _c12));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](149, 342, ctx.messageTranslationPrefix + "CONTACT-MAIL"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](151, 344, ctx.messageTranslationPrefix + "CONTACT-MAIL"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "contactEmail")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](438, _c13));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](156, 346, ctx.messageTranslationPrefix + "PHONE-ONE-NUMBER"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](158, 348, ctx.messageTranslationPrefix + "PHONE-ONE-NUMBER"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("maxlength", 11);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "phone1")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](439, _c11))("lengthValParam", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](440, _c12));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](163, 350, ctx.messageTranslationPrefix + "PHONE-TWO-NUMBER"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](165, 352, ctx.messageTranslationPrefix + "PHONE-TWO-NUMBER"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "phone2")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](441, _c14))("lengthValParam", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](442, _c12));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](170, 354, ctx.messageTranslationPrefix + "EMAIL"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](172, 356, ctx.messageTranslationPrefix + "EMAIL"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "email")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](443, _c13));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](1);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("header", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](175, 358, ctx.messageTranslationPrefix + "SITE-TAB-TEXT"))("selected", true);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](6);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](181, 360, ctx.messageTranslationPrefix + "PLACETYPE"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](183, 362, ctx.messageTranslationPrefix + "PLACETYPE"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("options", ctx.placeTypes)("optionLabel", ctx.currentLanguage === "ar" ? "nameAr" : "nameEn")("showClear", false)("filter", true);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "placeType")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](444, _c15));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](188, 364, ctx.messageTranslationPrefix + "PLACEOWNERSHIP"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](190, 366, ctx.messageTranslationPrefix + "PLACEOWNERSHIP"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("options", ctx.placeOwnerships)("optionLabel", ctx.currentLanguage === "ar" ? "nameAr" : "nameEn")("showClear", false)("filter", true);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "placeOwnership")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](445, _c15));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](195, 368, ctx.messageTranslationPrefix + "PLACENOOFYEARS"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](197, 370, ctx.messageTranslationPrefix + "PLACENOOFYEARS"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "placeNoOfYears")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](446, _c16));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](1);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("header", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](200, 372, ctx.messageTranslationPrefix + "ADDRESS-TAB-TEXT"))("selected", true);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](6);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](206, 374, ctx.messageTranslationPrefix + "STATE-CODE"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](208, 376, ctx.messageTranslationPrefix + "STATE-CODE"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("options", ctx.stateCodeList)("optionLabel", ctx.currentLanguage === "ar" ? "nameAr" : "nameEn")("showClear", false)("filter", true);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "address.stateCode")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](447, _c3));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](213, 378, ctx.messageTranslationPrefix + "CITY-CODE"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](215, 380, ctx.messageTranslationPrefix + "CITY-CODE"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("options", ctx.cityCodeList)("optionLabel", ctx.currentLanguage === "ar" ? "nameAr" : "nameEn")("showClear", false)("filter", true);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "address.cityCode")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](448, _c3));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](220, 382, ctx.messageTranslationPrefix + "VILLAGE-CODE"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](222, 384, ctx.messageTranslationPrefix + "VILLAGE-CODE"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("options", ctx.villagecodeList)("optionLabel", ctx.currentLanguage === "ar" ? "nameAr" : "nameEn")("showClear", false)("filter", true);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "address.villageCode")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](449, _c3));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](227, 386, ctx.messageTranslationPrefix + "STREET"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](229, 388, ctx.messageTranslationPrefix + "STREET"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "address.street")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](450, _c17));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](234, 390, ctx.messageTranslationPrefix + "BULIDING-NUMBER"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](236, 392, ctx.messageTranslationPrefix + "BULIDING-NUMBER"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("maxLength", 10);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "address.buildingNo")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](451, _c17));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](241, 394, ctx.messageTranslationPrefix + "FLOOR-NUMBER"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](243, 396, ctx.messageTranslationPrefix + "FLOOR-NUMBER"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("maxlength", 3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "address.floorNo")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](452, _c18));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](248, 398, ctx.messageTranslationPrefix + "FLAT-NUMBER"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](250, 400, ctx.messageTranslationPrefix + "FLAT-NUMBER"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("maxlength", 3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "address.flatno")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](453, _c18));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](255, 402, ctx.messageTranslationPrefix + "ADD-MARK"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](257, 404, ctx.messageTranslationPrefix + "ADD-MARK"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "address.addMark")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](454, _c17));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](262, 406, ctx.messageTranslationPrefix + "POSTAL-CODE"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](264, 408, ctx.messageTranslationPrefix + "POSTAL-CODE"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("useGrouping", false);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "address.postCode")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](455, _c19))("lengthValParam", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](456, _c20));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](269, 410, ctx.messageTranslationPrefix + "ADD-TEXT"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpropertyInterpolate"]("placeholder", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](271, 412, ctx.messageTranslationPrefix + "ADD-TEXT"));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("formInstance", ctx.organizationForm)("controlName", "address.addTxt")("validationErrorList", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpureFunction0"](457, _c21));
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](1);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("header", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](274, 414, ctx.messageTranslationPrefix + "PARTNER-DATA-TAB-TEXT"))("selected", true);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](4);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("ngForOf", ctx.getPartnerArray().controls);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](2);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("ngIf", ctx.isEditMode !== "VIEW");
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵadvance"](1);
      _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵproperty"]("label", _angular_core__WEBPACK_IMPORTED_MODULE_12__["ɵɵpipeBind1"](281, 416, ctx.commonMessages + "CANCEL-TEXT"));
    }
  },
  dependencies: [_angular_common__WEBPACK_IMPORTED_MODULE_16__.NgForOf, _angular_common__WEBPACK_IMPORTED_MODULE_16__.NgIf, _libs_shared_lib_src_lib_shared_UI_Components_form_validation_error_form_validation_error_component__WEBPACK_IMPORTED_MODULE_10__.FormValidationErrorComponent, primeng_inputtext__WEBPACK_IMPORTED_MODULE_17__.InputText, primeng_dropdown__WEBPACK_IMPORTED_MODULE_18__.Dropdown, primeng_inputnumber__WEBPACK_IMPORTED_MODULE_19__.InputNumber, primeng_button__WEBPACK_IMPORTED_MODULE_20__.ButtonDirective, _angular_forms__WEBPACK_IMPORTED_MODULE_14__["ɵNgNoValidate"], _angular_forms__WEBPACK_IMPORTED_MODULE_14__.DefaultValueAccessor, _angular_forms__WEBPACK_IMPORTED_MODULE_14__.NumberValueAccessor, _angular_forms__WEBPACK_IMPORTED_MODULE_14__.NgControlStatus, _angular_forms__WEBPACK_IMPORTED_MODULE_14__.NgControlStatusGroup, _angular_forms__WEBPACK_IMPORTED_MODULE_14__.MaxLengthValidator, primeng_accordion__WEBPACK_IMPORTED_MODULE_21__.Accordion, primeng_accordion__WEBPACK_IMPORTED_MODULE_21__.AccordionTab, primeng_calendar__WEBPACK_IMPORTED_MODULE_22__.Calendar, primeng_ripple__WEBPACK_IMPORTED_MODULE_23__.Ripple, _libs_shared_lib_src_lib_shared_directives_rtl_directive__WEBPACK_IMPORTED_MODULE_11__.RtlDirective, _angular_forms__WEBPACK_IMPORTED_MODULE_14__.FormGroupDirective, _angular_forms__WEBPACK_IMPORTED_MODULE_14__.FormControlName, _angular_forms__WEBPACK_IMPORTED_MODULE_14__.FormGroupName, _angular_forms__WEBPACK_IMPORTED_MODULE_14__.FormArrayName, _ngx_translate_core__WEBPACK_IMPORTED_MODULE_24__.TranslatePipe],
  styles: ["\n/*# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IiIsInNvdXJjZVJvb3QiOiIifQ== */"],
  encapsulation: 2
});
AddEditOrganizationComponent = (0,tslib__WEBPACK_IMPORTED_MODULE_25__.__decorate)([(0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_13__.UntilDestroy)({
  checkProperties: true
}), (0,tslib__WEBPACK_IMPORTED_MODULE_25__.__metadata)("design:paramtypes", [_angular_core__WEBPACK_IMPORTED_MODULE_12__.Injector, _microSharedLib_services_application_lookups_service__WEBPACK_IMPORTED_MODULE_4__.ApplicationLookupsService, _microSharedLib_services_financial_policies_service__WEBPACK_IMPORTED_MODULE_5__.FinancialPoliciesService, primeng_dynamicdialog__WEBPACK_IMPORTED_MODULE_15__.DynamicDialogConfig, _microSharedLib_services_rejection_reasons_service__WEBPACK_IMPORTED_MODULE_6__.RejectionReasonsService, primeng_dynamicdialog__WEBPACK_IMPORTED_MODULE_15__.DynamicDialogRef, _microSharedLib_services_lookups_service__WEBPACK_IMPORTED_MODULE_9__.LookupService])], AddEditOrganizationComponent);


/***/ })

}]);
//# sourceMappingURL=default-apps_fusion_src_app_pages_funding-request_organization_add-edit-organization_add-edit-958c56.js.map