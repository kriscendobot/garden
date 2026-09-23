Inbox empty. The work is complete and pushed to `main2`.

## Completion report

**Job:** Make the fleet's bot git identity durable across a garden reset.

**What I did** — assessed the existing mechanism (`bot_name`/`bot_email` in `common.sh` read the garden repo's untracked local `.git/config`, lost on any fresh checkout / container recreation), then made the identity self-restoring from two records a reset cannot lose, with a per-host journal override taking precedence over a tracked canonical default.

**What changed (landed on `main2`, commit `6b0f3dee2f`):**
- `scripts/jobs/bot-identity-defaults.tsv` (new) — tracked canonical default keyed on `GARDEN_BOT_LOGIN`: `kriscendobot` → `Kriscendo Bot` / `279080640+kriscendobot@users.noreply.github.com`. Always present in a fresh checkout.
- `scripts/jobs/bootstrap-bot-identity.sh` (new) — idempotent restore of the local config from override-then-default; no-op when correct; never blocks bring-up on an unreachable journal (journal read is subshell-contained so a `die` can't abort it).
- `scripts/jobs/set-bot-identity.sh` (new) — writes a per-host override to `journal2:identity/<host>` (mirrors `set-workers.sh`'s CAS-push pattern; survives a re-clone).
- `scripts/jobs/common.sh` — `GARDEN_BOT_LOGIN` default + `bot_default_name`/`bot_default_email` + the journal-override reader; `bot_name`/`bot_email` now self-heal to the tracked default instead of `garden-bot`.
- `entrypoint.sh` — runs the bootstrap as the bot user at every container start (tracked-default only; journal skipped since root mustn't write bot-owned state that early), best-effort so it can't block PID-1 boot.
- Docs — CLAUDE.md § Host environment and `context/operations/starting.md` (new step 2, renumbered, cross-refs fixed): identity is now auto-restored, no manual `git config`, plus how to set a per-host override.
- `scripts/jobs/test/bot-identity-bootstrap-test.sh` (new) — 8 assertions, all green: reset restores the canonical default, idempotent no-op, self-heal, override wins, unknown-login fallback (never `garden-bot`), and the per-job worktree pin reproduces the restored identity.

**Verification:** the new test passes 8/8; CI `bash -n` sweep over all `scripts/`/`skills/` is clean. Two pre-existing grep-gate failures (`test_maintainer_inbox_information_hiding`, `test_run_all`) were confirmed identical on the pristine base commit — unrelated to this change (they flag `botanist`/`orchestrator`/`prosecutor` roles I never touched).

**Follow-ups / notes:**
- The entrypoint applies only the tracked default at container start; a per-host **override** lands when `bootstrap-bot-identity.sh` re-runs with the journal reachable (the starting procedure now does this). Hosts wanting a non-canonical identity must `set-bot-identity.sh` before that bootstrap.
- The two pre-existing check failures are out of scope here but worth a separate cleanup job.
