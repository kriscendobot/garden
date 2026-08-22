---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-22T08:37:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Child 2 of 3 in the `openrouter-zdr-and-stealth-orchestration` orchestration.
Runs after `openrouter-zdr-data-policy` lands (depends on its deny-collection
enforcement existing in the handler — inherit it unconditionally, do not
re-derive it). Splits out Decision 2 from the doomed monolithic job
`openrouter-zdr-policy-and-stealth-lane` (deadline-overrun after 40 min
handler wall-clock; that record is superseded by this decomposition, do not
resurrect it). Builds on `design-openrouter-provider`
(`designs/openrouter-provider.md`, commit `9790c4f4db`).

## The maintainer's decision (answers Open question 2)

The maintainer wants to use OpenRouter's rotating cloaked "stealth" models
(e.g. `openrouter/stealth/ox-alpha`-shaped ids) *while cloaked*, accepting
the design's stated risk (undisclosed provenance, no reviewed stable id).
Build the design's already-sketched policy (b):

- A second kind, `openrouter-promo` (or a better name if one occurs to
  you — say why if you rename it), same handler/provider, same
  explicit-model-only fencing as `openrouter`, but with its OWN registry
  namespace so its arms never pool with the stable named lane's
  (`opencode-alternate-harness.md`'s option-C reasoning applies again here:
  a distinct kind keeps distinct risk profiles distinctly scored).
- A **short mandatory re-review cadence** for whatever cloaked ids are
  enabled (the design flagged this as required but undesigned) — pick a
  concrete cadence (daily is a reasonable default for something that can
  vanish or silently become a different model at any time) and a mechanism
  to enforce it: a scheduled check (skill: [schedule]) that re-probes each
  enabled stealth id's `/models` listing and a live tool-using canary, and
  **automatically disables** (not just warns about) an id that 404s or that
  the maintainer has not re-attested within the cadence window.
- A documented **rip-cord**: how to immediately zero the pool and drop a
  specific stealth id's row (`set-openrouter-promos.sh 0` plus removing its
  inventory row) — mirror the shape of `set-openrouters.sh`.
- This lane inherits the deny-logging/deny-training constraint from
  `openrouter-zdr-data-policy` unconditionally — "we accept not knowing
  which model this is" is a different risk than "we accept our prompts being
  logged", and the maintainer has only authorized the former.

## Out of scope for this job

The reputation-arm-migration tooling that lets a stealth arm's history carry
forward once unmasked — that's the third child,
`openrouter-reputation-unmask-migration`, which depends on this kind
existing (it needs a real `openrouter-promo` arm shape to migrate from). Also
out of scope: actually supplying `OPENROUTER_API_KEY` or enabling any
worker — both pools stay at zero. Container recreation with the key is a
separate, host-side, maintainer-run step the liaison is handling directly.

## Precedents to read first

- `designs/openrouter-provider.md`, `context/operations/openrouter.md`, and
  whatever `openrouter-zdr-data-policy` landed (read its commit/report
  before starting so you inherit its enforcement mechanism correctly rather
  than re-deriving it).
- `jobs/plan/openrouter-zdr-policy-and-stealth-lane.md` (the doomed original,
  for full context on all three decisions — but only Decision 2 is this
  job's scope).
