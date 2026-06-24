---
ts: 2026-05-13T22:13:29Z
kind: result
role: gardener
refs:
  - entries/2026/05/13/220933Z-dispatch-liaison-e0e7a3.md
---

Ported `references/endo-but-for-bots/roles/investigator.md` to `garden/roles/investigator/AGENT.md`. The new role is hypothesis-driven: it covers both the reference's static-sweep flavor (TODO density, AST visitor coverage, doc drift, branch hygiene) and the steward dispatch's behavioral-mystery flavor (CI failure with no obvious root cause, runtime regression, SES / hardened-JS / Endo daemon questions). Posture is read-only; concrete fixes hand off to a later builder or fixer dispatch.

Files written:

- `garden/roles/investigator/AGENT.md` (new, 56 lines).
- `garden/CLAUDE.md` § Current inventory: `investigator` appended to the roles list.
- `garden/roles/steward/AGENT.md` § Subordinate roles dispatched: investigator bullet placed alphabetically between groom and weaver, carrying the trigger language the dispatch specified.

Cited-skill picks:

- **Reused** (already in the active library): `rebase-hygiene-audit`, `prompt-section-discovery`, `em-dash-style`, `relative-paths`, `self-improvement`. Also cited `journalism` and `context-library` per the dispatch's "common-case investigations produce journal-side artifacts" hint; the role's deliverable defaults to a journal `result` entry, with a topic file under `journal/projects/<slug>/` for large audits.
- **Skipped** (too project-specific for a clean port): `todo-link-classification` and `babel-visitor-exhaustiveness`. Both are tightly bound to Endo (Babel AST internals, `@ts-expect-error XXX` reclassification, package-specific TODO counts) and belong as Endo-project-specific topic files in `journal/projects/endo/` if the maintainer wants them preserved; they do not generalize to the garden's project-agnostic skill layer. The role's *Operating norms* fold in the spirit (sample-validated, hypothesis-driven, search third-party source when an error names a property absent from the repo) without porting the bodies.

Commits on `main`:

- `01e5e61` role: investigator — port from references/endo-but-for-bots/ (hypothesis-driven investigation)
- `ce33e47` inventory + steward subordinate-roles: enumerate investigator

Pushed cleanly to `origin/main` on the first attempt (parent `0d46b8c`). No journal-side commit for this entry other than the `result` itself.

Self-improvement: a recurring pattern in today's ports is that the reference's deeply project-specific skill bodies (the TODO classifier, the Babel sentinel) do not survive translation cleanly; their content belongs in `journal/projects/<slug>/` as project-specific topic files, not in the garden's `skills/` layer. The current port-checklist phrasing ("port only what's missing") implicitly nudges toward porting, but the project-specific shape resists it. A future grooming pass on the gardener's role file (or the port checklist itself) could state explicitly: "if a reference skill's body is dominated by one project's idioms, leave it in `references/` and cite it from the project's journal tree instead of porting it." Logging this here as a candidate for the next gardener-on-gardener pass; below the threshold for a `message` to liaison this turn.
