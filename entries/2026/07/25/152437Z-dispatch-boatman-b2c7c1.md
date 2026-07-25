---
kind: dispatch
role: boatman
host: kmkmbp2026
posture: liaison
short_id: b2c7c1
dispatch_root: dispatches/boatman--b2c7c1
project: endo
repo: endojs/endo-but-for-bots
source_pr: 719
source_branch: feat/hardened-url-vetted-shim
source_head: 66524aeda02e29164430517768f1f5ff014daca0
upstream: endojs/endo
upstream_base: master
human: Kris Kowal <kriskowal@kriskowal.com>
identity_switch_authorized: true
model: sonnet
---

Ferry endo-but-for-bots#719 (`feat(ses): permit URL and URLSearchParams as a
vetted shim (%URL%/%SharedURL% split)`) upstream to endojs/endo. First-time
ferry (no existing `Mirror of ` cross-link on #719; #263's not ferried either;
no competing open URL PR on endojs/endo). Shape 1.

Preconditions verified before dispatch: `gh auth status` → kriskowal active
(kmkmbp2026); `gh api repos/endojs/endo --jq .permissions` → push:true (admin).
#719 OPEN, not draft, MERGEABLE, all 18 CI checks SUCCESS. Author kriscendobot;
base frozen `master-6ee3fda`; head `feat/hardened-url-vetted-shim` @ 66524aeda;
6 commits. Body refs `endojs/endo#2635` (upstream-equivalent; keep).

Direction chosen by the maintainer: #719 (the design's `Date`-style
%URL%/%SharedURL% split) over the competing #263 (universal placement). The
body's "Relationship to endojs/endo-but-for-bots#263" paragraph is fork-side
bookkeeping — the boatman strips it per pr-formation (drop fork-only refs and
bot bookkeeping). #263 stays open; the maintainer closes the loser separately.

Attribution: `Kris Kowal <kriskowal@kriskowal.com>` — the maintainer's
established choice for endo ferries this session (used on the #259 first-ferry
and re-ferry); defaulted here rather than re-asking, flagged in the report.

Expected report: upstream PR URL, upstream branch + head SHA, per-commit
attribution + trailer verification, upstream CI status, and the garden-side
`Mirror of ...` cross-link comment id.
