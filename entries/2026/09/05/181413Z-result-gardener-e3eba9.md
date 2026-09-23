---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-05T18:14:16Z
---
# Panel result: novice seat — kriscendobot/minion.town PR #95

Originating dispatch: design-panel round on PR #95
(`design/minion-town-guest-surface-documentation`, diff base `origin/main`,
worktree `scratch/project-wt-kriscen-47ce987fb4d6-f1f8d8a8`). Diff is one added
file: `designs/mcp-guest-surface-documentation.md` (+130).

### novice (top-down clarity, new-reader pass)

**Verdict:** request-changes

**Findings:**

- `designs/mcp-guest-surface-documentation.md:72` — § 2's flow starts at "Two
  authenticated principals each approve the same pending introduction," but
  nothing creates the pending introduction. The section's own premise (line 68,
  and the table row at line 28) is that a fresh guest has *no* way to name
  another guest — so step 1 presupposes exactly the referent whose absence is
  the capability gap. The reader cannot tell what A supplies to request an
  introduction to B. Name the initiating act and the out-of-band handle it
  addresses (account identifier? one-time code?) as step 0. Must-fix: this is
  the document's one new capability. [proposed-rule: a design that closes a
  named capability gap must state the flow's initiating act, not begin at the
  first approval step.]
- `…:70` and `…:79` — "minion.town must provide a host-mediated introduction
  flow" whose home is "the deployment's authenticated account or federation
  layer." Two candidate layers, neither described, no choice made; a new reader
  finishes § 2 unable to say what is being built or where. Should-fix: pick one,
  or name the deciding question. [rule: skills/gricean-maxims/SKILL.md § manner]
- `…:16-21` with `…:127-129` — the child accounting does not reconcile.
  "seven failed children"; "six children never reached the guest surface";
  `minion-town-eval-static-publish` "has no child report at all" — inside the
  six, the seventh, or an eighth? The appendix then introduces five report
  names (odometer, error-probe, guestbook, sandbox, lifecycle) that appear
  nowhere earlier, and the reader cannot map them onto the seven. List the
  seven once where the count is claimed, or drop the count. Should-fix.
  [rule: skills/gricean-maxims/SKILL.md § quantity]
- `…:5-9` — `minion-town-eval-campaign`, `-namestore-durability`, `-mail-pair`
  are the document's entire evidence base and appear as bare code spans: no
  link, no statement of where they live. The two companion designs *are* linked
  (`…:10-12`), so the reader can follow the design's reasoning but not its
  grounding. Should-fix. [proposed-rule: a design's "Grounded against" entries
  must be resolvable — a link, or one line saying where the artifact lives.]
- `…:23-28` vs `…:37-90` — each table row is answered by a specific later
  passage (row 1 → § 1 ¶1, row 2 → § 1 ¶2 + § Error contract, row 3 → § 1 ¶4,
  row 4 → § 2), and the "Design response" cells paraphrase rather than reuse
  the sections' wording ("Return an actual boolean in structured output" vs
  "give `has` an output schema"). The mapping is load-bearing for following the
  design and is never stated. Add a section pointer per row. Should-fix.
  [rule: skills/gricean-maxims/SKILL.md § manner]
- `…:21`, `…:3`, `…:94` — three terms arrive undefined: "one-guest mail" (a
  coinage of this document, not in either linked companion), "capability slice"
  in the status line, and `toToolError`, which appears as "the single conversion
  point" with no file, where `registerGuestTools` was given
  `src/endo/guest-tools.ts` at line 39. Should-fix. [rule:
  skills/gricean-maxims/SKILL.md § manner]

**Notes (out of scope but worth flagging):**

- `…:99` — "(now prevented by the input schema for schema-aware callers)"
  introduces a two-class caller model in a parenthetical. One sentence saying
  `maxLength` is advisory and `assertValidPetName` stays authoritative for
  non-validating clients would close it. Comment-only. [rule:
  skills/gricean-maxims/SKILL.md § manner]
- The pet-name / facet / formula mental model is *not* flagged: it is carried by
  the two companions linked at `…:10-12`, which is legitimate near-context for
  this seat.
- "surface" carries three senses in the document (the MCP guest tool surface,
  a tool's declared contract, the verb "surfaced an error"). Tolerable, but the
  § 1 sentence "aligns the tool boundary with the declared guest-facet contract"
  is where a new reader most likely stalls. Comment-only.

Self-improvement: my first pass wanted to file the pet-name and formula jargon
as must-fix undefined-term findings; checking the two linked companions showed
both models are defined there, which the seat brief explicitly counts as
near-context. The reusable habit: before filing an assumed-background finding,
open the documents the design cites at its head — the difference between "the
reader is lost" and "the reader must click once" is the difference between a
finding and noise.
