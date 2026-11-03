"use strict";
(self["webpackChunkfusion"] = self["webpackChunkfusion"] || []).push([["default-apps_fusion_src_app_pages_funding-programs_funding-service-query_components_fund-cust-3dd9ce"],{

/***/ 59098:
/*!**********************************************************************************************************************************************************************!*\
  !*** ./apps/fusion/src/app/pages/funding-programs/funding-service-query/components/fund-cust-account-statement-modal/fund-cust-account-statement-modal.component.ts ***!
  \**********************************************************************************************************************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "FundCustAccountStatementModalComponent": () => (/* binding */ FundCustAccountStatementModalComponent)
/* harmony export */ });
/* harmony import */ var tslib__WEBPACK_IMPORTED_MODULE_16__ = __webpack_require__(/*! tslib */ 42321);
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(/*! @angular/core */ 22560);
/* harmony import */ var _fusionCore_models_enum_LocalStorageKeys_enum__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @fusionCore/models/enum/LocalStorageKeys.enum */ 83906);
/* harmony import */ var _microSharedLib_core_models_classes_FusionBase__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @microSharedLib/core/models/classes/FusionBase */ 74591);
/* harmony import */ var _microSharedLib_core_models_enum_FusionHttpStatus_enum__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! @microSharedLib/core/models/enum/FusionHttpStatus.enum */ 79090);
/* harmony import */ var _microSharedLib_services_service_query_service__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! @microSharedLib/services/service-query.service */ 60404);
/* harmony import */ var _ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(/*! @ngneat/until-destroy */ 82777);
/* harmony import */ var primeng_dynamicdialog__WEBPACK_IMPORTED_MODULE_8__ = __webpack_require__(/*! primeng/dynamicdialog */ 62648);
/* harmony import */ var _angular_common__WEBPACK_IMPORTED_MODULE_9__ = __webpack_require__(/*! @angular/common */ 94666);
/* harmony import */ var primeng_api__WEBPACK_IMPORTED_MODULE_10__ = __webpack_require__(/*! primeng/api */ 14356);
/* harmony import */ var primeng_inputtext__WEBPACK_IMPORTED_MODULE_11__ = __webpack_require__(/*! primeng/inputtext */ 69906);
/* harmony import */ var primeng_button__WEBPACK_IMPORTED_MODULE_12__ = __webpack_require__(/*! primeng/button */ 76328);
/* harmony import */ var primeng_table__WEBPACK_IMPORTED_MODULE_13__ = __webpack_require__(/*! primeng/table */ 17485);
/* harmony import */ var primeng_ripple__WEBPACK_IMPORTED_MODULE_14__ = __webpack_require__(/*! primeng/ripple */ 84538);
/* harmony import */ var _libs_shared_lib_src_lib_shared_directives_rtl_directive__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ../../../../../../../../../libs/shared-lib/src/lib/shared/directives/rtl.directive */ 9638);
/* harmony import */ var _libs_shared_lib_src_lib_shared_UI_Components_table_not_data_found_table_not_data_found_component__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ../../../../../../../../../libs/shared-lib/src/lib/shared/UI-Components/table-not-data-found/table-not-data-found.component */ 99556);
/* harmony import */ var _ngx_translate_core__WEBPACK_IMPORTED_MODULE_15__ = __webpack_require__(/*! @ngx-translate/core */ 38699);




















