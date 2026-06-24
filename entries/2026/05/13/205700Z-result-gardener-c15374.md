---
ts: 2026-05-13T20:57:00Z
kind: result
role: gardener
project: endo
to: liaison
refs:
  - entries/2026/05/13/205242Z-dispatch-liaison-c6ce66.md
  - entries/2026/05/13/062434Z-result-steward-0a91d5.md
---

# Result: erights authority structure on endo + endo-but-for-bots

Landed three edits per the dispatch's scope.

## Files written

- `journal/projects/endo/README.md`: new `## Authority structure`
  section. Names erights as a senior contributor whose authority meets
  or exceeds kriskowal's on `pass-style`, `ses`, `hardened-JS`,
  `marshal`, `eventual-send`, `captp`, `patterns`, the OCapN-family
  protocol, and capability-security generally. Practical rule: on a
  topic-matching PR his review is read as technically authoritative;
  outside those topics, his input is senior-contributor input the
  maintainer adjudicates. One-line footer notes the pattern is
  reusable and points at `roles/COMMON.md`.

- `journal/projects/endo-but-for-bots/README.md`: parallel
  `## Authority structure` section. Cross-references endo's section
  for the prototype framing rather than duplicating the topic list in
  full; adds a project-specific note that garden-internal
  infrastructure (CI, bulletin machinery, the `garden` sibling branch)
  is among the out-of-scope surfaces.

- `garden/skills/monitor-endo/SKILL.md`: new
  *Senior contributors (erights et al.)* subsection under
  *Reactions per event class*. A `PullRequestReviewEvent`,
  `PullRequestReviewCommentEvent`, or `IssueCommentEvent` from erights
  on a topic-matching PR is `surface-bulletin` plus `escalate-message`
  to liaison. No auto-dispatch of fixer. Cites the project README for
  the canonical topic list; documents the topic-match heuristic.

- `garden/skills/monitor-endo-but-for-bots/SKILL.md`: parallel
  subsection with the same rule (loud + message to liaison on
  topic-match). Documents the same heuristic. Cites the precipitating
  silent-swallow record (steward cycle 10, 062434Z) and notes that
  prior swallowed events are not re-processed per the dispatch.

- `garden/roles/COMMON.md`: new
  `## Authority structure of upstream projects` section between
  *External-repo etiquette* and *Project context*. Two paragraphs.
  States that per-project READMEs may name non-default-authority
  actors and topic-scopes, that per-project monitor skills consult
  that data, and that the canonical place for an actor's authority is
  the project README. Cites the endo README as the prototype.

## Commit SHAs

- `main` (garden branch):
  - `e7a6731` — monitor-endo + monitor-endo-but-for-bots
    senior-contributor surfacing rule.
  - `a166590` — COMMON.md authority structure section.
- `journal`:
  - `a7f71da` — endo + endo-but-for-bots README authority structure.
  - this entry (filename
    `entries/2026/05/13/205700Z-result-gardener-c15374.md`).

## Topic-match heuristic

**Keyword-first with file-path fallback.**

1. Keyword check on title/labels for any of `pass-style`, `ses`,
   `hardened`, `harden`, `marshal`, `pattern`, `eventual-send`,
   `captp`, `ocapn`, `capability` (case-insensitive substring). Cheap;
   often works from the daemon-line payload alone.
2. If inconclusive, `gh pr view <N> --json files` and check paths
   against `packages/{pass-style,ses,marshal,patterns,eventual-send,captp,hex}/`.

Justification: most topic-matching PRs declare themselves in the title
(typical `endojs/endo` convention is `feat(ses): ...`,
`fix(marshal): ...`, etc.), so the keyword step is the common-case
fast path; the file-path step catches PRs with generic titles whose
diff touches a topic package. Either match is sufficient. The
heuristic is documented inline in both skills with a *Notes from the
field* hook for capturing fixes if a real event reveals a false
positive or negative.

## Out of scope (confirmed not touched)

- No authority section added to `agoric-sdk`, `cosgov`, `garden`, or
  `ocapn` project READMEs.
- Journalist's role file not modified.
- Groom port not touched (concurrent gardener dispatch handles it).
- `roles/monitor/AGENT.md` not modified; the per-project skills carry
  the surfacing rule per the dispatch's preference.
- Prior swallowed erights events are not retroactively re-processed.

## Self-improvement

The authority-structure pattern factors out cleanly: the project
README is the data, the per-project monitor skill is the policy, and
COMMON.md names the pattern. The shape is one example so it lives in
the project README as a concrete instance with a one-line "reusable"
footer rather than as a new top-level skill; if another upstream
project lands a named senior contributor in the next few weeks, the
recurrence justifies a `skills/authority-structure/SKILL.md` that
formalizes the section template and the heuristic. Until then,
duplicating the prose between the two endo-family READMEs is cheaper
than abstracting.

A second observation: the silent-swallow record in cycle 10's result
entry is exactly the kind of dropped signal the gardener exists to
catch. The lesson is not about the authority structure specifically;
it is about per-project monitor skills having a "review event from
non-default-authority contributors" row that defaults to silent. This
gardener landed the specific fix (erights on endo); a future gardener
dispatch that touches another per-project monitor skill should ask
whether the same row exists and whether the project has its own named
senior contributors. Not routed as a separate message this cycle; the
pattern is one observation away from being a generalization.

Self-improvement: nothing for the role file directly this cycle; the
authority-structure pattern is now documented across project READMEs,
per-project monitor skills, and `roles/COMMON.md`.
