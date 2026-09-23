Inbox empty. Work is complete and landed on `main2` (`a71081d81`).

## Completion report

Built the transcript-journal capture system per `designs/transcript-journal-capture.md` § Builder spec (items 1–8). Landed directly on `main2` as commit `a71081d81` (garden-meta, no PR), first-attempt CAS push.

**What changed (9 files, +900 lines):**

1. **`scripts/jobs/common.sh`** — added knobs `GARDEN_TRANSCRIPTS_BRANCH` (`transcripts2`), `GARDEN_TRANSCRIPTS_SPOOL`, `GARDEN_TRANSCRIPT_IDLE_SECS` (21600), and the `transcript_spool` helper (gzip-into-spool + pending index row; offline, never fails its caller).
2. **`scripts/jobs/handlers/gardener-claude.sh`** — spool the finished transcript for both candidate encodings immediately **before** the existing `rm -f`; the rm and its false-resume rationale are untouched.
3. **`scripts/jobs/transcript-capture.sh`** (new) — the per-tick sweep: reconcile `cleanupPeriodDays=36500` first/unconditionally (jq read-modify-write, foreign keys preserved, atomic mv, create-if-absent); read the armed remote from the journal (inert+exit 0 if absent); ensure a `--single-branch --branch transcripts2 --filter=blob:none` + sparse clone (orphan-init when the branch is absent, degraded plain clone fallback); drain the spool + sweep idle/changed `~/.claude/projects` sessions through `redact_stream` (gh/`github_pat`/`sk-ant`/Bearer shapes) then `gzip -n`; verified CAS push (fetch/reset/reapply); clear spool + update ledger only after a verified push. No `is-main-host` gate — runs on every host.
4. **`scripts/jobs/set-transcripts-remote.sh`** (new) — CAS-writes `config/transcripts-remote`, modeled on `set-garden-repo.sh`.
5. **`scripts/systemd/garden-transcript-capture.{service,timer}`** (new) — oneshot via `self-heal-run.sh`, `SuccessExitStatus=143 130 …`, `TimeoutStartSec=900`, no `is-main-host` condition, `OnCalendar=*-*-* *:20:00`, `Persistent=true`; auto-enabled by `install-units.sh` (timer-paired, `WantedBy=timers.target`).
6. **`garden`** launcher — seed `"cleanupPeriodDays": 36500` into new instances' settings.json (comment updated).
7. **`scripts/jobs/test/transcript-capture-test.sh`** (new) — **20/20 assertions green**: inert-when-unarmed spooling, settings reconcile (absent file AND foreign keys preserved, idempotent), set-transcripts-remote + journal read + spool drain, redaction, idle gating, changed-session re-capture, and CAS retry against a racing peer commit (via a `GARDEN_TRANSCRIPTS_PUSH_CMD` seam).
8. **`context/operations/transcripts.md`** (new) — operator page: arming, browsing, rotation escape hatch, knobs.

**Verification:** the dedicated test passes 20/20. I ran the existing `run-test.sh` suite; it flakes in this live-fleet environment (its own header documents "flakes under fleet load"), and a pristine `origin/main2` baseline failed *earlier and harder* (rc=126 in SUBTEST 1) than my tree (44 PASS/0 FAIL before an unrelated cross-subtest maintainer-inbox ordering FATAL on a path I never touch) — confirming the flakiness is environmental, not from this change. All touched scripts pass `bash -n`.

**Deliberately left out (per job spec):** `context/operations/starting.md` and `roles/liaison/AGENT.md` are untouched — bring-up surfacing + the liaison broadcast-reader are the serial follow-up child `build-liaison-broadcast-reader`.

**Follow-ups (maintainer/other jobs):** arming is the maintainer's act after this lands (create a private repo, grant the bot push, run `set-transcripts-remote.sh <url>`, record a journal `message`, post the `role/liaison` "durability armed" notice). The optional local janitor and `find-transcript.sh` wrapper remain deferred.
