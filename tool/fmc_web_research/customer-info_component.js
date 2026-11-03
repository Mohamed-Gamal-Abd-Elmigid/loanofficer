"use strict";
(self["webpackChunkfusion"] = self["webpackChunkfusion"] || []).push([["default-apps_fusion_src_app_pages_funding-request_customer_customer-info_customer-info_component_ts"],{

/***/ 40258:
/*!*****************************************************************************************************!*\
  !*** ./apps/fusion/src/app/pages/funding-request/customer/customer-info/customer-info.component.ts ***!
  \*****************************************************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "CustomerInfoComponent": () => (/* binding */ CustomerInfoComponent)
/* harmony export */ });
/* harmony import */ var tslib__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(/*! tslib */ 42321);
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(/*! @angular/core */ 22560);
/* harmony import */ var _fusionCore_models_enum_LocalStorageKeys_enum__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @fusionCore/models/enum/LocalStorageKeys.enum */ 83906);
/* harmony import */ var _microSharedLib_core_models_classes_FusionBase__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @microSharedLib/core/models/classes/FusionBase */ 74591);
/* harmony import */ var _ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! @ngneat/until-destroy */ 82777);
/* harmony import */ var _customer_info_service__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./customer-info.service */ 99215);
/* harmony import */ var _customerQuery_interface__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./customerQuery.interface */ 23706);
/* harmony import */ var _libs_shared_lib_src_lib_shared_UI_Components_dynamic_popup_readonly_dynamic_popup_readonly_component__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ../../../../../../../../libs/shared-lib/src/lib/shared/UI-Components/dynamic-popup-readonly/dynamic-popup-readonly.component */ 36915);










