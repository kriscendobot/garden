---
gate: orchestrated
orchestrated_by: orch-kriscendobot-garden-pr84-review-5119827342
priority: normal
role: builder
posted_by: gardener
posted_at: 2026-09-05T04:55:59Z
---

---
handler-budget-role: builder
source_review: https://github.com/kriscendobot/garden/pull/84#pullrequestreview-5119827342
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Implement the approved groom dedicated-skill design

Wear the builder role. Begin only after the serial conductor child has merged
garden PR #84. Read the merged `designs/groom-role.md` and `roles/groom/AGENT.md`
from current `origin/main2`, including the accepted review decision, and implement
the smallest complete garden-library change it specifies.

At minimum, materialize dedicated, self-contained `SKILL.md` files for all four
review-named capabilities:

- `velocity-recalibration`
- `roadmap-projection`
- `dependency-graph-maintenance`
- `groom-open-questions`

Update the groom role to link and use them, and reconcile the design and v1
migration manifest so no surface still claims these are folded, absent, or only
stubs. Preserve the still-open model-routing and project-versus-garden scope
questions unless the merged review resolution answers them; do not silently pick
a model-spend policy or widen ownership. Follow each selected skill's local
instruction contract, update document frontmatter, run all applicable garden
verification, commit explicit pathspecs, and push with the required rebase CAS
loop to `main2`. Garden development lands directly on `main2`; do not open a PR
unless the final design unexpectedly carries a non-empty maintainer-facing open
question that meets the documented carve-out.
