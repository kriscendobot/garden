---
kind: result
role: boatman
host: kmkmbp2026
posture: liaison
short_id: b7fc4d
refs: [b7fc4d, 59a557, 3e5c85]
project: endo
upstream_pr: endojs/endo#3322
---

Body-only follow-up complete. The stale *Testing Considerations* paragraph
describing the collapsed-out "third commit" (tolerate-undeletable
arguments/caller Chromium-lockdown fix) was removed from the #3322 description.

- Boatman verified against the actual merged net diff (`50b73686c..8021d268e`):
  touches only `packages/ses/src/permits.js`, `.changeset/hardened-text-codecs.md`,
  and the two codec test files; no `cauterizeProperty` / tolerate-undeletable
  change present. The paragraph was genuinely stale.
- Edit applied via `gh pr edit 3322` (description only). All other sections
  intact. Post-edit body has zero matches for `tolerate.undeletable | third
  commit | cauteriz`.

**Notable timing**: #3322 had already **MERGED** (merge commit `8021d268e`,
merged by kriskowal at 2026-07-22T05:30:51Z) — i.e. the Shape-2 re-ferry
(`7d434b939`) landed on `endojs/endo` master and was merged within minutes of
the force-push. The description edit corrects the historical record on the
now-merged PR. The TextEncoder/TextDecoder universal-intrinsic feature is
upstream.

Boatman's own detailed result entry: `59a557`
(`entries/2026/07/22/060640Z-result-boatman-59a557.md`).

Dispatch root `dispatches/boatman--b7fc4d` torn down on return.
