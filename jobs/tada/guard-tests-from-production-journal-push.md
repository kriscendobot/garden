Inbox empty. Work complete.

## Completion report

**Job:** Guard — a test must never push to the production `journal2`.

**Root cause found (incident 2026-07-11):** `run-test.sh:1504` did `unset JOURNAL_REMOTE`, stranding the proxy subtests (15/15b) with no throwaway remote. `message-user.sh`/`proxy.sh` then let `journal_remote()` derive the **production** `github.com/kriskowal/garden` origin from `$GARDEN_ROOT/journal` and pushed synthetic `pxhost`/ferry and `driftname` traffic onto the real `journal2`. State was sandboxed; the remote was not.

**What changed** (commit `fc6b02b541`, pushed to `main2`):

1. **Structural guard (`scripts/jobs/common.sh`) — the durable fix.** New `guard_no_production_push_in_test()` `die`s loudly from the two push choke points `commit_and_push` and `anchor_blob` when *both* hold: a test context is in effect (positive sentinel `GARDEN_TEST=1`, or a tight `.garden-test` `GARDEN_STATE` heuristic that can never match a real `.garden-state`) **and** the resolved push target is the canonical production journal remote (`is_production_journal_remote`, matching https/scp-ssh/ssh:// forms, anchored to `kriskowal/garden` so fork/product pushes never match). It's a no-op outside tests and for any throwaway origin, so production is unaffected. Since every producer (`post-*`, `inbox-send`, `message-user`, `send-msg`, `complete/claim-job`, schedule, bulletin) funnels through `commit_and_push`, this closes the whole class.

2. **Fixed the leaking test (`run-test.sh`).** Restored the throwaway `$BARE` at the end of subtest 14d (`export JOURNAL_REMOTE="$BARE"` instead of `unset`) — the actual leak vector — and exported the `GARDEN_TEST=1` sentinel from one place (after the env scrub) so every subtest is covered even if a future one forgets to override the remote.

3. **Backstop for the sibling test.** `identity-drift-guard-test.sh` now exports `GARDEN_TEST=1` after its scrub (it was already hermetic via EMIT overrides; this is belt-and-suspenders).

**Verification (evidence):**
- `bash -n` + `shellcheck -S warning` clean on all three files (the only shellcheck items are pre-existing lines untouched by me).
- Guard matcher hits all transport forms, rejects fork/other repos.
- `commit_and_push`: **refused** under sentinel+production (rc=1, loud "REFUSING production-journal push"); **succeeded** against a throwaway origin (commit landed); **no-op** without the sentinel; `.garden-test` heuristic also refuses.
- Reproduced the exact proxy leak: with the fixed harness state the `message-user.sh` message lands on the **throwaway** origin; with the remote missed, the sentinel **refuses** rather than pushing to production.
- `identity-drift-guard-test.sh`: 10/10 pass, no production push.
- No regression: `land-journal-edit` (18/0), `stale-lock` (7/0), `productive-cycle` (10/0), `producer-arg-guard` all green, guard correctly silent on their throwaway origins.

**Follow-up / caveat:** `run-test.sh` cannot run to completion in this host worktree — it aborts at SUBTEST 6 on a pre-existing `maintainer-reply … no reply_to` FATAL (confirmed by a clean-baseline run and documented in `run-test.sh:2790`), so subtest 15 isn't reachable here via the monolith; the proxy fix was validated in isolation instead. That SUBTEST 6 abort is unrelated to this change and left as-is.
