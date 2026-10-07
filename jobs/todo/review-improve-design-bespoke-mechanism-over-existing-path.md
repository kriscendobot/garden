---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# review-improve-design-bespoke-mechanism-over-existing-path

role: builder

Improvement job dispatched by the prosecutor (skills/review-retrospective/SKILL.md § 5)
for review-miss cluster `design-bespoke-mechanism-over-existing-path`
(journal2 `review-misses/clusters/design-bespoke-mechanism-over-existing-path.md`;
count=3, PRs endojs/endo-but-for-bots#1226 and #1407).

Pattern: a design or build invents a bespoke per-entity channel/mechanism (a
per-guest Unix socket, a derive-prune-pin catalog) where the repository's
existing connection path already provides the access (root bootstrap +
`lookupById`, a static Lal-style declaration), and successive panel rounds
patch that mechanism's recurring must-fix findings instead of asking whether
it is needed at all.

Member misses (read each in journal2 `review-misses/misses/`):
1. `endojs-endo-but-for-bots-pr1226-review-2fc247cc` — design #1226, six
   design-panel rounds hardened a per-guest socket endpoint; maintainer
   simplified to bootstrap-host lookup.
2. `endojs-endo-but-for-bots-pr1226-review-179ff5ab` — design #1226, catalog
   derivation mechanism built over an already-cited static tool set.
3. `endojs-endo-but-for-bots-pr1407-review-1d8c37a5` — BUILD #1407 re-introduced
   the per-guest socket the maintainer had already rejected on #1226 for the
   same design doc; six CODE-panel rounds (2026-10-01..03) patched its
   lifecycle (revocation, GC gating, cancellation, races, host fallback). The
   decomplector, whose category (f) "minimum viable abstraction" covers the
   question, is seated only on the design panel and never saw it.
Related held cluster (same root shape, code-side): `vestigial-mechanism-unquestioned`
(#1125, 2 members). Fold its members into your re-litigation test where the
same check would catch them; do not change that cluster's status.

Two-part contract — BOTH are mandatory; a completion that delivers only one is incomplete.

(a) Prevention. Edit the narrowest artifacts governing the producing work:
- `roles/builder/AGENT.md` (and `roles/designer/AGENT.md` if not already
  covered): before adding a new channel/endpoint/formula type/per-entity
  resource, name the existing path that already provides the access and say
  why it does not suffice; if the work would reverse or re-open a decision a
  maintainer made on an earlier PR for the same design doc, stop and ask
  (message-user) rather than build.
- The follow-up-to-build path that produced #1407 (a review job reading
  "build" as "build every bot-authored follow-up item"): add a guard where it
  lives (the job that reads approvals/"conduct and build") that a bot-authored
  follow-up which re-opens a design open question is parked for maintainer
  confirmation, not built on autopilot.

(b) Sensing (prefer deterministic):
- Seat the decomplector's category-(f) lens on the CODE panel when a probe
  fires. Add a `skills/panel-hints/probes/` probe (same commit as the seat
  change, per panel-hints "Adding a probe") that fires `decomplector` on a code
  PR whose diff (i) touches `designs/*.md`, or (ii) adds a new socket/listener/
  endpoint/`servePrivatePath`-style serve call or a new daemon formula `type`.
  Err toward firing.
- Amend `roles/jurors/decomplector/AGENT.md` with an explicit code-panel mode:
  "does an existing repository path already provide this access/boundary?" and
  "has a maintainer already rejected this mechanism on an earlier PR touching
  the same design doc?" (check the design doc's history / linked PR reviews).
- Panel-stage repeat-finding signal: when the fix-loop's panel round N>=3
  raises must-fix findings on the same new mechanism/files it raised in
  rounds N-1/N-2, the panel aggregate (scripts/jobs/gardening/panel.sh or the
  decider) should force a decomplector "is this mechanism needed?" question
  into the next round rather than another patch round. Mechanize if feasible.

Verification — the re-litigation test: for each member miss above (and the
vestigial-mechanism members you fold in), name the exact check that would now
catch it and demonstrate the probe fires on the historical diff (#1226 head
e5c63291 / 4e1696a4; #1407 head a62e91aca or aa79a93cce). Add tests for any
script change. Then close the cluster:

  scripts/jobs/review-miss-record.sh cluster-status design-bespoke-mechanism-over-existing-path closed --improved-by "<commits/files>"

Garden repo work: land on main2 directly per CLAUDE.md conventions.
