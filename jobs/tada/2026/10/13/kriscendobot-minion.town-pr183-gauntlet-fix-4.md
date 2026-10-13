## Gauntlet fix round 4: kriscendobot/minion.town PR #183

I applied the one must-fix item from the round-4 panel and two of the should-fix items. The head moved from `8faa77a` to `cab37a5` and CI is green.

**Commits pushed** (with `safe-push-pr-head.sh`, a fast-forward):
- `b7e570b` `test(endo)`: **Must-fix (stylist).** Renamed the abbreviated local `tmp` to `daemonTemporary` in the new "@secrets" integration test (`test/endo-daemon-integration.test.ts`, around line 700). I left the sibling tests' `tmp` locals alone, as the panel suggested.
- `cb8dc1a` `docs(claude)`: **Should-fix (typist).** Moved `PromptOrigin` above the `InferResult` doc comment in `src/endo/claude/types.ts`. That comment had ended up on the wrong type.
- `cab37a5` `test(claude)`: **Should-fix (pruner).** Removed the header in `test/claude-prompt-origin-gate.test.ts` that repeated the gate module's own doc comment.

**Checks:** `npm run typecheck` passes, and `test/claude-prompt-origin-gate.test.ts` passes (5 of 5).

**CI:** `ci-wait-merge.sh --no-merge` returned 0 (green) for `cab37a5`. The bot's token can't read the PR's combined check status, so the script fell back to the Actions runs API. It saw only the one Actions run; any other status checks were not visible.

**Should-fix items left open for later rounds or the maintainer:**
- **purist:** replace the hand-rolled hash and base64 with `@endo/sha256` and `@endo/base64`, or ask the maintainer. This needs a dependency decision.
- **pruner:** remove the source file names from the breaking-change paragraph in `DEPLOYMENT.md`.
- **assessor:** the vault's connection handler is registered on every call instead of once, and a timed-out `@secrets` call can still be running after the queue moves on.
- **decomplector:** `readState` still migrates and writes old records while reading.
- **prover:** missing tests for repeated gate refusals, the vendored `buildArgv` flags and `authFailed`.

The archivist's request-changes finding was refuted when the panel checked it, so I made no change for it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr183-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (943122 cached reads)
- Output: 5407 tokens
- Cost: $0.7410524
- Wall-clock: 1155s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
