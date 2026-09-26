## Completion report — `audit-inbox-discipline-and-deadmail`

Worn the mentor role. Both parts done; all work committed to `main2` as **`3cd4ffcd`** (pushed, fast-forward clean) in an isolated worktree off `origin/main2`.

### Part A — audit (`designs/inbox-discipline-audit.md`)
Enumerated every `claude -p` agent and classified its inbox-monitor / can-message coverage. Key finding: the fleet has **two shapes**, and "every agent monitors an inbox" is the wrong invariant:
- **Job doers (gardeners)** have a *lifecycle inbox* (created at claim, destroyed at completion) and monitor it (`inbox-read.sh <base>` at claim + `read-msgs.sh role/gardener broadcast` each loop).
- **Service agents** (triager, watchman, mentor, proxy, foreman, follow-up, bulletin) are *stateless per-tick* producers with no addressable identity — correctly no inbox; each has a working outbound channel (post jobs / broadcast / write to maintainer/doer inboxes).

Coverage summary: **all 8 agents covered**, after fixing two real gaps:
- **G1 (gardener, was partial):** mid-job discipline lived only in the role brief. Fixed — `handlers/gardener-claude.sh` now injects a *Messaging discipline* block naming the agent's `<base>`, `inbox-read.sh`, `message-user.sh`, `inbox-send.sh`, `inbox-list.sh`.
- **G2 (missing):** no live-peer discovery. Fixed — added `scripts/jobs/inbox-list.sh`, the canonical "who is alive right now" lookup (lists live `inbox/<doer>/`, excludes `maintainer`/`dead`).

### Part B — dead-mail mechanism (the race the maintainer named)
- **Capture, don't drop:** `inbox-send.sh` (and everything layered on it — `message-user.sh`, `maintainer-reply.sh`, the proxy/foreman/follow-up senders) now dead-letters a message whose recipient inbox is gone into `inbox/dead/<id>.md` (carrying `to:`/`from`/`reply_to`/body) instead of erroring. Live delivery stays the fast path; `GARDEN_NO_DEADLETTER=1` restores the legacy hard fail.
- **Promote to jobs:** `scripts/jobs/deadmail.sh` (`garden-deadmail`, timer-driven like the reaper) posts one job per dead-letter — deterministic basename `deadmail-<id>` (idempotent re-scan), body carrying the original message + intended recipient + "the addressee had already completed; pick up its intent" — then retires the entry. Honors `killswitch_engaged`, quiet on success.
- **Registered:** `scripts/systemd/garden-deadmail.{service,timer}` + `install-units.sh` (`enable_services` + summary line).

### Hygiene & tests
- Message bodies treated as DATA (promoted-job body says so explicitly).
- `bash -n` + `shellcheck -x` clean on all touched scripts (only pre-existing codebase-style infos remain).
- `run-test.sh`: SUBTEST 5 updated (send to torn-down doer is dead-lettered, not a hard error; `GARDEN_NO_DEADLETTER=1` still hard-fails; `inbox-list` peer-discovery asserted); **SUBTEST 16 (new)** covers dead-letter capture, recipient recording, promotion to exactly one job, retirement, idempotency on re-scan. **Result: 81 passed, 0 failed.**

### Follow-ups / notes
- **Test-harness gotcha (documented in the audit):** `claim-job.sh`/`gardener.sh` honor `GARDEN_GARDENER_CLONE`/`GARDEN_GARDENER_ID` from the env. On a host running the live fleet those are exported into the shell, so `run-test.sh` must run with them unset (`env -u GARDEN_GARDENER_CLONE -u GARDEN_GARDENER_ID`) or SUBTEST 1 spuriously fails. Pre-existing — the unmodified baseline fails identically. Worth a future hardening (have `run-test.sh` self-unset them).
- During diagnosis I accidentally ran `claim-job.sh` once against the live gardener-91 clone; it produced only a **local** claim commit that never reached `origin/journal2` (the job stayed in `todo` on origin). The real gardener's next `sync_clone` (`reset --hard origin/journal2`) discards it — no real-garden damage. No action needed.
