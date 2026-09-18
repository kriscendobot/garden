The FIX stage is complete. CI is green on the fix commit.

## Completion report

**Job:** Gauntlet FIX round 1 for endojs/endo-but-for-bots PR #1304 (read-only directory attenuation).

**What I found:** A prior attempt of this same job (requeued after a reap) had already applied the panel's must-fix items comprehensively and pushed them as commit `e377c1fe4` ("fix(daemon): address panel round-1 must-fix items for read-only directory attenuation"). `HEAD == origin/bot/build/1125-readonly-directory-attenuation == e377c1fe4`, so the fix is durably on the PR head. Per the "apply once, push, watch CI, then STOP" contract, I did not re-apply.

**What the pushed fix addresses** (matching the round-1 must-fix findings across the 31-seat panel):
- **Unpinned/unnamed eval formula** (the dominant must-fix, 10 seats): `readOnly()` now pins the eval formula via `pinTransient` and memoizes one view per directory, so it survives collection sweeps and repeated calls no longer spawn a worker each — closing the worker-per-call amplification too.
- **mailHub/messageHub `readOnly()`** now return a genuinely narrow `ReadableNameHub` exo instead of the full directory (so `__getMethodNames__` feature detection no longer sees present-but-throwing mutators).
- **Shallow-attenuation contract test** (prover/warden/corner-prober) + guard-parity test against `readableNameHubMethodGuards`.
- **Recognizer forgeability** documented as a caller precondition.
- Housekeeping must-fix/should-fix: `EndoDirectory.readOnly` help entry, `ReadableNameHub` re-export from public `types.d.ts`, null-prototype help record, `maybeLookup` Promise return type, `ReadableTreeView` (was `SubMount`) cross-reference, dropped U+2026 ellipsis, changeset rewrapped one-sentence-per-line.

**Verification:** Bounded CI watch (`GARDEN_CI_DEADLINE_SECS=3600 ci-wait-merge.sh … --no-merge`) returned **rc 0 — CI GREEN** (`total=32 failed=0`) on `e377c1fe4`. All checks pass or skip; none red or pending.

**Not touched:** the uncommitted `packages/floot/package.json` em-dash change is pre-existing worktree junk the panel itself flagged as out-of-diff; I left it uncommitted (torn down with the worktree).

**Follow-up:** none for this stage — the driver re-posts panel-2 for re-review.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1304-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 258 tokens (17862810 cached reads)
- Output: 88486 tokens
- Cost: $13.855162999999996
- Wall-clock: 2305s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