let CustomerInfoComponent = class CustomerInfoComponent extends _microSharedLib_core_models_classes_FusionBase__WEBPACK_IMPORTED_MODULE_1__.FusionBase {
  constructor(injector, customerQuery) {
    super(injector);
    this.customerQuery = customerQuery;
    this.currentLanguage = '';
    this.activeIndex = 0;
    this.customerQueryObj = new _customerQuery_interface__WEBPACK_IMPORTED_MODULE_3__.customerQueryModel();
    this.messageTranslationPrefix = 'PAGES.CUSTOMER-INFO-VIEW-PAGE.MESSAGES.';
  }
  ngOnInit() {
    this.userSession = this.localStorageService.getSessionStorage(_fusionCore_models_enum_LocalStorageKeys_enum__WEBPACK_IMPORTED_MODULE_0__.LocalStorageKeys.APP_TOKEN_SESSION);
    this.getAppLanguage();
    if (this.idno) {
      this.customerQuery.customerQuery(this.idno).pipe((0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_5__.untilDestroyed)(this)).subscribe(res => {
        const result = res.result[0];
        this.createPageTabs(result);
      });
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
      type: _customerQuery_interface__WEBPACK_IMPORTED_MODULE_3__.CustomerInformation,
      key: 'customerInformation'
    }, {
      type: _customerQuery_interface__WEBPACK_IMPORTED_MODULE_3__.IdAddressInformation,
      key: 'idAddressInformation'
    }, {
      type: _customerQuery_interface__WEBPACK_IMPORTED_MODULE_3__.AddressInformation,
      key: 'addressInformation'
    }, {
      type: _customerQuery_interface__WEBPACK_IMPORTED_MODULE_3__.ContactInformation,
      key: 'contactInformation'
    }], 'CustomerInformationQuery');
    this.getInformationQueryData(result, [{
      type: _customerQuery_interface__WEBPACK_IMPORTED_MODULE_3__.CreditInformation,
      key: 'creditInformation'
    }, {
      type: _customerQuery_interface__WEBPACK_IMPORTED_MODULE_3__.GrantCreditInformation,
      key: 'grantCreditInformation'
    }, {
      type: _customerQuery_interface__WEBPACK_IMPORTED_MODULE_3__.IScoreInformation,
      key: 'iScoreInformation'
    }], 'creditInformationQuery');
    this.getInformationQueryData(result, [{
      type: _customerQuery_interface__WEBPACK_IMPORTED_MODULE_3__.CreditStatusInformation,
      key: 'creditStatusInformation'
    }, {
      type: _customerQuery_interface__WEBPACK_IMPORTED_MODULE_3__.GuaranteesInformation,
      key: 'guaranteesInformation'
    }], 'creditStatusInformationQuery');
    this.getInformationQueryData(result, [{
      type: _customerQuery_interface__WEBPACK_IMPORTED_MODULE_3__.WorkplaceInformation,
      key: 'workplaceInformation'
    }], 'workplaceInformationQuery');
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
    if (query) this.customerQueryObj[queryObjKey] = query;
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
};
CustomerInfoComponent.ɵfac = function CustomerInfoComponent_Factory(t) {
  return new (t || CustomerInfoComponent)(_angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵdirectiveInject"](_angular_core__WEBPACK_IMPORTED_MODULE_6__.Injector), _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵdirectiveInject"](_customer_info_service__WEBPACK_IMPORTED_MODULE_2__.CustomerQueryService));
};
CustomerInfoComponent.ɵcmp = /*@__PURE__*/_angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵdefineComponent"]({
  type: CustomerInfoComponent,
  selectors: [["micro-finance-customer-info-query"]],
  inputs: {
    idno: "idno"
  },
  features: [_angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵInheritDefinitionFeature"]],
  decls: 1,
  vars: 2,
  consts: [[3, "queryObj", "messagePrefix"]],
  template: function CustomerInfoComponent_Template(rf, ctx) {
    if (rf & 1) {
      _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵelement"](0, "micro-finance-dynamic-popup-readonly", 0);
    }
    if (rf & 2) {
      _angular_core__WEBPACK_IMPORTED_MODULE_6__["ɵɵproperty"]("queryObj", ctx.customerQueryObj)("messagePrefix", ctx.messageTranslationPrefix);
    }
  },
  dependencies: [_libs_shared_lib_src_lib_shared_UI_Components_dynamic_popup_readonly_dynamic_popup_readonly_component__WEBPACK_IMPORTED_MODULE_4__.DynamicPopUpReadOnlyComponent],
  styles: ["\n/*# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IiIsInNvdXJjZVJvb3QiOiIifQ== */"]
});
CustomerInfoComponent = (0,tslib__WEBPACK_IMPORTED_MODULE_7__.__decorate)([(0,_ngneat_until_destroy__WEBPACK_IMPORTED_MODULE_5__.UntilDestroy)({
  checkProperties: true
}), (0,tslib__WEBPACK_IMPORTED_MODULE_7__.__metadata)("design:paramtypes", [_angular_core__WEBPACK_IMPORTED_MODULE_6__.Injector, _customer_info_service__WEBPACK_IMPORTED_MODULE_2__.CustomerQueryService])], CustomerInfoComponent);


/***/ }),

/***/ 99215:
/*!***************************************************************************************************!*\
  !*** ./apps/fusion/src/app/pages/funding-request/customer/customer-info/customer-info.service.ts ***!
  \***************************************************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "CustomerQueryService": () => (/* binding */ CustomerQueryService)
/* harmony export */ });
/* harmony import */ var _microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @microSharedLib/core/models/enum/FusionServers.enum */ 44721);
/* harmony import */ var _microSharedLib_services_http_HttpCall_service__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @microSharedLib/services/http/HttpCall.service */ 42682);
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! @angular/core */ 22560);
/* harmony import */ var ngx_spinner__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ngx-spinner */ 17217);






class CustomerQueryService {
  constructor(http, spinnerService) {
    this.http = http;
    this.spinnerService = spinnerService;
  }
  customerQuery(idno) {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, 'query/customer', {
      idno
    });
  }
}
CustomerQueryService.ɵfac = function CustomerQueryService_Factory(t) {
  return new (t || CustomerQueryService)(_angular_core__WEBPACK_IMPORTED_MODULE_2__["ɵɵinject"](_microSharedLib_services_http_HttpCall_service__WEBPACK_IMPORTED_MODULE_1__.HttpCall), _angular_core__WEBPACK_IMPORTED_MODULE_2__["ɵɵinject"](ngx_spinner__WEBPACK_IMPORTED_MODULE_3__.NgxSpinnerService));
};
CustomerQueryService.ɵprov = /*@__PURE__*/_angular_core__WEBPACK_IMPORTED_MODULE_2__["ɵɵdefineInjectable"]({
  token: CustomerQueryService,
  factory: CustomerQueryService.ɵfac,
  providedIn: 'root'
});

