**PR #258 viability check: proceed.** PR #258 is still needed. No newer change on the base branches does what it does.

**Deciding question:** Does any current base branch (`master` or `llm` in endo-but-for-bots, or upstream `endojs/endo` master) already cache the Guix runtime store (`/gnu/store` plus `/var/guix/db`) between runs of the Guile interop workflow?

**Answer:** No. So the PR has not been superseded, and the problem it addresses is still open.

**Evidence:**
- **PR state:** open, not a draft and not merged. The base is `master-46d4edf` and the head is `ace90ab0af`. It is one commit that touches only `.github/workflows/ocapn-guile-interop.yml`. Its `test-ocapn-guile-interop` check passed.
- **No base branch has this cache:** `.github/workflows/ocapn-guile-interop.yml` has no mention of `gnu/store`, `var/guix/db` or a store cache on endo-but-for-bots `master`, on endo-but-for-bots `llm`, or on upstream endojs/endo `master`.
- **Later work on the workflow is about other failures:**
  - `master` has only action-pin bumps since iteration II (`407d25c5b`), which this PR builds on.
  - `llm` adds a GNU mirror redirect for the installer download (`0391b4b44`), a fallback source for the Guix tarball (`33005c02b`), Codeberg-outage handling (`eb23c3c3a`) and job selection (`3b2dc3e17`). All of these fix getting the installer or the sources. None caches the resolved runtime closure. The daemon still resolves it from `ci.guix.gnu.org` and `bordeaux.guix.gnu.org` on every run, so the 2026-05-14 failure (both substitute servers degraded at once) can still block the job.
- **Maintainer engagement:** kriskowal asked for a rebase so it could be ferried. They then ferried it upstream as endojs/endo#3264, which is still open and not a draft, has no reviews, and was last updated 2026-06-03. No competing PR was found in either repo; the search for "guix store cache" returned no other PRs.

**Note for the next stages:**
- The base is a frozen `master-46d4edf`.
- `master` has since moved `actions/cache` to v5.0.5 (`e76ebd7c8`) and changed checkout and setup-node pins.
- Upstream endojs/endo#3264 mirrors an older head (`c89593c5c`). Any fixes made here will need a re-ferry to reach it.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr258-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (223548 cached reads)
- Output: 2465 tokens
- Cost: $0.4490816
- Wall-clock: 36s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