function FundCustAccountStatementModalComponent_ng_template_10_Template(rf, ctx) {
  if (rf & 1) {
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementStart"](0, "div", 14)(1, "div", 15)(2, "label", 16);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtext"](3);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵpipe"](4, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelement"](5, "input", 17);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementStart"](6, "div", 18)(7, "label", 16);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtext"](8);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵpipe"](9, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelement"](10, "input", 17);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementEnd"]()();
  }
  if (rf & 2) {
    const ctx_r1 = _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵnextContext"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵadvance"](3);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵpipeBind1"](4, 4, ctx_r1.messageTranslationPrefix + "FUND-CUST-TOTAL-CREDIT"));
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵproperty"]("value", ctx_r1.curerntBalance);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵadvance"](3);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtextInterpolate"](_angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵpipeBind1"](9, 6, ctx_r1.messageTranslationPrefix + "FUND-CUST-NAME"));
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵproperty"]("value", ctx_r1.custName.nameAr);
  }
}
function FundCustAccountStatementModalComponent_ng_template_11_Template(rf, ctx) {
  if (rf & 1) {
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementStart"](0, "tr")(1, "th", 19);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelement"](2, "p-sortIcon", 20);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtext"](3);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵpipe"](4, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementStart"](5, "th", 21);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelement"](6, "p-sortIcon", 22);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtext"](7);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵpipe"](8, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementStart"](9, "th");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtext"](10);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵpipe"](11, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementStart"](12, "th");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtext"](13);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵpipe"](14, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementStart"](15, "th");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtext"](16);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵpipe"](17, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementStart"](18, "th");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtext"](19);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵpipe"](20, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelement"](21, "th");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementEnd"]();
  }
  if (rf & 2) {
    const ctx_r2 = _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵnextContext"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵadvance"](3);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtextInterpolate1"](" ", _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵpipeBind1"](4, 6, ctx_r2.messageTranslationPrefix + "FUND-CUST-RECIVE-DATE"), " ");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵadvance"](4);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtextInterpolate1"](" ", _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵpipeBind1"](8, 8, ctx_r2.messageTranslationPrefix + "FUND-CUST-REF-DATE"), " ");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵadvance"](3);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtextInterpolate1"](" ", _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵpipeBind1"](11, 10, ctx_r2.messageTranslationPrefix + "FUND-CUST-REF-CODE"), " ");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵadvance"](3);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtextInterpolate1"](" ", _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵpipeBind1"](14, 12, ctx_r2.messageTranslationPrefix + "FUND-CUST-NOTE"), " ");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵadvance"](3);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtextInterpolate1"](" ", _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵpipeBind1"](17, 14, ctx_r2.messageTranslationPrefix + "FUND-CUST-RECIVE-AMT"), " ");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵadvance"](3);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtextInterpolate1"](" ", _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵpipeBind1"](20, 16, ctx_r2.messageTranslationPrefix + "FUND-CUST-PAIED-AMT"), " ");
  }
}
function FundCustAccountStatementModalComponent_ng_template_12_Template(rf, ctx) {
  if (rf & 1) {
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementStart"](0, "tr")(1, "td");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtext"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementStart"](3, "td");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtext"](4);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementStart"](5, "td");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtext"](6);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementStart"](7, "td");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtext"](8);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementStart"](9, "td");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtext"](10);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementStart"](11, "td");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtext"](12);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementEnd"]()();
  }
  if (rf & 2) {
    const data_r5 = ctx.$implicit;
    const ctx_r3 = _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵnextContext"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtextInterpolate1"](" ", data_r5 == null ? null : data_r5.appdate, " ");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtextInterpolate1"](" ", data_r5 == null ? null : data_r5.valdate, " ");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtextInterpolate1"](" ", data_r5 == null ? null : data_r5.oprno, " ");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtextInterpolate1"](" ", ctx_r3.currentLanguage === "ar" ? data_r5 == null ? null : data_r5.narrativeAr : data_r5 == null ? null : data_r5.narrativeEn, " ");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtextInterpolate"](data_r5 == null ? null : data_r5.amtCr);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtextInterpolate"](data_r5 == null ? null : data_r5.amtDr);
  }
}
function FundCustAccountStatementModalComponent_ng_template_13_ng_container_2_Template(rf, ctx) {
  if (rf & 1) {
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementContainerStart"](0);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelement"](1, "app-table-not-data-found");
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementContainerEnd"]();
  }
}
function FundCustAccountStatementModalComponent_ng_template_13_Template(rf, ctx) {
  if (rf & 1) {
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementStart"](0, "tr")(1, "td", 23);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtemplate"](2, FundCustAccountStatementModalComponent_ng_template_13_ng_container_2_Template, 2, 0, "ng-container", 24);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementEnd"]()();
  }
  if (rf & 2) {
    const ctx_r4 = _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵnextContext"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵproperty"]("ngIf", ctx_r4.tableData && ctx_r4.tableData.length <= 0);
  }
}
const _c0 = function () {
  return ["brcode", "nameAr", "nameEn", "licenseNo"];
};
let FundCustAccountStatementModalComponent = class FundCustAccountStatementModalComponent extends _microSharedLib_core_models_classes_FusionBase__WEBPACK_IMPORTED_MODULE_1__.FusionBase {
  constructor(injector, dialogRef, dialogConfig, serviceQuery) {
    super(injector);
    this.dialogRef = dialogRef;
    this.dialogConfig = dialogConfig;
    this.serviceQuery = serviceQuery;
    this.currentLanguage = '';
    this.tableData = [];
    this.curerntBalance = 0;
    this.custName = {};
    this.messageTranslationPrefix = 'PAGES.FUND-SERVICE-QUERY.MESSAGES.';
  }
  ngOnInit() {
    this.getAppLanguage();
    if (this.dialogConfig.data) {
      this.queryItem = this.dialogConfig.data.queryItem;
    }
    this.getLookupOnStart();
  }
  getAppLanguage() {
    this.currentLanguage = this.getFusionHelper().getActiveLanguage(_fusionCore_models_enum_LocalStorageKeys_enum__WEBPACK_IMPORTED_MODULE_0__.LocalStorageKeys.APP_LANG);
    this.getTranslation().onLangChange.pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_7__.untilDestroyed)(this)).subscribe(lang => {
      this.currentLanguage = lang?.lang;
    });
  }
  getLookupOnStart() {
    this.serviceQuery.getCustomerStateData(this.dialogConfig.data.queryItem.custno, this.dialogConfig.data.queryItem.prodType).pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_7__.untilDestroyed)(this)).subscribe(data => {
      console.log(data.result);
      if (data.status === _microSharedLib_core_models_enum_FusionHttpStatus_enum__WEBPACK_IMPORTED_MODULE_2__.FusionHttpStatus.STATUS_SUCCESS) {
        this.tableData = data.result.details;
        this.curerntBalance = data.result.curerntBalance;
        this.custName = {
          nameAr: data.result.subglNameAr,
          nameEn: data.result.subglNameEn
        };
      }
    });
  }
  closeDialog() {
    this.dialogRef.close({
      cancel: true,
      confirm: false
    });
  }
};
FundCustAccountStatementModalComponent.ɵfac = function FundCustAccountStatementModalComponent_Factory(t) {
  return new (t || FundCustAccountStatementModalComponent)(_angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵdirectiveInject"](_angular_core__WEBPACK_IMPORTED_MODULE_6__.Injector), _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵdirectiveInject"](primeng_dynamicdialog__WEBPACK_IMPORTED_MODULE_8__.DynamicDialogRef), _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵdirectiveInject"](primeng_dynamicdialog__WEBPACK_IMPORTED_MODULE_8__.DynamicDialogConfig), _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵdirectiveInject"](_microSharedLib_services_service_query_service__WEBPACK_IMPORTED_MODULE_3__.ServiceQueryService));
};
FundCustAccountStatementModalComponent.ɵcmp = /*@__PURE__*/_angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵdefineComponent"]({
  type: FundCustAccountStatementModalComponent,
  selectors: [["micro-finance-fund-cust-account-statement-modal"]],
  features: [_angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵInheritDefinitionFeature"]],
  decls: 17,
  vars: 13,
  consts: [[1, "fund-customer-state-wrapper", "relative"], [1, "grid", "p-fluid", "p-0", "m-0"], [1, "col-12", "flex", "flex-row", "justify-content-between", "align-items-center", "my-2", "p-0"], ["pButton", "", "pRipple", "", "type", "button", "icon", "pi pi-times", 1, "p-button-rounded", "p-button-danger", "p-button-text", 3, "click"], [1, "m-0", "text-lg", "font-bold"], [1, "col-12", "p-fluid"], ["responsiveLayout", "scroll", "appRtl", "", 1, "p-datatable-striped", "p-datatable-custom", 3, "globalFilterFields", "value", "rows", "paginator", "totalRecords", "rowsPerPageOptions"], ["dt", ""], ["pTemplate", "caption"], ["pTemplate", "header"], ["pTemplate", "body"], ["pTemplate", "emptymessage"], [1, "product-footer-wrapper", "col-12", "mx-auto", "flex", "flex-row", "justify-content-end", "align-items-center"], ["pButton", "", "pRipple", "", "type", "button", 1, "p-button", "p-button-outlined", "mx-1", "w-2", 3, "label", "click"], [1, "grid", "card", "bg-gray-100"], [1, "col-5", "field"], ["for", ""], ["pInputText", "", "disabled", "", 3, "value"], [1, "col-7", "field"], ["pSortableColumn", "appdate"], ["field", "appdate"], ["pSortableColumn", "valdate"], ["field", "valdate"], ["colspan", "100%", 1, "text-center"], [4, "ngIf"]],
  template: function FundCustAccountStatementModalComponent_Template(rf, ctx) {
    if (rf & 1) {
      _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementStart"](0, "div", 0)(1, "div", 1)(2, "div", 2)(3, "button", 3);
      _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵlistener"]("click", function FundCustAccountStatementModalComponent_Template_button_click_3_listener() {
        return ctx.closeDialog();
      });
      _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementStart"](4, "p", 4);
      _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtext"](5);
      _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵpipe"](6, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementEnd"]()();
      _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementStart"](7, "div", 5)(8, "p-table", 6, 7);
      _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtemplate"](10, FundCustAccountStatementModalComponent_ng_template_10_Template, 11, 8, "ng-template", 8);
      _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtemplate"](11, FundCustAccountStatementModalComponent_ng_template_11_Template, 22, 18, "ng-template", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtemplate"](12, FundCustAccountStatementModalComponent_ng_template_12_Template, 13, 6, "ng-template", 10);
      _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtemplate"](13, FundCustAccountStatementModalComponent_ng_template_13_Template, 3, 1, "ng-template", 11);
      _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementEnd"]()();
      _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementStart"](14, "div", 12)(15, "button", 13);
      _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵlistener"]("click", function FundCustAccountStatementModalComponent_Template_button_click_15_listener() {
        return ctx.closeDialog();
      });
      _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵpipe"](16, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelementEnd"]()()()();
    }
    if (rf & 2) {
      _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵadvance"](5);
      _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵtextInterpolate1"](" ", _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵpipeBind1"](6, 8, ctx.messageTranslationPrefix + "MENU-FUND-CUST-ACC-STATEMENT"), " ");
      _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵadvance"](3);
      _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵproperty"]("globalFilterFields", _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵpureFunction0"](12, _c0))("value", ctx.tableData)("rows", ctx.pageSize)("paginator", true)("totalRecords", ctx.rowTotalCount)("rowsPerPageOptions", ctx.rowsPerPage);
      _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵadvance"](7);
      _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵproperty"]("label", _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵpipeBind1"](16, 10, ctx.commonMessages + "CANCEL-TEXT"));
    }
  },
  dependencies: [_angular_common__WEBPACK_IMPORTED_MODULE_9__.NgIf, primeng_api__WEBPACK_IMPORTED_MODULE_10__.PrimeTemplate, primeng_inputtext__WEBPACK_IMPORTED_MODULE_11__.InputText, primeng_button__WEBPACK_IMPORTED_MODULE_12__.ButtonDirective, primeng_table__WEBPACK_IMPORTED_MODULE_13__.Table, primeng_table__WEBPACK_IMPORTED_MODULE_13__.SortableColumn, primeng_table__WEBPACK_IMPORTED_MODULE_13__.SortIcon, primeng_ripple__WEBPACK_IMPORTED_MODULE_14__.Ripple, _libs_shared_lib_src_lib_shared_directives_rtl_directive__WEBPACK_IMPORTED_MODULE_4__.RtlDirective, _libs_shared_lib_src_lib_shared_UI_Components_table_not_data_found_table_not_data_found_component__WEBPACK_IMPORTED_MODULE_5__.TableNotDataFoundComponent, _ngx_translate_core__WEBPACK_IMPORTED_MODULE_15__.TranslatePipe],
  styles: ["\n/*# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IiIsInNvdXJjZVJvb3QiOiIifQ== */"]
});
FundCustAccountStatementModalComponent = (0,tslib__WEBPACK_IMPORTED_MODULE_16__.__decorate)([(0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_7__.UntilDestroy)({
  checkProperties: true
}), (0,tslib__WEBPACK_IMPORTED_MODULE_16__.__metadata)("design:paramtypes", [_angular_core__WEBPACK_IMPORTED_MODULE_6__.Injector, primeng_dynamicdialog__WEBPACK_IMPORTED_MODULE_8__.DynamicDialogRef, primeng_dynamicdialog__WEBPACK_IMPORTED_MODULE_8__.DynamicDialogConfig, _microSharedLib_services_service_query_service__WEBPACK_IMPORTED_MODULE_3__.ServiceQueryService])], FundCustAccountStatementModalComponent);


