---
title: Per-persona model tiers
source: TADA/723_devoker_per_persona_model_tiers.md
source_repo: jcorbin.tngl.sh/unum
source_commit: f98ff13c198040ce68c4b69b6608235b3e7fad4a
source_date: 2026-07-05
source_authors: [jcorbin]
ingested: 2026-07-10
ingested_by: scholar
topics: [coding-agent-economics]
status: current
---

## Abstract

unum right-sizes the model **per persona**, decided up front in durable config,
not by a runtime difficulty router: chat/control-plane personas (`liaison`,
`foreman`) run on a fast, low-reasoning tier (sonnet), the autonomous
depth-handler (`steward`) runs on the frontier tier (opus), and the
invoker/coding-task path stays on `fable`. This is a concrete instance of the
"cheaper tokens" lever ([[model-routing]]) applied at the granularity of the
agent's *role*, and it is why unum's cost aggregation grew a `--by model` axis
(the tiers split spend across models). The operator's framing (verbatim,
2026-07-02): *"we moved too many things up to opus; chat message (operator
handling) should be fast and does not need max reasoning, move it back to
sonnet; probably also the foreman can use sonnet, just use opus for the steward."*

## The mechanism

The split needed **code**, not a config flip: post a routing refactor, all
persona-routed turns resolved their model through a single `generic_agent` tail
(`resolveChannelModel` → `genericAgentModel` → the `generic` agent profile,
`model: opus`), with **no per-persona override** — the per-channel husk files are
gitignored runtime state, and the soul files are frontmatter-free. So the split
required a durable, git-tracked per-persona seam.

The chosen shape is a `persona_models:` map in the realm's tracked
`evoke/config.yaml`, mirroring the existing per-persona routing table:

```yaml
persona_models:
  liaison: sonnet
  foreman: sonnet
  steward: opus
```

wired into `resolveChannelModel` with the precedence

```
prof.Model  >  ch.Model  >  persona_models[role]  >  genericAgentModel()
```

so the persona tier wins **above** the generic tail but **below** an explicit
channel `agent:`/`model:` override. A role absent from the map falls through to
the generic tail unchanged (no flag-day; non-persona channel turns untouched).
The turn's role is resolved once per call site via a single-source precedence
helper (`forced > routed > wildcard > channel role`) so the resume-guard,
dry-run, and live-launch call sites can never disagree on the model.

**Liveness trade (documented).** The bot binds its config once at startup, so a
`persona_models:` edit cannot be honored per-turn the way the file-reading
generic tail is; classifying it "reload-live" would be silent staleness.
Classified **reload-restart** instead: a committed tier edit trips the automatic
graceful between-turns re-exec — honored without a manual restart, at the cost of
one re-exec per (rare) tier tweak. A truly-per-turn-live alternative (per-role
agent-profile files with `model:` frontmatter) is recorded for revival if
re-exec-per-tweak ever grates. The `generic.md` floor was dropped opus→sonnet so
an unmapped future persona defaults cheap rather than to a surprising opus.

## Relevance to the garden

This is unum's version of the garden's per-role model-tier map
([`skills/model-selection/SKILL.md`](../../../skills/model-selection/SKILL.md):
designer on Fable, builder on the latest Opus, other roles the fleet default).
Both right-size **per role/persona up front** rather than routing by runtime task
difficulty — the coarse, deterministic instance of [[model-routing]]. Two
transferable specifics: (1) keep the tier map in **durable, tracked** config, not
a runtime husk, or an operator edit silently fails to persist; (2) a clear
precedence chain (explicit override > per-role tier > default floor) lets a
one-off task pin a heavier model without disturbing the role's default. unum's
per-role tiers also make its `--by model` cost breakdown meaningful — the same
would hold for a garden cost ledger grouped by model (see [[cost-ledger]]).

Source: [`TADA/723_devoker_per_persona_model_tiers.md`](https://tangled.org/jcorbin.tngl.sh/unum) at commit `f98ff13` (with `devoker/README.md` @ `cb25155`), unum on tangled.org.
