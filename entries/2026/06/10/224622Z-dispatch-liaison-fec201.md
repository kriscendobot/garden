---
ts: 2026-06-10T22:46:22Z
kind: dispatch
role: liaison
repo: agoric/agoric-sdk
project: agoric-sdk
refs:
  - entries/2026/06/10/220923Z-dispatch-liaison-f5b22f.md
---

Dispatched boatman (dispatch-root `dispatches/boatman--fec201`) to **re-ferry the rebased kriscendobot/agoric-sdk#5** onto Agoric/agoric-sdk#12527, clearing the CONFLICTING. The bot rebased the mirror onto current agoric master `57c65644e` since my first ferry (new base `master-57c6564`, MERGEABLE), so a plain re-ferry now lands it current.

Source: kriscendobot/agoric-sdk#5, head `02782246b`, base `master-57c6564` (= agoric master `57c65644e`), 13 commits (96 files; rebase reconciled vs newer master). Upstream #12527 head `8d2ccb2b9a` (my prior ferry, on daf7a86, CONFLICTING), APPROVED by turadg, branch `copilot/update-endo-dependency-versions` on Agoric/agoric-sdk.

Same per-commit attribution scheme as dispatch f5b22f (new SHAs):
- PRESERVE authors on 9 upstream commits: `d3a90fa16` copilot-swe-agent[bot], `218350dda` Turadg, `9fd0304fc` Michael FIG, `43e88c10a`/`28f48a84b`/`103a19744`/`364843822` Kris Kowal, `01e2e7d7c` Turadg, `ea1e76300` Kris Kowal.
- NORMALIZE 4 endolinbot -> Kris Kowal <kris@agoric.com>: `54de66c9e`, `181a10e25`, `425ffc4e4`, `02782246b`.
- Committer kris@agoric.com on all.

Boatman brief: detach at current master `57c65644e` (= the mirror's new base); rebuild the 13 commits via commit-tree (proven last ferry; zero conflict risk) reusing each mirror commit's exact tree with attribution per table; VERIFY HEAD tree == mirror tip `02782246b^{tree}`; strip ONLY Claude/Generated-with trailers (preserve legit Co-Authored-By; grep claude/anthropic), no DCO; force-with-lease against `8d2ccb2b9a` to `copilot/update-endo-dependency-versions`. **Push form (agoric is behind SAML SSO):** `git push --force-with-lease=...:8d2ccb2b9a... https://x-access-token:$(gh auth token)@github.com/agoric/agoric-sdk.git HEAD:refs/heads/copilot/update-endo-dependency-versions` (SSH + keychain HTTPS are SSO-rejected for writes). Confirm CONFLICTING->MERGEABLE + turadg approval state; edit-or-create cross-link on kriscendobot/agoric-sdk#5 (--paginate; prior comment 4675157471). `identity_switch_authorized: true`. No re-review request.

Expected report: new #12527 head, force-with-lease, attribution table (9 originals preserved, 4 endolinbot->kriskowal), no-Claude confirmation, tree==mirror, mergeable (expect MERGEABLE) + turadg approval, CI, cross-link.
