// Bulletin configuration. Per-instance values live here; the rest of the app is
// generic. The garden repo is public, so reads work without a token; a token is
// only needed to push the reply commit.
window.GARDEN_BULLETIN_CONFIG = {
  owner: 'kriscendobot',
  repo: 'garden',
  // The orphan branch that holds the bulletin README and the maintainer inbox.
  journalBranch: 'journal2',

  // Optional OAuth device-flow upgrade. Leave `proxyBase` empty to use the
  // pasted fine-grained PAT path (pure client side, no backend). To enable the
  // device flow, register a GitHub App, deploy the CORS token-exchange shim
  // described in SETUP.md, and fill both fields. When `proxyBase` is set the
  // page offers a "Sign in with GitHub" button alongside the PAT field.
  deviceFlow: {
    clientId: '',   // GitHub App / OAuth App client id
    proxyBase: '',  // e.g. https://garden-oauth.<you>.workers.dev
  },
};
