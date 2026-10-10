**PR #348 viability (endojs/endo-but-for-bots, mirror of endojs/endo#2902, "Deduplicate bundle-lite"): proceed.**

**Deciding question:** Does `packages/compartment-mapper/src/bundle.js` on the current base (and on `llm` and upstream `master`) still carry its own copy of `makeFunctorFromMap`/`makeScriptFromMap` rather than importing them from `bundle-lite.js`, with nothing else having landed or opened to remove it?

**Answer:** Yes.

**Evidence:**
- **PR state:** open, not draft, not merged. Base is `master-6ee3fda`, head is `496b4ffa`. The diff is 3 files: `bundle.js` +1/-563, `bundle-lite.js` +2/-0, and a one-line `ci.yml` change.
- **The base hasn't moved:** the fork's live `master` is identical to the pinned base `master-6ee3fda` (0 commits ahead, 0 behind). The maintainer's 2026-08-16 request to repin the base was carried out, and the PR was reported mergeable at that time.
- **The duplication is still there everywhere:** `bundle.js` still defines its own `makeFunctorFromMap` (line 316) and `makeScriptFromMap` (line 662) on fork `master`, on fork `llm`, and on upstream `endojs/endo` `master`.
- **The upstream source is still open:** endojs/endo#2902 is open and unmerged.
- **No competitor:** searching the fork for "bundle-lite" finds no other PR doing this dedup. The only overlap, #332 ("Embrace default chaining"), is closed, and that commit has already landed on `master` and was dropped from this branch during the refresh.
- **Motivation still holds:** the PR still adds the `syncModuleTransforms` fix to `bundle-lite.js` that the hermes build depends on.

**Note for the clean stage:** the `ci.yml` change only edits a comment on the pinned `dorny/paths-filter` action (`# v3` becomes `# v3.0.3`). It has nothing to do with the dedup and should probably be dropped.

I made no changes to the garden or the project repo; this stage only gathered evidence.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr348-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (175735 cached reads)
- Output: 1914 tokens
- Cost: $0.44077900000000003
- Wall-clock: 24s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
