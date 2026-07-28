---
role: conductor
---
# Conduct (merge) endojs/endo-but-for-bots#755

Wear [conductor](../../roles/conductor/AGENT.md). Merge
https://github.com/endojs/endo-but-for-bots/pull/755 —
*"feat(cbor): @endo/cbor canonical CBOR primitives (phase 1)"*.

## Why this job exists

kriskowal **APPROVED** the PR and asked, in the review body, to *conduct*:
https://github.com/endojs/endo-but-for-bots/pull/755#pullrequestreview-4799487076

That review carried **no inline comments** — the approval body is the whole of it,
and its two asks were (1) conduct, and (2) post a CBOR-adoption follow-up. Ask (2)
is already discharged: `endo-cbor-adopt-primitives` is parked in `jobs/plan/`,
gated `blocked` on this very PR, so **merging this PR is what releases it**.

## State observed at post time (2026-07-28T16:15Z) — re-verify, do not trust

- **non-draft**, OPEN, `mergeable=MERGEABLE`, `mergeStateStatus=CLEAN`
- head `build/endo-cbor-package`, base **`llm-4f09410`**
- **all 23 checks pass** (build, cover, lint, test x4, test-xs, test-hermes,
  test262, zizmor, viable-release, sandbox-drivers, …)
- `reviewDecision` carries kriskowal's APPROVED review above

## Specific hazards for THIS merge

1. **The base is a frozen-base snapshot** (`llm-4f09410`, matching
   `^(llm|main|master)-[0-9a-f]{4,40}$`). Per conductor step 2 and
   [frozen-base-branch](../../skills/frozen-base-branch/SKILL.md), **unfreeze
   before merging** or the content lands on the snapshot and never reaches the
   live trunk:

   ```sh
   gh pr edit 755 -R endojs/endo-but-for-bots --base llm
   ```

   Then rebase onto the now-live `llm` and re-check CI. `llm` has moved since the
   snapshot (trunk tip at post time was `7f8c08d74`), so expect a real rebase.
   Conflicts follow [conflict-resolution](../../skills/conflict-resolution/SKILL.md)
   — no `--ours`/`--theirs`; if the unfreeze exceeds surgical scope, stall
   `needs weave: frozen-base unfreeze conflicts`.

   The trunk here is **`llm`**, not `master`. The repo has **no fork `master`
   trunk** (maintainer directive 2026-07-16, endojs/endo-but-for-bots#475) — never
   unfreeze to or merge into `master` on this repo.

2. **A peer gauntlet job was in flight on this PR** —
   `endojs-endo-but-for-bots-pr755-gauntlet`, claimed on `endolin-garden2-5bcdff64`
   at 2026-07-28T12:36Z with `handler-timeout: 14000`. It has been messaged that
   the PR is approved and asked not to force-push further. **Before you tidy or
   force-push, re-read the PR head SHA** and use `--force-with-lease=<head>:<sha>`
   so a straggling peer push fails safe instead of being clobbered.

3. **Carry the merge to completion.** Waiting for CI is not a terminal state
   (the endojs/endo-but-for-bots#178 bug). The unfreeze rebase triggers a fresh CI
   run; block on it with the deterministic spine rather than hand-rolling a wait:

   ```sh
   scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 755
   ```

   Exit 0 merged / 2 already closed / 3 CI red (stall `ci red: needs shepherd`) /
   4 watch timed out (**re-enqueue this job, do not complete unmerged**) /
   1 merge blocked.

4. **Always `--merge`** (never `--squash`, never `--rebase`).

5. **Branch cleanup.** `--delete-branch` only if no other open PR uses
   `build/endo-cbor-package` as its base (endojs/endo-but-for-bots#800 was
   auto-closed by exactly that mistake). Then sweep the `llm-4f09410` frozen-base
   branch per [frozen-base-branch](../../skills/frozen-base-branch/SKILL.md) if no
   other open PR still bases on it.

## Definition of done

- endojs/endo-but-for-bots#755 is **MERGED into the live `llm` trunk** (verify
  `mergedAt` non-null and that `packages/cbor/` exists on `llm`), **or** a genuine
  blocker is reported (CI red → shepherd; conflict → weave). Do **not** move this
  job to `tada` while CI is merely pending.
- Frozen base unfrozen; head and snapshot branches swept per the rule above.
- The report notes the merge commit SHA, so the follow-up gardener promoted off
  `endo-cbor-adopt-primitives` can confirm `@endo/cbor` is on trunk.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  claimed_at: 2026-07-28T16:43:24Z
