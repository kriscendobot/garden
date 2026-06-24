---
ts: 2026-05-13T23:38:47Z
kind: result
role: gardener
project: endo-but-for-bots
to: liaison
refs:
  - entries/2026/05/13/233324Z-dispatch-liaison-9d9774.md
  - entries/2026/05/13/233119Z-message-steward-b4bb7f.md
  - entries/2026/05/13/205700Z-result-gardener-c15374.md
---

# Result: jcorbin recognized as maintainer on endo-but-for-bots

Landed both edits per the dispatch's scope.

## Files written

- `garden/skills/monitor-endo-but-for-bots/SKILL.md` (on `main`): new
  *Recognized maintainers* section names `kriskowal` and `jcorbin`
  as the maintainer set, explicitly contrasting maintainer authority
  (repo-wide, every topic) with senior-contributor authority
  (topic-scoped) so the existing erights *Senior contributors*
  subsection remains coherent. The `PullRequestReviewEvent` and
  `IssueCommentEvent` rule rows now resolve "recognized maintainer"
  as either login rather than `kriskowal` alone; the routing
  semantics (`CHANGES_REQUESTED` → fixer; `APPROVED` → clear;
  `COMMENTED` → fixer-with-authorization; authorization-grant
  shapes → *Pre-staged authorizations*) are unchanged. New
  *Notes from the field* row dated 2026-05-13 records the change,
  cites the kriskowal directive, and documents the deliberate
  decision not to touch `skills/monitor-endo/SKILL.md`.

- `journal/projects/endo-but-for-bots/README.md` § Authority
  structure: restructured into three subsections: *Maintainers*
  (kriskowal + jcorbin, with the explanatory paragraph that
  maintainer authority is repo-wide and topic-agnostic),
  *Senior contributors* (erights, unchanged in substance), and
  *Practical rule* (one paragraph summarizing how the garden
  reads each kind of signal). The maintainer-vs-senior-contributor
  distinction is now load-bearing in two places (this README and
  the monitor skill), in matching prose.

## Commit SHAs

- `main` (garden branch): `8820e0a` — skill edit.
- `journal`: `c3bb666` — project README edit. This entry adds a
  second journal commit on top.

## Routing confirmation

The next `jcorbin`-authored event on `endojs/endo-but-for-bots`
routes per the kriskowal-equivalent rules:

- `PullRequestReviewEvent` with `CHANGES_REQUESTED` → fixer
  dispatch (per `roles/COMMON.md` § fixer).
- `PullRequestReviewEvent` with `APPROVED` → bulletin row cleared.
- `PullRequestReviewEvent` with `COMMENTED` + non-trivial body →
  fixer with the per-action authorization the maintainer
  pre-stages (otherwise journal-only).
- `IssueCommentEvent` on an open PR with an authorization-grant
  shape (identity switches, write-access grants, no-PR-upstream
  constraints, `/<command>` directives) → bulletin's
  *Pre-staged authorizations* section.

A `jcorbin` review or comment without one of these shapes is
journal-only, matching the existing kriskowal default.

## Out of scope (confirmed not touched)

- `garden/skills/monitor-endo/SKILL.md`: unchanged. The
  maintainer's directive named `endo-but-for-bots` specifically.
  Surveyed the journal (`grep jcorbin` across journal entries
  and README; matches surfaced only PR authorship on
  endo-but-for-bots #119 and #94, no maintainer-authority
  signal on endo). Default per-repo recognition applies; no
  message to liaison generated since there is no evidence to
  surface.
- Role files not modified (per dispatch).
- No retroactive re-processing of swallowed `jcorbin` events
  (per dispatch).

## Self-improvement

The authority structure section now carries two named
non-default-authority actors in two distinct kinds (maintainer,
senior contributor). The pattern of subdividing the section into
*Maintainers* / *Senior contributors* / *Practical rule* is
cheap to replicate if another project's README acquires a
similar shape. Not landing a new top-level skill yet: the shape
is two examples in one README, and the cross-project framing
in `roles/COMMON.md` § *Authority structure of upstream
projects* already captures the pattern at the abstraction layer
where it belongs.

A secondary observation: the *Senior contributors* subsection's
opening sentence in the monitor skill refers to "kriskowal's"
authority as the comparison baseline. With two maintainers
now recognized, "the maintainers'" is the more accurate phrase.
The journal README edit pivoted to "maintainer-equivalent" /
"maintainers' authority" already; the monitor skill's
*Senior contributors* subsection still reads
"meets or exceeds kriskowal's" via the project-README citation,
which is acceptable because the deferred prose lives in the
README (now fixed) rather than the skill. Not landing a follow-up
edit; the skill defers to the README and the README is current.

Self-improvement: nothing for role files this cycle.
