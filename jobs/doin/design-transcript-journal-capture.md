role: designer

Design a garden feature: durable capture of the fleet's Claude Code session
transcripts into the journal, plus fleet-wide disabling of Claude Code's transcript
deletion. Write the design under the garden's own `designs/` (this is a garden-meta
feature; land the design doc on `main2`). Spec it concretely enough for a builder.

## Goal / motivation
Claude Code deletes old session transcripts after `cleanupPeriodDays` (default 30).
The maintainer wants (a) that deletion disabled across the whole fleet, and (b)
automation that captures the garden's transcripts into the journal so they are a
durable, versioned record ("the journal holds the garden's transcript").

## Building blocks that already exist (use them; cite in the design)
- Transcripts live at `~/.claude/projects/<encoded-cwd>/<session-id>.jsonl`
  (HOME=<garden-root> in-container). There are thousands (this host had ~5,700).
- `scripts/jobs/usage-meter.sh` already scans `$HOME/.claude/projects/**/*.jsonl`
  (var `GARDEN_CCUSAGE_LOGDIR`) — precedent for reading session logs.
- `scripts/jobs/handlers/gardener-claude.sh`: a job's transcript path is
  DETERMINISTIC — `session_id = uuid5(NAMESPACE_URL, "garden-job:"+base)`, encoded
  cwd derived from the worktree. So a capture step can locate any job's transcript
  exactly, keyed by job base.
- `capture_blob` / `anchor_blob` / `inspect_note` in `common.sh` (skill
  prompt-on-failure-capture) store a blob in the journal's git object DB referenced
  by SHA — a possible storage primitive that avoids committing large tree files.
- The `garden` launcher already seeds `.claude/settings.json` host-side when absent;
  `cleanupPeriodDays` was just set to 36500 in THIS instance's settings.json by hand.

## Constraints / hazards to design around
- **Git bloat is the central risk.** Transcripts are large and numerous, and
  `journal2` is a SHARED orphan branch every host pushes to — naively committing all
  transcripts there would bloat it and slow every push fleet-wide. The design MUST
  address this. Enumerate and recommend among: a DEDICATED orphan branch (e.g.
  `transcripts2`, mirroring the journal2 orphan pattern) with its own worktree;
  a subtree under journal2; or blob-by-SHA object storage. Consider gzip (jsonl
  compresses very well) and whether/how to prune.
- These are OUR OWN transcripts, so there is no prompt-injection concern in storing
  them — but they may contain secrets/tokens that scrolled through a session; the
  design should note whether any redaction/scoping is warranted.
- Cross-host: capture must be per-host (each container has its own transcripts) but
  land in a shared place without clobbering peers (path by GARDEN identity).
- Idempotent + incremental: a live session's .jsonl grows; decide capture-on-
  completion (deterministic path, keyed by job base) vs. a periodic sweep of all
  new/changed transcripts, or both. Leader-only vs every-host (gardeners run on
  every host, so likely every-host for capture).

## Open decisions to resolve in the design (recommend, don't just list)
1. Storage location + bloat strategy (branch vs subtree vs blob; compression; prune).
2. Capture trigger: job-completion hook in the gardener path vs. a periodic timer
   (a new `garden-transcript-capture` systemd timer) vs. both. Which sessions:
   gardener jobs only, or liaison + subagents too.
3. Fleet-wide disable of deletion: have the `garden` launcher seed
   `cleanupPeriodDays` into the settings.json it writes, AND a way to reconcile
   EXISTING instances whose settings.json predates the change (the launcher only
   seeds when absent) — e.g. an idempotent per-host reconcile step in a startup or
   scaler path. settings.json is gitignored, so it cannot propagate via git.
4. Retention/index: how a human finds a given job's or session's transcript later
   (an index? path convention keyed by base/host/date?).

## Deliverable
A design doc under `designs/` with a recommended approach and enough spec (paths,
the capture script's shape, the systemd unit(s), the branch/worktree setup if any,
the launcher change) for a builder to implement without re-deciding. Keep it
proportionate — prefer the simplest design that handles the bloat hazard; do not
gold-plate. Note follow-on build steps. Garden-meta only; no project repo, no upstream.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 8
  claimed_at: 2026-07-06T23:24:36Z
