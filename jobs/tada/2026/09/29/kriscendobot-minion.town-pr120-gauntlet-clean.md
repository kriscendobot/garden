# Clean stage report: kriscendobot/minion.town PR #120

The clean stage is done. I added tests for four untested code paths in the PR, found no dead code, and CI is green on the new head `ed25945`.

**Starting point.** The PR was a draft with one commit (`8e6ed5ef2`). CI was green, but no coverage pass had been done yet, so this stage was not a no-op.

**Coverage.** I ran coverage over `src/endo/claude/**` using the eight `test/claude-*.test.ts` files, and closed these gaps:
- **`agents.ts`**: a revoke that lands while a delegated `create` is still running was untested. The new test checks two things: the child that exists only in the directory listing is freed, and the `create` that finishes after the revoke tears itself down and returns `needs-auth` without keeping a quota slot.
- **`never-reject.ts`**: a `failOpen` display read that throws now has a test showing it returns an empty array.
- **`inbox-watch.ts`**: an agent whose `infer` throws now has a test showing it maps to `{type:"inferred", result:{type:"unavailable"}}`.
- **`wiring.ts`**: the `ENDO_CLAUDE_MAX_CHILDREN` setting is now tested. A valid value sets the cap; `-1`, `2.5` and non-numbers fall back to the default.

After the new tests, `agents.ts` is at 99.6% line coverage, and `inbox-watch.ts` and `never-reject.ts` are at 100%. Two small gaps remain, and I left them on purpose:
- `agents.ts:251` is a catch around a connect call that is allowed to fail.
- `wiring.ts:373-376` is a stub in the fail-closed production build that callers can never reach.

**Dead code.** None. The exported names that nothing else imports are public API types or helpers used inside their own module, and the exports removed from `main-c815041` are not orphaned.

**Checks and push.**
- Typecheck is clean and the full suite passes (499 passed, 7 skipped). The coverage tool was a temporary symlink, removed before committing.
- I pushed commit `ed25945` ("test(claude): cover revoke-during-create race, failOpen, inbox-watch throw, max-children env") to `claude-agents-delegate` with `safe-push-pr-head.sh` (fast-forward from `8e6ed5e`).
- `ci-wait-merge.sh --no-merge` exited with rc 0: all three checks passed on the new head.

**Follow-ups:** none. The PR is still a draft; the panel stage comes next.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr120-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1074623 cached reads)
- Output: 6984 tokens
- Cost: $0.8721886000000001
- Wall-clock: 411s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
