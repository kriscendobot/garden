Inbox empty. Work complete.

## Completion report

**Job:** Fix the receipt-watcher empty-prerequisite-stderr diagnostic gap and add a regression test.

**What I found:** The *code* fix the job describes was **already shipped** — commit `ebfff9b84e` ("point empty-prereq-stderr fallback at resource check") already guards the `sed` with `if [ -s "$PREREQ_ERR" ]`, and the empty-stderr `else` branch already logs a `WARN: prerequisite subshell produced NO diagnostic output` pointing at a resource/environmental check and dies with wording that does **not** falsely claim "see prerequisite stderr above" (`scripts/jobs/receipt-watcher.sh:128-142`). The current implementation is in fact stronger than the job spec requested. The production root cause is also documented and fixed in `common.sh` (the `clone_lock` permanent `2>/dev/null` redirect that silenced stderr, lines 3842-3848).

**What was missing:** the regression test. The existing suite covered transient outages, structural failures, and the sync_clone second-reset path — but had **no case** exercising an empty-stderr *non-transient* prerequisite exit (the second-reset test even asserts that path is *not* hit). So the diagnostic gap could silently regress.

**What I changed** (`scripts/jobs/test/receipt-watcher-test.sh`, +45 lines, committed `0144ff77da`, pushed to `main2`):
- Extended the harness git stub with a `FAIL_GIT_CONFIG_KILL` mode that SIGTERMs the prerequisite subshell at ensure_clone's `git config user.name` write — modelling one of the four environmental cuts the WARN names (a signal). It matches `config` **without** `--get`, so `bot_name`/`bot_email`'s own `config --get` reads (in a different command-substitution subshell) pass through untouched. The subshell dies rc=143 with a **completely empty** `$PREREQ_ERR`, and 143 is not a transient code (75/124/137), so it must hit the empty-stderr guard.
- Added a test case asserting the watcher dies loud with the `produced NO diagnostic output (rc=143)` WARN and the `no diagnostic captured` die wording, and **never** cites `see prerequisite stderr above`.

**Verification:** Full suite passes 13/13. I proved the test bites by temporarily reverting receipt-watcher.sh to the old unguarded shape — the new case fails (12 passed, 1 failed) — then restored the fixed code (13/13). Shellcheck of the test flags only pre-existing style/info items in untouched lines; my additions introduce none.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-receipt-watcher-kriscendobot-ymax-e2e-empty-prereq-diagnostic.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2498208 cached reads)
- Output: 32588 tokens
- Cost: $3.0202109999999993
- Wall-clock: 545s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
