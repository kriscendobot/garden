---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 648
panel_kind: design
base_ref: 7870da1d916e1c4143f69e5caf2016e5bc1dad37
rounds: 1
disposition: must-fix
exit_code: 0
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: e8f3d3ccc2d5
recorded_by: endolin-garden-ece02cb4
---

# Panel run — endojs/endo-but-for-bots #648 (design)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `e6b82284`

seat verdicts (9): copyeditor=must-fix critic=must-fix decomplector=must-fix ergonomist=must-fix novice=comment orthographer=pass pedant=must-fix skeptic=comment thesaurus=pass
must-fix items (20):
- copyeditor: **Mermaid diagram renders HTML entities as literal text** (mount-extensions-reconstruction.md, ~line 75)
- copyeditor: The graph node shows `llm[llm-&lt;sha&gt; frozen base]` but should show `llm[llm-<sha> frozen base]`
- copyeditor: Mermaid will display the encoded entities as text: `&lt;sha&gt;` instead of `<sha>`
- copyeditor: Fix: replace `&lt;` with `<` and `&gt;` with `>` in the mermaid code block
- copyeditor: **Compound sentence in daemon-mount.md is structurally sound but very long** (daemon-mount.md, lines 32-35)
- copyeditor: The update paragraph's lead sentence runs 70+ words with three coordinated clauses: "Additional mount extensions... w...
- copyeditor: Parses correctly with appropriate semicolon use, but the density makes the status update harder to follow
- copyeditor: Consider breaking after the link: separate the future action ("and #127 closes when the replacements are open") into ...
- copyeditor: **Prose throughout the new design document is well-structured** (mount-extensions-reconstruction.md)
- copyeditor: Clear section progression (summary → what changed → four PRs → test strategy → disposition → orchestration ...
- copyeditor: Voice consistent (present tense for design, past/future as appropriate for status tracking)
- copyeditor: Jargon introduced before use (`defaultDeniedSegments`, `conformance allowlist`, `revocation`, `mount fixtures`)
- copyeditor: Transitions between sections work: "What changed on `llm` since #127 was cut" follows "Summary" logically; "The four ...
- critic: **Deny-pattern security invariant has an unaddressed symlink-alias bypass.** PR A's deny check (`assertValidSegment` ...
- critic: **`grep()` accepts an unbounded regex from the mount's caller with no complexity guard.** PR C evaluates `pattern` as...
- critic: PR D's stacking after PR C is justified only by shared-file conflict avoidance, not a semantic dependency (the design...
- decomplector: Ownership-map gap across the persistence/lifecycle boundary: the design assigns `deniedSegments` to durable state (a ...
- decomplector: The place-oriented `ctx.revocation` sharing (mutating one boolean observed by all derived faces via structural `...ct...
- ergonomist: The glob spec's default behavior — silent truncation at `GLOB_MAX_RESULTS` (§ PR B — glob, and again in the Open...
- ergonomist: `maybeReadJson`'s failure envelope is narrower than the "maybe*" family it claims to mirror. `mount.js`'s existing `m...
