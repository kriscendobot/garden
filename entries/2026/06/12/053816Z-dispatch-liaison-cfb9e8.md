---
ts: 2026-06-12T05:38:16Z
kind: dispatch
role: liaison
repo: agoric/agoric-sdk
project: agoric-sdk
refs:
  - entries/2026/06/11/063132Z-message-liaison-18e0c9.md
---

Dispatched boatman (dispatch-root `dispatches/boatman--cfb9e8`) to re-ferry the rebuilt kriscendobot/agoric-sdk#5 onto Agoric/agoric-sdk#12527 — **carrying the ava fix**. The bot dropped the `restore ava ^7.0.0` commit (my CI-triage proposal, msg `18e0c9`) so the mirror is now 12 commits (was 13); ava stays ^6.4.1, compatible with the synced @endo/ses-ava (^5.3.0||^6.1.2) -> should clear test-docker-build.

Source: kriscendobot/agoric-sdk#5, head `bd397628b`, base `master-57c6564` (= 57c65644e), 12 commits, MERGEABLE. Upstream #12527 head `ee7df351b` (my prior re-ferry, 13 commits incl the ava bump), APPROVED by turadg, branch `copilot/update-endo-dependency-versions` on Agoric/agoric-sdk. agoric master moved to 491ce6bb5 but the mirror (and #12527) stay on 57c65644e and remain MERGEABLE; recompute onto the mirror's base 57c65644e (preserve the maintainer's resolved tree; do NOT re-rebase onto 491ce6bb5).

Per-commit attribution (same scheme, NEW SHAs; committer kris@agoric.com on all 12):
- PRESERVE: `d3a90fa16` copilot-swe-agent[bot], `ed29496b2` Turadg, `f32af8dc4` Michael FIG, `84735c184`/`35c18254e`/`a8040fe92`/`5f76256b6` Kris Kowal, `5cc0059c9` Turadg, `9625b667c` Kris Kowal.
- NORMALIZE endolinbot->Kris Kowal <kris@agoric.com>: `3bb633f59`, `b46dc4cc4`, `bd397628b`.

Boatman brief (same as dispatch fec201, updated): detach at `57c65644e`; commit-tree rebuild the 12 commits reusing each mirror commit's exact tree with attribution per table (zero conflict risk); VERIFY HEAD tree == mirror tip `bd397628b^{tree}`; strip ONLY Claude/Generated-with trailers (preserve legit Co-Authored-By; grep claude/anthropic); no DCO; force-with-lease against `ee7df351b` to `copilot/update-endo-dependency-versions` via the **SSO token-URL push form** `https://x-access-token:$(gh auth token)@github.com/agoric/agoric-sdk.git` (SSH/keychain SSO-rejected for writes); confirm MERGEABLE + turadg approval state; edit cross-link 4675157471 to new head. No re-review request. `identity_switch_authorized: true`.

Expected report: new #12527 head, force-with-lease, attribution table (9 preserved + 3 endolinbot->kriskowal), no-Claude confirmation, tree==mirror, mergeable + turadg approval, ava commit absent (12 commits), CI, cross-link.
