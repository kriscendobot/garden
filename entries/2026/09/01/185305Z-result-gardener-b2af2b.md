---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-01T18:53:06Z
---
---
kind: result
role: jurors/decomplector
repo: kriscendobot/minion.town
project: minion-town
---

Design-panel seat `decomplector`, PR kriscendobot/minion.town#77 (`docs(designs): reconcile proposed MCP tool names`), head `d0aaa6b`, base `origin/main`. Docs-only: three design documents reconciled to the interface-native tool-name convention.

### decomplector

**Verdict:** request-changes

**Findings:**

- `README.md` § *MCP tool name compatibility* is a **migration record** (an old→new table for one completed breaking rename), and this PR promotes it into the **standing forward naming policy** that three designs now cite normatively (`designs/claude-agents-capability.md:391`, `designs/git-remote-capability.md:983`, `designs/remote-guest-endo-cli.md:206`). Policy is braided with the historical artifact: the next rename churns the table and the cited rule moves with it, and a citing design cannot say whether it invokes the rule or the table. Decomplect — state the rule (mirror the facet method; strip transport/category prefixes; facet-qualify only on collision) as its own normative anchor the designs cite, and leave the table as history nothing points at. [proposed-rule: a normative convention must live in its own anchor, separate from the migration table that occasioned it, so citing documents bind to the rule and not to a changelog.]

- `designs/git-remote-capability.md:683,986` propose "an asynchronous-handle `request` tool" returning a handle the client polls, on the ground that the backing request may pend. `GuestAgent.request(to, description, responseName?)` (`src/endo/guest-control.ts:91`) already carries the decomplected shape: the response settles into the guest's own directory under `responseName`, and `has` / `readText` / `listMessages` are already mounted. The pending request also already has an identity — its `messageNumber`. The proposed handle is therefore a **new mutable place** standing in for an existing immutable binding, and a second identity for a thing that has one. Ask the design to say why `responseName` plus the existing tools does not suffice before it reaches for a new primitive. [proposed-rule: a design proposing a new handle/identity primitive must first state why an existing name-to-value binding on the same interface cannot carry the same fact.]

- `designs/remote-guest-endo-cli.md:216` justifies `cancelInvite` as avoiding "a future flat-namespace collision with the reminder design's proposed `cancel` operation" — but `designs/endo-reminder-minion-town.md:57` proposes `reminder_cancel`, a category-prefixed name this very convention retires. So either that fourth unimplemented design is also due reconciliation and was left out of this pass, or the collision is hypothetical and `cancelInvite` is unearned. Beyond the inconsistency: a name in one design is now a function of another design's **unbuilt** vocabulary. `listSites` disambiguated a real, shipped collision; this is the first name whose shape depends on a document that may never land. Pick one — reconcile `endo-reminder-minion-town.md` in the same pass and keep `cancelInvite`, or drop the forward-looking rationale and name it `cancel` until a collision exists. [rule: skills/rename-discipline/SKILL.md]

**Notes (out of scope but worth flagging):**

- Sibling asymmetry inside one facet: `invite` bare, `cancelInvite` qualified (`designs/remote-guest-endo-cli.md:206,216`). A collision-at-write-time rule makes each name's shape a fact about the whole namespace at a moment rather than about the facet, so readers cannot infer provenance from a name and the namespace's shape carries no information. Familiar per-name, accidental complexity per-namespace — the easy-not-simple signature. Taste call within the chosen convention; not blocking. [rule: skills/rename-discipline/SKILL.md]

- `src/endo/guest-control.ts:87` refers to "the async-handle note in guest-tools.ts"; no such note exists in that file. Implementation-side dangling reference, pre-existing and untouched here — the code panel's surface, not this design PR's. [proposed-rule: a cross-file "see the note in X" reference must name a section or symbol that exists in X.]

Self-improvement: the decomplector brief tells the seat to stop at the boundary of what the design claims, but says nothing about the case where a design's claim is *about another document* (here, the reminder design's proposed vocabulary). Walking to that second document is what turned a taste call into a concrete finding. Proposal for `roles/jurors/decomplector/AGENT.md` § Operating norms: when a design justifies a modeling or naming decision by citing another document's content, read that document — a cross-document justification is in scope precisely because the coupling it creates is the complecting.