/***/ }),

/***/ 68787:
/*!****************************************************************************************************************************************!*\
  !*** ./apps/fusion/src/app/pages/funding-programs/funding-service-query/components/fund-inquiry-modal/fund-inquiry-modal.component.ts ***!
  \****************************************************************************************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "FundInquiryModalComponent": () => (/* binding */ FundInquiryModalComponent)
/* harmony export */ });
/* harmony import */ var tslib__WEBPACK_IMPORTED_MODULE_8__ = __webpack_require__(/*! tslib */ 42321);
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(/*! @angular/core */ 22560);
/* harmony import */ var _fusionCore_models_enum_LocalStorageKeys_enum__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @fusionCore/models/enum/LocalStorageKeys.enum */ 83906);
/* harmony import */ var _microSharedLib_core_models_classes_FusionBase__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @microSharedLib/core/models/classes/FusionBase */ 74591);
/* harmony import */ var _microSharedLib_services_service_query_service__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! @microSharedLib/services/service-query.service */ 60404);
/* harmony import */ var _ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! @ngneat/until-destroy */ 82777);
/* harmony import */ var primeng_dynamicdialog__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(/*! primeng/dynamicdialog */ 62648);
/* harmony import */ var _fund_inquiry_modal_interface__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./fund-inquiry-modal.interface */ 78622);
/* harmony import */ var _libs_shared_lib_src_lib_shared_UI_Components_dynamic_popup_readonly_dynamic_popup_readonly_component__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ../../../../../../../../../libs/shared-lib/src/lib/shared/UI-Components/dynamic-popup-readonly/dynamic-popup-readonly.component */ 36915);












