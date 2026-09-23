---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr124-review-6332cda5
verdict: not-a-miss
category: new-direction
pr: 124
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/124#pullrequestreview-4659623974
identity: endojs/endo-but-for-bots#124:review:4659623974:retro
producing_role: none-garden-did-not-panel-review
severity: minor
grounds: >
  kriskowal's CHANGES_REQUESTED review on the XS-sqlite `slot-machine` PR carried
  one spine directive plus fourteen inline items (all paraphrased). The spine:
  PAUSE this work until the underlying XS sqlite bindings are ready, move the PR
  to draft, and add a rebase trigger for when the bindings land. The inline items
  cluster into four buckets: (a) four forward DESIGN suggestions for the sqlite
  binding once it can proceed — lazy stmt.iterate() streaming, the
  non-generalised JSON1/FTS5/R-tree/UDF/backup/ATTACH/collation surface, a
  pragma({simple:true}) form, and WAL checkpointing at shutdown; (b) two NEW
  garden-meta STYLE rules the comment itself creates — avoid hard-to-type code
  points, and prefer `new URL` over a `path` import; (c) minor code nits — a
  workflow rename to `rust` with trigger alignment, base64 decode/encode
  type-specificity, and an EXCLUDED_PACKAGES filter investigation; (d) one item
  acknowledged closed (connection pooling). This retro judges whether the garden
  REVIEW PROCESS should have anticipated any of this, and concludes it could not
  have. Dispositive fact from the PR's actual history: NO gauntlet, panel, build,
  fix, or clean job for #124 exists anywhere on the board (grep of journal/jobs
  finds only the review-6332cda5 routing job and this retro) — the sqlite work
  was never at the un-draft/merge stage where the gauntlet runs, so its absence
  of a panel is intentional pre-gauntlet WIP, not a `process` miss. The spine
  directive (pause pending an EXTERNAL upstream dependency's readiness) is
  unanticipatable by definition: no seat brief, skill, or standing instruction
  encodes "do not build sqlite bindings before XS bindings land," and only the
  maintainer knows the upstream schedule. The four design suggestions are
  first-stated forward direction whose own framing signals recency, and the
  primary loop correctly PARKED each as a go-ahead plan rather than treating them
  as defects. The two style rules are being CREATED by this very comment — a
  review-cycle check cannot flag a violation of a convention that did not yet
  exist; the primary loop routed both as garden-meta jobs to author the rule +
  jury + auto-fix, which is precisely how a brand-new convention enters the
  panel's knowledge (a check FOLLOWS the rule, it cannot precede it). The code
  nits are trivial taste-level polish on work the maintainer explicitly wants
  paused, and no seat demonstrably knew and failed to bind them. This is
  maintainer-first strategic direction plus a live design/style discussion on
  paused WIP — new direction, not a garden review-process miss. Recorded as a
  durable dismissal so the same comment is never re-litigated. No cluster minted;
  no improvement dispatched.
---

# Dismissal: endo-but-for-bots #124 review 4659623974 (retro)

kriskowal's CHANGES_REQUESTED review on the XS-sqlite `slot-machine` PR asked to
PAUSE the work until the upstream XS sqlite bindings are ready (move to draft,
add a rebase trigger), and layered on four forward design suggestions for the
binding, two brand-new garden style rules (avoid hard-to-type code points; prefer
`new URL` over `path`), and a handful of minor code nits. Not a garden
review-process miss: no gauntlet/panel/build job for #124 exists on the board —
the work was intentional pre-gauntlet WIP, never at the merge stage where a panel
runs — so there is no review surface that knew a convention and failed to bind.
The pause directive depends on the maintainer's knowledge of an external
dependency's schedule (unanticipatable); the design items are first-stated
forward direction the primary loop correctly parked; and the two style rules are
being created BY this comment (a check can only follow a new convention, not
precede it) — the primary loop routed both as garden-meta rule-authoring jobs.
Strategic direction plus a design/style discussion on paused WIP — new direction,
not a miss. See comment_url for the verbatim review.
