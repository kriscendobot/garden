<!-- garden-design-open-questions -->
# Scaffolding-prefix caching and reaper-driven session-summarization handoff

| Created | 2026-09-06 |
| Author  | gardener (investigate-scaffolding-cache-and-reaper-handoff) |
| Status  | Proposed |

Maintainer directive (kriskowal, 2026-09-06): before designing a reaper-driven
session-summarization handoff for gauntlet stages, **measure whether it's actually
needed.** Investigation first, design second. This document reports the
measurement, then proposes two changes the measurement supports.

## TL;DR

- **Garden's own scaffolding (`roles/COMMON.md`, the role brief, cited skills) is
  NOT cache-shared across independent jobs today, and structurally cannot be** as
  currently plumbed. It is pulled in mid-session by the agent's own `Read` tool
  calls, so it lands in `messages` *after* the point where two different jobs'
  prompts already diverge (the job base name, at ~token 26 of the first user
  message). Anthropic's prompt cache is a pure prefix match; nothing after the
  first divergence is a cross-session hit.
- **The huge `cache_read` numbers on `Engagements: 1` jobs are NOT evidence of
  cross-session scaffolding sharing.** They are (a) intra-session prefix re-reads —
  every turn of one long conversation re-reads the accumulated transcript — and
  (b) same-base `--resume` continuations re-reading their *own* prior transcript.
  `cache_read` correlates with conversation length at **log-log Pearson r = 0.93**
  and is 96% of all tokens the fleet spends. It does not correlate with the
  recency of a *different* same-role sibling.
- **The one thing that IS cross-session shared is Claude Code's own `tools`+`system`
  prefix** (the baseline floor), which is CLI-wide and not garden's to change.
- **Design A** (companion, small but real): hoist the stable, every-job scaffolding
  (`COMMON.md` + the generic gardener role brief) out of an agent `Read` and into
  the frozen `system` prefix via `--append-system-prompt`, so it joins the
  cross-session-shared cached region. Honest magnitude: ~11.75k tokens/job, a
  modest saving, dwarfed by intra-session growth — worth doing for the *also*-saved
  `Read` round-trip and as the prerequisite that makes Design B's handoff land on a
  genuinely shared prefix.
- **Design B** (the requested handoff): on a cross-host / transcript-lost requeue,
  today a gauntlet stage either drags the full prior transcript forward
  (`--resume`) or silently restarts from zero ("lost-state" fresh session).
  Replace the zero-state restart with a **fresh session on the identical frozen
  prefix + a short structured progress summary appended as ordinary trailing
  content**, extracted from the captured transcript.

## Background the reader can take as given

- **Gauntlet stages are already fresh, short-lived sessions.** `gauntlet.sh` gives
  each stage (`clean`, `panel-k`, `fix-k`) its own job basename;
  `handlers/monk-claude.sh` derives a deterministic Claude session id from that
  basename (`uuid5(NAMESPACE_URL, "garden-job:"+base)`). Different basename →
  different session → fresh by default.
- **Panel jurors are already independent, parallel, fresh `claude -p` calls**
  (`scripts/jobs/gardening/panel.sh`, up to `GARDEN_PANEL_CONCURRENCY`=8 at once),
  one per seat, and the foreperson is its own fresh call fed the aggregated
  verdicts as prompt text. This already matches the "fresh session + prompt
  fragment" shape and is not in scope for change.
- **Anthropic's prompt cache is a pure prefix-byte match, not session-scoped.** Two
  independent `claude -p` processes — different session ids, different hosts — read
  the SAME cache entry if they render an identical `tools` + `system` +
  prefix-of-`messages` within the cache TTL (5 min default, up to 1h). Render order
  is `tools` → `system` → `messages`; any byte change anywhere in the prefix
  invalidates everything after it. This is not a garden mechanism.

## Measurement

Data source: this garden's own `journal/usage/*.jsonl`, `source:"result"` records
(the immutable per-invocation envelope `monk-claude.sh` writes). 4,521 result
records; 4,154 on `claude-opus-4-8` (the dominant fleet model — the analysis
controls for model by restricting to it).