let FundInquiryModalComponent = class FundInquiryModalComponent extends _microSharedLib_core_models_classes_FusionBase__WEBPACK_IMPORTED_MODULE_1__.FusionBase {
  constructor(injector, serviceQuery, dialogRef, dialogConfig) {
    super(injector);
    this.serviceQuery = serviceQuery;
    this.dialogRef = dialogRef;
    this.dialogConfig = dialogConfig;
    this.currentLanguage = '';
    this.fundInquiryData = new _fund_inquiry_modal_interface__WEBPACK_IMPORTED_MODULE_3__.FundInquiryData();
    this.messageTranslationPrefix = 'PAGES.FUND-SERVICE-QUERY.MESSAGES.';
  }
  ngOnInit() {
    this.getAppLanguage();
    if (this.dialogConfig.data) {
      this.queryItem = this.dialogConfig.data.queryItem;
      this.createPageTabs(this.queryItem);
      //console.log(this.queryItem );
    }
  }

  getAppLanguage() {
    this.currentLanguage = this.getFusionHelper().getActiveLanguage(_fusionCore_models_enum_LocalStorageKeys_enum__WEBPACK_IMPORTED_MODULE_0__.LocalStorageKeys.APP_LANG);
    this.getTranslation().onLangChange.pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_5__.untilDestroyed)(this)).subscribe(lang => {
      this.currentLanguage = lang?.lang;
    });
  }
  createPageTabs(result) {
    this.getInformationQueryData(result, [{
      type: _fund_inquiry_modal_interface__WEBPACK_IMPORTED_MODULE_3__.BranchDetails,
      key: 'branchDetails'
    }, {
      type: _fund_inquiry_modal_interface__WEBPACK_IMPORTED_MODULE_3__.CustomerDetails,
      key: 'customerDetails'
    }, {
      type: _fund_inquiry_modal_interface__WEBPACK_IMPORTED_MODULE_3__.FundDetails,
      key: 'fundDetails'
    }, {
      type: _fund_inquiry_modal_interface__WEBPACK_IMPORTED_MODULE_3__.FundGivenDetails,
      key: 'fundGivenDetails'
    }, {
      type: _fund_inquiry_modal_interface__WEBPACK_IMPORTED_MODULE_3__.LoanDetails,
      key: 'loanDetails'
    }, {
      type: _fund_inquiry_modal_interface__WEBPACK_IMPORTED_MODULE_3__.EarlySettlementDebt,
      key: 'earlySettlementDebt'
    }, {
      type: _fund_inquiry_modal_interface__WEBPACK_IMPORTED_MODULE_3__.OffloadingData,
      key: 'offloadingData'
    }, {
      type: _fund_inquiry_modal_interface__WEBPACK_IMPORTED_MODULE_3__.executionData,
      key: 'executionData'
    }, {
      type: _fund_inquiry_modal_interface__WEBPACK_IMPORTED_MODULE_3__.rescheduleDate,
      key: 'rescheduleDate'
    }], 'fundInquiryTab');
    // console.log(this.fundInquiryData)
  }

  getInformationQueryData(result, objTypes, queryObjKey) {
    const query = {};
    objTypes.forEach(({
      type,
      key
    }) => {
      const obj = new type();
      this.getObjData(obj, result);
      query[key] = obj;
    });
    if (query) this.fundInquiryData[queryObjKey] = query;
  }
  getObjData(obj, data) {
    const objKeys = Object.keys(obj);
    objKeys.forEach(key => {
      if (data.hasOwnProperty(key)) {
        obj[key] = data[key];
      }
    });
    return obj;
  }
  closeDialog() {
    this.dialogRef.close({
      cancel: true,
      confirm: false
    });
  }
};
FundInquiryModalComponent.ɵfac = function FundInquiryModalComponent_Factory(t) {
  return new (t || FundInquiryModalComponent)(_angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵdirectiveInject"](_angular_core__WEBPACK_IMPORTED_MODULE_6__.Injector), _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵdirectiveInject"](_microSharedLib_services_service_query_service__WEBPACK_IMPORTED_MODULE_2__.ServiceQueryService), _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵdirectiveInject"](primeng_dynamicdialog__WEBPACK_IMPORTED_MODULE_7__.DynamicDialogRef), _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵdirectiveInject"](primeng_dynamicdialog__WEBPACK_IMPORTED_MODULE_7__.DynamicDialogConfig));
};
FundInquiryModalComponent.ɵcmp = /*@__PURE__*/_angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵdefineComponent"]({
  type: FundInquiryModalComponent,
  selectors: [["micro-finance-fund-inquiry-modal"]],
  features: [_angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵInheritDefinitionFeature"]],
  decls: 1,
  vars: 3,
  consts: [[3, "queryObj", "messagePrefix", "isTabs"]],
  template: function FundInquiryModalComponent_Template(rf, ctx) {
    if (rf & 1) {
      _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelement"](0, "micro-finance-dynamic-popup-readonly", 0);
    }
    if (rf & 2) {
      _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵproperty"]("queryObj", ctx.fundInquiryData)("messagePrefix", ctx.messageTranslationPrefix)("isTabs", false);
    }
  },
  dependencies: [_libs_shared_lib_src_lib_shared_UI_Components_dynamic_popup_readonly_dynamic_popup_readonly_component__WEBPACK_IMPORTED_MODULE_4__.DynamicPopUpReadOnlyComponent],
  styles: ["\n/*# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IiIsInNvdXJjZVJvb3QiOiIifQ== */"]
});
FundInquiryModalComponent = (0,tslib__WEBPACK_IMPORTED_MODULE_8__.__decorate)([(0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_5__.UntilDestroy)({
  checkProperties: true
}), (0,tslib__WEBPACK_IMPORTED_MODULE_8__.__metadata)("design:paramtypes", [_angular_core__WEBPACK_IMPORTED_MODULE_6__.Injector, _microSharedLib_services_service_query_service__WEBPACK_IMPORTED_MODULE_2__.ServiceQueryService, primeng_dynamicdialog__WEBPACK_IMPORTED_MODULE_7__.DynamicDialogRef, primeng_dynamicdialog__WEBPACK_IMPORTED_MODULE_7__.DynamicDialogConfig])], FundInquiryModalComponent);


