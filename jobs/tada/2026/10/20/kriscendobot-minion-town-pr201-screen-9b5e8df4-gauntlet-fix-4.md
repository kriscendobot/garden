I pushed fixes for every panel-4 must-fix that can be settled without a maintainer decision, but CI hadn't finished by the deadline, so the stage result is still-pending. Of the four CI jobs that have run, all passed; the arm64 Claude harness job is still waiting in the self-hosted runner's queue.

**Pushed** to `feat/new-clip-inventory` with `safe-push-pr-head.sh`, moving the head from `e3de8484` to `848436a4`:
- **`4676e449`: fixes**
  - **Fake app (assessor, must-fix):** a listing now marks a directory as an app only if it has a valid `form` *and* an `inventory` directory, the same check `isApp` makes. Added a power test.
  - **Reused suffix (saboteur, must-fix):** before creating anything, minting checks that both the space name and the power name are unused. If either is taken it draws a new suffix, up to four tries, then fails. So a reused suffix can't overwrite an existing directory, and the rollback can't delete one. Added two tests.
  - **Canonical ids (saboteur, wire-watcher):** the shell's minter now accepts only a hash that passes `isCanonicalClipId`. So `"a"` and pad-bit aliases are now refused.
  - **fast-check (fast-checker, must-fix-loop):** added property tests for `normalizeEntries` and for which minted hashes the minter accepts.
  - **Smaller items:** `normalizeEntries` now drops a record whose property read throws (breaker). The sort-order test compares against a fixed list instead of `.sort()` (spec-keeper).
- **`848436a4`: benchmarker (must-fix-loop).** `designs/new-clip.md` now says why we aren't benchmarking the quota cache or the bounded `list` reads.

**Declined:** the releaser's changeset request, because the repo has no `.changeset` configuration and the package is private.

**Still blocked on the maintainer:** locksmith, purist 1, integrator and decomplector 1–2 all raise one design question: visitors can write to the clip, which departs from the direction set in #85. The options are (a) accept the interim departure, (b) ship without visitor-writable creators, or (c) wait for #88. The PR must not merge until the maintainer rules. The should-fix items on that same code are on hold too, because (b) or (c) would remove most of it.

**Checks:** `tsc --noEmit` is clean and both New Clip test files pass (48 tests). I posted a summary comment on the PR: https://github.com/kriscendobot/minion.town/pull/201#issuecomment-6298253585

**CI on `848436a4`:** the browser-gate run passed. In the test run, `changes`, `test` and `Claude harness (amd64)` passed. `Claude harness (arm64)` was still queued when the 3600s deadline ran out, so `ci-wait-merge.sh` returned rc 4. The self-hosted `ci-minion-town` runner had a backlog: both runs sat queued for about 40 minutes. The bot token also hit GitHub's API rate limit once while I was polling, and it reset a few minutes later.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr201-screen-9b5e8df4-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (3108745 cached reads)
- Output: 16506 tokens
- Cost: $1.7369729999999997
- Wall-clock: 3932s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
