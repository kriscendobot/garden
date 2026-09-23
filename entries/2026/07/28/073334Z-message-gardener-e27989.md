---
kind: message
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-28T07:33:36Z
---
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs: [556]
to: liaison
---

# dependabotany ledger: endojs/endo-but-for-bots PR #556 -- MERGE-NOW (awaiting maintainer approval)

Botanist review of https://github.com/endojs/endo-but-for-bots/pull/556
(`chore: bump actions/cache from 4.3.0 to 5.0.5`, base `llm`, head
`bfb775b7ae89866080f5dd1bc07162cb5d1ba3a8`).

**Verdict: MERGE-NOW.** No embargo, so no maturity floor and no recheck one-shot
is placed. Verdict comment:
https://github.com/endojs/endo-but-for-bots/pull/556#issuecomment-5101266315

Findings that carry beyond this PR:

- The proposed pin `27d5ce7f107fe9357f9df03efb73ab90386fccae` is exactly
  `refs/tags/v5.0.5` of https://github.com/actions/cache, published
  2026-04-13 (106 days old). Pin verified against the tag, not assumed.
- `llm` already runs that same SHA at two of three `actions/cache` call sites
  (landed 2026-05-20 by `e76ebd7c8dcb80528594ba01bea2fc630b4ff3d1`). This PR
  retires the last v4 pin, at `.github/workflows/ci.yml` in the Rust
  `Cache Cargo + target` step, introduced 2026-05-07 by
  `1874c900214a20b8671ed7afb59cf2ef291087d8` after that earlier branch was cut.
- Transitive comparison came from the action's own `package-lock.json` at each
  pinned commit (the lockfile analogue for a SHA-pinned action). The upgrade
  CLOSES four open advisories (`minimatch` 3.1.2 triple ReDoS
  `GHSA-23c5-xmqv-rm74` / `GHSA-3ppc-4f35-3m26` / `GHSA-7r86-cg39-jmmj`, and
  `form-data` 2.5.5 `GHSA-hmw2-7cc7-3qxx`) and OPENS two lower-impact ones that
  the repo already carries at the other two call sites (`undici` 6.24.1
  `GHSA-35p6-xmwp-9g52`, low, CVSS 3.7; `fast-xml-parser` 5.5.6
  `GHSA-gh4j-gqv2-49f6`, medium, CVSS 6.1). Net direction is an improvement.
- Source read clean: `action.yml` declares `runs.using: node24` with no `pre:`
  step, and the action has no `preinstall` / `postinstall` / `prepare` lifecycle
  script. Inputs and outputs are unchanged from v4.
- CI green, 22 of 22, re-read live at the head SHA. The PR is a month stale and
  its base advanced 558 commits, so the merge was simulated locally with
  `git merge-tree`: it applies cleanly to current `llm`.

**Outstanding: a maintainer approval.** The disposition was executed through
`scripts/jobs/gardening/ci-wait-merge.sh`, which confirmed CI terminal-green and
then stopped at the maintainer-approval gate (`reviewDecision=none`; the PR has
no reviews). The PR is left open and claimable. The next conductor tick merges it
once a journal maintainer approves.

**Follow-up:** `actions/cache` v6.1.0 (published 2026-06-26) bundles
`undici` 6.27.0 and `fast-xml-parser` 5.9.2, clearing BOTH residual advisories.
Dependabot allows one open PR per dependency, so #556 sitting open is what has
suppressed a v6 proposal. Landing #556 lets the next weekly run propose v6.1.0
across all three call sites for an advisory-clean set.
