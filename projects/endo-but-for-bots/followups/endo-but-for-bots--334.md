---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 334
upstream_mirror_repo: endojs/endo
upstream_mirror_pr: 2887
created_at: 2026-05-21T06:54:00Z
last_appended_at: 2026-05-21T06:54:00Z
status: actioned
actioned_at: 2026-06-06T03:54:17Z
merge_event: 2026-05-21T17:42:55Z
actioned_via: jobs/open/20260606T035417Z--391a65--endo-but-for-bots-334-docs-mirror-title.md
---

# Follow-ups for endojs/endo-but-for-bots#334

Created from the docs-streamlined panel verdict (6 seats: stylist, archivist, integrator, packager, pruner, curator; in-band fallback) on the moduleSpecifier→moduleLocation README-rename mirror PR. The PR is a 1-file +9/-9 docs-only correction in `@endo/compartment-mapper/README.md`. One follow-up warrants revisit at merge time.

## Items

- [ ] **Mirror PR titles for docs-only upstream PRs.**
  **Source juror(s)**: integrator.
  **Round**: 1.
  **Recommended action**: when the boatman ferries an upstream PR whose substance is docs-only (no source / test change), prefer `docs(...)` over `fix(...)` in the mirror PR title even when the upstream PR's own title was `fix(...)`. This PR's title (`fix(compartment-mapper): Correct moduleSpecifier/moduleLocation naming mistakes`) reads as a code-shape fix; the substance is a README terminology correction. Not a blocker on this PR; flagged so future mirror-titling discipline can pick it up. Actioning trigger: this PR merges, or its upstream mirror endojs/endo#2887 merges; at that point, the boatman's titling note lands either as a rule in `roles/boatman/AGENT.md` or as a one-line note in `journal/projects/endo/README.md`.