### 1. The baseline floor and the intra-session driver

`cache_read` by conversation length (`num_turns`), opus-4-8:

| num_turns | n | median cache_read | p90 cache_read |
|---|---|---|---|
| 1 | 1078 | **0** | 0 |
| 2–3 | 218 | 133,774 | 414,141 |
| 4–8 | 477 | 326,369 | 714,797 |
| 9–20 | 1027 | 718,044 | 1,198,339 |
| 21–50 | 877 | 1,981,200 | 3,812,672 |
| 51+ | 477 | 7,862,970 | 19,990,918 |

- **Single-turn jobs read a median of zero cache.** A genuinely fresh, one-round-trip
  `claude -p` reads *nothing* from a shared cache. If garden's scaffolding were
  landing in a shared cross-session position, a fresh single-turn job would show a
  non-zero floor. It shows zero. (The 1,078 single-turn jobs are dominated by
  fast-fail / no-op ticks with zero tokens.)
- **`cache_read` scales monotonically and steeply with `num_turns`.** log-log
  Pearson r(cache_read, num_turns) = **0.933** (n=3089). `cache_read` is 96.5% of
  all tokens the fleet spends (fresh input ~0.00%, cache_creation 2.8%, output
  0.7%); the fleet mean is ~94.6k cache-read tokens *per turn*. This is exactly
  intra-session prefix re-reading: each API request in a session resends and
  cache-reads the whole growing conversation. It is normal, healthy caching and is
  *not* cross-session sharing of anything garden-specific.

### 2. The `Engagements: 1` puzzle, resolved

The 13 single-turn jobs that *did* show large `cache_read` (median ~105k) are
almost all **same-base requeues/resumes** — they appear 2–7 times in the record.
A `--resume` continuation re-reads its *own* prior session transcript on its first
turn, so `num_turns` for that attempt is 1 while `cache_read` is 100k–220k:

| base (truncated) | appears | cache_read | note |
|---|---|---|---|
| endojs…pr715-gauntlet-fix-1 | 4× | 105,355 | same-base resume |
| endojs…pr796-gauntlet-panel | 4× | 56,027 | same-base resume |
| ironhorse-fuzz-…-repair-gauntlet | 7× | 10,114 (cc=55,169) | first attempt *creating* cache |

This is intra-*base* session continuity (the deterministic-session-id `--resume`
path), not cross-*role* scaffolding sharing. It is the mechanism working as
designed.

### 3. Mechanism check — where two jobs' prompts diverge

Rendering `worker_job_prompt` (`handlers/worker-common.sh`) for two different
bases in `fresh` mode and diffing byte-for-byte: **the common prefix is 105
characters (~26 tokens)**, ending at `…You have claimed job '` — i.e. the two
prompts diverge at the job base name in the *first sentence* of the first user
message. The worktree note then re-embeds the base and worktree path throughout.

Consequences, given render order `tools` → `system` → `messages`:

- `tools` + `system` are Claude Code's own, byte-identical across every garden job
  → the shared cross-session prefix (the "floor"). Not ours to change.
- The garden prompt is `messages[0]` and diverges at ~token 26. The message-level
  cache region after the first user turn is therefore unique per base.
- `COMMON.md` / role brief / skills are read via `Read` **during** the session,
  landing as `tool_result` blocks in `messages` *after* the divergence. They can
  never be a cross-job cache hit. (Within one session they are cached after first
  read — that is the intra-session effect measured in §1, not cross-session.)

**Conclusion:** garden scaffolding is not cache-shared across independent jobs, and
cannot be while it is delivered by the agent's own `Read` after a base-specific
prompt prefix. The assumption that the big cache-read numbers proved otherwise is
false; they are intra-session and intra-base.

## Design A — hoist stable scaffolding into the frozen `system` prefix

**Problem.** Every fresh job of every role pays a fresh `Read` (and a cache *write*,
at the 1.25× multiplier) for `COMMON.md` (~10.1k tok) + the generic gardener role
brief (~1.6k tok) ≈ **11.75k tokens**, plus a tool round-trip turn, and never gets
a cross-session cache hit on any of it.

