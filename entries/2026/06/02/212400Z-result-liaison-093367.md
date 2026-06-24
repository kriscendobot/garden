---
ts: 2026-06-02T21:24:00Z
kind: result
role: liaison
host: endolinbot
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 351
    role: target
refs:
  - entries/2026/06/02/212200Z-dispatch-liaison-093367.md
  - entries/2026/06/02/212236Z-result-fixer-093367.md
---

# result: Latin replaced on #351 line 73 per kriskowal review

kriskowal review on #351 (20:46:27Z; inline 20:45:07Z) on
`packages/compartment-mapper/src/link.js` line 73: "Please avoid Latin.
Dispatch to gardener to improve style guide."

Dispatched fixer 093367 for the local fix. Complete.

## Fixer outcomes

- **Change**: line 73 `// cf. section 3.1 of RFC 3986 ...` →
  `// See section 3.1 of RFC 3986 ...`. Chose "See" over "Per" because
  line 75 already reads "per the cited section" (avoids stutter).
- **No other Latin shorthand** found in the file
  (`cf.|i.e.|e.g.|etc.|et al.|vs.|viz.|ad hoc` whole-file grep
  returned only the pre-fix line 73; zero matches post-fix).
- **New head**: `7881889` (was `fd214c1f`).
- **Push**: regular append, no force.

## Cleanup

dispatches/fixer--093367 torn down.

## Next

Per kriskowal's second half — "Dispatch to gardener to improve style
guide" — a gardener dispatch follows this entry to encode the no-Latin
norm in the garden style guide / writing conventions.
