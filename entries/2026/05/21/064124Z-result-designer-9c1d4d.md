---
ts: 2026-05-21T06:41:24Z
kind: result
role: designer
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/designer--ba22ee/project
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/96
---

# Result: designer dispatch (PR #96 second-round review feedback)

## Task

Apply kriskowal's CHANGES_REQUESTED on PR #96 at 2026-05-21T06:31:18Z:
five inline asks on
`designs/compartment-mapper-auxiliary-package-json.md`, all
decision-locking from a list of options the design had surfaced
earlier.

## Per-ask disposition

| Comment | Ask | Disposition |
|---|---|---|
| r3279100411 (line 502) | "Let's run with `languageForExtensionByPrefix`." | Locked. Renamed the field end-to-end in body text; Design Decisions §7 records the choice; `languageOverrides` recorded as 'Considered and rejected' (same-as-`parsers` reason); three-field split 'Considered and deferred' until a fixture forces it. |
| r3279104694 (line 533) | "Export a new function that constructs/injects the cache by default at the base." | Locked. Added sibling-constructor pattern (`mapNodeModulesWithAuxiliary`) to the cache sketch; Phased Implementation §4 schedules it alongside the threaded option; Design Decisions §8 names the maintainer's "as usual" convention. |
| r3279106143 (line 538) | "Agreed." (policy composition) | Resolved out of scope; Design Decisions §10 records that policy is keyed by canonical name and an auxiliary descriptor produces none. |
| r3279110708 (line 543) | "It does. The only case that it does not apply is importArchive and relatives that have a fully described compartment map." | Locked with exception noted. Phased Implementation §6 spells out 'Apply the same shape to `mapNodeModules`'s relatives'; Design Decisions §9 records the `importArchive` exception (fully described compartment maps need no auxiliary lookup). |
| r3279112208 (line 548) | "Not a concern." (performance) | Dropped; concern removed from the design entirely. |

Editorial cut: the now-empty Open Questions section is removed in
full (all four items resolved); content moved to Design Decisions
§7-10 and Phased Implementation §4 and §6.

`designs/README.md`: summary row `Updated` bumped to 2026-05-21;
milestone description rewritten to drop the obsolete
`mapNodeModulesWithAuxiliaryDescriptors` lane and to name the new
field and sibling-constructor pattern.

## Commits + push

- Commit: `725b3d3d3` on `design/compartment-mapper-auxiliary-package-json`.
- Push: `origin design/compartment-mapper-auxiliary-package-json`
  (fast-forward `f087b1357..725b3d3d3`).

## Inline reply IDs

| Parent | Reply |
|---|---|
| 3279100411 | 3279156397 |
| 3279104694 | 3279156867 |
| 3279106143 | 3279157092 |
| 3279110708 | 3279157392 |
| 3279112208 | 3279157522 |

## Top-level summary comment

`issuecomment-4505462575` at
<https://github.com/endojs/endo-but-for-bots/pull/96#issuecomment-4505462575>.
Tabulates each ask, the disposition, and the section the resolution
landed in; calls out the editorial cut (Open Questions retired in
full) and the pre-push-gate state.

## Pre-push gates (diff-only)

Clean on the new content.
`no-ascii-banners` pass; `no-pull-citations` pass on our paths;
`sentence-per-line-md` re-checked after one edit that broke a
multi-sentence line into per-sentence physical lines.
Pre-existing false positives at
`designs/compartment-mapper-auxiliary-package-json.md` lines
234/236/240 (numbered-list "1. " / "2. " / "3. " prefixes) and
`designs/README.md` lines 258/266/293 are outside the diff and were
not addressed.

## Self-improvement

The sentence-per-line probe's false-positive on `^N. ` numbered-list
prefixes is structural: every numbered list whose item starts at
column 0 or in a hanging indent reads as `". " + capital`. A future
refinement of `skills/pre-push-gates/probes/sentence-per-line-md.sh`
could skip lines matching `^[[:space:]]*[0-9]+\. ` the same way it
already skips bullet-list items (`^[[:space:]]*[-*+][[:space:]]`).
Worth a `message` to the gardener if the false positive recurs on
the next designer dispatch.
