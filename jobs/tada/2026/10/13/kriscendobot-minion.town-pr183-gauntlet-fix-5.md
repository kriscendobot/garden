Fix round 5 for kriscendobot/minion.town PR #183 is pushed, and CI is green on the new head `8415af619d2`.

**Must-fix applied (breaker, round-5 panel):** every confined spawn passed `--output-format stream-json --verbose` twice. The vendored `buildArgv` now emits those flags before its trailing `-p`, and `src/endo/claude/cli-launch.ts` was still adding them again after the harness argv.
- **`cli-launch.ts`:** `launchClaude` now spawns `[...spec.argv]` exactly as the harness built it, so the harness alone owns those flags. I rewrote the header, which still said the flags were "appended after the harness's trailing `-p`", to describe this.
- **`test/claude-cli-launch.test.ts`:** this test used to check that the seam appended the flags. It now checks that the seam passes the argv through unchanged and adds nothing.
- **`test/claude-cli-backend.test.ts`:** a new test runs the real vendored `buildArgv` through the harness and the real launch seam, reads back the argv the fake binary received, and checks that `--output-format`, `stream-json`, `--verbose` and `-p` each appear exactly once, with `-p` last. It fails against the old seam and passes now, so it also gives the vendored `argv.js` change the behavior test the prover said was missing.

**Commit:** `8415af6 fix(claude): spawn the harness argv without re-appending stream-json flags`, pushed with `safe-push-pr-head.sh` in advance mode (`cab37a5 → 8415af6`).

**Checks:**
- **Local:** both test files pass (30 tests), and `tsc --noEmit` is clean.
- **eslint:** it did not run. It printed only its config-migration help text, so lint was not checked locally.
- **prettier:** it flags one line in `claude-cli-backend.test.ts` (around line 300). That line was there before this change and I left it alone.
- **CI:** `ci-wait-merge --no-merge` hit its deadline still pending on the first try (rc 4) and came back green on the second (rc 0, 1 run, 0 failed). The bot token can't read the full check rollup, so this green covers the GitHub Actions runs only.

**Follow-ups:** I did not touch the round-5 should-fix items. They are left for the next panel round:
- `readSecret` treats a revoked secret as a fault instead of `needs-auth`.
- A timed-out `@secrets` call releases the per-subject queue while still running.
- A refused message is re-delivered on every responder restart.
- `activate()` is not tied to the probed token.
- `cli-deployment.ts` has no connection-lifecycle unit test.
- The vault hand-rolls base64 instead of using `@endo/base64`.
- The vault gets the whole root host instead of a narrowed `@secrets` facet.
- The refusal is checked in three places.
- The v1-to-`@secrets` migration has no rollback, and DEPLOYMENT.md doesn't say so.

The job inbox was empty when I checked.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr183-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1436453 cached reads)
- Output: 8611 tokens
- Cost: $0.9770386000000002
- Wall-clock: 1285s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
