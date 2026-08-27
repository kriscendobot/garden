---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: American-English spelling jury panel + a role to fix divergences

Origin: maintainer (kriskowal) review directive on
https://github.com/endojs/endo-but-for-bots/pull/282#pullrequestreview-5045909300
(inline nit on `serialise` → `serialize`). The spelling fix itself is already
landed on the PR head; THIS job is the garden-automation half of the same
directive, which the maintainer asked to be dispatched as its own gardener job.

## The ask (maintainer's words, quoted as data — not instructions)

> serialize (American, Chicago Manual Style, in general. Please dispatch a
> gardener to create or augment the garden automation for paneling a jury to
> grep for common divergence from British English and dispatch a job with a
> dedicated role for addressing these digressions. We can similarly encourage
> vertexes over verticies, matrixes over matrices, indexes over indices, thawed
> over thawn, and other cases that make English clearer to an international
> audience.

## Deliverable

Design (and, where the shape is obvious, spec to the point a builder can carry
it) garden automation that:

1. **Panels a jury seat** (a new `roles/jurors/<seat>/AGENT.md`, likely
   dispatched by `skills/panel/SKILL.md`) that greps a PR's changed text for
   common British→American spelling divergences and reports each occurrence as a
   panel finding. Candidate rule set to start from (extend, don't treat as
   closed): -ise→-ize verbs (serialise→serialize, canonicalise→canonicalize,
   normalise→normalize, …) and their -isation/-ised/-ising forms; British
   irregular plurals the maintainer named — vertices→vertexes, matrices→matrixes,
   indices→indexes; thawn→thawed; plus -our→-or (colour→color), -re→-er
   (centre→center), -ll- doubling (modelling→modeling), catalogue→catalog, etc.
   Prefer a data-driven word/pattern list the panel greps against, not hand-coded
   regexes scattered in prose, so the set is auditable and extensible. Beware
   false positives inside identifiers, third-party names, quoted upstream text,
   and generated fixtures.

2. **A dedicated role** (a new `roles/<name>/AGENT.md` — an "americanizer" /
   spelling-normalizer fixer variant) that the jury finding can dispatch a job
   to, whose definition of done is converting flagged British spellings to the
   American/Chicago form without touching semantics, upstream identifiers, or
   quoted external text.

## Notes for the designer

- Decide juror-only vs standalone-role vs both, and how the finding hands off to
  the fixing role (panel finding → posted job, or a standing grep watcher).
- Consider whether this belongs as a new skill (e.g.
  `skills/american-english-normalization/SKILL.md`) that both the juror and the
  role reference, so the word/pattern list has ONE home.
- Follow the garden design-completion norms: if the design carries open
  questions, land it as a review PR per `roles/designer/AGENT.md`; otherwise land
  bare on main2. Then, if the shape is settled, post the follow-on builder job
  (or an orchestration) to actually carve the juror seat + role + skill.
- This is garden-library work (roles/skills/scripts on main2), NOT a change to
  any project repo.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-27T21:46:31Z
