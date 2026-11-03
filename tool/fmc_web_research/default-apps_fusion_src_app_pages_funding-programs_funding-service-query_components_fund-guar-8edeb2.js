"use strict";
(self["webpackChunkfusion"] = self["webpackChunkfusion"] || []).push([["default-apps_fusion_src_app_pages_funding-programs_funding-service-query_components_fund-guar-8edeb2"],{

/***/ 39494:
/*!********************************************************************************************************************************************!*\
  !*** ./apps/fusion/src/app/pages/funding-programs/funding-service-query/components/fund-guarantor-modal/fund-guarantor-modal.component.ts ***!
  \********************************************************************************************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "FundGuarantorModalComponent": () => (/* binding */ FundGuarantorModalComponent)
/* harmony export */ });
/* harmony import */ var tslib__WEBPACK_IMPORTED_MODULE_16__ = __webpack_require__(/*! tslib */ 42321);
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(/*! @angular/core */ 22560);
/* harmony import */ var _fusionCore_models_enum_LocalStorageKeys_enum__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @fusionCore/models/enum/LocalStorageKeys.enum */ 83906);
/* harmony import */ var _fusionPages_funding_request_customer_basic_data_view_customer_basic_data_view_customer_basic_data_component__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @fusionPages/funding-request/customer-basic-data/view-customer-basic-data/view-customer-basic-data.component */ 74011);
/* harmony import */ var _microSharedLib_core_models_classes_FusionBase__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! @microSharedLib/core/models/classes/FusionBase */ 74591);
/* harmony import */ var _microSharedLib_core_models_enum_FusionHttpStatus_enum__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! @microSharedLib/core/models/enum/FusionHttpStatus.enum */ 79090);
/* harmony import */ var _microSharedLib_services_service_query_service__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! @microSharedLib/services/service-query.service */ 60404);
/* harmony import */ var _ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_8__ = __webpack_require__(/*! @ngneat/until-destroy */ 82777);
/* harmony import */ var primeng_dynamicdialog__WEBPACK_IMPORTED_MODULE_9__ = __webpack_require__(/*! primeng/dynamicdialog */ 62648);
/* harmony import */ var _angular_common__WEBPACK_IMPORTED_MODULE_10__ = __webpack_require__(/*! @angular/common */ 94666);
/* harmony import */ var primeng_api__WEBPACK_IMPORTED_MODULE_11__ = __webpack_require__(/*! primeng/api */ 14356);
/* harmony import */ var primeng_button__WEBPACK_IMPORTED_MODULE_12__ = __webpack_require__(/*! primeng/button */ 76328);
/* harmony import */ var primeng_table__WEBPACK_IMPORTED_MODULE_13__ = __webpack_require__(/*! primeng/table */ 17485);
/* harmony import */ var primeng_ripple__WEBPACK_IMPORTED_MODULE_14__ = __webpack_require__(/*! primeng/ripple */ 84538);
/* harmony import */ var _libs_shared_lib_src_lib_shared_directives_rtl_directive__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ../../../../../../../../../libs/shared-lib/src/lib/shared/directives/rtl.directive */ 9638);
/* harmony import */ var _libs_shared_lib_src_lib_shared_UI_Components_table_not_data_found_table_not_data_found_component__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(/*! ../../../../../../../../../libs/shared-lib/src/lib/shared/UI-Components/table-not-data-found/table-not-data-found.component */ 99556);
/* harmony import */ var _ngx_translate_core__WEBPACK_IMPORTED_MODULE_15__ = __webpack_require__(/*! @ngx-translate/core */ 38699);




















