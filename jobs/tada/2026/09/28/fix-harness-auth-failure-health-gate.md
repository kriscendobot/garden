## Completion report: fix-harness-auth-failure-health-gate

**Result:** A host whose agent CLI credential has died now forces the job to requeue as transient, parks its own pool after one failure, and sends the maintainer exactly one notice for the whole episode. It un-parks by itself when the credential file's content changes. This is landed on `main2` as commit `58f9bb651fe`, pushed directly with no PR.

### The real signature
I read it from endolin-garden2's gardener-inbox captures (`journal/inboxes/endolin-garden2-5bcdff64/captures/`). All 110 auth-bearing captures from 2026-09-27/28 end with:
> `Failed to authenticate: OAuth session expired and could not be refreshed`

It comes right after `Claude structured API error (status=unknown).` That line also matches the generic `api error` transient pattern, and because the failure took only seconds, the existing speed check then escalated each one as a terminal failure. That explains the 109 escalations.

### Providers covered
The other wordings were taken from the installed binaries' own strings, not guessed:
- **Anthropic `claude`:**
  - "OAuth session expired" and "Failed to authenticate: OAuth"
  - "OAuth token revoked", "Login expired · Please run /login" and "Invalid API key · Please run /login"
  - "Session expired. Please run /login" and "Not logged in. Run claude auth login"
- **OpenAI `codex`:**
  - "access token could not be refreshed." and "… could not be refreshed because …"
  - "no Codex credentials were found" and "re-run `codex login`"
- **Deliberately not matched:** Claude Code's "OAuth access token could not be refreshed: another Claude Code process is holding the refresh lock". That is a short-lived lock race between workers, not a dead credential.

### What changed
All changes mirror `916ab48e206` and use the same functions and the same place in `gardener.sh`.
- **`common.sh`:**
  - `is_auth_failure_signature` and `auth_failure_excerpt` recognise the wordings above and pull out the CLI's own sentence for the notice.
  - `worker_credential_fingerprint` hashes the credential's content, not its mtime. For `claude` that is the file named by the new `claude_credential_file` (which `claude_auth_ok` now also uses); for `codex` it is `${CODEX_HOME:-~/.codex}/auth.json`. Provider API-key environment variables are included too.
  - `worker_auth_failure_latch` opens a `reason=auth-failure` episode and reports through the existing `_worker_health_report` → `alert_maintainer` path, which already deduplicates per episode.
  - `worker_health_gate` keeps the pool parked until the fingerprint changes. It makes no live API call.
- **`gardener.sh`:**
  - On the signature it sets the job transient and latches the host's gate.
  - It only does this if the handler died within 300 seconds (`GARDEN_AUTH_FAILURE_LATCH_MAX_SECS`, default 300). A dead credential fails on the first API call, so this stops a long job whose output merely quotes these sentences from parking a healthy host.
  - It skips the provider-wide cooldown in this case, because a bad credential on one host is not a provider outage and the cooldown would delay recovery after re-login.
  - Park and recovery log lines and notices now name the cause ("credential rejected (re-login required)", "CHANGED credential (re-login detected)") instead of "agent CLI unresolvable".

### Tests
`worker-health-gate-test.sh`: **64 passed, 0 failed**.
- **SUBTEST 7** covers:
  - the matcher, with 10 real wordings and 4 near-misses
  - the latch
  - that rewriting the file with the same content (only the mtime changes) keeps the host parked
  - recovery after a genuine credential change, reported once
  - the codex fingerprint
- **SUBTEST 8** runs the endolin-garden2 scenario through the real `gardener.sh` loop, with three jobs on the board and a handler that prints the real error:
  - **(a)** the failed job is classified transient and requeued, not escalated, and no provider cooldown is published
  - **(b)** the handler ran **once**; the other two jobs stayed in `todo/` while the host was parked
  - **(c)** exactly **one** maintainer notice: "monk workers on authsimhost cannot AUTHENTICATE their agent CLI (… "Failed to authenticate: OAuth session expired …")"
  - after the credential was rewritten, the host un-parked by itself, finished the other two jobs, and sent exactly one RECOVERED notice

The real incident had already been fixed when I ran; this worker is on endolin-garden2 and authenticated fine.

- **Existing failures fixed:** on `main2`, SUBTESTs 1, 2, 4 and 5 of this file were already failing because they used the retired `gardener` worker kind. I switched them to `monk`.
- **Other suites:** `shellcheck -S warning` on `common.sh` and `gardener.sh` is clean. Ten other related suites pass: provider-cooldown, empty-output-classifier, mentor-transient-backoff, alert-maintainer-edge, cursor-outage-cooldown, scaler-desired-count, worker-ensure-worktree, quota-calibration, journal-entry-project and elapsed-constancy. `tests/checks/run.sh` ran for 25 minutes with 0 failures before my time cap stopped it, so it did not finish.

### Follow-ups
- **Tests already failing on `main2`:** `backend-autotune-test.sh`, `claude-session-limit-classifier-test.sh` and `completion-signal-test.sh` fail identically on unmodified `origin/main2`, mostly because of the retired `gardener` kind. None of them is in the CI list. They are worth a small cleanup job.
- **Latch window:** a credential that expires partway through a long job only latches on the next claim, which fails fast. That costs one extra cycle, and I accepted it in exchange for the false-positive guard.
- **Other providers:** kinds that authenticate only with an API key (fireworks, openrouter, friar) are fingerprinted through their environment variables, but I added no wording for their errors. I found no captures to base a regex on.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-harness-auth-failure-health-gate.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 112 tokens (6611167 cached reads)
- Output: 38702 tokens
- Cost: $3.3501214000000004
- Wall-clock: 5069s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
