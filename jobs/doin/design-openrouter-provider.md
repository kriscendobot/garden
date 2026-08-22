---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Directive (kriskowal, 2026-08-22): harness and configure OpenRouter as a new
garden provider so the fleet can reach more models through it — motivated in
part by OpenRouter's rotating free/promotional models (e.g.
`openrouter/stealth/ox-alpha`-style cloaked releases) whose terms are "at
least allegedly fine" but not rigorously vetted. Wants a new category (or
categories) of gardener able to draw on these.

## What to produce

1. `designs/openrouter-provider.md` in the garden's own repo (garden has no
   PR workflow for itself — commit directly to `main2`, no PR; see CLAUDE.md
   § Conventions). Reason through:
   - **Mechanism.** The codex handler already fronts arbitrary
     OpenAI-compatible endpoints — `fireworker` is the precedent
     (`handlers/codex-provider-common.sh` + `handlers/cleric-codex.sh`,
     pointed at a custom base URL). OpenRouter's API is OpenAI-compatible
     (`https://openrouter.ai/api/v1`), so this is very likely the same
     generalization, not a new harness. Confirm/refute against
     `designs/opencode-alternate-harness.md` (already investigated a
     broader multi-provider harness question; read it first so this design
     doesn't re-litigate the kind-vs-dimension tradeoff it already settled
     — one kind per provider, reusing one handler, is the established
     pattern here).
   - **New worker-kind naming**, tier placement, and the wiring shape
     (inventory row(s), routing-default row, `common.sh` worker_kind_field,
     a `set-<kind>s.sh` helper, systemd unit template instance, count key,
     eligibility branch in `claim-job.sh`). Use the exact file list from
     `git show 2c21ea3f2c0359833494f39f4150578a5031de70 --stat` (commit
     "feat: add Fireworks worker kind") as the mechanical checklist — same
     shape, new provider.
   - **The closed-inventory vs. rotating-stealth-model tension — this is
     the crux question, don't wave it through.**
     `skills/model-selection/SKILL.md` is explicit: the inventory is
     closed, every enabled model gets exactly one reviewed row, and
     wildcard/pattern routes are forbidden precisely so an unreviewed model
     can't silently acquire an automatic route. OpenRouter's free "stealth"
     models are cloaked, anonymous, and rotate identity/availability
     without notice — structurally in tension with "reviewed row, stable
     id". Propose a policy rather than assuming one: e.g. stable *named*
     free models (`:free` suffixed ids with a real vendor/model name) get
     ordinary reviewed rows like any other model; cloaked/stealth ids are
     either (a) excluded from the closed inventory until they stabilize
     under a real name, or (b) admitted only through a separate,
     explicitly-labeled promotional lane with a short mandatory
     re-review cadence and a documented rip-cord for when the id vanishes
     or reappears as something else. Say which you recommend and why.
   - **Terms/data-retention as an explicit open question for the
     maintainer, not a settled premise.** OpenRouter's free tier commonly
     defaults to logging/training-use on prompts and completions unless a
     paid or zero-data-retention route is selected, and a "stealth" model's
     provenance/operator is by definition undisclosed. State this plainly
     in the design's Open Questions rather than accepting "allegedly fine"
     as a conclusion — the maintainer decides what's fine, the design
     surfaces the tradeoff.
   - Ship the whole thing **disabled by default** — same posture as
     `fireworker`/`mystic`: pool at zero, explicit-model-only lane, no
     automatic/unpinned job may reach it.

2. If the mechanism does turn out to be pure data + reuse of the existing
   codex custom-provider path (no new handler file needed), go ahead and do
   the actual **disabled-by-default wiring** in this same job — inventory
   rows for one or two stable, named OpenRouter free models to start
   (leave cloaked/stealth ids out per whatever policy the design lands on),
   routing-default row, `common.sh`/`claim-job.sh` plumbing, a
   `set-<kind>s.sh` helper, systemd unit template, and a
   `context/operations/openrouter.md` activation doc written in the same
   bounded-probe shape as `context/operations/kimi-k3.md` (secret-safe key
   handoff via `./garden reset && OPENROUTER_API_KEY=... ./garden create`,
   status-only curl probe, enable exactly one worker, one harmless
   tool-using canary, return to zero unless the maintainer authorizes a
   wider trial). **Do not** supply or request an actual API key, arm any
   worker, or spend anything — key provisioning and the first canary stay a
   separate maintainer-directed step, same as fireworks/kimi-k3.

3. If the wiring turns out to be non-trivial or the stealth-model policy
   question is genuinely unresolved, stop at the design doc and leave the
   wiring as follow-up open questions rather than guessing — same as
   `opencode-alternate-harness.md` did.

## Precedents to read first

- `designs/opencode-alternate-harness.md` — kind-vs-dimension reasoning,
  option C (one kind per provider, one shared handler).
- `context/operations/fireworks.md` and `context/operations/kimi-k3.md` —
  the bounded-probe onboarding/activation playbook.
- `skills/model-selection/SKILL.md` — closed inventory, no wildcard routes,
  per-role tier floors.
- `git show 2c21ea3f2c0359833494f39f4150578a5031de70` — the mechanical
  "add a provider" diff to use as a checklist.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-22T04:04:13Z
