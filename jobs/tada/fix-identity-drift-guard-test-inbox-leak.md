Done — pushed to `main2` as `81a9f464dd`.

## Root cause

`tests/checks/test_identity_drift_guard.sh` captured only the **journal** sink (`GARDEN_IDENTITY_GUARD_EMIT`). The **maintainer-inbox** sink was added to `identity-drift-guard.sh` *after* that test was written and never got an override, so `emit_maintainer` fell straight through to the real `inbox-send.sh maintainer` on each of the test's three drift runs — the three `driftname` / `/tmp/idg-XXXXXX` `kind: error` messages, 5 seconds apart, exactly matching its subtest sequence. The 2026-07-11 backstop could not catch it because that test set **neither** `GARDEN_TEST=1` (so `guard_no_production_push_in_test` was inert) **nor** `JOURNAL_REMOTE` (so the remote resolved to the real garden repo). The sibling `scripts/jobs/test/identity-drift-guard-test.sh` was never the leaker — it already captured both sinks.

## What changed

- **`scripts/jobs/identity-drift-guard.sh`** — every sink now routes through one fail-closed `emit_sink`. With no capture override it invokes the real helper *only* outside a test context; under `_in_test_context` it swallows the body and refuses with a loud log line. A sink added later that forgets its override becomes a failing, noisy test instead of production traffic.
- **`scripts/jobs/common.sh`** — `_in_test_context` also recognizes a test-tree **entrypoint** (`$0` under `test/`/`tests/`), so a test run directly rather than through a harness is no longer invisible to the push guard. It reads `$0`, never the cwd, so a gardener in a project checkout that contains a `tests/` dir is unaffected. Only two consumers exist (`guard_no_production_push_in_test`, `emit_sink`), both fail-closed refusals that fire only on a production target or a missing override.
- **Both drift-guard tests** — throwaway bare journal origin via `JOURNAL_REMOTE`, `GARDEN_TEST=1`, ambient `GARDEN_*`/`JOURNAL_*` scrub, and the maintainer sink captured. Four independent layers.
- **`tests/checks/run.sh`** — exports `GARDEN_TEST=1` once for every checks suite, mirroring `scripts/jobs/test/run-test.sh`.

## Regression tests for a *new* escalation path

Two simulations, in both suites: (a) the guard run on genuine drift with the maintainer override deliberately unset — must refuse and must not arm the dedup marker; (b) the bus helper called **directly**, bypassing the wrappers entirely — must land in the throwaway origin. Plus the backstop assertion (`guard_no_production_push_in_test` dies on a production origin) and the converse invariant: **outside** a test context a real drift still posts its maintainer-inbox report, so containment did not become suppression. `proxy.sh` is untouched — `identity-drift-guard:*` is not `watchdog:*`, so real drift is still never auto-cleared.

Verified the new subtests actually catch the bug: running them against the pre-fix guard gives 2 failures ("forgotten sink did not refuse", "dedup marker armed despite a refused escalation").

## Containment demonstration

Filename set-diff against the real `journal2` (counts alone were noisy — the liaison was archiving the leaked messages concurrently, which is why the totals *drop*):

```
BEFORE inbox=277 entries=2
  identity-drift-guard-test.sh   rc=0  14 passed, 0 failed
  test_identity_drift_guard.sh   rc=0  21 passed, 0 failed
  tests/checks/run.sh            (full suite)
AFTER  inbox=274 entries=2
NEW inbox:   []
NEW entries: []
```

## CI-equivalent checks

- `shellcheck -S warning` over the exact CI scope: clean.
- `bash -n` over all `scripts/`+`skills/` `*.sh`: clean.
- Journal-heavy suites re-run for regressions from the `_in_test_context` change — `journal-entry-argv`, `producer-arg-guard`, `land-journal-edit`, `orchestrate`, `main-host`: all rc=0.

## Follow-ups (not in scope, not done)

1. `tests/checks/run.sh` reports **2 pre-existing failures** unrelated to this job — `test_maintainer_inbox_information_hiding.sh` (allowlist drift: `roles/prosecutor`, `skills/{orchestration,restore,review-retrospective,schedule}` reference the maintainer inbox off-allowlist) and `test_run_all.sh` (2 claude-stub-invocation assertions). Confirmed pre-existing by re-running with my `run.sh` change stashed.
2. ~80 suites under `scripts/jobs/test/` still export neither `GARDEN_TEST` nor `JOURNAL_REMOTE`. The new entrypoint heuristic covers the leak-from-the-test-process shape for all of them, but there is no aggregate runner to add the sentinel to; a sweep adding per-suite isolation is a separate job.
3. Neither drift-guard test is in the CI shellcheck list; adding them would need the shared `unset $(compgen -v …)` idiom (SC2046) suppressed or rewritten.
