Done and pushed.

## What I did

Added both identity drift-guard tests to the CI shellcheck list in `.github/workflows/checks.yml` and resolved the SC2046 that their shared env-scrub idiom trips:

- `tests/checks/test_identity_drift_guard.sh`
- `scripts/jobs/test/identity-drift-guard-test.sh`

**Chose suppression over rewrite.** The deciding fact: `unset $(compgen -v … )` is not local to these two files — it appears verbatim in **~70 test scripts** under `scripts/jobs/test/`. Rewriting only these two to a `while read` + process-substitution loop would fork the copy-pasted form from every sibling that a future lint-surface widening will meet. So each site gets a narrow `# shellcheck disable=SC2046` with a justifying comment: the split *is* the intent (`unset` takes a list of names, and `compgen -v` emits only `[A-Za-z_][A-Za-z0-9_]*` names, which can hold neither whitespace nor glob characters — quoting would pass the whole newline-joined blob as one bogus name). This matches existing house precedent for deliberate splits at `scripts/aws/turnkey/teardown.sh:34`. I also updated the step's scope comment, which had gone stale.

## Verification

- Full CI shellcheck list run exactly as CI invokes it: **exit 0**.
- **Suppression is narrow, not file-wide** — proved by appending a second, unrelated SC2046 to a scratch copy: the appended line is still flagged while the scrub line is not.
- Both suites green: **14/0** and **21/0**. Since the fixtures depend on the scrub, that also confirms the scrub still works.
- Confirmed the inbox-leak fix `81a9f464dd` is in my base before running the tests, so the hermetic layers were present — no risk of re-leaking into the real maintainer inbox.
- YAML parses; `bash -n` clean on both.

One thing worth flagging rather than glossing: `tests/checks/run.sh` reports **2 failing suites** (`test_maintainer_inbox_information_hiding.sh`, `test_run_all.sh`). I did not assume these were unrelated — I set my edits aside, reverted to pristine HEAD, and re-ran: **identical two failures**. They are pre-existing and untouched by this change (`test_run_all` fails on `claude` not being invokable in this sandbox; the inbox gate fires on `roles/`/`skills/` markdown I never touched).

## Follow-ups

- **Pre-existing, unowned:** those two failing suites are red on `main2` today. The maintainer-inbox gate lists 14 real `LEAK` entries in `roles/`/`skills/` markdown — that looks like genuine drift someone should triage, not sandbox noise, unlike the `test_run_all` failure.
- Both files still carry info-level SC2015/SC2016, below CI's `-S warning` threshold. Many siblings already carry `# shellcheck disable=SC2015,SC2016` headers, so tightening CI to `-S info` would need that sweep first — out of scope here.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-fix-identity-drift-guard-test-inbox-leak-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 47 tokens (1654318 cached reads)
- Output: 17754 tokens
- Cost: $2.016824
- Wall-clock: 275s

<!-- garden-usage-end -->
