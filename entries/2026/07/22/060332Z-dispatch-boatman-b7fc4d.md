---
kind: dispatch
role: boatman
host: kmkmbp2026
posture: liaison
short_id: b7fc4d
dispatch_root: dispatches/boatman--b7fc4d
project: endo
upstream: endojs/endo
upstream_pr: 3322
upstream_branch: kriskowal-hardened-text-codecs-shim
identity_switch_authorized: true
model: sonnet
refs: [3e5c85]
---

Body-only follow-up to the re-ferry (3e5c85). The Shape-2 recompute collapsed
the source's fix+revert pair (`0b7ab7590` "tolerate undeletable
arguments/caller" + `fa2c5d023` its revert) out of the upstream series, but the
#3322 description's *Testing Considerations* section still contains a paragraph
describing that removed commit ("A third commit fixes a Chromium-only lockdown
failure … extends the existing tolerate-undeletable escape hatch …"). The body
now promises a fix absent from the diff on an already-APPROVED PR.

Maintainer chose (this session) to correct it via a boatman body edit — within
boatman scope-boundary #2 (restructure made the existing body materially
misleading). Edit ONLY the #3322 description; no commits, no code push, no
upstream comment. Attribution N/A (body edit, not a commit).

Expected report: confirmation the stale paragraph is removed, that the revised
body matches the actual net diff on `kriskowal-hardened-text-codecs-shim` (no
tolerate-undeletable change present), and the resulting body renders cleanly.
