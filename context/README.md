# context/ — the garden's operations manual for agents

This tree is the garden's **operator procedure for agents**, read on demand by
the liaison — never auto-loaded. It answers two questions: how do I walk a
brand-new user through their first run (`help`), and how do I operate a running
instance day to day (`help <topic>`). It ships with the code on `main2`, so the
procedure and the scripts it drives version together. If your query is "what
command does X" or "walk the user through Y," it is here or one hop away; if it
is "why is the machinery shaped this way," that is `designs/`, and this tree
routes you there rather than repeating it.

What this tree does **not** hold: per-instance state or history (that is the
journal, `journal2`); architectural rationale (that is `designs/`); imported
material (that is `references/`); and procedures already encoded as skills —
where a skill owns a procedure (restore, schedule, job-board), the page here
**routes to it** and adds only the operator's framing. See
`skills/context-library/SKILL.md` for the authoring discipline this tree obeys,
and `designs/streamlined-onboarding.md` for why it exists.

## Children

- **[first-run/](first-run/README.md)** — the guided first-run tutorial the
  liaison drives when a user says **help** on a not-yet-armed instance: an
  ordered, conversational stage list (welcome → identity → bot credentials →
  starting the garden → first job → where next) plus the interaction norms that
  bind the liaison driving it. Read here to run the tour or to answer a
  first-run question (identity, auth, posting a first job).

- **[operations/](operations/README.md)** — day-2 procedure, picked by symptom
  or intent: starting the garden at command level, leader/follower on multiple
  hosts, scaling the pool, the deliberate deploy, schedules, and health. Read
  here to *do* an operation on a running instance, or to answer `help <topic>`
  for an operator.

## Convention

Cross-references **within** this tree are relative (`first-run/identity.md`,
`../operations/starting.md`). Cross-references to **other** trees — skills,
designs, roles, the top-level READMEs — are repo-root paths
(`skills/restore/SKILL.md`, `designs/multibot-leader-follower.md`). A new
operational topic lands as a new leaf with a row in the nearest directory
README; split a directory only when its README stops routing cleanly.