function FundGuarantorModalComponent_ng_template_10_Template(rf, ctx) {
  if (rf & 1) {
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementStart"](0, "tr")(1, "th", 13);
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵtext"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵpipe"](3, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementStart"](4, "th", 14);
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵtext"](5);
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵpipe"](6, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementStart"](7, "th", 15);
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵtext"](8);
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵpipe"](9, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementStart"](10, "th");
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵtext"](11);
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵpipe"](12, "translate");
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelement"](13, "th");
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementEnd"]();
  }
  if (rf & 2) {
    const ctx_r1 = _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵnextContext"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵtextInterpolate1"](" ", _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵpipeBind1"](3, 4, ctx_r1.messageTranslationPrefix + "GRANT-ID-NO"), " ");
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵadvance"](3);
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵtextInterpolate1"](" ", _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵpipeBind1"](6, 6, ctx_r1.messageTranslationPrefix + "ORDER-BY"), " ");
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵadvance"](3);
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵtextInterpolate1"](" ", _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵpipeBind1"](9, 8, ctx_r1.messageTranslationPrefix + "GRANT-FULL-NAME"), " ");
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵadvance"](3);
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵtextInterpolate1"](" ", _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵpipeBind1"](12, 10, ctx_r1.messageTranslationPrefix + "RELATION-TYPE"), " ");
  }
}
function FundGuarantorModalComponent_ng_template_11_Template(rf, ctx) {
  if (rf & 1) {
    const _r8 = _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵgetCurrentView"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementStart"](0, "tr")(1, "td");
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵtext"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementStart"](3, "td");
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵtext"](4);
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementStart"](5, "td");
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵtext"](6);
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementStart"](7, "td");
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵtext"](8);
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementEnd"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementStart"](9, "td")(10, "button", 16);
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵlistener"]("click", function FundGuarantorModalComponent_ng_template_11_Template_button_click_10_listener() {
      const restoredCtx = _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵrestoreView"](_r8);
      const data_r4 = restoredCtx.$implicit;
      const ctx_r7 = _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵnextContext"]();
      return _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵresetView"](ctx_r7.showGrantDetails("VIEW", data_r4));
    });
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementEnd"]()()();
  }
  if (rf & 2) {
    const data_r4 = ctx.$implicit;
    const ctx_r2 = _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵnextContext"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵtextInterpolate"](data_r4 == null ? null : data_r4.grantIdno);
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵtextInterpolate"](data_r4 == null ? null : data_r4.orderby);
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵtextInterpolate"](data_r4 == null ? null : data_r4.grantFullName);
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵtextInterpolate1"](" ", ctx_r2.currentLanguage === "ar" ? data_r4 == null ? null : data_r4.relationTypeAr : data_r4 == null ? null : data_r4.relationTypeEn, " ");
  }
}
function FundGuarantorModalComponent_ng_template_12_ng_container_2_Template(rf, ctx) {
  if (rf & 1) {
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementContainerStart"](0);
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelement"](1, "app-table-not-data-found");
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementContainerEnd"]();
  }
}
function FundGuarantorModalComponent_ng_template_12_Template(rf, ctx) {
  if (rf & 1) {
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementStart"](0, "tr")(1, "td", 17);
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵtemplate"](2, FundGuarantorModalComponent_ng_template_12_ng_container_2_Template, 2, 0, "ng-container", 18);
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementEnd"]()();
  }
  if (rf & 2) {
    const ctx_r3 = _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵnextContext"]();
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵadvance"](2);
    _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵproperty"]("ngIf", ctx_r3.tableData && ctx_r3.tableData.length <= 0);
  }
}
let FundGuarantorModalComponent = class FundGuarantorModalComponent extends _microSharedLib_core_models_classes_FusionBase__WEBPACK_IMPORTED_MODULE_2__.FusionBase {
  constructor(injector, dialogRef, dialogConfig, dialogService, serviceQuery) {
    super(injector);
    this.dialogRef = dialogRef;
    this.dialogConfig = dialogConfig;
    this.dialogService = dialogService;
    this.serviceQuery = serviceQuery;
    this.currentLanguage = '';
    this.tableData = [];
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
    this.getTranslation().onLangChange.pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_8__.untilDestroyed)(this)).subscribe(lang => {
      this.currentLanguage = lang?.lang;
    });
  }
  convertDate(d) {
    if (d !== null) {
      d = d.split('/');
      let newDate = new Date(d[2] + '/' + d[1] + '/' + d[0]);
      console.log(newDate);
      return newDate;
    } else {
      return new Date();
    }
  }
  // calculateDiff(installmentPayedDate, installmentDate) {
  //   console.log(installmentPayedDate, installmentDate);
  //   installmentDate = this.convertDate(installmentDate);
  //   installmentPayedDate = this.convertDate(installmentPayedDate);
  //   const diffTime = Math.abs(installmentPayedDate - installmentDate);
  //   const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  //   console.log(diffDays + ' days');
  //   return diffDays;
  // }
  showGrantDetails(mode = 'VIEW', data) {
    const ref = this.dialogService.open(_fusionPages_funding_request_customer_basic_data_view_customer_basic_data_view_customer_basic_data_component__WEBPACK_IMPORTED_MODULE_1__.ViewCustomerBasicDataComponent, {
      width: '75vw',
      height: '80vh',
      modal: true,
      rtl: true,
      showHeader: false,
      closeOnEscape: true,
      closable: true,
      data: {
        isModal: true,
        idno: data.grantIdno,
        isEditMode: mode,
        isGuar: true
      },
      styleClass: 'p-2'
    });
  }
  getLookupOnStart() {
    const {
      status,
      serviceId
    } = this.dialogConfig.data.queryItem;
    this.serviceQuery.getGrantors(status, serviceId).pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_8__.untilDestroyed)(this)).subscribe(data => {
      console.log(data.result);
      if (data.status === _microSharedLib_core_models_enum_FusionHttpStatus_enum__WEBPACK_IMPORTED_MODULE_3__.FusionHttpStatus.STATUS_SUCCESS) {
        this.tableData = data.result.data;
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
FundGuarantorModalComponent.ɵfac = function FundGuarantorModalComponent_Factory(t) {
  return new (t || FundGuarantorModalComponent)(_angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵdirectiveInject"](_angular_core__WEBPACK_IMPORTED_MODULE_7__.Injector), _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵdirectiveInject"](primeng_dynamicdialog__WEBPACK_IMPORTED_MODULE_9__.DynamicDialogRef), _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵdirectiveInject"](primeng_dynamicdialog__WEBPACK_IMPORTED_MODULE_9__.DynamicDialogConfig), _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵdirectiveInject"](primeng_dynamicdialog__WEBPACK_IMPORTED_MODULE_9__.DialogService), _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵdirectiveInject"](_microSharedLib_services_service_query_service__WEBPACK_IMPORTED_MODULE_4__.ServiceQueryService));
};
FundGuarantorModalComponent.ɵcmp = /*@__PURE__*/_angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵdefineComponent"]({
  type: FundGuarantorModalComponent,
  selectors: [["micro-finance-fund-guarantor-modal"]],
  features: [_angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵInheritDefinitionFeature"]],
  decls: 16,
  vars: 11,
  consts: [[1, "fund-installment-page-wrapper", "relative", "h-100"], [1, "col-12", "flex", "flex-row", "justify-content-between", "align-items-center", "m-0", "p-0"], ["pButton", "", "pRipple", "", "type", "button", "icon", "pi pi-times", 1, "p-button-rounded", "p-button-danger", "p-button-text", 3, "click"], [1, "m-0", "text-lg", "font-bold"], [1, "grid", "p-fluid", "p-0", "m-0", "h-80"], [1, "col-12"], ["responsiveLayout", "scroll", "appRtl", "", 1, "p-datatable-striped", "p-datatable-custom", 3, "value", "rows", "paginator", "totalRecords", "rowsPerPageOptions"], ["dt", ""], ["pTemplate", "header"], ["pTemplate", "body"], ["pTemplate", "emptymessage"], [1, "product-footer-wrapper", "col-12", "mx-auto", "p-0", "flex", "flex-row", "justify-content-end", "align-items-center"], ["pButton", "", "pRipple", "", "type", "button", 1, "p-button", "p-button-outlined", "mx-1", "w-2", 3, "label", "click"], ["pSortableColumn", "serviceId"], ["pSortableColumn", "installmentDate"], ["pSortableColumn", "installmentAmount"], ["pButton", "", "pRipple", "", "type", "button", "icon", "pi pi-eye", 1, "p-button-rounded", "p-button-text", 3, "click"], ["colspan", "100%", 1, "text-center"], [4, "ngIf"]],
  template: function FundGuarantorModalComponent_Template(rf, ctx) {
    if (rf & 1) {
      _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementStart"](0, "div", 0)(1, "div", 1)(2, "button", 2);
      _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵlistener"]("click", function FundGuarantorModalComponent_Template_button_click_2_listener() {
        return ctx.closeDialog();
      });
      _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementEnd"]();
      _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementStart"](3, "p", 3);
      _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵtext"](4);
      _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵpipe"](5, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementEnd"]()();
      _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementStart"](6, "div", 4)(7, "div", 5)(8, "p-table", 6, 7);
      _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵtemplate"](10, FundGuarantorModalComponent_ng_template_10_Template, 14, 12, "ng-template", 8);
      _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵtemplate"](11, FundGuarantorModalComponent_ng_template_11_Template, 11, 4, "ng-template", 9);
      _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵtemplate"](12, FundGuarantorModalComponent_ng_template_12_Template, 3, 1, "ng-template", 10);
      _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementEnd"]()()();
      _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementStart"](13, "div", 11)(14, "button", 12);
      _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵlistener"]("click", function FundGuarantorModalComponent_Template_button_click_14_listener() {
        return ctx.closeDialog();
      });
      _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵpipe"](15, "translate");
      _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵelementEnd"]()()();
    }
    if (rf & 2) {
      _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵadvance"](4);
      _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵtextInterpolate1"](" ", _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵpipeBind1"](5, 7, ctx.messageTranslationPrefix + "MENU-FUND-GRANT-QUERY"), " ");
      _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵadvance"](4);
      _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵproperty"]("value", ctx.tableData)("rows", ctx.pageSize)("paginator", true)("totalRecords", ctx.rowTotalCount)("rowsPerPageOptions", ctx.rowsPerPage);
      _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵadvance"](6);
      _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵproperty"]("label", _angular_core__WEBPACK_IMPORTED_MODULE_7__["ɵɵpipeBind1"](15, 9, ctx.commonMessages + "CANCEL-TEXT"));
    }
  },
  dependencies: [_angular_common__WEBPACK_IMPORTED_MODULE_10__.NgIf, primeng_api__WEBPACK_IMPORTED_MODULE_11__.PrimeTemplate, primeng_button__WEBPACK_IMPORTED_MODULE_12__.ButtonDirective, primeng_table__WEBPACK_IMPORTED_MODULE_13__.Table, primeng_table__WEBPACK_IMPORTED_MODULE_13__.SortableColumn, primeng_ripple__WEBPACK_IMPORTED_MODULE_14__.Ripple, _libs_shared_lib_src_lib_shared_directives_rtl_directive__WEBPACK_IMPORTED_MODULE_5__.RtlDirective, _libs_shared_lib_src_lib_shared_UI_Components_table_not_data_found_table_not_data_found_component__WEBPACK_IMPORTED_MODULE_6__.TableNotDataFoundComponent, _ngx_translate_core__WEBPACK_IMPORTED_MODULE_15__.TranslatePipe],
  styles: ["\n/*# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IiIsInNvdXJjZVJvb3QiOiIifQ== */"]
});
FundGuarantorModalComponent = (0,tslib__WEBPACK_IMPORTED_MODULE_16__.__decorate)([(0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_8__.UntilDestroy)({
  checkProperties: true
}), (0,tslib__WEBPACK_IMPORTED_MODULE_16__.__metadata)("design:paramtypes", [_angular_core__WEBPACK_IMPORTED_MODULE_7__.Injector, primeng_dynamicdialog__WEBPACK_IMPORTED_MODULE_9__.DynamicDialogRef, primeng_dynamicdialog__WEBPACK_IMPORTED_MODULE_9__.DynamicDialogConfig, primeng_dynamicdialog__WEBPACK_IMPORTED_MODULE_9__.DialogService, _microSharedLib_services_service_query_service__WEBPACK_IMPORTED_MODULE_4__.ServiceQueryService])], FundGuarantorModalComponent);


