model: fable
role: orchestrator

# Fable supervisor: implement transcript-journal capture (design is DONE)

The design is COMPLETE and landed: read `designs/transcript-journal-capture.md` on
main2 (commit d9c7ad6c7) FIRST — it is your spec, including its § Builder spec. The
maintainer decided a dedicated `transcripts2` orphan branch and to proceed to
implementation. You are the Fable supervisor who drives that implementation to
completion.

## Your job (supervise; do not hand-write the code yourself)
Decompose the design's § Builder spec into Opus BUILDER sub-job(s) and drive them to
completion per skills/orchestration (park children with post-plan.sh --orchestrated
--orchestrated-by <this-base>, record with post-orchestration.sh, let the
deterministic orchestrate watcher sequence + watch them to tada; or a single builder +
blocked_on follow-ups if simpler). Builders (Opus) write the code; you plan, sequence,
watch to completion, apply the failure policy, and make sure the follow-ups are not
forgotten. The design suggests ONE builder job for items 1-7 of its § Builder spec —
keeping it to one builder is fine if that matches the spec, but YOU own landing it and
the bring-up + broadcast-reader pieces.

## Scope to ensure gets built (all per the design; all INERT until the remote is armed)
- common.sh helpers; the gardener-claude.sh completion spool hook placed immediately
  BEFORE the existing `rm -f` (which STAYS — false-resume hazard); the capture script;
  gzip + deterministic token-redaction; per-host GARDEN-keyed paths; a blobless+sparse
  per-host clone of transcripts2.
- `set-transcripts-remote.sh` + `config/transcripts-remote` per-instance journal config
  (inert-until-armed, the issue-inbox pattern), defaulting OFF.
- The every-host `garden-transcript-capture` systemd timer/service pair (capture runs
  on every host, not leader-only).
- Fleet-wide deletion disable: launcher seeds `cleanupPeriodDays: 36500`, PLUS an
  idempotent jq-merge reconcile each capture tick (covers existing instances whose
  settings.json predates the change — including verifying THIS host actually carries it).
- Bring-up surfacing: context/operations/starting.md + roles/liaison/AGENT.md.
- Liaison broadcast-reader: liaisons read NO broadcast today; add that on bring-up they
  drain role/liaison (+ broadcast) via read-msgs.sh with a per-host seen-key, so a
  send-msg.sh role/liaison broadcast reaches liaisons fleet-wide. A cleanupPeriodDays
  notice is ALREADY queued on role/liaison; your reader makes it deliverable. Document
  in roles/liaison/AGENT.md + starting.md.
- Tests for the capture script + the settings reconcile; all green before land.

## Do NOT
- Do NOT arm the transcripts remote, create any repo, or grant push access — that is a
  permissioned MAINTAINER action (create a PRIVATE repo, grant the bot push, run
  set-transcripts-remote.sh, record a journal `message` entry). Build so it is INERT
  until armed. In your completion report, SURFACE to the maintainer inbox
  (message-user.sh <this-base>) the exact arming steps and the design's open questions:
  private repo as plan of record? liaison sessions in scope (default yes)? the idle
  threshold value? — for the maintainer to decide.
- Garden-meta only: land code/docs on main2 (push directly, no PR). No project repo, no
  upstream.

<!-- garden-reaped: 2 -->
