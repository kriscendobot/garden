Fix round 5 for PR #1596 (endojs/endo-but-for-bots) is done, and CI is green on the round-5 head `138af45b95`.

**What I did**
- No pre-pass block came with the job, so the latest panel verdict is review 5725315089.
- A previous claimant on host endolin-garden-ece02cb4 had already applied that review's must-fix items and pushed them. It also posted the round summary on the PR (comment 6550269522). The three commits:
  - `164148ef28` fix(exo-npm): pre-release eligibility is now checked separately in each `||` comparator set. Also: full-precision numeric identifiers, version parsing anchored at both ends, `^0.0.x-pre` bounded by its patch, and range grouping in a fixed order. Tarballs are fetched and pinned only for the final closure, after the peer check. The typedefs moved to `types.d.ts`, and the tests were fixed.
  - `a9c5445a21`: the changeset is now `major`.
  - `138af45b95`: `designs/mvs-resolver.md` and the `designs/README.md` row now describe the range-group, least-version algorithm.
- The PR head still matched `138af45b95`, so there was nothing left to apply. I pushed no new commits, which would only have duplicated that work.
- I ran `ci-wait-merge.sh endojs/endo-but-for-bots 1596 --no-merge`. It returned rc 0 with all 35 checks passed and none failed.

**Follow-ups (deferred by the previous claimant; listed in the PR comment)**
- Bringing the Rust resolver and the daemon's semver copy in line with this rule is parked as job `endo-mvs-semver-convergence`, blocked on this PR.
- `test:xs` was already a stub before this PR, so this change has no XS test coverage.
- A fast-check property test was left out because it needs a new devDependency and a `yarn.lock` change.
- The driver will post panel-6 next. The PR is still a draft.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1596-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 108 tokens (7298592 cached reads)
- Output: 57403 tokens
- Cost: $4.3035863999999995
- Wall-clock: 1767s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
