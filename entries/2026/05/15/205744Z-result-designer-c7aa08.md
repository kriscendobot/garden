---
ts: 2026-05-15T20:57:44Z
kind: result
role: designer
worktree: dispatches/designer--c7aa08/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/15/214530Z-dispatch-steward-c7aa08.md
---

Extended the endopi comparative analysis on PR #265 to cover
`packages/genie` per jcorbin's review comment.

## Files touched

- `designs/endopi.md`: added § *Endo-side surfaces covered* preamble naming
  the three surfaces (Lal, Fae, Genie) the document compares against Pi;
  added new section § *Genie: Pi inside Endo* with mapping table, three
  follow-on implications, and source-file citation list; updated the
  *Multi-provider LLM API* table to call out two surfaces (Lal's per-
  provider modules vs. Genie's pi-ai dependency).
- `designs/endopi-provider-registry-and-oauth.md` (M1): added *Status*
  section flagging partial satisfaction; added *Lal vs Genie consolidation*
  open question.
- `designs/endopi-iterative-compaction.md` (M4): added *Status* section
  flagging partial satisfaction by Genie's observer+reflector pair.
- `designs/README.md`: status cells for the two affected designs flag
  partial satisfaction; M1 size cut M-L → M (4-5d) since pi-ai's 30+
  providers are no longer the headline; M4 iterative-compaction size cut
  M → S-M (3d) since the substrate is shipped.

## Commit

- `4fbb9dc79` on `design/endopi` (force-fast-forward not needed; clean
  append on top of `b5fd77d4e`).
- Push succeeded; remote updated.

## Genie row content (paraphrase)

Genie is Pi-inside-Endo: depends on `@mariozechner/pi-agent-core` (the
embeddable agent core, not the cli) and `@mariozechner/pi-ai` (the
provider registry) directly. Ships a custom ollama adaptor
(`buildOllamaModel`) that masquerades local ollama as
`openai-completions` because `pi-ai`'s default registry lacks a native
ollama entry. Layers Claw-like subagents on top: observer (token + idle
triggered compaction into `memory/observations.md`), reflector (size + daily
triggered consolidation into `memory/reflections.md` and `memory/profile.md`),
heartbeat (autonomous task executor reading `HEARTBEAT.md`). Workspace
template (`SOUL.md` + `HEARTBEAT.md` + `memory/`) is Claw-compatible.
System prompt built by `buildSystemPrompt` in `src/system/index.js`
(Claw-modeled). Tool confinement is per-tool gating via `tool-gate.js`
over an ambient-Node tool surface; SES/capability confinement is NOT
present today, and the maintainer's direction is `packages/sandbox`
(bwrap on Linux) as the eventual confinement layer for `command` and
`vfs-node`.

## Roadmap impact

**M1 (`endopi-provider-registry-and-oauth`): partially satisfied.**
Genie ships pi-ai's full registry today by transitive dependency, plus
the ollama adaptor. The milestone's remaining scope reduces to four
items: (a) subscription OAuth (Claude Pro / ChatGPT Plus / Copilot),
(b) cross-provider mid-session handoff, (c) image-input wiring, and
(d) the Lal-vs-Genie consolidation policy question. README size
estimate reduced M-L → M, 1.5w → 4-5d.

**M4 (`endopi-iterative-compaction`): partially satisfied.**
Genie's observer+reflector pair is a working iterative compactor with
the trigger split (token threshold + idle for observer; size threshold
+ daily heartbeat for reflector) and the iterative-summary-feeds-next
axis. Remaining work: project the observer/reflector pair onto Lal's
in-memory transcript graph (today they write to markdown on disk), plus
the `keepRecentTokens` / `reserveTokens` knobs. README size estimate
reduced M → S-M, 4-5d → 3d.

**Confinement story raised as open question** in the Genie section but
not turned into a new spinout: wiring `packages/sandbox` under genie's
`command` and `vfs-node` tools is the natural follow-on once
`endo-posix-sandbox` Phase 1.5 lands. Not blocking either M1 or M4.

## Ack comment

Posted at https://github.com/endojs/endo-but-for-bots/pull/265#issuecomment-4463564677
(per the dispatch's optional per-action authorization). Names commit
SHA, summarises the extension, and explicitly thanks jcorbin.

## Self-improvement

The dispatch brief named a journal-entry path
(`journal/entries/2026/05/15/214530Z-dispatch-steward-c7aa08.md`)
that did not yet exist when this subagent started; the orchestrator
likely wrote it after dispatch or never wrote it. Subagents
should treat brief-referenced journal entries as "expected but not
guaranteed" and proceed when the dispatch prompt is self-sufficient,
rather than blocking on the missing entry. This is implicit in the
COMMON.md "If you are interrupted or hit a blocker you cannot resolve,
write a message" rule but might be worth surfacing in
`roles/designer/AGENT.md` § Operating norms.

Self-improvement: subagents proceeding when a brief-referenced journal entry is not yet present is the right move; consider noting this in the designer role if the pattern recurs.
