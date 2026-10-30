/// FMC Fusion UAT (`https://fmc-uat.tanmeyah.lan`).
///
/// The web app joins `appsUrl.baseUrl` with `/fmc/`, then appends the service
/// path. Login lives under an extra `fmc/auth` prefix, so the full login URL is
/// `https://fmc-api-uat.tanmeyah.lan/fmc/fmc/auth/login`.
class FmcConfig {
  static const apiRoot = 'https://fmc-api-uat.tanmeyah.lan/fmc/';
}
