Downgrade all MECHANICAL gardener work to the cheapest adequate model tier.

Maintainer directive (2026-07-25): to cut Anthropic/Opus spend (live Claude quota
crunch today), route mechanical / low-judgment work in the gardener scripts to a
cheap tier — a local Ollama model, Sonnet, or Haiku — instead of the fleet default.
Judgment-heavy roles stay on their current high tiers: designer and builder remain
on the latest Opus per skills/model-selection/SKILL.md; jurors and fixer keep their
current tiers unless clearly mechanical.

Scope of change (garden repo, main2 — pushed directly, NO PR per CLAUDE.md):
  - Update the canonical tier map in skills/model-selection/SKILL.md and the
    resolver it feeds (role_default_model / resolve_model_tier in
    scripts/jobs/common.sh) so mechanical roles resolve to ollama / haiku / sonnet.
  - Classify roles/steps as mechanical vs judgment and downgrade ONLY the mechanical
    set. Candidates for mechanical: cleaner, weaver/rebase mechanics, retcon,
    yarn-lock chores, conductor/merge mechanics, journalist, pages-shepherd. Prefer
    local Ollama (hermit) for purely deterministic text-shuffling; Haiku/Sonnet where
    light reasoning is needed.
  - Preserve the worker-kind abstraction (gardener/Anthropic, cleric/OpenAI,
    hermit/local Ollama, mystic/Moonshot) — this is tier selection, not removing kinds.

Deliverable: model-selection skill + resolver updated and pushed to origin/main2,
with a one-paragraph note in the job report listing which roles moved to which tier.
This change reaches running hosts only via a subsequent garden deploy/upgrade.

<!-- garden-reaped: 3 -->
