---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-22T06:53:35Z
---
# Retrospective: endojs/endo-but-for-bots #475 review 4998361023 — naming miss (held)

Second-loop retrospective (prosecutor) on erights' review 4998361023, the third
review in his 2026-08-22 burst on #475 pressing the `buffer`-named-`Uint8Array`
naming defect (the `buffer.buffer` expression where one identifier denotes both a
Uint8Array and its backing ArrayBuffer).

Verdict: **miss** (category `naming`), joining cluster
`semantic-name-matches-value-kind` (count 1 → 2). The stylist naming lens and the
2026-08-19 gauntlet's style/docs lens both ran over
`packages/immutable-arraybuffer/src/bytes.js` and did not flag a name that
contradicts its own adjacent type — a standing rule that existed and did not bind.
Not evaluator gaming. Grounded in the world, not the primary report: verified the
first-loop fix `1364f685c` ("refactor(bytes): name Uint8Array values bytes") is a
genuine ancestor of current PR head `affe74453`, so the deliverable exists.

Threshold: **held below dispatch.** After joining, every member of this cluster —
and of the sibling `name-contradicts-value-type` cluster — comes from the single
PR #475. The floor's ≥ 2-distinct-PR guard is unmet; this is the "one messy PR
masquerading as systemic" case (one maintainer pressing one point across an edit
burst), and severity is minor so no major bypass applies. No `review-improve` job
dispatched; no recurrence (writer reported recurrence=0).

Self-improvement: nothing this time.