**Change.** Move that stable, every-job content out of the agent's `Read` and into
the `system` prefix, where the prompt cache shares it across independent sessions
exactly as it shares Claude Code's own system prompt. Claude Code headless exposes
`--append-system-prompt <text>` (and `--append-system-prompt-file`) for precisely
this. In `monk-claude.sh`, append the concatenated `roles/COMMON.md` +
`roles/gardener/AGENT.md` via that flag; keep every job-specific byte (base,
worktree path, job body) in the user message as today.

Because the appended block is **byte-identical across every monk job fleet-wide**
(the spine role brief is generic for all worker kinds), it renders into the shared
`system` region *before* `messages`, so:

- Within a TTL window, the first job writes it once and every other concurrent /
  close-in-time job (panels of 8, pools of ~20) reads it as a cache hit.
- The `Read` round-trip disappears (one fewer turn, one fewer `tool_result`).
- Skills stay `Read`-on-demand: they are selected per job, so pinning *all* of them
  into every prompt would bloat every call — a net loss. Only the universally-read
  `COMMON.md` + role brief are hoisted.

**Honest magnitude.** This is a *small* optimization. ~11.75k tokens/job of avoided
cache write is ≈ $0.07/job at opus-4-8 write pricing when it becomes a hit; across
the ~2,379 historical `tada` jobs, order ~$100 total even under generous hit-rate
assumptions. It does **not** touch the dominant cost, which is intra-session
conversation growth (§1, 96% of tokens) and is not addressable by any
prefix-caching change. Design A earns its place as (a) a free-ish structural
cleanup that also removes a turn, and (b) the **prerequisite** that makes Design B's
handoff append land on a genuinely shared, cache-hit-eligible prefix rather than on
scaffolding that is itself re-created every time.

**Risk / caveats.**
- `--exclude-dynamic-system-prompt-sections` interactions and Claude Code version
  drift on the flag name must be verified against the installed CLI before wiring
  (the flag is present in the CLI shipped here; a self-healing probe should confirm
  it and fall back to the current `Read` path if absent).
- The appended block must be *frozen* per fleet-deploy: a per-tick recomputation
  that varies (e.g. embeds a timestamp) would silently invalidate the shared prefix
  and forfeit the whole benefit. Verify with `usage.cache_read_input_tokens` after
  rollout.

## Design B — reaper-driven session-summarization handoff

**Problem.** A requeued gauntlet stage today takes one of two paths, chosen in
`monk-claude.sh` from the `$resuming` signal:

- **`--resume` (same host, transcript present)** — drags the *entire* prior
  transcript forward. Correct for continuity but pays the full re-read.
- **"lost-state" fresh restart (cross-host requeue, or transcript pruned)** —
  `monk-claude.sh:168–170` starts a fresh session under the same id with
  `fallback` framing (`worker-common.sh` `mode=fallback`). All prior
  reasoning/progress is discarded; the new attempt re-derives from committed state
  and the journal only. **Zero benefit carried, for real prior work.**

The reaper (`reaper.sh`) is deliberately a *dumb* requeue — it keeps no session
knowledge; recovery is the handler's half of the contract. And by reap time the
dead session's process is already gone (crash / OOM / reboot / TTL), so "a final
act of the dying session" is generally *not* available — the summary must be
**extracted from the captured transcript**, which the garden already spools to the
journal (`designs/transcript-journal-capture.md`; `transcript_spool` in
`common.sh`, drained by the hourly `transcript-capture.sh`).

**Change.** Replace the zero-state restart with a genuine fresh session carrying a
short structured summary, grounded in the documented fork-safety rule (reuse the
parent's exact `system`/`tools`/`model` prefix verbatim, append fork-specific
content at the end):

1. **Produce a progress summary** for the reaped attempt — *what was tried, what is
   confirmed, what is still open* — from its captured transcript when reachable
   (spool or journal capture). Generation options in Open Questions.
