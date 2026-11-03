"use strict";
(self["webpackChunkfusion"] = self["webpackChunkfusion"] || []).push([["apps_fusion_src_app_pages_funding-programs_funding-programs_module_ts"],{

/***/ 31024:
/*!***************************************************************************************!*\
  !*** ./apps/fusion/src/app/pages/funding-programs/funding-programs-routing.module.ts ***!
  \***************************************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "FundingProgramsRoutingModule": () => (/* binding */ FundingProgramsRoutingModule)
/* harmony export */ });
/* harmony import */ var _angular_router__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! @angular/router */ 60124);
/* harmony import */ var _microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @microSharedLib/core/models/enum/FusionModuleScreens.model */ 7070);
/* harmony import */ var ngx_permissions__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ngx-permissions */ 98209);
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! @angular/core */ 22560);





const routes = [{
  path: 'pay-order-commissions',
  loadChildren: () => Promise.all(/*! import() */[__webpack_require__.e("default-libs_shared-lib_src_lib_shared_validator_CustomValidation_ts"), __webpack_require__.e("default-libs_shared-lib_src_lib_services_funding-request_service_ts"), __webpack_require__.e("common"), __webpack_require__.e("apps_fusion_src_app_pages_funding-programs_pay-order-commissions_pay-order-commissions_module_ts")]).then(__webpack_require__.bind(__webpack_require__, /*! ./pay-order-commissions/pay-order-commissions.module */ 33864)).then(m => m.PayOrderCommissionsModule),
  canLoad: [ngx_permissions__WEBPACK_IMPORTED_MODULE_1__.NgxPermissionsGuard],
  data: {
    screenName: _microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.FUNDING_PAY_ORDER_COMMISSIONS_ITEM,
    permissions: {
      only: [_microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.FUNDING_PAY_ORDER_COMMISSIONS_ITEM],
      redirectTo: '/dashboard'
    }
  }
}, {
  path: 'funding-disbursement',
  loadChildren: () => Promise.all(/*! import() */[__webpack_require__.e("default-libs_shared-lib_src_lib_services_funding-request_service_ts"), __webpack_require__.e("default-node_modules_primeng_fesm2020_primeng-treetable_mjs"), __webpack_require__.e("apps_fusion_src_app_pages_funding-programs_funding-disbursement_funding-disbursement_module_ts")]).then(__webpack_require__.bind(__webpack_require__, /*! ./funding-disbursement/funding-disbursement.module */ 13947)).then(m => m.FundingDisbursementModule),
  canLoad: [ngx_permissions__WEBPACK_IMPORTED_MODULE_1__.NgxPermissionsGuard],
  data: {
    screenName: _microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.FUNDING_REQUESTS_FUNDING_DISBURSEMENT_ITEM,
    permissions: {
      only: [_microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.FUNDING_REQUESTS_FUNDING_DISBURSEMENT_ITEM],
      redirectTo: '/dashboard'
    }
  }
}, {
  path: 'funding-branch-disbursement',
  loadChildren: () => Promise.all(/*! import() */[__webpack_require__.e("default-libs_shared-lib_src_lib_shared_validator_CustomValidation_ts"), __webpack_require__.e("default-libs_shared-lib_src_lib_services_funding-request_service_ts"), __webpack_require__.e("default-node_modules_primeng_fesm2020_primeng-treetable_mjs"), __webpack_require__.e("apps_fusion_src_app_pages_funding-programs_funding-branch-disbursment_funding-branch-disbursm-b53faf")]).then(__webpack_require__.bind(__webpack_require__, /*! ./funding-branch-disbursment/funding-branch-disbursment.module */ 10189)).then(m => m.FundingBranchDisbursmentModule),
  canLoad: [ngx_permissions__WEBPACK_IMPORTED_MODULE_1__.NgxPermissionsGuard],
  data: {
    screenName: _microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.FUNDING_DISBURSEMENT_ITEM,
    permissions: {
      only: [_microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.FUNDING_DISBURSEMENT_ITEM],
      redirectTo: '/dashboard'
    }
  }
}, {
  path: 'group-disbursement',
  loadChildren: () => Promise.all(/*! import() */[__webpack_require__.e("default-libs_shared-lib_src_lib_services_funding-request_service_ts"), __webpack_require__.e("default-node_modules_primeng_fesm2020_primeng-treetable_mjs"), __webpack_require__.e("apps_fusion_src_app_pages_funding-programs_group-disbursement_group-disbursement_module_ts")]).then(__webpack_require__.bind(__webpack_require__, /*! ./group-disbursement/group-disbursement.module */ 6905)).then(m => m.GroupDisbursementModule),
  canLoad: [ngx_permissions__WEBPACK_IMPORTED_MODULE_1__.NgxPermissionsGuard],
  data: {
    screenName: _microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.GROUP_FUND_CREATE_DEBT_ITEM,
    permissions: {
      only: [_microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.GROUP_FUND_CREATE_DEBT_ITEM],
      redirectTo: '/dashboard'
    }
  }
}, {
  path: 'premium-collection',
  loadChildren: () => Promise.all(/*! import() */[__webpack_require__.e("default-libs_shared-lib_src_lib_shared_validator_CustomValidation_ts"), __webpack_require__.e("default-libs_shared-lib_src_lib_services_funding-request_service_ts"), __webpack_require__.e("common"), __webpack_require__.e("apps_fusion_src_app_pages_funding-programs_premium-collection_premium-collection_module_ts")]).then(__webpack_require__.bind(__webpack_require__, /*! ./premium-collection/premium-collection.module */ 22617)).then(m => m.PremiumCollectionModule),
  canLoad: [ngx_permissions__WEBPACK_IMPORTED_MODULE_1__.NgxPermissionsGuard],
  data: {
    screenName: _microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.FUNDING_PREMIUM_COLLECTION_ITEM,
    permissions: {
      only: [_microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.FUNDING_PREMIUM_COLLECTION_ITEM],
      redirectTo: '/dashboard'
    }
  }
}, {
  path: 'funding-close',
  loadChildren: () => Promise.all(/*! import() */[__webpack_require__.e("default-libs_shared-lib_src_lib_shared_validator_CustomValidation_ts"), __webpack_require__.e("default-libs_shared-lib_src_lib_services_funding-request_service_ts"), __webpack_require__.e("apps_fusion_src_app_pages_funding-programs_funding-close_funding-close_module_ts")]).then(__webpack_require__.bind(__webpack_require__, /*! ./funding-close/funding-close.module */ 68295)).then(m => m.FundingCloseModule),
  canLoad: [ngx_permissions__WEBPACK_IMPORTED_MODULE_1__.NgxPermissionsGuard],
  data: {
    screenName: _microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.FUNDING_CLOSE_FUND_FULLPAYMENT_ITEM,
    permissions: {
      only: [_microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.FUNDING_CLOSE_FUND_FULLPAYMENT_ITEM],
      redirectTo: '/dashboard'
    }
  }
}, {
  path: 'premium-collection-from-file',
  loadChildren: () => Promise.all(/*! import() */[__webpack_require__.e("default-libs_shared-lib_src_lib_services_funding-request_service_ts"), __webpack_require__.e("common"), __webpack_require__.e("apps_fusion_src_app_pages_funding-programs_premium-collection-from-file_premium-collection-fr-3453d3")]).then(__webpack_require__.bind(__webpack_require__, /*! ./premium-collection-from-file/premium-collection-from-file.module */ 35173)).then(m => m.PremiumCollectionFromFileModule),
  canLoad: [ngx_permissions__WEBPACK_IMPORTED_MODULE_1__.NgxPermissionsGuard],
  data: {
    screenName: _microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.FUNDING_PREMIUM_COLLECTION_FILE_ITEM,
    permissions: {
      only: [_microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.FUNDING_PREMIUM_COLLECTION_FILE_ITEM],
      redirectTo: '/dashboard'
    }
  }
}, {
  path: 'clearance-payment',
  loadChildren: () => Promise.all(/*! import() */[__webpack_require__.e("default-libs_shared-lib_src_lib_services_funding-request_service_ts"), __webpack_require__.e("apps_fusion_src_app_pages_funding-programs_clearance-payment_clearance-payment_module_ts")]).then(__webpack_require__.bind(__webpack_require__, /*! ./clearance-payment/clearance-payment.module */ 95785)).then(m => m.ClearancePaymentModule),
  canLoad: [ngx_permissions__WEBPACK_IMPORTED_MODULE_1__.NgxPermissionsGuard],
  data: {
    screenName: _microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.FUNDING_CLEARANCE_PAYMENT_ITEM,
    permissions: {
      only: [_microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.FUNDING_CLEARANCE_PAYMENT_ITEM],
      redirectTo: '/dashboard'
    }
  }
}, {
  path: 'early-payment',
  loadChildren: () => Promise.all(/*! import() */[__webpack_require__.e("default-libs_shared-lib_src_lib_shared_validator_CustomValidation_ts"), __webpack_require__.e("default-libs_shared-lib_src_lib_services_funding-request_service_ts"), __webpack_require__.e("apps_fusion_src_app_pages_funding-programs_early-payment_early-payment_module_ts")]).then(__webpack_require__.bind(__webpack_require__, /*! ./early-payment/early-payment.module */ 86539)).then(m => m.EarlyPaymentModule),
  canLoad: [ngx_permissions__WEBPACK_IMPORTED_MODULE_1__.NgxPermissionsGuard],
  data: {
    screenName: _microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.FUNDING_EARLY_PAYMENT_ITEM,
    permissions: {
      only: [_microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.FUNDING_EARLY_PAYMENT_ITEM],
      redirectTo: '/dashboard'
    }
  }
}, {
  path: 'cancel-funding-disbursement',
  loadChildren: () => Promise.all(/*! import() */[__webpack_require__.e("default-libs_shared-lib_src_lib_services_funding-request_service_ts"), __webpack_require__.e("default-node_modules_primeng_fesm2020_primeng-treetable_mjs"), __webpack_require__.e("apps_fusion_src_app_pages_funding-programs_cancel-funding-disbursement_cancel-funding-disburs-006cbb")]).then(__webpack_require__.bind(__webpack_require__, /*! ./cancel-funding-disbursement/cancel-funding-disbursement.module */ 57308)).then(m => m.CancelFundingDisbursementModule),
  canLoad: [ngx_permissions__WEBPACK_IMPORTED_MODULE_1__.NgxPermissionsGuard],
  data: {
    screenName: _microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.FUNDING_CANCEL_FUNDING_DISBURSEMENT_ITEM,
    permissions: {
      only: [_microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.FUNDING_CANCEL_FUNDING_DISBURSEMENT_ITEM],
      redirectTo: '/dashboard'
    }
  }
}, {
  path: 'postpone-premiums',
  loadChildren: () => Promise.all(/*! import() */[__webpack_require__.e("default-libs_shared-lib_src_lib_services_funding-request_service_ts"), __webpack_require__.e("default-node_modules_lodash_lodash_js"), __webpack_require__.e("common"), __webpack_require__.e("apps_fusion_src_app_pages_funding-programs_postpone-premiums_postpone-premiums_module_ts")]).then(__webpack_require__.bind(__webpack_require__, /*! ./postpone-premiums/postpone-premiums.module */ 44164)).then(m => m.PostponePremiumModule),
  canLoad: [ngx_permissions__WEBPACK_IMPORTED_MODULE_1__.NgxPermissionsGuard],
  data: {
    screenName: _microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.FUNDING_POSTPONE_PREMIUMS_ITEM,
    permissions: {
      only: [_microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.FUNDING_POSTPONE_PREMIUMS_ITEM],
      redirectTo: '/dashboard'
    }
  }
}, {
  path: 'reschedule',
  loadChildren: () => Promise.all(/*! import() */[__webpack_require__.e("default-libs_shared-lib_src_lib_services_funding-request_service_ts"), __webpack_require__.e("default-node_modules_lodash_lodash_js"), __webpack_require__.e("common"), __webpack_require__.e("apps_fusion_src_app_pages_funding-programs_reschedule_reschedule_module_ts")]).then(__webpack_require__.bind(__webpack_require__, /*! ./reschedule/reschedule.module */ 84373)).then(m => m.RescheduleModule),
  canLoad: [ngx_permissions__WEBPACK_IMPORTED_MODULE_1__.NgxPermissionsGuard]
  // data: {
  //   screenName: FusionAppScreens.SERVICE_TRANS_RESCHDULE_ITEM,
  //   permissions: {
  //     only: [FusionAppScreens.SERVICE_TRANS_RESCHDULE_ITEM],
  //     redirectTo: '/dashboard',
  //   },
  // },
}, {
  path: 'updateGroupLending',
  loadChildren: () => Promise.all(/*! import() */[__webpack_require__.e("default-libs_shared-lib_src_lib_services_funding-request_service_ts"), __webpack_require__.e("apps_fusion_src_app_pages_funding-programs_group-lending_group-lending_module_ts")]).then(__webpack_require__.bind(__webpack_require__, /*! ./group-lending/group-lending.module */ 58798)).then(m => m.GroupLendingModule),
  canLoad: [ngx_permissions__WEBPACK_IMPORTED_MODULE_1__.NgxPermissionsGuard]
  // data: {
  //   screenName: FusionAppScreens.SERVICE_TRANS_RESCHDULE_ITEM,
  //   permissions: {
  //     only: [FusionAppScreens.SERVICE_TRANS_RESCHDULE_ITEM],
  //     redirectTo: '/dashboard',
  //   },
  // },
}, {
  path: 'updateGroupLending',
  loadChildren: () => Promise.all(/*! import() */[__webpack_require__.e("default-libs_shared-lib_src_lib_services_funding-request_service_ts"), __webpack_require__.e("apps_fusion_src_app_pages_funding-programs_group-lending_group-lending_module_ts")]).then(__webpack_require__.bind(__webpack_require__, /*! ./group-lending/group-lending.module */ 58798)).then(m => m.GroupLendingModule),
  canLoad: [ngx_permissions__WEBPACK_IMPORTED_MODULE_1__.NgxPermissionsGuard]
  // data: {
  //   screenName: FusionAppScreens.SERVICE_TRANS_RESCHDULE_ITEM,
  //   permissions: {
  //     only: [FusionAppScreens.SERVICE_TRANS_RESCHDULE_ITEM],
  //     redirectTo: '/dashboard',
  //   },
  // },
}, {
  path: 'funding-download-docs',
  loadChildren: () => Promise.all(/*! import() */[__webpack_require__.e("default-libs_shared-lib_src_lib_services_funding-request_service_ts"), __webpack_require__.e("apps_fusion_src_app_pages_funding-programs_funding-download-docs_funding-download-docs_module_ts")]).then(__webpack_require__.bind(__webpack_require__, /*! ./funding-download-docs/funding-download-docs.module */ 93252)).then(m => m.FundingDownloadDocsModule),
  canLoad: [ngx_permissions__WEBPACK_IMPORTED_MODULE_1__.NgxPermissionsGuard]
  // data: {
  //   screenName: FusionAppScreens.FUNDING_DOWNLOAD_DOCS_ITEM,
  //   permissions: {
  //     only: [FusionAppScreens.FUNDING_DOWNLOAD_DOCS_ITEM],
  //     redirectTo: '/dashboard',
  //   },
  // },
}, {
  path: 'funding-personal-service-query',
  loadChildren: () => Promise.all(/*! import() */[__webpack_require__.e("default-libs_shared-lib_src_lib_shared_validator_CustomValidation_ts"), __webpack_require__.e("default-libs_shared-lib_src_lib_services_funding-request_service_ts"), __webpack_require__.e("default-libs_shared-lib_src_lib_services_financial-policies_service_ts"), __webpack_require__.e("default-libs_shared-lib_src_lib_services_lookups_service_ts-libs_shared-lib_src_lib_services_-73072a"), __webpack_require__.e("default-apps_fusion_src_app_pages_funding-programs_funding-service-query_components_fund-inst-a6a1c9"), __webpack_require__.e("default-apps_fusion_src_app_pages_funding-request_customer_customer-info_customer-info_component_ts"), __webpack_require__.e("default-node_modules_lodash_lodash_js"), __webpack_require__.e("default-apps_fusion_src_app_pages_funding-request_organization_add-edit-organization_add-edit-958c56"), __webpack_require__.e("default-apps_fusion_src_app_pages_funding-programs_funding-service-query_components_fund-guar-8edeb2"), __webpack_require__.e("default-apps_fusion_src_app_pages_funding-programs_funding-service-query_components_fund-cust-3dd9ce"), __webpack_require__.e("default-apps_fusion_src_app_pages_funding-request_fund-track_components_fund-track-query-data-72e3b2"), __webpack_require__.e("default-apps_fusion_src_app_pages_funding-programs_funding-service-query_components_fund-docu-086350"), __webpack_require__.e("common"), __webpack_require__.e("apps_fusion_src_app_pages_funding-programs_funding-service-query_funding-service-query_module_ts")]).then(__webpack_require__.bind(__webpack_require__, /*! ./funding-service-query/funding-service-query.module */ 92218)).then(m => m.FundingServiceQueryModule),
  canLoad: [ngx_permissions__WEBPACK_IMPORTED_MODULE_1__.NgxPermissionsGuard],
  data: {
    screenName: _microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.FUNDING_QUERY_SERVICE_ITEM,
    permissions: {
      only: [_microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.FUNDING_QUERY_SERVICE_ITEM],
      redirectTo: '/dashboard'
    }
  }
}, {
  path: 'merge-services',
  loadChildren: () => Promise.all(/*! import() */[__webpack_require__.e("default-libs_shared-lib_src_lib_services_funding-request_service_ts"), __webpack_require__.e("apps_fusion_src_app_pages_funding-programs_merge-services_merge-services_module_ts")]).then(__webpack_require__.bind(__webpack_require__, /*! ./merge-services/merge-services.module */ 72930)).then(m => m.MergeServicesModule),
  canLoad: [ngx_permissions__WEBPACK_IMPORTED_MODULE_1__.NgxPermissionsGuard],
  data: {
    screenName: _microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.FUNDING_MERGE_SERVICE_ITEM,
    permissions: {
      only: [_microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.FUNDING_MERGE_SERVICE_ITEM],
      redirectTo: '/dashboard'
    }
  }
}, {
  path: 'disbursement-payments',
  loadChildren: () => Promise.all(/*! import() */[__webpack_require__.e("default-libs_shared-lib_src_lib_services_funding-request_service_ts"), __webpack_require__.e("apps_fusion_src_app_pages_funding-programs_disbursement-payments_disbursment-payments_module_ts")]).then(__webpack_require__.bind(__webpack_require__, /*! ./disbursement-payments/disbursment-payments.module */ 73706)).then(m => m.DisbursmentPaymentsModule),
  canLoad: [ngx_permissions__WEBPACK_IMPORTED_MODULE_1__.NgxPermissionsGuard],
  data: {
    screenName: _microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.FUNDING_DISBURSEMENT_SEGMENTATION_ITEM,
    permissions: {
      only: [_microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.FUNDING_DISBURSEMENT_SEGMENTATION_ITEM],
      redirectTo: '/dashboard'
    }
  }
}, {
  path: 'update-funding-segmentation',
  loadChildren: () => Promise.all(/*! import() */[__webpack_require__.e("default-libs_shared-lib_src_lib_services_funding-request_service_ts"), __webpack_require__.e("apps_fusion_src_app_pages_funding-programs_update-fund-segmentation_update-fund-segmentation_-4ae505")]).then(__webpack_require__.bind(__webpack_require__, /*! ./update-fund-segmentation/update-fund-segmentation.module */ 521)).then(m => m.UpdateFundSegmentationModule),
  canLoad: [ngx_permissions__WEBPACK_IMPORTED_MODULE_1__.NgxPermissionsGuard],
  data: {
    screenName: _microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.UPDATE_FUND_SEGMENTATION_ITEM,
    permissions: {
      only: [_microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.UPDATE_FUND_SEGMENTATION_ITEM],
      redirectTo: '/dashboard'
    }
  }
}, {
  path: 'update-funding-documents',
  loadChildren: () => Promise.all(/*! import() */[__webpack_require__.e("default-libs_shared-lib_src_lib_services_funding-request_service_ts"), __webpack_require__.e("apps_fusion_src_app_pages_funding-programs_update-funding-documents_update-funding-documents_-a1dac1")]).then(__webpack_require__.bind(__webpack_require__, /*! ./update-funding-documents/update-funding-documents.module */ 35945)).then(m => m.UpdateFundingDocumentsModule),
  canLoad: [ngx_permissions__WEBPACK_IMPORTED_MODULE_1__.NgxPermissionsGuard],
  data: {
    screenName: _microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.UPDATE_FUND_DOCUMENTS_ITEM,
    permissions: {
      only: [_microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.UPDATE_FUND_DOCUMENTS_ITEM],
      redirectTo: '/dashboard'
    }
  }
}, {
  path: 'insurance-booking-item',
  loadChildren: () => Promise.all(/*! import() */[__webpack_require__.e("default-libs_shared-lib_src_lib_shared_validator_CustomValidation_ts"), __webpack_require__.e("default-libs_shared-lib_src_lib_services_funding-request_service_ts"), __webpack_require__.e("default-libs_shared-lib_src_lib_services_financial-policies_service_ts"), __webpack_require__.e("apps_fusion_src_app_pages_funding-programs_booking-insurance_booking-insurance_module_ts")]).then(__webpack_require__.bind(__webpack_require__, /*! ./booking-insurance/booking-insurance.module */ 8104)).then(m => m.BookingInsuranceModule),
  canLoad: [ngx_permissions__WEBPACK_IMPORTED_MODULE_1__.NgxPermissionsGuard],
  data: {
    screenName: _microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.INSURANCE_BOOKING_ITEM,
    permissions: {
      only: [_microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.INSURANCE_BOOKING_ITEM],
      redirectTo: '/dashboard'
    }
  }
}, {
  path: 'cancel-insurance-booking-item',
  loadChildren: () => Promise.all(/*! import() */[__webpack_require__.e("default-libs_shared-lib_src_lib_services_funding-request_service_ts"), __webpack_require__.e("apps_fusion_src_app_pages_funding-programs_cancel-booking-insurance_cancel-booking-insurance_-08e583")]).then(__webpack_require__.bind(__webpack_require__, /*! ./cancel-booking-insurance/cancel-booking-insurance.module */ 41868)).then(m => m.CancelBookingInsuranceModule),
  canLoad: [ngx_permissions__WEBPACK_IMPORTED_MODULE_1__.NgxPermissionsGuard],
  data: {
    screenName: _microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.INSURANCE_CANCEL_BOOKING_ITEM,
    permissions: {
      only: [_microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.INSURANCE_CANCEL_BOOKING_ITEM],
      redirectTo: '/dashboard'
    }
  }
}, {
  path: 'clearance-branch-printing-item',
  loadChildren: () => Promise.all(/*! import() */[__webpack_require__.e("default-libs_shared-lib_src_lib_shared_validator_CustomValidation_ts"), __webpack_require__.e("default-libs_shared-lib_src_lib_services_funding-request_service_ts"), __webpack_require__.e("default-node_modules_primeng_fesm2020_primeng-treetable_mjs"), __webpack_require__.e("apps_fusion_src_app_pages_funding-programs_clearance-branch-printing-item_clearance-branch-pr-2b18b5")]).then(__webpack_require__.bind(__webpack_require__, /*! ./clearance-branch-printing-item/clearance-branch-printing.module */ 30997)).then(m => m.ClearanceBranchPrintingModule),
  canLoad: [ngx_permissions__WEBPACK_IMPORTED_MODULE_1__.NgxPermissionsGuard],
  data: {
    screenName: _microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.CLEARANCE_PRINT_BRANCH_ITEM,
    permissions: {
      only: [_microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.CLEARANCE_PRINT_BRANCH_ITEM],
      redirectTo: '/dashboard'
    }
  }
}, {
  path: 'clearance-customer-exception-item',
  loadChildren: () => Promise.all(/*! import() */[__webpack_require__.e("default-libs_shared-lib_src_lib_shared_validator_CustomValidation_ts"), __webpack_require__.e("default-libs_shared-lib_src_lib_services_funding-request_service_ts"), __webpack_require__.e("default-node_modules_primeng_fesm2020_primeng-treetable_mjs"), __webpack_require__.e("apps_fusion_src_app_pages_funding-programs_clearance-customer-exception-item_clearance-custom-5aa30e")]).then(__webpack_require__.bind(__webpack_require__, /*! ./clearance-customer-exception-item/clearance-customer-exception.module */ 51658)).then(m => m.ClearanceCustomerExceptionModule),
  canLoad: [ngx_permissions__WEBPACK_IMPORTED_MODULE_1__.NgxPermissionsGuard],
  data: {
    screenName: _microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.CLEARANCE_PRINT_CUSTOMER_EXCEPTION_ITEM,
    permissions: {
      only: [_microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.CLEARANCE_PRINT_CUSTOMER_EXCEPTION_ITEM],
      redirectTo: '/dashboard'
    }
  }
}, {
  path: 'clearance-main-branch-printing-item',
  loadChildren: () => Promise.all(/*! import() */[__webpack_require__.e("default-libs_shared-lib_src_lib_services_funding-request_service_ts"), __webpack_require__.e("default-node_modules_primeng_fesm2020_primeng-treetable_mjs"), __webpack_require__.e("apps_fusion_src_app_pages_funding-programs_clearance-main-branch-printing-item_clearance-main-634d1f")]).then(__webpack_require__.bind(__webpack_require__, /*! ./clearance-main-branch-printing-item/clearance-main-branch-printing-item.module */ 91268)).then(m => m.ClearanceMainBranchPrintingModule),
  canLoad: [ngx_permissions__WEBPACK_IMPORTED_MODULE_1__.NgxPermissionsGuard],
  data: {
    screenName: _microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.CLEARANCE_PRINT_MAIN_BRANCH_ITEM,
    permissions: {
      only: [_microSharedLib_core_models_enum_FusionModuleScreens_model__WEBPACK_IMPORTED_MODULE_0__.FusionAppScreens.CLEARANCE_PRINT_MAIN_BRANCH_ITEM],
      redirectTo: '/dashboard'
    }
  }
}];
class FundingProgramsRoutingModule {}
FundingProgramsRoutingModule.ɵfac = function FundingProgramsRoutingModule_Factory(t) {
  return new (t || FundingProgramsRoutingModule)();
};
FundingProgramsRoutingModule.ɵmod = /*@__PURE__*/_angular_core__WEBPACK_IMPORTED_MODULE_2__["ɵɵdefineNgModule"]({
  type: FundingProgramsRoutingModule
});
FundingProgramsRoutingModule.ɵinj = /*@__PURE__*/_angular_core__WEBPACK_IMPORTED_MODULE_2__["ɵɵdefineInjector"]({
  imports: [_angular_router__WEBPACK_IMPORTED_MODULE_3__.RouterModule.forChild(routes), _angular_router__WEBPACK_IMPORTED_MODULE_3__.RouterModule]
});
(function () {
  (typeof ngJitMode === "undefined" || ngJitMode) && _angular_core__WEBPACK_IMPORTED_MODULE_2__["ɵɵsetNgModuleScope"](FundingProgramsRoutingModule, {
    imports: [_angular_router__WEBPACK_IMPORTED_MODULE_3__.RouterModule],
    exports: [_angular_router__WEBPACK_IMPORTED_MODULE_3__.RouterModule]
  });
})();

