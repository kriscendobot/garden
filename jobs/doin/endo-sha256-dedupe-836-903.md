---
role: gardener
handler-timeout: 10800
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repository: https://github.com/endojs/endo-but-for-bots

# Reconcile the two platform-neutral SHA-256 implementations; land ONE on live `llm`

**Maintainer directive (kriskowal, 2026-08-12):** "Let's not waste two sunk
implementations. We are trying to merge on `llm`. Compare the two pull requests,
take the best of both, advance #836 and close #903. Also investigate why we
duplicated the work and note that for self-improvement."

## READ THIS FIRST — the directive's premise needs checking against these facts

Verified 2026-08-12. **Re-verify before acting; do not take this brief on faith.**

- **#836 is already MERGED** — into the **frozen** base `llm-bfc91f5`, NOT live `llm`.
  Head `3933946e2`, +926/-166 across 26 files, APPROVED, CI 23/23, created 07-22.
- **#903 is OPEN on live `llm`.** Head `e506d78ba`, +2123/-167 across 48 files,
  created 08-01. CI 25/26 — **`lint` FAILED**. Both prior approvals are stale
  against the current head.
- `packages/sha256` **exists on `llm-bfc91f5`** and is **ABSENT from `llm`**.
- `llm` vs `llm-bfc91f5`: **diverged** — 7 ahead, **254 behind**. That snapshot will
  not merge forward as-is.
- `llm-bfc91f5` is **shared** with open PRs **#943** and **#888**. A conductor already
  refused to unfreeze #943 unilaterally because moving one PR off a shared frozen base
  forks the stack. Honor that: do not fork it here either.

So "advance #836" cannot mean the ordinary thing — it is closed, and its content sits
on a dead-end snapshot. The maintainer's *goal* is unambiguous: **one implementation,
merged on live `llm`, losing nothing from either.** Serve that goal.

## What to do

1. **Diff the two implementations properly.** Compare #836's merged content (from
   `llm-bfc91f5`) against #903's head, and produce an explicit inventory: what each
   has that the other lacks. #903 is 2.3× the size — determine whether that is
   genuine additional work (more conditional implementations, XS/browser variants,
   the blobref migration, tests) or merely rebase noise and unrelated churn.
2. **Choose the carrier and say why.** The likely shape, given the facts, is that
   **#903 is the carrier** (already on live `llm`) and anything #836 has that #903
   lacks gets ported into it — which serves the directive's goal even though it
   inverts its literal wording. If your diff shows the opposite (that #836's content
   is materially better and #903 is bloat), then cherry-pick #836's tree from
   `llm-bfc91f5` onto live `llm` as a fresh PR and close #903 instead.
   **State your reasoning and the evidence either way.**
3. **If the two have genuinely diverged in design** — different APIs, different
   host-function contracts, different conditional-export layouts — STOP and report
   the fork rather than merging them by hand. That is a maintainer call.
4. **Land the survivor on live `llm`.** Fix the `lint` failure on the carrier: note
   that #903 shows TWO `lint` legs, one FAIL and one PASS, which on #873 and #652 turned
   out to be a **pre-existing repo-wide lint issue, not the PR's own diff**. Check
   that before "fixing" anything in the PR. Drive CI green.
5. **Close the loser with a clear cross-reference**, so the record shows the work was
   absorbed, not abandoned.
6. **Do NOT merge without a current maintainer approval on the exact head** — the
   approvals on both PRs are stale, and this repo's gate correctly refuses. Get it
   green and mergeable, then report that it awaits approval.

## The self-improvement half — this is not optional

Investigate **why the fleet built the same feature twice**, and write it up. Starting
points, not conclusions:

- #836 was created 07-22 against a frozen base; #903 on 08-01 against live `llm`.
  What did the second producer see (or not see) that let it start over? Was there a
  supersession check that should have caught an existing open PR for the same package?
- The **frozen-base pattern** looks causal: work merged into `llm-bfc91f5` is invisible
  to anyone reading live `llm`, so `packages/sha256` genuinely does not exist there. A
  producer checking "does this package exist?" against `llm` would correctly conclude
  it must be built.
- Note that this is not isolated: `llm-bfc91f5` currently strands **three** PRs
  (#836 merged, #888, #943) at 254 commits behind, and the fleet has separately hit
  frozen-base drift on #621, #503, #475, and #910.

Land the write-up per [skills/self-improvement](skills/self-improvement/SKILL.md).
If the right fix is a producer-side supersession check, or a policy on merging into
frozen bases, propose it — do not implement a fleet-wide policy change in this job.

## Report

The diff inventory, which PR you chose as carrier and why, what you ported, the lint
disposition (pre-existing vs PR-introduced), the closed PR's cross-reference, and the
self-improvement finding with its proposed fix.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 5
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-12T01:03:44Z