2. **Start the next attempt as a genuinely fresh session** — *not* `--resume`; new
   session content on the identical frozen scaffolding prefix (Design A's
   `system` block, unchanged byte-for-byte so the cache prefix still shares).
3. **Append the prior summary as ordinary trailing content** after that prefix (in
   the `fallback`-mode user message), never folded into the frozen prefix — so the
   prefix stays byte-identical and cache-shared while the volatile summary sits
   after the last breakpoint.

**Exact touch points.**
- `handlers/monk-claude.sh` — the `fallback` branch: today it logs "prior session
  and worktree were lost — starting FRESH session … with lost-state framing"
  (`:168–170`) and hands `worker_job_prompt … fallback` a prompt with *no* prior
  context. Change: look up a summary for `$base` (from the transcript
  spool/journal capture), and when present pass it into the prompt builder.
- `handlers/worker-common.sh` — `worker_job_prompt` `mode=fallback`: accept an
  optional summary argument and, when present, append a clearly-fenced
  `PRIOR-ATTEMPT SUMMARY (not a memory you hold — a briefing)` block after the
  worktree note, replacing the current "trust nothing, re-derive from scratch"
  framing with "here is what the prior attempt established; verify against
  committed state, then continue."
- The **summary producer** — a new small helper (deterministic, no `claude` in the
  reaper's own path; see Open Questions on where generation runs). It reads the
  captured transcript for `$base` and writes
  `journal/…/attempt-summary/<base>.md`, keyed by base like every other per-job
  artifact. `reaper.sh` stays a dumb requeue; at most it *marks* that a summary
  should be produced (it already stamps `<!-- garden-reaped: N -->`).

**Scope.** This targets the `fallback` (transcript-lost) path only. The `--resume`
path (same host, transcript present) already carries full continuity and is
unchanged. The `fresh` first-claim path has nothing to summarize.

## Open questions

1. **Is Design A worth building at all, given the measured magnitude is small?**
   The investigation's headline finding is that the *big* cache numbers are
   intra-session, not scaffolding — so the scaffolding-caching win is real but
   modest (~$100-scale historically, plus one saved turn/job). Do we build A on its
   own merits, or only as the prerequisite bundled with B? Recommendation: bundle;
   don't ship A alone.

2. **How is the progress summary generated (Design B step 1)?** Three options, in
   increasing cost: (a) a cheap deterministic extract of the transcript's tool
   calls / final assistant turns (no model call); (b) a small `claude -p`
   summarization on a cheap tier (minion/haiku) over the transcript; (c) instruct
   every gauntlet-stage worker to periodically checkpoint a summary as a side file
   so a reaped attempt already has one. (c) is most robust to an unreachable
   transcript but adds per-turn cost to the *common* (non-reaped) path — probably
   not worth it. Lean (a) with (b) as fallback when the extract is too thin.

3. **When does summary generation run, given the reaper must stay dumb and no-LLM?**
   If (b), the model call cannot live in `reaper.sh`. Candidates: the re-claiming
   handler produces the summary lazily on entering the `fallback` branch (simplest,
   but adds latency to the retry), or a separate leader-only timer drains a
   "summarize-these-reaped-bases" queue. Lean: lazy in the handler for (a); queue
   for (b).

4. **Cross-host transcript reachability.** The `fallback` path exists precisely
   because the transcript was *not* local. Is the journal transcript-capture
   (`transcript-journal-capture.md`) reliably drained and reachable from the
   re-claiming host by retry time (hourly sweep vs. the reaper's 10-min cadence +
   4h TTL)? If a reap can outrun capture, B degrades to today's behavior for that
   window — acceptable, but quantify how often.

5. **Prompt-injection surface.** A summary derived from a transcript that processed
   external PR text is itself derived data. It is appended as trailing content, not
   into the frozen prefix, and is framed as an untrusted briefing — but confirm this
   adds no new injection path beyond what the original stage already read.

## What this job did NOT do

Per the directive, this is investigation + design only — no build. The two designs
name their exact touch points but change no code.