/***/ }),

/***/ 74011:
/*!**************************************************************************************************************************************!*\
  !*** ./apps/fusion/src/app/pages/funding-request/customer-basic-data/view-customer-basic-data/view-customer-basic-data.component.ts ***!
  \**************************************************************************************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "ViewCustomerBasicDataComponent": () => (/* binding */ ViewCustomerBasicDataComponent)
/* harmony export */ });
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @angular/core */ 22560);
/* harmony import */ var primeng_dynamicdialog__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! primeng/dynamicdialog */ 62648);
/* harmony import */ var _customer_customer_info_customer_info_component__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../../customer/customer-info/customer-info.component */ 40258);




class ViewCustomerBasicDataComponent {
  constructor(dialogConfig) {
    this.dialogConfig = dialogConfig;
  }
  ngOnInit() {
    if (this.dialogConfig.data) {
      this.idno = this.dialogConfig.data.idno;
      this.isModal = this.dialogConfig.data.isModal;
    }
  }
}
ViewCustomerBasicDataComponent.ɵfac = function ViewCustomerBasicDataComponent_Factory(t) {
  return new (t || ViewCustomerBasicDataComponent)(_angular_core__WEBPACK_IMPORTED_MODULE_1__["ɵɵdirectiveInject"](primeng_dynamicdialog__WEBPACK_IMPORTED_MODULE_2__.DynamicDialogConfig));
};
ViewCustomerBasicDataComponent.ɵcmp = /*@__PURE__*/_angular_core__WEBPACK_IMPORTED_MODULE_1__["ɵɵdefineComponent"]({
  type: ViewCustomerBasicDataComponent,
  selectors: [["micro-finance-view-customer-basic-data"]],
  decls: 1,
  vars: 1,
  consts: [[3, "idno"]],
  template: function ViewCustomerBasicDataComponent_Template(rf, ctx) {
    if (rf & 1) {
      _angular_core__WEBPACK_IMPORTED_MODULE_1__["ɵɵelement"](0, "micro-finance-customer-info-query", 0);
    }
    if (rf & 2) {
      _angular_core__WEBPACK_IMPORTED_MODULE_1__["ɵɵproperty"]("idno", ctx.idno);
    }
  },
  dependencies: [_customer_customer_info_customer_info_component__WEBPACK_IMPORTED_MODULE_0__.CustomerInfoComponent],
  encapsulation: 2
});

