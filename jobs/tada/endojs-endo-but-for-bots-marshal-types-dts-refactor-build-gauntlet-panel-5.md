Panel round 5 complete.

**What I did**
- Set up an isolated project worktree of PR #1061 head (`refactor/marshal-types-declaration-module`, head `87f4cf5ca`, base `master-8c402ee`).
- Ran the 29-seat code panel in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`). After two session-teardown-induced kills of the panel child process (reaper requeues 1 and 2), I relaunched it **detached** (`setsid`, stable output files) so it survived; it exited 0 with disposition **must-fix**.
- Posted the aggregate as a `gh pr review` on the PR.

**Verdict: must-fix.** Two seats returned request-changes, converging on one gap:
- `prover` + `spec-keeper`: `Encoding` and `TreeOf<T>` in `types.test-d.ts` are pinned only one-directionally (`expectAssignable`) instead of the bidirectional `Equal<>` treatment every other exported type gets. Verified by mutation — widening either to `any` leaves `tsc -p packages/marshal` fully green, so a silent widening ships undetected. `spec-keeper` also notes the round-4 commit message falsely claims the `Equal<>` pin mirrors "every exported type."
- Advisory (comment-only, fold in during the fix): `corner-prober`'s three uncovered boundary pins, `coverage-auditor`'s missing c8 report, `typist`'s `value`→`val` param-name mirror, `purist`'s `@module` wording parity.

Everything else (the `PartialComparison` widening, the `rankOrder.js` cast cleanup, the 1:1 type relocation, no-changeset call, capability/SES/wire surfaces) was verified clear and is not a regression.

**Delivery note:** The bot (`kriscendobot`) is the PR author, so GitHub blocks self-request-changes — only COMMENT reviews are permitted (as with all four prior rounds). I posted the must-fix disposition as a COMMENTED review with the disposition stated explicitly at the top. The full 65811-byte per-seat aggregate exceeded GitHub's review-body cap, so the posted review is a size-capped digest (6895 bytes) carrying both must-fix findings verbatim plus the compressed advisory list.

**Follow-up:** Next gauntlet stage (fix) owns tightening the two `Equal<>` pins; this stage stops here as instructed.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-marshal-types-dts-refactor-build-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 61 tokens (2258104 cached reads)
- Output: 17320 tokens
- Cost: $2.8586679999999998
- Wall-clock: 821s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