/***/ }),

/***/ 78622:
/*!****************************************************************************************************************************************!*\
  !*** ./apps/fusion/src/app/pages/funding-programs/funding-service-query/components/fund-inquiry-modal/fund-inquiry-modal.interface.ts ***!
  \****************************************************************************************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "BranchDetails": () => (/* binding */ BranchDetails),
/* harmony export */   "CustomerDetails": () => (/* binding */ CustomerDetails),
/* harmony export */   "EarlySettlementDebt": () => (/* binding */ EarlySettlementDebt),
/* harmony export */   "FundDetails": () => (/* binding */ FundDetails),
/* harmony export */   "FundGivenDetails": () => (/* binding */ FundGivenDetails),
/* harmony export */   "FundInquiryData": () => (/* binding */ FundInquiryData),
/* harmony export */   "FundInquiryTab": () => (/* binding */ FundInquiryTab),
/* harmony export */   "LoanDetails": () => (/* binding */ LoanDetails),
/* harmony export */   "OffloadingData": () => (/* binding */ OffloadingData),
/* harmony export */   "executionData": () => (/* binding */ executionData),
/* harmony export */   "rescheduleDate": () => (/* binding */ rescheduleDate)
/* harmony export */ });
class FundInquiryData {
  constructor(fundInquiryTab = null) {
    this.fundInquiryTab = fundInquiryTab;
  }
}
class FundInquiryTab {
  constructor(branchDetails, customerDetails, fundDetails, fundGivenDetails, loanDetails, earlySettlementDebt, offloadingData) {
    this.branchDetails = branchDetails;
    this.customerDetails = customerDetails;
    this.fundDetails = fundDetails;
    this.fundGivenDetails = fundGivenDetails;
    this.loanDetails = loanDetails;
    this.earlySettlementDebt = earlySettlementDebt;
    this.offloadingData = offloadingData;
  }
}
class BranchDetails {
  constructor(branchName, bmCodeName, tlCodeName, loCodeName, telerName) {
    this.branchName = branchName;
    this.bmCodeName = bmCodeName;
    this.tlCodeName = tlCodeName;
    this.loCodeName = loCodeName;
    this.telerName = telerName;
  }
}
class CustomerDetails {
  constructor(custName, custno, custId, renewDescr) {
    this.custName = custName;
    this.custno = custno;
    this.custId = custId;
    this.renewDescr = renewDescr;
  }
}
class FundDetails {
  constructor(serviceId, loanName, promotionName,
  // public hangNameAr: string,
  srvStatusName, layerName, groupId, prodName, merchantName, legalActionDescr,
  // public offloadingTypeDescr: string,
  issueSrcDescr, disbursementStatus, fundingSourceDescr, insLifeCoDescr, insDebtCoDescr, archiveCode) {
    this.serviceId = serviceId;
    this.loanName = loanName;
    this.promotionName = promotionName;
    this.srvStatusName = srvStatusName;
    this.layerName = layerName;
    this.groupId = groupId;
    this.prodName = prodName;
    this.merchantName = merchantName;
    this.legalActionDescr = legalActionDescr;
    this.issueSrcDescr = issueSrcDescr;
    this.disbursementStatus = disbursementStatus;
    this.fundingSourceDescr = fundingSourceDescr;
    this.insLifeCoDescr = insLifeCoDescr;
    this.insDebtCoDescr = insDebtCoDescr;
    this.archiveCode = archiveCode;
  }
}
class FundGivenDetails {
  constructor(approveValue, addedValue, profitValue, kstAmt, totalAmount, requiredValue, netDeliverToCust, noOfKsts, noOfMonths, rate,
  // public penaltyRate: number,
  // public expRate: number,
  issueDate, openDate, fkstDate, lkstDate, expireDate) {
    this.approveValue = approveValue;
    this.addedValue = addedValue;
    this.profitValue = profitValue;
    this.kstAmt = kstAmt;
    this.totalAmount = totalAmount;
    this.requiredValue = requiredValue;
    this.netDeliverToCust = netDeliverToCust;
    this.noOfKsts = noOfKsts;
    this.noOfMonths = noOfMonths;
    this.rate = rate;
    this.issueDate = issueDate;
    this.openDate = openDate;
    this.fkstDate = fkstDate;
    this.lkstDate = lkstDate;
    this.expireDate = expireDate;
  }
}
class LoanDetails {
  constructor(balValue, debtDues, remBalKstAmt, remIntKstAmt, remPenaltyAmt, lateNoOfKst, lateKstDate, remNoOfKst, totalDebts, customerCrBalance, netTotalDebts, entryAppCommAmt, customerPindingBalance) {
    this.balValue = balValue;
    this.debtDues = debtDues;
    this.remBalKstAmt = remBalKstAmt;
    this.remIntKstAmt = remIntKstAmt;
    this.remPenaltyAmt = remPenaltyAmt;
    this.lateNoOfKst = lateNoOfKst;
    this.lateKstDate = lateKstDate;
    this.remNoOfKst = remNoOfKst;
    this.totalDebts = totalDebts;
    this.customerCrBalance = customerCrBalance;
    this.netTotalDebts = netTotalDebts;
    this.entryAppCommAmt = entryAppCommAmt;
    this.customerPindingBalance = customerPindingBalance;
  }
}
class EarlySettlementDebt {
  constructor(earlyPaymentRequired, netEarlyPaymentRequired, earlyIntRate, earlyIntAmt, earlyKstIntPayed) {
    this.earlyPaymentRequired = earlyPaymentRequired;
    this.netEarlyPaymentRequired = netEarlyPaymentRequired;
    this.earlyIntRate = earlyIntRate;
    this.earlyIntAmt = earlyIntAmt;
    this.earlyKstIntPayed = earlyKstIntPayed;
  }
}
class OffloadingData {
  constructor(offloadingTypeDescr, offloadingBanknoName, offloadingAppdate) {
    this.offloadingTypeDescr = offloadingTypeDescr;
    this.offloadingBanknoName = offloadingBanknoName;
    this.offloadingAppdate = offloadingAppdate;
  }
}
class executionData {
  constructor(writoffType, writoffDescription, writoffDate, writoffBal, writoffTotDebt, writoffPayments, writoffUnpaiedNoKst) {
    this.writoffType = writoffType;
    this.writoffDescription = writoffDescription;
    this.writoffDate = writoffDate;
    this.writoffBal = writoffBal;
    this.writoffTotDebt = writoffTotDebt;
    this.writoffPayments = writoffPayments;
    this.writoffUnpaiedNoKst = writoffUnpaiedNoKst;
  }
}
class rescheduleDate {
  constructor(reschUpdateDate, reschExecuteDate, reschTotalAmount, reschCommAmount, reschProfitAmount) {
    this.reschUpdateDate = reschUpdateDate;
    this.reschExecuteDate = reschExecuteDate;
    this.reschTotalAmount = reschTotalAmount;
    this.reschCommAmount = reschCommAmount;
    this.reschProfitAmount = reschProfitAmount;
    this.reschUpdateDate = this.removeTime(reschUpdateDate);
    this.reschExecuteDate = this.removeTime(reschExecuteDate);
  }
  removeTime(dateStr) {
    return dateStr?.split(' ')[0] ?? '';
  }
}

/***/ })

}]);
//# sourceMappingURL=default-apps_fusion_src_app_pages_funding-programs_funding-service-query_components_fund-cust-3dd9ce.js.map