/***/ }),

/***/ 60404:
/*!*******************************************************************!*\
  !*** ./libs/shared-lib/src/lib/services/service-query.service.ts ***!
  \*******************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "ServiceQueryService": () => (/* binding */ ServiceQueryService)
/* harmony export */ });
/* harmony import */ var _http_HttpCall_service__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./http/HttpCall.service */ 42682);
/* harmony import */ var _microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @microSharedLib/core/models/enum/FusionServers.enum */ 44721);
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! @angular/core */ 22560);




class ServiceQueryService {
  constructor(http) {
    this.http = http;
  }
  geteAllServiceQuery(queryData) {
    return this.http.post(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_1__.FusionServers.BASE_API_SERVER, `query/service/findService`, queryData ? {
      ...queryData
    } : {});
  }
  geteAllGrantorsQuery(serviceId) {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_1__.FusionServers.BASE_API_SERVER, `query/service/grantors`, {
      serviceId
    });
  }
  getInstallmentData(serviceId) {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_1__.FusionServers.BASE_API_SERVER, `query/premiumsData`, {
      serviceId
    });
  }
  // getDocumentData(serviceId: any) {
  //   return this.http.getAll<HttpResponseModel>(
  //     FusionServers.BASE_API_SERVER,
  //     `query/docs/service`,
  //     { serviceId }
  //   );
  // }
  getCustomerStateData(custNo, prodType) {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_1__.FusionServers.BASE_API_SERVER, `query/glCustomerStatement`, {
      custNo,
      prodType
    });
  }
  // getPenaltyData(serviceId: any) {
  //   return this.http.getAll<HttpResponseModel>(
  //     FusionServers.BASE_API_SERVER,
  //     `query/penalty`,
  //     { serviceId }
  //   );
  // }
  getMicroFinancialStudy(custNo, serviceId) {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_1__.FusionServers.BASE_API_SERVER, `query/service/microFinancialStudy`, {
      custNo,
      serviceId
    });
  }
  getGrantors(status, serviceId) {
    let endpoint;
    if ([70, 80, 81, 71].includes(status)) {
      endpoint = 'query/service/writeOff/grantors';
    } else if ([50, 60, -1].includes(status)) {
      endpoint = 'query/service/closed/grantors';
    } else {
      endpoint = 'query/service/grantors';
    }
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_1__.FusionServers.BASE_API_SERVER, endpoint, {
      serviceId
    });
  }
  getPremiumsData(status, serviceId) {
    let endpoint;
    if ([70, 80, 81, 71].includes(status)) {
      endpoint = 'query/writeOff/premiumsData';
    } else if ([50, 60, -1].includes(status)) {
      endpoint = 'query/closed/premiumsData';
    } else {
      endpoint = 'query/premiumsData';
    }
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_1__.FusionServers.BASE_API_SERVER, endpoint, {
      serviceId
    });
  }
  getPenaltyData(status, serviceId) {
    let endpoint;
    if ([70, 80, 81, 71].includes(status)) {
      endpoint = 'query/writeOff/penalty';
    } else if ([50, 60, -1].includes(status)) {
      endpoint = 'query/closed/penalty';
    } else {
      endpoint = 'query/penalty';
    }
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_1__.FusionServers.BASE_API_SERVER, endpoint, {
      serviceId
    });
  }
  getenhancedDocumentData(status, serviceId) {
    let endpoint = `query/docs/service/enhanced?wfCode=1`;
    // status === 0 || status > 999 ? 'query/wfDocs/service' : 'query/docs/service';
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_1__.FusionServers.BASE_API_SERVER, endpoint, {
      serviceId
    });
  }
  getDocumentData(status, serviceId) {
    let endpoint = 'query/docs/service';
    // status === 0 || status > 999 ? 'query/wfDocs/service' : 'query/docs/service';
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_1__.FusionServers.BASE_API_SERVER, endpoint, {
      serviceId
    });
  }
  getDocumentByServiceId(serviceId) {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_1__.FusionServers.BASE_API_SERVER, `query/docs/service/update?serviceId=${serviceId}`);
  }
  getDocumentDataReview(status, serviceId) {
    let endpoint = 'offloading/docs/service';
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_1__.FusionServers.BASE_API_SERVER, endpoint, {
      serviceId
    });
  }
}
ServiceQueryService.ɵfac = function ServiceQueryService_Factory(t) {
  return new (t || ServiceQueryService)(_angular_core__WEBPACK_IMPORTED_MODULE_2__["ɵɵinject"](_http_HttpCall_service__WEBPACK_IMPORTED_MODULE_0__.HttpCall));
};
ServiceQueryService.ɵprov = /*@__PURE__*/_angular_core__WEBPACK_IMPORTED_MODULE_2__["ɵɵdefineInjectable"]({
  token: ServiceQueryService,
  factory: ServiceQueryService.ɵfac,
  providedIn: 'root'
});

/***/ })

}]);
//# sourceMappingURL=default-apps_fusion_src_app_pages_funding-programs_funding-service-query_components_fund-guar-8edeb2.js.map