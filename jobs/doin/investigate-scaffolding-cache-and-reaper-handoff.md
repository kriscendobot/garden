---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Maintainer directive (kriskowal, 2026-09-06): before designing a reaper-driven
session-summarization handoff for gauntlet stages, measure whether it's
actually needed. This job is investigation first, design second (only if the
measurement supports it) — do not build the handoff on a guess.

## Background (read before starting — this was already worked out in
conversation, don't rediscover it)

- Gauntlet stages are already fresh, short-lived sessions by construction:
  `gauntlet.sh` gives each stage (`clean`, `panel-k`, `fix-k`) its own job
  basename, and `handlers/monk-claude.sh` derives a **deterministic Claude
  session id from that basename** — different basename, different session,
  fresh by default. Within one basename, a reaper requeue or a bounded
  "still-pending" CI-wait re-post uses `--resume <sid>` and continues the FULL
  prior transcript; if the transcript file isn't found on the retrying host,
  it falls back to a **fresh session under the same id with "lost-state"
  framing** (`monk-claude.sh`'s own log line: `"prior session and worktree
  were lost — starting FRESH session $session_id with lost-state framing"`).
- Panel jurors (`scripts/jobs/gardening/panel.sh`) are already independent,
  parallel, fresh `claude -p` calls (up to `GARDEN_PANEL_CONCURRENCY`, default
  8, at once) — one per seat — and the foreperson/decider is also its own
  fresh `claude -p` call fed the aggregated verdicts as prompt text, not
  session continuation. This part already matches the "fresh session + prompt
  fragment" shape under discussion; it is not in scope for change.
- Anthropic's prompt cache is a **pure prefix-byte match, not session-scoped**:
  any two independent `claude -p` processes — different session ids, different
  hosts — read the SAME cache entry if they render an identical `tools` +
  `system` + prefix-of-`messages` within the cache TTL (5 min default, up to
  1h). This is NOT a garden mechanism; it's how the Messages API works
  underneath every call.
- Real evidence already pulled from this garden's own `jobs/tada/*.md` `##
  Cost` blocks: several jobs marked `Engagements: 1` (genuinely one fresh
  session, no internal resume) show massive `cached reads` against near-zero
  fresh input (examples seen: 858,133 / 274,935 / 1,631,558 / 493,234 cached
  read tokens). Something is already being shared across independent fresh
  sessions.
- **The open question this job answers**: are those big cache-read numbers
  Claude Code's own baseline system-prompt + tool-schema cache (huge, CLI-wide,
  identical regardless of which garden role runs, and not ours to change), or
  is garden's OWN scaffolding — `roles/COMMON.md`, the role brief
  (`roles/<role>/AGENT.md`), cited skill files under `skills/` — ALSO landing
  in a shared, cache-hit-eligible position across independent jobs of the same
  role? Those are read via `Read` tool calls during the session, not baked
  into a static system-prompt block, so whether they land at an identical
  cache-eligible position across two different jobs is genuinely unknown and
  worth measuring rather than assuming either way.

## What to measure

1. **Establish the baseline floor.** Across a broad, role-mixed sample of
   `Engagements: 1` jobs (pull from `usage/*.jsonl` + the `## Cost` blocks in
   `jobs/tada/*.md`), find the cache-read magnitude that appears *regardless*
   of role, repo, or time-of-day — that constant-ish floor is almost certainly
   Claude Code's own baseline (system prompt + built-in tool schemas), not
   garden-specific.
2. **Look for an excess above that floor that correlates with recency of a
   same-role sibling job.** Pick a handful of roles/skills that run
   frequently (e.g. `builder`, the `panel` juror seats, `fixer`) and compare
   cache-read counts for jobs of that role/seat that ran within ~5 minutes of
   another job citing the *same* role brief and skill set, versus jobs of the
   same role separated by a long gap (past the 1h TTL even, if any exist). If
   close-in-time same-role jobs show a reliably higher cache-read count than
   far-apart ones (beyond the flat Claude-Code-CLI floor), that's evidence
   garden's own scaffolding IS sharing cache hits across independent sessions.
   If there's no such correlation, it isn't.
3. **Sanity-check the mechanism, not just the correlation.** If you can
   determine how the handler actually feeds `COMMON.md`/role/skill content to
   Claude (a `Read` tool call's result landing in `messages`, versus something
   pre-loaded into `system`), reason about whether the *position and ordering*
   of that content across two different jobs' conversations could plausibly
   match byte-for-byte (job-specific task text differs per job — does it come
   *before* or *after* the shared-scaffolding reads in the actual turn
   sequence?). This matters more than the correlation alone, since a
   coincidental match is possible without a real shared-position guarantee.

## What to do with the answer

- **If garden scaffolding is NOT meaningfully cache-hit-eligible today**: that
  is itself a higher-leverage, more general finding than the reaper-specific
  question — every fresh job of every role pays full uncached cost for
  `COMMON.md`/role/skill reads, not just gauntlet stages. Write this up (a
  `designs/*.md` doc is appropriate) proposing how to change that — e.g.
  whether pinning that content into something closer to a stable prefix
  (rather than leaving it to an agent's own `Read` tool call) would let it hit
  Anthropic's cache the way Claude Code's own system prompt does — and note
  this as a prerequisite/companion to the reaper-summarization design below,
  since building fork-friendly session handoffs on top of scaffolding that
  ISN'T actually cache-shared would undersell the benefit.
- **Either way, design the reaper-summarization handoff** for gauntlet-stage
  requeues, since it addresses a real, separate problem regardless of the
  scaffolding-caching answer: today a requeued stage either drags the full
  prior transcript forward (`--resume`) or, on a cross-host retry, silently
  loses all prior reasoning/progress (the "lost-state" fresh restart) for zero
  benefit. The fix, grounded in the documented fork-safety rule ("fork
  operations must reuse the parent's exact prefix... copy `system`/`tools`/
  `model` verbatim, then append fork-specific content at the end"):
  1. Before a stalled/reaped stage's session is discarded, extract or generate
     a short structured summary of its progress (what was tried, what's
     confirmed, what's still open) — from its transcript if reachable, or as a
     final act of the dying session itself if it's still reachable.
  2. Start the next attempt as a genuinely fresh session (new session id, not
     `--resume`) with the identical frozen scaffolding prefix.
  3. Append the prior summary as ordinary content after that prefix, not
     folded into it.
  Write this as a design doc naming the exact touch points (`monk-claude.sh`'s
  resume/lost-state branch, the reaper's own requeue path) and what changes.

Land per the garden's own conventions; this is investigation + design, no
build in this job.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-06T05:37:58Z
