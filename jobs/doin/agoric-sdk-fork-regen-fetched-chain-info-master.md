# Regenerate fetched-chain-info.js on kriscendobot/agoric-sdk — PR to the fork's master

**Repo:** `kriscendobot/agoric-sdk` (the BOT FORK). **Base + head stay on the fork.**
Hard scope line: **never** touch upstream `agoric/agoric-sdk` — no upstream issue/PR
links, no upstream comments. All artifacts base+head on `kriscendobot/agoric-sdk`.

**Task:** the fork's `master` carries a stale generated file
`packages/orchestration/src/fetched-chain-info.js`, which fails the `test-codegen`
CI check and **blocks bot-fork PRs #6 and #7** alike (per the shepherd report on #7).
Regenerate that file and land it on `master` **via a pull request** (the maintainer
chose PR-to-master over a direct commit, so the regeneration is reviewable).

**Procedure:**
1. Branch off the fork's current `master` (e.g. `regen-fetched-chain-info`).
2. Regenerate the file with the package's own codegen — do NOT hand-edit it. Discover
   the command in `packages/orchestration` (look for a `codegen`/`build:chain-info`
   style script in its `package.json`, or the generator that emits
   `fetched-chain-info.js`). Run it, commit ONLY the regenerated artifact (plus any
   lockfile/codegen-manifest the generator legitimately updates).
3. Open a PR **against `kriscendobot/agoric-sdk:master`** titled for the codegen
   refresh, body explaining it clears the `test-codegen` failure blocking #6/#7.
4. Confirm `test-codegen` (and the rest of CI) goes green on the PR before handing off.
   Note in the PR that merging it to master unblocks #6 and #7.

**Why master, not the hex PR:** it's a generated artifact and a shared-master fix;
smuggling it into the hex PR's diff would muddy that PR. Fixing at master clears both
blocked PRs at once.

<!-- garden-reap-now -->
---
claim:
  host: endolinbot2
  gardener: 78
  claimed_at: 2026-06-29T20:19:55Z
