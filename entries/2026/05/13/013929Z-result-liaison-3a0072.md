---
ts: 2026-05-13T01:39:29Z
kind: result
role: liaison
project: endo-but-for-bots
to: "*"
refs:
  - entries/2026/05/13/012400Z-result-steward-da0309.md
---

# Bulletin: `kriscendobot` push authorization on `endojs/ocapn-test-suite` enriched with baseline hash

Replaces the steward's terse row in `README.md` § *Pre-staged authorizations* (from commit `df39457`) with a fuller body and sub-list, including the actual baseline commit on `ocapn/ocapn-test-suite` so future dispatches do not have to re-derive it.

## Bulletin row (verbatim)

```markdown
- **`kriscendobot` write access to `endojs/ocapn-test-suite`.** The maintainer granted the bot push access to the endojs fork of the OCapN test suite, with two constraints attached: the work starts from a specific upstream commit on `ocapn/ocapn-test-suite`, and no PR is to be opened against the OCapN-org upstream. The bot's pre-grant analysis on PR #109 referenced the pin in two comments, so the hash is recorded inline here to spare future agents the re-derivation.
  - Identity: `kriscendobot`.
  - Action: push branches and commits to `endojs/ocapn-test-suite`.
  - Baseline (Constraint A): start from `74db78f08a40efba1e2b975d809374ff0e7acf60` on `ocapn/ocapn-test-suite`. Origin of the pin: kriscendobot's investigation comments on PR #109 ([issuecomment-4427618615](https://github.com/endojs/endo-but-for-bots/pull/109#issuecomment-4427618615) and [issuecomment-4427633977](https://github.com/endojs/endo-but-for-bots/pull/109#issuecomment-4427633977)) anchor every "current state of the Python suite" claim on that commit (verified: it is `Merge pull request #35 ... pluralize-gc-ops`, dated 2026-02-25). The maintainer's grant comment ("Be sure to use the hash pinned from here as a baseline") refers back to those anchors. PR #109's own `baseRefOid` (`c2fc02eb8bf674389a8445ce785ff5eff36ed5aa`) and `headRefOid` (`4ffb3d84e50c35f330d90e7e600040944e789a3c`) are on `endojs/endo-but-for-bots` and are not the baseline; they are noted here only to rule them out.
  - No-upstream (Constraint B): do **not** open a PR against `ocapn/ocapn-test-suite`. Work stays on `endojs/ocapn-test-suite` only.
  - Source: [endojs/endo-but-for-bots#109#issuecomment-4436075344](https://github.com/endojs/endo-but-for-bots/pull/109#issuecomment-4436075344) (kriskowal, 2026-05-13T00:54:05Z); steward write-up at [`entries/2026/05/13/012400Z-result-steward-da0309.md`](entries/2026/05/13/012400Z-result-steward-da0309.md).
  - Clearing: the row stays until a future dispatch picks up the authorization and pushes the agreed branch. The dispatching liaison clears it at that future time.
```

## Pinned hashes discovered

The maintainer's grant comment was terse ("Be sure to use the hash pinned from here as a baseline") and did not itself cite a hash. Resolution came from the PR's other artifacts:

- **`74db78f08a40efba1e2b975d809374ff0e7acf60` on `ocapn/ocapn-test-suite`** is the pin. Recorded in the bulletin. Both pre-grant `kriscendobot` analysis comments hardcoded this hash into their permalinks to `netlayers/testing_only_tcp.py`, `netlayers/base.py`, and `README.md` while reporting the current Python wire-format state. Verified via `gh api repos/ocapn/ocapn-test-suite/commits/74db78f0...`: commit `Merge pull request #35 ... pluralize-gc-ops`, 2026-02-25. This is what the maintainer's "from here" refers to.
- **`c2fc02eb8bf674389a8445ce785ff5eff36ed5aa`** is PR #109's `baseRefOid`. On `endojs/endo-but-for-bots`, not the test suite. Not the baseline. Recorded in the bulletin only to rule out.
- **`4ffb3d84e50c35f330d90e7e600040944e789a3c`** is PR #109's `headRefOid`. Same: on `endojs/endo-but-for-bots`. Not the baseline. Recorded in the bulletin only to rule out.
- **No submodule pin in PR #109's diff.** The PR adds a JS-side `framing` option to `makeTcpNetLayer`, three netlayer tests, and the `@endo/syrups` package. No `.gitmodules` entry, no recorded `ocapn-test-suite` SHA in any file. The hash lives only in the comment-thread anchors.

## Journal commit SHA

`6c7a21eba216b9a695667f9e59ec3772170c22d33d` (full), `6c7a21e` short. Single commit, message `bulletin: pre-staged authorization for kriscendobot push to endojs/ocapn-test-suite (from #109#issuecomment-4436075344)`, pushed to `origin/journal`.

## What this entry does NOT do

- It does **not** bare-clone `endojs/ocapn-test-suite`. The dispatch was explicit: infrastructure setup happens when the first work task arrives, not at authorization-staging time.
- It does **not** dispatch a subagent into the test-suite fork. No work has been authorized to start; the bulletin merely records that work *can* start.
- It does **not** comment back on PR #109. The maintainer's grant did not include a comment-authorization, and a thank-you reply would itself need one.

## Self-improvement

A maintainer grant phrased as "use the hash pinned from here as a baseline" refers to whatever hash the immediate prior bot comment thread anchored its analysis on; the grant is shorthand for "the hash you already cited". A `verify-upstream-state-before-pinning` discipline (the named skill on `main`) is already in the inventory; this engagement is one more piece of evidence that "the maintainer's pin is the bot's cited pin, not an independent maintainer-authored SHA" deserves a sentence in that skill's notes-from-the-field. Surfaced here for the next liaison turn on `main` to incorporate. Threshold check: this is the first vivid instance, so the note is observational rather than rule-changing.

Self-improvement: nothing this time (note routed to a future on-`main` turn rather than to a structural change; engagement is too narrow on its own to justify a new rule).
