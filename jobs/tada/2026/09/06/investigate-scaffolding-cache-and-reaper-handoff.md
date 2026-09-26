All complete. Verified: PR #88 base is the frozen pre-design snapshot and head is the design commit, so the diff shows only the new design; inbox is empty.

## Completion report

**Job:** `investigate-scaffolding-cache-and-reaper-handoff` — investigation-first (kriskowal, 2026-09-06), design only if the measurement supports it.

### What I measured (from this garden's own `journal/usage/*.jsonl`, 4,521 `source:"result"` records; 4,154 on `claude-opus-4-8`)

- **Baseline floor:** single-turn jobs read a **median of 0** cache tokens. A genuinely fresh, one-round-trip `claude -p` reads nothing from a shared cache — if garden scaffolding were in a shared cross-session position, this would show a non-zero floor. It doesn't.
- **The real driver:** `cache_read` scales steeply with conversation length — **log-log Pearson r = 0.93** with `num_turns`, and `cache_read` is **96.5%** of all fleet tokens. The huge `cache_read` numbers on `Engagements: 1` jobs are **intra-session** prefix re-reads (each turn re-reads the growing transcript) plus **same-base `--resume`** continuations reading their own prior transcript (the 13 single-turn high-cache jobs all appear 2–7× in the record). **Not** cross-role scaffolding sharing.
- **Mechanism check (decisive):** rendered two different-base job prompts and diffed them — common prefix is **105 chars (~26 tokens)**, diverging at the job base name in the first sentence. Given render order `tools → system → messages`, garden's `COMMON.md`/role/skills (read via `Read` tool calls, landing in `messages` after that divergence) can never be a cross-session cache hit. The only genuinely cross-session-shared prefix is Claude Code's own `tools`+`system` block — not garden's to change.

**Answer to the open question:** garden scaffolding is **not** cache-hit-shared across independent jobs, and cannot be as currently plumbed.

### What changed
- **New design** `designs/scaffolding-cache-and-reaper-summarization-handoff.md`, landed **bare on `main2`** (commit `c5f89c8694`), containing the measurement writeup plus:
  - **Design A** (companion): hoist `COMMON.md` + generic role brief (~11.75k tok) into the frozen `system` prefix via `--append-system-prompt` so it joins the cross-session-shared cache region. Honestly scoped as *modest* (dwarfed by intra-session growth) — its value is the removed `Read` round-trip and being B's prerequisite.
  - **Design B** (the requested handoff): replace the cross-host "lost-state" zero-restart with a fresh session on the identical frozen prefix + a short structured progress summary extracted from the already-captured transcript, appended as trailing content. Names exact touch points: `monk-claude.sh` fallback branch (`:168–170`), `worker-common.sh` `worker_job_prompt` fallback mode, and a new no-LLM-in-reaper summary producer.
- Because the design carries a non-empty `## Open questions` section, per the garden's carve-out it also gets a **review PR: [#88](https://github.com/kriscendobot/garden/pull/88)** (frozen base at pre-design `28de1891af`, head at the design commit), marked `<!-- garden-design-open-questions -->` so the completion machinery does not stage a design panel.

### Follow-ups (for the maintainer, in the PR's Open questions)
1. Is Design A worth building alone given the small measured magnitude, or only bundled with B? (rec: bundle.)
2. How to generate B's summary — cheap deterministic transcript extract vs. small model call vs. per-turn checkpointing.
3. Where summary generation runs given the reaper must stay dumb/no-LLM.
4. Cross-host transcript reachability by retry time (hourly capture sweep vs. 10-min reaper cadence).
5. Prompt-injection surface of a transcript-derived summary (appended as untrusted trailing briefing).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/investigate-scaffolding-cache-and-reaper-handoff.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1969880 cached reads)
- Output: 32820 tokens
- Cost: $3.0106029999999997
- Wall-clock: 490s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