/***/ }),

/***/ 23706:
/*!*****************************************************************************************************!*\
  !*** ./apps/fusion/src/app/pages/funding-request/customer/customer-info/customerQuery.interface.ts ***!
  \*****************************************************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "AddressInformation": () => (/* binding */ AddressInformation),
/* harmony export */   "ContactInformation": () => (/* binding */ ContactInformation),
/* harmony export */   "CreditInformation": () => (/* binding */ CreditInformation),
/* harmony export */   "CreditInformationQuery": () => (/* binding */ CreditInformationQuery),
/* harmony export */   "CreditStatusInformation": () => (/* binding */ CreditStatusInformation),
/* harmony export */   "CreditStatusInformationQuery": () => (/* binding */ CreditStatusInformationQuery),
/* harmony export */   "CustomerInformation": () => (/* binding */ CustomerInformation),
/* harmony export */   "CustomerInformationQuery": () => (/* binding */ CustomerInformationQuery),
/* harmony export */   "GrantCreditInformation": () => (/* binding */ GrantCreditInformation),
/* harmony export */   "GuaranteesInformation": () => (/* binding */ GuaranteesInformation),
/* harmony export */   "IScoreInformation": () => (/* binding */ IScoreInformation),
/* harmony export */   "IdAddressInformation": () => (/* binding */ IdAddressInformation),
/* harmony export */   "WorkplaceInformation": () => (/* binding */ WorkplaceInformation),
/* harmony export */   "WorkplaceInformationQuery": () => (/* binding */ WorkplaceInformationQuery),
/* harmony export */   "customerQueryModel": () => (/* binding */ customerQueryModel)
/* harmony export */ });
class customerQueryModel {
  constructor(CustomerInformationQuery = null, creditInformationQuery = null, creditStatusInformationQuery = null, workplaceInformationQuery = null) {
    this.CustomerInformationQuery = CustomerInformationQuery;
    this.creditInformationQuery = creditInformationQuery;
    this.creditStatusInformationQuery = creditStatusInformationQuery;
    this.workplaceInformationQuery = workplaceInformationQuery;
  }
}
// CUSTOMER INFORMATION INTERFACES !!==
class CustomerInformationQuery {
  constructor(customerInformation = null, idAddressInformation = null, addressInformation = null, contactInformation = null) {
    this.customerInformation = customerInformation;
    this.idAddressInformation = idAddressInformation;
    this.addressInformation = addressInformation;
    this.contactInformation = contactInformation;
  }
}
class CustomerInformation {
  constructor(lastUpdateDate = null, custno = null, fullname = null, nickname = null, idNumber = null, idIssueDate = null, idExpDate = null, birthdate = null, custAge = null, genderDescr = null, lifeStatusDescr = null, qualification = null, healthDescr = null, socialDescr = null, noOfChildren = null, religionDescr = null, nationDescr = null, carLicenseDescr = null, clubCardDescr = null) {
    this.lastUpdateDate = lastUpdateDate;
    this.custno = custno;
    this.fullname = fullname;
    this.nickname = nickname;
    this.idNumber = idNumber;
    this.idIssueDate = idIssueDate;
    this.idExpDate = idExpDate;
    this.birthdate = birthdate;
    this.custAge = custAge;
    this.genderDescr = genderDescr;
    this.lifeStatusDescr = lifeStatusDescr;
    this.qualification = qualification;
    this.healthDescr = healthDescr;
    this.socialDescr = socialDescr;
    this.noOfChildren = noOfChildren;
    this.religionDescr = religionDescr;
    this.nationDescr = nationDescr;
    this.carLicenseDescr = carLicenseDescr;
    this.clubCardDescr = clubCardDescr;
  }
}
class IdAddressInformation {
  constructor(idCountryName = null, idStateName = null, idCityName = null, idVillageName = null, idStreet = null, idBuildingNo = null, idFloorNo = null, idFlatNo = null, idAdd = null) {
    this.idCountryName = idCountryName;
    this.idStateName = idStateName;
    this.idCityName = idCityName;
    this.idVillageName = idVillageName;
    this.idStreet = idStreet;
    this.idBuildingNo = idBuildingNo;
    this.idFloorNo = idFloorNo;
    this.idFlatNo = idFlatNo;
    this.idAdd = idAdd;
  }
}
class AddressInformation {
  constructor(homeCountryName = null, homeStateName = null, homeCityName = null, homeVillageName = null, homeStreet = null, homeBuildingNo = null, homeFloorNo = null, homeFlatNo = null, homeMark = null, homeAdd = null) {
    this.homeCountryName = homeCountryName;
    this.homeStateName = homeStateName;
    this.homeCityName = homeCityName;
    this.homeVillageName = homeVillageName;
    this.homeStreet = homeStreet;
    this.homeBuildingNo = homeBuildingNo;
    this.homeFloorNo = homeFloorNo;
    this.homeFlatNo = homeFlatNo;
    this.homeMark = homeMark;
    this.homeAdd = homeAdd;
  }
}
class ContactInformation {
  constructor(phoneNo1 = null, phoneNo2 = null, eMail = null) {
    this.phoneNo1 = phoneNo1;
    this.phoneNo2 = phoneNo2;
    this.eMail = eMail;
  }
}
//====================!!
// CreditInformation INTERFACES !!==
class CreditInformationQuery {
  constructor(creditInformation = null, grantCreditInformation = null, iScoreInformation = null) {
    this.creditInformation = creditInformation;
    this.grantCreditInformation = grantCreditInformation;
    this.iScoreInformation = iScoreInformation;
  }
}
class CreditInformation {
  constructor(noOfSrvActive = null, totalSrvAmounts = null, totalSrvDues = null, noOfKstLate = null, noOfDaysLate = null, highestNoOfDaysLate = null, noOfSrvClosed = null, noOfSrvClosedEarly = null, noOfSrvRejected = null, lastRejectedReason = null, noOfSrvWriteoff = null, firstServiceClosedPeriod = null) {
    this.noOfSrvActive = noOfSrvActive;
    this.totalSrvAmounts = totalSrvAmounts;
    this.totalSrvDues = totalSrvDues;
    this.noOfKstLate = noOfKstLate;
    this.noOfDaysLate = noOfDaysLate;
    this.highestNoOfDaysLate = highestNoOfDaysLate;
    this.noOfSrvClosed = noOfSrvClosed;
    this.noOfSrvClosedEarly = noOfSrvClosedEarly;
    this.noOfSrvRejected = noOfSrvRejected;
    this.lastRejectedReason = lastRejectedReason;
    this.noOfSrvWriteoff = noOfSrvWriteoff;
    this.firstServiceClosedPeriod = firstServiceClosedPeriod;
  }
}
class GrantCreditInformation {
  constructor(noOfSrvActiveAsGrant = null, totalSrvAmountsAsGrant = null, totalSrvDuesAsGrant = null, noOfSrvClosedAsGrant = null, noOfSrvClosedEarlyAsGrant = null, noOfSrvRejectedAsGrant = null, riskRateAsGrant = null, noOfKstLateAsGrant = null, noOfDaysLateAsGrant = null, noOfSrvWriteoffAsGrant = null) {
    this.noOfSrvActiveAsGrant = noOfSrvActiveAsGrant;
    this.totalSrvAmountsAsGrant = totalSrvAmountsAsGrant;
    this.totalSrvDuesAsGrant = totalSrvDuesAsGrant;
    this.noOfSrvClosedAsGrant = noOfSrvClosedAsGrant;
    this.noOfSrvClosedEarlyAsGrant = noOfSrvClosedEarlyAsGrant;
    this.noOfSrvRejectedAsGrant = noOfSrvRejectedAsGrant;
    this.riskRateAsGrant = riskRateAsGrant;
    this.noOfKstLateAsGrant = noOfKstLateAsGrant;
    this.noOfDaysLateAsGrant = noOfDaysLateAsGrant;
    this.noOfSrvWriteoffAsGrant = noOfSrvWriteoffAsGrant;
  }
}
class IScoreInformation {
  constructor(iscoreLastScoring = null, iscoreOpenAccCnt = null, iscoreOpenAccOutstading = null, iscoreOpenAccUnearnedInt = null, iscoreOpenAccKstAmt = null, iscoreOpenAccNoofksts = null, iscoreClosedAccountsCnt = null, iscoreLeagalAccountsCnt = null, iscoreNegativeListCnt = null, iscoreMaxNdpd = null, iscoreOpenAccOverdueamt = null, iscoreWrittenoffCnt = null) {
    this.iscoreLastScoring = iscoreLastScoring;
    this.iscoreOpenAccCnt = iscoreOpenAccCnt;
    this.iscoreOpenAccOutstading = iscoreOpenAccOutstading;
    this.iscoreOpenAccUnearnedInt = iscoreOpenAccUnearnedInt;
    this.iscoreOpenAccKstAmt = iscoreOpenAccKstAmt;
    this.iscoreOpenAccNoofksts = iscoreOpenAccNoofksts;
    this.iscoreClosedAccountsCnt = iscoreClosedAccountsCnt;
    this.iscoreLeagalAccountsCnt = iscoreLeagalAccountsCnt;
    this.iscoreNegativeListCnt = iscoreNegativeListCnt;
    this.iscoreMaxNdpd = iscoreMaxNdpd;
    this.iscoreOpenAccOverdueamt = iscoreOpenAccOverdueamt;
    this.iscoreWrittenoffCnt = iscoreWrittenoffCnt;
  }
}
// ========================!!
// CreditStatusInformation InterFaces !!==
class CreditStatusInformationQuery {
  constructor(creditStatusInformation = null, guaranteesInformation = null) {
    this.creditStatusInformation = creditStatusInformation;
    this.guaranteesInformation = guaranteesInformation;
  }
}
class CreditStatusInformation {
  constructor(blacklistStatusDescr = null, blackListDate = null, legalStautsDescr = null, riskRate = null, totalCreditAmt = null, usedCreditAmt = null) {
    this.blacklistStatusDescr = blacklistStatusDescr;
    this.blackListDate = blackListDate;
    this.legalStautsDescr = legalStautsDescr;
    this.riskRate = riskRate;
    this.totalCreditAmt = totalCreditAmt;
    this.usedCreditAmt = usedCreditAmt;
  }
}
class GuaranteesInformation {
  constructor(grantsTotalAmt = null, grantsFinalAmt = null, grantsNoSrvRelated = null, grantsSrvRelatedAmt = null, grantsEndDate = null) {
    this.grantsTotalAmt = grantsTotalAmt;
    this.grantsFinalAmt = grantsFinalAmt;
    this.grantsNoSrvRelated = grantsNoSrvRelated;
    this.grantsSrvRelatedAmt = grantsSrvRelatedAmt;
    this.grantsEndDate = grantsEndDate;
  }
}
// ========================!!
//  WorkplaceInformation InterFaces     !!==
class WorkplaceInformationQuery {
  constructor(workplaceInformation = null) {
    this.workplaceInformation = workplaceInformation;
  }
}
class WorkplaceInformation {
  constructor(code1Name = null, code2Name = null, code3Name = null, workCompanyName = null, workPlace = null, cifWorkMonthSalary = null, cifWorkOthrRev = null, cifWorkPayments = null, cifWorkNetIncome = null) {
    this.code1Name = code1Name;
    this.code2Name = code2Name;
    this.code3Name = code3Name;
    this.workCompanyName = workCompanyName;
    this.workPlace = workPlace;
    this.cifWorkMonthSalary = cifWorkMonthSalary;
    this.cifWorkOthrRev = cifWorkOthrRev;
    this.cifWorkPayments = cifWorkPayments;
    this.cifWorkNetIncome = cifWorkNetIncome;
  }
}
// ========================!!

/***/ })

}]);
//# sourceMappingURL=default-apps_fusion_src_app_pages_funding-request_customer_customer-info_customer-info_component_ts.js.map