---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-06T23:40:29Z -->

role: builder

# Build transcript-journal capture (design § Builder spec, items 1–8)

The design is COMPLETE and landed: read `designs/transcript-journal-capture.md`
on main2 FIRST. Its § Builder spec is your file-by-file checklist and its
Decisions 1–4 are the semantics — implement exactly that, no improvisation
beyond it. Everything you build must be INERT until the maintainer arms a
transcripts remote (`config/transcripts-remote` on journal2, absent today):
spool locally, push nowhere, no repo creation, no push-access changes.

File-by-file (details live in the design):

1. `scripts/jobs/common.sh`: knobs `GARDEN_TRANSCRIPTS_BRANCH` (default
   `transcripts2`), `GARDEN_TRANSCRIPTS_SPOOL` (default
   `$GARDEN_STATE/transcripts/spool`), `GARDEN_TRANSCRIPT_IDLE_SECS` (default
   21600); helper `transcript_spool <jsonl-path> [<job-base>]` — gzip into the
   spool plus a pending index row; always returns 0, logging failures.
2. `scripts/jobs/handlers/gardener-claude.sh`: in the completion-teardown
   block, call `transcript_spool` for `$proj_dir/$session_id.jsonl` and
   `$proj_dir_alt/$session_id.jsonl` (whichever exists) with `$base`,
   immediately BEFORE the existing `rm -f` (~line 315). The `rm -f` and its
   rationale comment STAY exactly as they are — the false-resume hazard is real.
3. `scripts/jobs/transcript-capture.sh`: the per-tick sweep per design
   Decision 2. Order matters: (a) reconcile `cleanupPeriodDays: 36500` into
   `~/.claude/settings.json` FIRST, unconditionally — jq read-modify-write into
   a temp file, atomic `mv`, create-if-absent, foreign keys preserved (Claude
   Code rewrites this file; never template-overwrite); (b) read
   `config/transcripts-remote` from the synced journal
   (`git show origin/journal2:config/transcripts-remote`, the issue-inbox read
   path) — absent: log inert, exit 0, spool keeps accumulating; (c) ensure the
   capture clone at `$GARDEN_STATE/transcripts/clone`: `--single-branch
   --branch transcripts2 --filter=blob:none` + `git sparse-checkout set
   transcripts/<GARDEN> index/<GARDEN>`, plain single-branch as degraded mode,
   init a local orphan `transcripts2` if the remote lacks the branch;
   (d) drain the spool and sweep `$HOME/.claude/projects/**/*.jsonl` for idle
   (mtime older than `GARDEN_TRANSCRIPT_IDLE_SECS`) sessions new/changed vs the
   ledger `$GARDEN_STATE/transcripts/captured.tsv`, each through
   `redact_stream` (GitHub token shapes `gh[pousr]_…`/`github_pat_…`, Anthropic
   `sk-ant-…`, `Authorization: Bearer` values → tail `…REDACTED`; one function,
   growable list) then `gzip -n`, into
   `transcripts/<GARDEN>/<encoded-cwd>/<session-id>.jsonl.gz` plus an appended
   row in `index/<GARDEN>.tsv` (`captured_at session_id job_base(or -)
   encoded_cwd raw_bytes gz_bytes raw_mtime`; the sweep back-derives job base
   from the `gardener-wt-<base>` dir-name pattern when it can); (e) nothing
   new → quiet one-liner exit, per house daemon style; else commit + CAS push
   (fetch/reset/reapply, `_verify_pushed` idiom); (f) clear drained spool
   entries and update the ledger ONLY after a verified push. Local originals
   under `~/.claude/projects/` stay untouched.
4. `scripts/jobs/set-transcripts-remote.sh`: CAS-writes
   `config/transcripts-remote` on journal2, modeled on `set-garden-repo.sh`.
5. `scripts/systemd/garden-transcript-capture.{service,timer}`: oneshot
   through `self-heal-run.sh`, `SuccessExitStatus=143 130 SIGTERM SIGINT`,
   `TimeoutStartSec=900`, NO `is-main-host` ExecCondition (capture runs on
   EVERY host); timer `OnCalendar=*-*-* *:20:00`, `Persistent=true`, with the
   absolute-schedule rationale comment the sibling timers carry.
   `install-units.sh` auto-enables non-template units; no exclusion needed.
6. `garden` launcher: add `"cleanupPeriodDays": 36500` to the JSON written by
   `seed_claude_settings()`.
7. `test/transcript-capture-test.sh`: fake `$HOME` with synthetic project
   dirs, a local bare repo as the remote, a fake journal config; assert
   inert-when-unarmed spooling, spool drain, idle gating, changed-session
   re-capture, redaction, settings reconcile (absent file AND foreign keys
   preserved), and CAS retry against a racing peer commit. ALL tests green
   before you land; run the existing scripts/jobs/test suite too if one covers
   files you touched.
8. Docs: write the operator page `context/operations/transcripts.md` (arming
   steps, browsing a transcript, the rotation escape hatch). Do NOT edit
   `context/operations/starting.md` or `roles/liaison/AGENT.md` — the bring-up
   surfacing is the serial follow-up child `build-liaison-broadcast-reader` in
   this orchestration, and keeping those files out of your diff avoids
   conflicting with it.

Garden-meta only: land on main2 directly (commit explicit pathspecs, rebase
CAS push), no PR, no project repo. Do NOT arm the remote, create any repo, or
touch push access — that is the maintainer's act, after this lands.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  claimed_at: 2026-07-06T23:40:33Z
