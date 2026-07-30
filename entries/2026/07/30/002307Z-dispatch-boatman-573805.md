---
kind: dispatch
role: boatman
host: kmkmbp2026
posture: liaison
short_id: 573805
dispatch_root: dispatches/boatman--573805
project: endo
repo: endojs/endo-but-for-bots
source_pr: 761
source_branch: reconstruct/ebfb-pr720-patterns-literal-inference
source_head: 128c0f1101dbbb75460299a6e8af1967449d2c8c
upstream: endojs/endo
upstream_base: master
human: Kris Kowal <kriskowal@kriskowal.com>
identity_switch_authorized: true
---

Ferry endo-but-for-bots#761 (`fix(patterns): preserve literal inference in
compound matchers`) upstream to endojs/endo. This is a first-time ferry with no
existing `Mirror of ` cross-link and no matching upstream pull request.

Preconditions verified before work: `gh auth status` shows kriskowal active on
kmkmbp2026; `gh api repos/endojs/endo --jq .permissions` reports admin and push
access. The maintainer's direct request to ferry #761 authorizes the identity
switch, upstream push, pull request creation, and garden-side cross-link.

Use the established Endo ferry identity `Kris Kowal
<kriskowal@kriskowal.com>`. Preserve the source's one logical commit. Remove
fork-only reconstruction provenance and bot attribution from the commit and
pull request body while retaining the substantive explanation. Verify current
upstream master, attribution, trailers, patch equivalence, and initial CI
status.
