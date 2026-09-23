---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-28T07:36:33Z
---
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs: [556]
---

# botanist result: endojs/endo-but-for-bots pull request 556 -- MERGE-NOW, blocked at the approval gate

Job `endojs-endo-but-for-bots-pr556-dependabot` (auto-posted by the dependabot-PR
watcher). Reviewed https://github.com/endojs/endo-but-for-bots/pull/556
(`chore: bump actions/cache from 4.3.0 to 5.0.5`, base `llm`, head
`bfb775b7ae89866080f5dd1bc07162cb5d1ba3a8`) end to end under
`roles/botanist/AGENT.md`.

**Verdict: MERGE-NOW.** All four legs of the gate hold: CI green, maturity window
satisfied (106 days past publish), source read surfaced nothing, transitive set
assessed net-benign. Verdict comment posted:
https://github.com/endojs/endo-but-for-bots/pull/556#issuecomment-5101266315

**Disposition executed, and it stopped where designed.** Ran the conductor
spine `scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 556
--merge`. It re-read the rollup live (`total=22 failed=0 -> CI GREEN`) and then
refused at the maintainer-approval gate
(`pr-maintainer-approval-gh.sh`: `reviewDecision=none`; the pull request has no
reviews). NOT merged. The pull request is left open and claimable. A maintainer
approval is the only outstanding item; the next conductor tick merges it.
Maintainer alerted via `message-user.sh`.

Evidence gathered (all commands run, not inferred):

- Pin verified against the tag: `refs/tags/v5.0.5` of
  https://github.com/actions/cache resolves to exactly
  `27d5ce7f107fe9357f9df03efb73ab90386fccae`. Published 2026-04-13T15:57:52Z,
  not draft, not prerelease.
- Diff is `+1/-1` in `.github/workflows/ci.yml` only. No source files touched,
  so the step-1 preflight passes.
- `llm` already pins that identical SHA at two of three `actions/cache` call
  sites (landed 2026-05-20 by `e76ebd7c8dcb80528594ba01bea2fc630b4ff3d1`); the
  straggler at the Rust `Cache Cargo + target` step came in 2026-05-07 via
  `1874c900214a20b8671ed7afb59cf2ef291087d8`. The PR retires the last v4 pin.
- Transitive set diffed from the action's own `package-lock.json` at each pinned
  commit. Upgrade CLOSES four open advisories (`minimatch` 3.1.2:
  `GHSA-23c5-xmqv-rm74`, `GHSA-3ppc-4f35-3m26`, `GHSA-7r86-cg39-jmmj`;
  `form-data` 2.5.5: `GHSA-hmw2-7cc7-3qxx`) and OPENS two lower-impact ones the
  repo already carries at the other two sites (`undici` 6.24.1
  `GHSA-35p6-xmwp-9g52` low CVSS 3.7; `fast-xml-parser` 5.5.6
  `GHSA-gh4j-gqv2-49f6` medium CVSS 6.1). `actions/cache` itself carries no
  advisory in GHSA or OSV at any version.
- Source read: `action.yml` declares `runs.using: node24`, no `pre:` step; the
  action's `package.json` has no `preinstall` / `postinstall` / `prepare`.
  Inputs and outputs unchanged from v4. Cosmetic oddity noted in the comment:
  `package.json` at the v5.0.5 tag still reads `"version": "5.0.4"`.
- The pull request is a month old against a base that advanced 558 commits, so
  the merge was simulated: `git merge-tree --write-tree` produced a conflict-free
  tree, and GitHub reports `mergeable: MERGEABLE`.

**Follow-up:** `actions/cache` v6.1.0 (2026-06-26) bundles `undici` 6.27.0 and
`fast-xml-parser` 5.9.2, clearing BOTH residual advisories. Dependabot allows one
open pull request per dependency, so this one sitting open is what has suppressed
a v6 proposal. Landing it unblocks a clean v6 bump across all three call sites.

Self-improvement: sent a proposal to `inbox/liaison` (5 items) rather than landing
role edits, since this is not a garden-infra job and one item rewrites an existing
rule; `roles/botanist/AGENT.md` is written entirely for npm lockfile bumps and has
no leg for the `github-actions` ecosystem it is routinely handed, including no
instruction to verify a pinned SHA resolves to its claimed tag.
