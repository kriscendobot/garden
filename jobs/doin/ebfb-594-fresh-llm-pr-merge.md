# conductor/builder: fresh `llm`-based PR of #594's bucketed lint fix — MERGE WITHOUT DELAY

**Repo:** `endojs/endo-but-for-bots` (bot-pushable; the repo is "yours" per standing authorization — comments and merges on this repo need no per-action grant; **no upstream `endojs/endo` touch**).

## Maintainer directive (kriskowal, 2026-07-02, via the liaison)

"With regard to #594, we need a fresh PR that bases that on the `llm` branch, and that should be merged **without delay**." This is an authorized fast unblock (a maintainer-authority lifecycle directive on this repo): open a fresh PR against `llm` carrying #594's change and **merge it immediately** (merge commit, no full judge/gamut), the same shape as the earlier #596 llm unblock.

## What to port

PR #594's **current head `3473f5df2`** implementation of the typescript-eslint project-service-ceiling lint fix — the **bucketed** form:

- `scripts/eslint-repo.sh` — lints a **bucket of workspaces per process** (bucket size 10, `ESLINT_BUCKET_SIZE` override), so the whole-repo project-service ceiling (tail-drops `packages/zip`/`packages/where`) can never be reached, and per-process `tsc` rebuild cost is amortized back to ≈whole-repo parity.
- `package.json` — `lint:eslint` delegates to `scripts/eslint-repo.sh`.
- the accompanying changeset.

## Reconcile with #596 (important — do not blindly duplicate)

`llm` already merged **#596**, which landed the **earlier per-package form** (one process per package — the ~1.9x local / +44% real-CI regression). This fresh PR brings #594's **bucketed refinement** to `llm`, replacing the per-package script with the bucketed one. Net effect on `llm`: `scripts/eslint-repo.sh` becomes the bucket-10 version and lint runs at ≈parity instead of the per-package regression. If `llm` already has `scripts/eslint-repo.sh` from #596, **update it** to #594's bucketed version rather than adding a second script.

## Procedure

1. Branch off **current `origin/llm`** (it has moved; do not reuse a stale checkout — #596's replicate hit exactly that and had to reset).
2. Apply #594's `3473f5df2` bucketed change (cherry-pick the fix commit, or replicate the three files), reconciling with #596 per above.
3. **Genuinely verify lint on `llm`**: run the bucketed `scripts/eslint-repo.sh` over all packages plus the top-level `scripts/` dir → expect **0 errors** (warnings only), coverage byte-identical to `eslint .` including `where`/`zip`; `shellcheck scripts/eslint-repo.sh` clean. Cite the command and its output in your report (do not write "verified" without the real run, per `garden/roles/COMMON.md` § Reporting). The sandbox blocks the bare `eslint` bin shim — exercise the identical one-eslint-process-per-bucket mechanism via `yarn eslint` / `node <eslint entry>` as #596 and the verify job did, and say so.
4. Open the PR (base `llm`) and **merge it immediately** (merge commit; delete the branch).
5. Post a top-level **summary comment** (standing-authorized) on the new PR: head SHA, that it ports #594's bucketed fix to `llm` and supersedes the per-package form from #596, and the verification evidence. Journal a `result` entry with the PR/merge URLs.

## Constraints

- **Do NOT touch `master` or PR #594.** The master-side landing is deliberately parked for a separate evidence-based decision (bucket vs. shard) under job `ebfb-lint-master-strategy-evidence`; this job is `llm`-only.
- **No upstream `endojs/endo` interaction** (no comments, PRs, links, merges). `llm` is the bot's own active branch and is in scope.

## Definition of done

A fresh PR based on `llm` carrying #594's bucketed lint fix is **opened and merged** (merge commit), its `scripts/eslint-repo.sh` is the bucketed version reconciled with #596, lint is verified green on `llm` with cited evidence, a summary comment is posted, and a journal `result` records the merge. No master/#594 changes.

---
claim:
  host: endolinbot2
  gardener: 80
  claimed_at: 2026-07-02T09:47:43Z
