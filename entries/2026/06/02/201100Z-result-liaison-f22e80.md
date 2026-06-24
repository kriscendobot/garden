---
ts: 2026-06-02T20:11:00Z
kind: result
role: liaison
host: endolinbot
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 387
    role: target
refs:
  - entries/2026/06/02/200700Z-dispatch-liaison-f22e80.md
  - entries/2026/06/02/200948Z-result-fixer-f22e80.md
  - https://github.com/endojs/endo-but-for-bots/pull/387
---

# result: .engines -> .bench-engines rename per kriskowal #387 missed-feedback catch

User correction: "Did you miss feedback on
https://github.com/endojs/endo-but-for-bots/pull/387". Yes — I missed a
file-level review comment from kriskowal at 02:39Z on #387: "Please
rename `.engines`. Nothing limits us from using engines for other
workflows." (line=null, path=packages/benchmark/install-engines.sh).

Dispatched fixer f22e80 to rename `.engines` -> `.bench-engines` across
the three files in `packages/benchmark/` that reference the dir.
Successful.

## Fixer outcomes

- **Change**: sed-substituted `.engines` -> `.bench-engines` in three files
  (no other paths touched):
  - install-engines.sh: 20 references rewritten
  - run-tests.sh: 2
  - README.md: 1
- **Internal `/engines/` segment** in paths like
  `.engines/engines/xs/xst` correctly preserved (sed anchor `\.engines`
  matches only the dot-prefixed dir name, not the inner unprefixed
  `engines`).
- **New head**: `9e3cde0f2` (was `dda872eb0`).
- **Push**: regular append; no force.
- **Verification**: post-sed grep for `\.engines` returns zero matches;
  `sh -n install-engines.sh` exits 0.

## Note on what I missed and what I did NOT miss

The `.engines` rename ask predates my prior fixer dispatch (gibson042
feedback at 19:11Z). I focused narrowly on the gibson042 upstream
review and didn't sweep #387's existing inline comments before
dispatching. Catching kriskowal's earlier ask required a separate
follow-up pass, prompted by the user.

The other recent maintainer feedback on #387 — "Please use `shellcheck`
as well." (kriskowal issue comment at 19:12Z) — is being addressed by
PR #401 (parallel orchestrator's builder), not by additional work on
#387.

## Self-improvement candidate

Before any "carry upstream feedback to mirror" dispatch, scan the mirror
PR's own existing inline comments first. The upstream comments arrive
fresh and feel urgent; the mirror's standing asks can be older but
equally actionable. A pre-dispatch sweep would have caught this in one
pass instead of two. Worth a memory rule if the pattern repeats.

## Cleanup

dispatches/fixer--f22e80 torn down.

## Steward queue net effect on #387

PR #387 (`fix-benchmark-wget-engines-master`) now has 4 commits atop
`master-814dfa1`:

```
9e3cde0f2 fix(benchmark): rename .engines -> .bench-engines per kriskowal #387  ← this fixer
dda872eb0 fix(benchmark): carry gibson042 shell-script feedback from endo#3294  ← prior fixer
c786ba635 chore: Update yarn.lock
03165ef12 fix(benchmark): install xs/v8 via direct download, drop esvu
```

Remaining unaddressed maintainer asks on #387: none. Awaiting kriskowal
review of the two new feedback-carry commits.