/***/ }),

/***/ 41383:
/*!*******************************************************************************!*\
  !*** ./apps/fusion/src/app/pages/funding-programs/funding-programs.module.ts ***!
  \*******************************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "FundingProgramsModule": () => (/* binding */ FundingProgramsModule)
/* harmony export */ });
/* harmony import */ var _angular_common__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! @angular/common */ 94666);
/* harmony import */ var _funding_programs_routing_module__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./funding-programs-routing.module */ 31024);
/* harmony import */ var _microSharedLib_shared_SharedFusion_module__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @microSharedLib/shared/SharedFusion.module */ 25916);
/* harmony import */ var _microSharedLib_shared_UI_Components_UI_Components_module__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! @microSharedLib/shared/UI-Components/UI-Components.module */ 13554);
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! @angular/core */ 22560);





class FundingProgramsModule {}
FundingProgramsModule.ɵfac = function FundingProgramsModule_Factory(t) {
  return new (t || FundingProgramsModule)();
};
FundingProgramsModule.ɵmod = /*@__PURE__*/_angular_core__WEBPACK_IMPORTED_MODULE_3__["ɵɵdefineNgModule"]({
  type: FundingProgramsModule
});
FundingProgramsModule.ɵinj = /*@__PURE__*/_angular_core__WEBPACK_IMPORTED_MODULE_3__["ɵɵdefineInjector"]({
  imports: [_angular_common__WEBPACK_IMPORTED_MODULE_4__.CommonModule, _funding_programs_routing_module__WEBPACK_IMPORTED_MODULE_0__.FundingProgramsRoutingModule, _microSharedLib_shared_SharedFusion_module__WEBPACK_IMPORTED_MODULE_1__.SharedFusionModule, _microSharedLib_shared_UI_Components_UI_Components_module__WEBPACK_IMPORTED_MODULE_2__.UiComponentsModule]
});
(function () {
  (typeof ngJitMode === "undefined" || ngJitMode) && _angular_core__WEBPACK_IMPORTED_MODULE_3__["ɵɵsetNgModuleScope"](FundingProgramsModule, {
    imports: [_angular_common__WEBPACK_IMPORTED_MODULE_4__.CommonModule, _funding_programs_routing_module__WEBPACK_IMPORTED_MODULE_0__.FundingProgramsRoutingModule, _microSharedLib_shared_SharedFusion_module__WEBPACK_IMPORTED_MODULE_1__.SharedFusionModule, _microSharedLib_shared_UI_Components_UI_Components_module__WEBPACK_IMPORTED_MODULE_2__.UiComponentsModule]
  });
})();

/***/ })

}]);
//# sourceMappingURL=apps_fusion_src_app_pages_funding-programs_funding-programs_module_ts.js.map