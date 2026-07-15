---
kind: dispatch
role: boatman
host: kmkmbp2026
posture: liaison
short_id: a7d440
dispatch_root: dispatches/boatman--a7d440
project: endo
repo: endojs/endo-but-for-bots
source_pr: 259
source_branch: feat/hardened-text-codecs-shim
upstream: endojs/endo
upstream_base: master
human: Kris Kowal <kriskowal@kriskowal.com>
identity_switch_authorized: true
model: sonnet
---

Ferry endojs/endo-but-for-bots#259 (`feat(ses): permit TextEncoder and
TextDecoder as universal intrinsics`) upstream to endojs/endo. First-time
ferry (no existing upstream PR; no prior `Mirror of ` cross-link on #259).

Preconditions verified by the liaison before dispatch:

- `gh auth status` → active identity `kriskowal` on this host (kmkmbp2026).
- `gh api repos/endojs/endo --jq .permissions` → `push: true` (admin).
- #259 is OPEN, not draft, MERGEABLE, all CI checks SUCCESS.
- Author kriscendobot; base master; head feat/hardened-text-codecs-shim.
- Source body refs `endojs/endo#2635` (upstream-equivalent; keep/translate).

Human attribution confirmed by the maintainer this session:
`Kris Kowal <kriskowal@kriskowal.com>` (both agoric and kriskowal emails are
registered on the kriskowal account; maintainer chose the kriskowal.com one).

Expected report: the upstream PR URL, the upstream branch name and head SHA,
per-commit attribution/trailer verification result, upstream CI status at
report time, and the garden-side `Mirror of ...` cross-link comment ID.
