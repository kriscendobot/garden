CI is GREEN (rc 0). The fix stage is complete.

## Completion report

**Job:** endojs/endo-but-for-bots PR #1083 — gauntlet FIX round 6 (design-doc-only PR: `designs/npm-registry-as-directory-tree.md`).

Read the panel-6 verdict (request-changes from critic, skeptic, ergonomist, copyeditor; comment-only from decomplector, pedant, novice) and applied the must-fix / should-fix items once, in a single review-feedback follow-up commit (`27d428081`, +128/−42):

- **skeptic (must-fix):** The shipped `readableTreeMethodGuards.lookup` is `M.call(NameOrPathShape)` — a single `string | string[]` arg — not variadic; verified against `packages/platform/src/fs/interfaces.js`. Corrected the calling-convention prose and the TS `LookupTree` interface, and replaced every guard-rejecting `lookup('@endo', 'patterns')` two-arg spelling with the path-array `lookup(['@endo', 'patterns'])`, keeping the single-string npm convenience form.
- **ergonomist (must-fix + should-fix):** `has()` now keeps the platform-wide no-throw boolean contract (folds "can't tell" into `false`); the present/absent/unreachable distinction is carried by `lookup()` alone. Named the composite `RegistryHub` / `RegistryDirectory` types so `getInfo` is discoverable structurally. Added a shared registry-error discriminant so the three contract failures catch as one family, with the guard `TypeError` kept deliberately outside it.
- **critic (should-fix):** Tightened the `daemon-worker-import-from-mount` Dependencies row to name the removed `registry` formula slot / `registryP` dispatch arg and the required companion revision; gave the snapshot-mapper late-bind fallback round-trip accounting (cold miss path, same-side colocation, bounded by late bindings).
- **copyeditor (must-fix + should-fix):** Rewrote the arity-collision sentence to name `lookup` vs `list` explicitly; moved the `SyntaxError` appositive next to its noun.
- **pedant (comment-only, cheap):** Three one-sentence-per-line splits.

Pushed to the PR head via `safe-push-pr-head.sh` (`1a959d3c6..27d428081`). Watched CI bounded: **rollup-terminal total=5 failed=0 → GREEN (rc 0)**.

Comment-only findings I deliberately did not act on (they oppose deliberate design choices or are taste calls): decomplector's `@registry` bridging-window restructure and `getInfo` split, skeptic's npm-name-validation softening. The driver re-posts panel-7 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1083-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 91 tokens (4608225 cached reads)
- Output: 36698 tokens
- Cost: $4.2364645
- Wall-clock: 926s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
