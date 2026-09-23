---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: fixer

Fix the duplicate acknowledgment-comment storm from the comment watcher.

SYMPTOM: endojs/endo-but-for-bots#600 has 34+ identical bot comments — "On it —
I've posted a job (`endojs-endo-but-for-bots-pr600-rebase`) and will follow up
here when it lands." — posted 2026-09-01 through 2026-09-23, in bursts (6 on
09-19, 4 between 00:05 and 00:16 on 09-23). kriskowal quoted one back at the bot
on 2026-09-19 (comment 5786588027 is a recent instance). Every copy carries the
IDENTICAL dedup marker `<!-- garden-reply:1601 -->`.

EMITTER: scripts/jobs/comment-watcher.sh:2103 (post_reply on the verify_posted
branch) -> scripts/jobs/handlers/comment-reply-gh.sh.

DEFECT 1 — the idempotency guard fails OPEN on a PARTIAL read.
comment-reply-gh.sh does:

    existing="$(gh api --paginate "$list_path" --jq '.[].body' 2>/dev/null \
                || printf '__READ_FAILED__')"
    if [ "$existing" = "__READ_FAILED__" ]; then ... exit 0; fi

When gh emits some pages and THEN fails (rate limit / transient mid-pagination),
stdout is "<partial>__READ_FAILED__", which is NOT equal to "__READ_FAILED__", so
the fail-closed branch never runs. It then greps a TRUNCATED comment list; the
marker lives in the newest page — exactly what truncation drops — so it posts a
duplicate. The file's own comment states the intent ("we treat any nonzero read as
skip the post this tick"), but sentinel-string-equality only detects a TOTAL
failure, never a partial one. This explains the bursty pattern (duplicates cluster
in rate-limit windows) and why a clean manual read correctly no-ops.

FIX: capture gh's exit status separately from its stdout and fail closed on ANY
nonzero rc, e.g.

    if ! existing="$(gh api --paginate "$list_path" --jq '.[].body' 2>/dev/null)"; then
      log "could not list existing replies on $list_path (transient); deferring"
      exit 0
    fi

Do not rely on an in-band sentinel that can be prefixed by partial output. Also
consider verifying pagination completeness before trusting a negative marker
result (a negative is only meaningful on a COMPLETE read).

DEFECT 2 — the source comment id is synthetic. The marker is keyed on cid=1601,
but 1601 is NOT a real id on endojs/endo-but-for-bots: GET issues/comments/1601,
pulls/comments/1601 and issues/1601 all 404, and no review has id 1601. Trace
where comment-watcher.sh derives $cid for the surface that produced this reply and
why it yields a small synthetic value instead of a GitHub id. A bogus cid also
makes the reactji ack and the marker keyspace unreliable.

ACCEPTANCE:
- A partial/failed dedup read NEVER results in a posted reply (add a regression
  test alongside scripts/jobs/test/comment-watcher-test.sh, stubbing gh to emit
  partial output then exit nonzero; assert zero POSTs).
- The cid passed to the reply handler is a real GitHub id for every surface, with
  a test covering the surface that produced cid=1601.
- Do NOT delete or edit the existing #600 comments as part of this fix; cleanup is
  a separate maintainer decision.

CONTEXT: the comment watcher is a leader-only singleton and, by standing
maintainer instruction (2026-09-23), runs on the leader host. It is currently
ARMED on endolin-garden2-5bcdff64, so this defect is live in production.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-23T00:24:22Z
