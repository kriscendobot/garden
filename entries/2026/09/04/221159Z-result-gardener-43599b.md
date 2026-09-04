---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-04T22:12:12Z
---
---
ts: 2026-09-04T00:00:00Z
kind: result
role: decomplector
repo: endojs/endo-but-for-bots
project: endo
---

Panel result for endojs/endo-but-for-bots PR #665 (design:
`designs/release-automation-major-bump-exports-trigger.md`), diff base
`origin/llm`, head `d5fff2b140`.

### decomplector

**Verdict:** request-changes

**Findings**

1. **should-fix — surface selection is read from a *place* (branch name)
   instead of passed as a *value*.** § The script and its wiring, step 2
   says "The branch shape is the default selector because each workflow
   trigger already knows which surface it is." Those clauses contradict:
   if the trigger knows, it should say so (`--mode changesets|versions`).
   Deriving policy from a mutable name braids surface-selection with
   branch naming, and the failure mode is *silence* — on a release PR
   whose head is not `changeset-release/*`, the script falls back to
   changeset mode, finds no changesets (the Version Packages PR consumed
   them) and reports zero findings, indistinguishable from "nothing
   removable." § Which branch actually cuts releases already concedes the
   prefix is unverified here (`release.yml` triggers on `master` only;
   `.changeset/config.json` sets `baseBranch: master`; this fork develops
   on `llm`). Decomplected: mode is an explicit argument, and a mode with
   no candidate inputs is an error, not a quiet pass.
   [rule: roles/jurors/decomplector/AGENT.md § Operating norms (a),
   configuration-with-behavior]

2. **should-fix — `isBreakingBump` is one name over two argument shapes.**
   Design Decision 4 and the test plan ("across both its input shapes")
   share a *name*; the simple move is to share a *value*. Surface 2 can
   normalize `(oldVersion, newVersion)` to a level (major increased →
   `major`, else minor increased → `minor`) and call a single-arity
   `isBreakingBump(currentVersion, level)`. As written the 0.x rule is
   stated twice in prose — once per surface — which is the drift the
   decision says it prevents.
   [rule: roles/jurors/decomplector/AGENT.md § Operating norms (f),
   minimum viable abstraction]

3. **should-fix — reopening a Complete milestone to hold an unrelated row
   is place-oriented bookkeeping.** `designs/README.md` flips M2 from
   `0 | Complete` to `1`, then spends three prose caveats un-saying it
   ("tracked under this bucket by convenience, not against this stated
   criterion"; "original six rows Complete"; "Opportunistic ... no
   critical-path shift"). The roadmap already carries the primitive for
   this: the **Out of milestone** lane with a rationale column
   (`designs/README.md:561`, `hardener-indexed-cardinality`; and the `—`
   milestone column at :1672-1673). Using it keeps "M2: Complete"
   readable as a value and deletes all three caveats and the 65→66 total
   edit.
   [rule: roles/jurors/decomplector/AGENT.md § Operating norms (d),
   value-oriented vs place-oriented]

4. **comment-only — the annotation line anchor complects data with
   presentation.** Script step 3 keeps the raw `package.json` text beside
   the parsed JSON solely to locate "the first removable key's line," and
   § Surfacing concedes the anchor is inert on surface 1 (that PR touches
   only `.changeset/*.md`). `::notice` without `file=`/`line=`, plus the
   step-summary table, carries the same facts at lower cost.

**Approved as simple:** the removable-on-major predicate is a pure
derivation over the working tree with no disarm state — self-quieting and
idempotent by construction, not by a flag; and `dualExportPairs` shared
with the migration's gate A is the right minimum primitive (one
enumeration, two polarities) rather than two structure walks.

**Out of scope:** `designs/exports-extensionless-migration.md` is not on
`llm` yet (PR #663 in flight), so this design's four relative links to it
and the new `designs/README.md` entry dangle until #663 merges — link
hygiene, not a modeling concern; curator/scribe seat.

Self-improvement: none this engagement. The seat's category walk (a)/(d)/(f)
covered the diff without reaching for a complecting the design does not
claim; the roadmap-table finding suggests a reusable probe — when a design
edits a *shared* index rather than only its own file, check whether the
index already has a lane for the shape being added before mutating a
completed row — but that is a per-review habit, not yet a skill-level rule.
