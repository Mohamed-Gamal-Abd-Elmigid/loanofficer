"use strict";
(self["webpackChunkfusion"] = self["webpackChunkfusion"] || []).push([["default-libs_shared-lib_src_lib_services_financial-policies_service_ts"],{

/***/ 10544:
/*!************************************************************************!*\
  !*** ./libs/shared-lib/src/lib/services/financial-policies.service.ts ***!
  \************************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "FinancialPoliciesService": () => (/* binding */ FinancialPoliciesService)
/* harmony export */ });
/* harmony import */ var _microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @microSharedLib/core/models/enum/FusionServers.enum */ 44721);
/* harmony import */ var _microSharedLib_services_http_HttpCall_service__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @microSharedLib/services/http/HttpCall.service */ 42682);
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! @angular/core */ 22560);




class FinancialPoliciesService {
  constructor(http) {
    this.http = http;
  }
  //interests
  getAllInterests() {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/yield-pricing/interest`);
  }
  getOneInterest(intCode) {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/yield-pricing/interest/${intCode}`);
  }
  updateInterest(data) {
    return this.http.update(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/yield-pricing/interest`, data);
  }
  addInterest(data) {
    return this.http.post(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/yield-pricing/interest`, data);
  }
  deleteInterest(intCode) {
    return this.http.delete(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/yield-pricing/interest?intCode=${intCode}`);
  }
  //interests
  //expenses
  getAllExpenses() {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/expenses`);
  }
  deleteExpenses(expCode) {
    return this.http.delete(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/expenses/${expCode}`);
  }
  getOneExpense(expCode) {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/expenses/${expCode}`);
  }
  updateExpense(data) {
    return this.http.update(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/expenses`, data);
  }
  addExpense(data) {
    return this.http.post(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/expenses`, data);
  }
  getExpenseStep(id) {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `lookups/domainsSysData/${id}`);
  }
  getExpensesGlNumber() {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `finance/gl`);
  }
  getExpensesSubGl(glno) {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `finance/glSub/subNameById/${glno}/{subGl}`);
  }
  getAmountType() {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `lookups/domainsSysData/EXPENSES_AMT_TYPE`);
  }
  //expenses
  /////////////////////insurance-companies
  getAllInsuranceCompanies() {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/insurance-companies`);
  }
  getAllProductAuditor() {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/products/reviewUsersProductsSetup`);
  }
  getAllInsuranceCompaniesList() {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/insuranceCoList`);
  }
  deleteInsuranceCompanies(insuranceComp) {
    return this.http.delete(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/insurance-companies/${insuranceComp}`);
  }
  getOneInsuranceCompanies(insuranceComp) {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/insurance-companies/${insuranceComp}`);
  }
  createInsuranceCompanies(data) {
    return this.http.post(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/insurance-companies`, data);
  }
  updateInsuranceCompanies(data) {
    return this.http.update(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/insurance-companies`, data);
  }
  ////////////////funding-sources
  getAllFundingSources() {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/funding-sources`);
  }
  deleteFundingSources(fundingsources) {
    return this.http.delete(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/funding-sources/${fundingsources}`);
  }
  getOneFundingSources(fundingsources) {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/funding-sources/${fundingsources}`);
  }
  createFundingSources(data) {
    return this.http.post(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/funding-sources`, data);
  }
  updateFundingSources(data) {
    return this.http.update(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/funding-sources`, data);
  }
  //organization
  getAllOrganizations(queryParam) {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `cif/organizations`, queryParam ? queryParam : {});
  }
  getOneOrg(orgId) {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `cif/organizations/${orgId}`);
  }
  getCustomerFullName(idNo) {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `cif/customers/names?idNo=${idNo}`);
  }
  deleteOrg(orgId) {
    return this.http.delete(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `cif/organizations/${orgId}`);
  }
  addOrg(data) {
    return this.http.post(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `cif/organizations`, data);
  }
  updateOrg(data) {
    return this.http.update(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `cif/organizations`, data);
  }
  //organization
  //////////////////documents
  getAllDocuments() {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `adminController/documents`);
  }
  deleteDocuments(documents) {
    return this.http.delete(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `adminController/documents/${documents}`);
  }
  getOneDocuments(documents) {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `adminController/documents/${documents}`);
  }
  updateDocuments(data) {
    return this.http.update(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `adminController/documents`, data);
  }
  addDocuments(data) {
    return this.http.post(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `adminController/documents`, data);
  }
  //issue source
  // getApiSetupData() {
  //   return this.http.getAll<HttpResponseModel>(
  //     FusionServers.BASE_API_SERVER,
  //     `api-setup/data`
  //   );
  // }
  getApiBasicSetupData() {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `api-setup/apisBasicData`);
  }
  // getOneApiSetupData(providerCode: any) {
  //   return this.http.getOne<HttpResponseModel>(
  //     FusionServers.BASE_API_SERVER,
  //     `api-setup/data/`,
  //     providerCode
  //   );
  // }
  getOneApiBasicSetupData(providerCode) {
    return this.http.getOne(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `api-setup/apisBasicData/`, providerCode);
  }
  getApiOperation(providerCode) {
    return this.http.getOne(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `api-setup/apisOperations/`, providerCode);
  }
  updateApiOperation(data) {
    return this.http.update(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `api-setup/apisOperations`, data);
  }
  getOneApiSetupCredentials(providerCode) {
    return this.http.getOne(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `api-setup/credentials/`, providerCode);
  }
  getOneApiSetupBlockedBranches(providerCode) {
    return this.http.getOne(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `api-setup/blockedBranches/`, providerCode);
  }
  getOneApiOperationsBranches(operationType, stateId, providerCode) {
    return this.http.getOne(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `api-setup/apisOperationsBranches?providerCode=${providerCode}&operationType=${operationType}&stateId=${stateId}`);
  }
  updateApiSetupData(data) {
    return this.http.update(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `api-setup/apisBasicData`, data);
  }
  saveApiSetupData(data) {
    return this.http.post(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `api-setup/apisBasicData`, data);
  }
  updateblockedBranches(data) {
    return this.http.update(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `api-setup/blockedBranches`, data);
  }
  updateOperationsBranches(data) {
    return this.http.update(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `api-setup/apisOperationsBranches`, data);
  }
  updateCredentials(data) {
    return this.http.update(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `api-setup/credentials  `, data);
  }
  getAllIssueSource() {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `api-setup/getCashOutProviders`);
  }
  getOneIssueSource(codeId) {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/products/issueSource/${codeId}`);
  }
  updateIssueSource(data) {
    return this.http.update(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/products/issueSource`, data);
  }
  deleteIssueSource(codeId) {
    return this.http.delete(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/products/issueSource/${codeId}`);
  }
  getAllProducts() {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/products/getAllProducts`);
  }
  getReviewRoles() {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/products/reviewRoles`);
  }
  getReviewRolesProductsSetup(loanType) {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/products/reviewRolesProductsSetup/${loanType}`);
  }
  editReviewRolesProductsSetup(data) {
    return this.http.update(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/products/reviewRolesProductsSetup`, data);
  }
  getReviewUsersProductsById(userId) {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/products/reviewUsersProductsSetup/${userId}`);
  }
  updateReviewUsersProducts(data) {
    return this.http.update(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `product-setup/products/reviewUsersProductsSetup`, data);
  }
  //issue source
  //promotions
  getAllPromotions() {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `promotions/micro/setup`);
  }
  getOneSetupPromotion(codeId) {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `promotions/micro/setup/${codeId}`);
  }
  updateSetupPromotions(data) {
    return this.http.update(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `promotions/micro/setup`, data);
  }
  addSetupPromotions(data) {
    return this.http.post(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `promotions/micro/setup`, data);
  }
  getOneApplyConditionScopePromotions(codeId) {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `promotions/micro/setupScope/${codeId}`);
  }
  updateApplyConditionScopePromotions(data) {
    return this.http.update(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `promotions/micro/setupScope`, data);
  }
  // getOneProductPromotion(codeId: number) {
  //   return this.http.getAll<HttpResponseModel>(
  //     FusionServers.BASE_API_SERVER,
  //     `promotions/micro/setupProducts/${codeId}`
  //   );
  // }
  // updateProductPromotions(data: any) {
  //   return this.http.update<HttpResponseModel>(
  //     FusionServers.BASE_API_SERVER,
  //     `promotions/micro/setupProducts`,
  //     data
  //   );
  // }
  // addProductPromotions(data: any) {
  //   return this.http.post<HttpResponseModel>(
  //     FusionServers.BASE_API_SERVER,
  //     `promotions/micro/setupProducts`,
  //     data
  //   );
  // }
  // getOneCifPromotion(codeId: number) {
  //   return this.http.getAll<HttpResponseModel>(
  //     FusionServers.BASE_API_SERVER,
  //     `promotions/micro/setupCif/${codeId}`
  //   );
  // }
  // updateCifPromotions(data: any) {
  //   return this.http.update<HttpResponseModel>(
  //     FusionServers.BASE_API_SERVER,
  //     `promotions/micro/setupCif`,
  //     data
  //   );
  // }
  // addCifPromotions(data: any) {
  //   return this.http.post<HttpResponseModel>(
  //     FusionServers.BASE_API_SERVER,
  //     `promotions/micro/setupCif`,
  //     data
  //   );
  // }
  // getOneRegionPromotion(codeId: number) {
  //   return this.http.getAll<HttpResponseModel>(
  //     FusionServers.BASE_API_SERVER,
  //     `promotions/micro/setupRegion/${codeId}`
  //   );
  // }
  // updateRegionPromotions(data: any) {
  //   return this.http.update<HttpResponseModel>(
  //     FusionServers.BASE_API_SERVER,
  //     `promotions/micro/setupRegion`,
  //     data
  //   );
  // }
  // addRegionPromotions(data: any) {
  //   return this.http.post<HttpResponseModel>(
  //     FusionServers.BASE_API_SERVER,
  //     `promotions/micro/setupRegion`,
  //     data
  //   );
  // }
  //promotions
  //credit scoring
  getCriteriaSetup(riskCat, loanType) {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `scoring/criteriaSetup?riskCat=${riskCat}&loanType=${loanType}`);
  }
  getAllScoringTabs() {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `lookups/domainsSysData/SCORING_TABS`);
  }
  getAllScoringFields(tabId) {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `scoring/fields/${tabId}`);
  }
  getAllScoringFiledsListData(filedId) {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `scoring/fields/listData/${filedId}`);
  }
  updateCreditScrotingData(data) {
    return this.http.update(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `scoring/criteriaSetup`, data);
  }
  //credit scoring
  //promotion customers screen
  getAllPromotionCustomers() {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `promotions/micro/customerIds`);
  }
  deletePromotionCustomers(promCodeId) {
    return this.http.delete(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `promotions/micro/customerIds/${promCodeId}`);
  }
  updatePromotionCustomers(data) {
    return this.http.update(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `promotions/micro/customerIds`, data);
  }
  //promotion customers screen
  //funding insurance item
  getAllFundingInsuranceProducts() {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `insuranceFund/products`);
  }
  getActiveFundingInsuranceProducts() {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `insuranceFund/productsList`);
  }
  getOneFundingInsuranceProduct(insCode) {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `insuranceFund/products/${insCode}`);
  }
  updateFundingInsuranceProducts(data) {
    return this.http.update(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `insuranceFund/products`, data);
  }
  addFundingInsuranceProducts(data) {
    return this.http.post(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `insuranceFund/products`, data);
  }
  getAllGlKindZero() {
    return this.http.getAll(_microSharedLib_core_models_enum_FusionServers_enum__WEBPACK_IMPORTED_MODULE_0__.FusionServers.BASE_API_SERVER, `finance/gl?glKind=0`);
  }
}
FinancialPoliciesService.treeMenuData = null;
FinancialPoliciesService.ɵfac = function FinancialPoliciesService_Factory(t) {
  return new (t || FinancialPoliciesService)(_angular_core__WEBPACK_IMPORTED_MODULE_2__["ɵɵinject"](_microSharedLib_services_http_HttpCall_service__WEBPACK_IMPORTED_MODULE_1__.HttpCall));
};
FinancialPoliciesService.ɵprov = /*@__PURE__*/_angular_core__WEBPACK_IMPORTED_MODULE_2__["ɵɵdefineInjectable"]({
  token: FinancialPoliciesService,
  factory: FinancialPoliciesService.ɵfac,
  providedIn: 'root'
});

/***/ })

}]);
//# sourceMappingURL=default-libs_shared-lib_src_lib_services_financial-policies_service_ts.js.map