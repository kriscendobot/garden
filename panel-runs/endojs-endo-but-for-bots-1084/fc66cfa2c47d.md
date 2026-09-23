---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1084
panel_kind: design
base_ref: origin/llm
rounds: 1
disposition: must-fix
must_fix_total: 16
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: fc66cfa2c47d
recorded_by: endolin-garden-ece02cb4
---

# Panel run — endojs/endo-but-for-bots #1084 (design)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `8bb43e4a`

seat verdicts (7): copyeditor=comment critic=comment decomplector=must-fix ergonomist=must-fix novice=comment pedant=must-fix skeptic=must-fix
must-fix items (16):
- decomplector: **`makeCodelCreditController` complects constructor identity with actual runtime policy.** § Limits and failure beha...
- decomplector: The default `target = alpha * target0` coupling (§ The alpha knob, `:209-245`) braids "relative aggressiveness" (gro...
- ergonomist: **`packages/exo-stream/index.js` is empty (`export {}`) today** — confirmed by reading the file and the package's `...
- ergonomist: **Malformed/typo'd descriptor fields have no stated error visibility.** § Surface and compatibility (lines 254–258...
- ergonomist: The `buffer` name spans two conceptually different quantities (`lines()`'s producer pre-pull vs. `iterateReader`'s co...
- pedant: **Must-fix — em-dash violation, wholesale, in new prose.** `designs/exo-stream-adaptive-pacing.md` uses the em-dash...
- pedant: **Should-fix — inconsistent hyphenation of the same root word within one section.** "Verification plan" uses both `...
- pedant: Hard-to-type code points (arrows, ellipsis, curly quotes, comparison symbols): none found; the doc correctly spells `...
- pedant: The mermaid `stateDiagram-v2` block is the correct diagram form (no ASCII art). [rule: pedant brief, mermaid convention]
- pedant: Headings are consistently sentence-case at `##`/`###`, title-case at `#`, matching sibling design docs.
- pedant: Bold-lead-in micro-headings ("**Cold start.**", "**Trust.**", etc.) are used in parallel construction throughout.
- pedant: `pre-pull`/`prefetch`/`precondition` and other repeat compounds are each spelled consistently across the document.
- pedant: Citation form for PR #832 links is uniform throughout.
- skeptic: The verification plan never actually exercises the CoDel shrink half against real timing. The synthetic controller un...
- skeptic: Compatibility commits `iterateBytesReader` to "the identical discriminated-union widening... wired to the same contro...
- skeptic: None beyond the above; the compatibility, PR #832 status, and `lines()` claims all check out against the current tree...
