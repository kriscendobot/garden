**Clean stage for kriscendobot/minion.town #240 is done: CI is green at head `be01b3a804e`, and I pushed three follow-up commits.** `ci-wait-merge.sh --no-merge` returned rc 0 with 2 of 2 Actions runs passing. The bot PAT can't read `statusCheckRollup`, so this reflects Actions runs only; commit statuses and non-Actions checks aren't visible.

**Starting state:** this was not a no-op. At `46ca5fda`, `clip frame browser gate` failed on all three browsers because of the PR's own change. The landing route moved from `handle /` to `handle @landing`, and the gate could no longer find the landing CSP.

**Commits pushed with `safe-push-pr-head.sh`:**
- **`a243c137` `fix(test)`:** points `test/browser/clip-frame-gate.ts` at the `@landing` block.
- **`cbf52cdd` `chore(www)`:** removes `fragmentHoldsCredential` from `home.js`, which this PR left with only test callers. Its cases for unparsed credentials now assert `fragmentHoldsSecret`.
- **`be01b3a8` `fix(web)`:** fixes a bug the coverage pass exposed.
  - **Bug:** a malformed percent escape in a locator (e.g. `endo://<node>/%E0%A4%A?type=guest`) made `isEndoLocator` throw a `URIError`. `parseCapabilityUrl` and `toEndoLocator` then threw too, instead of rejecting the link.
  - **Fix:** the link now comes back as `invalid-locator`. I also added tests for the other refusal branches.

**Coverage on the touched source:**

| File | Branch before | Branch after | Note |
| --- | --- | --- | --- |
| `capability-url.ts` | 96.36% | 100% | Lines and statements also 100% |
| `local-invitations.ts` | 100% | 100% | Line 234 still uncovered; not changed by this PR |
| `home.js` | 96.42% | 96.38% | Line coverage about 52%, mostly the DOM `boot` code, which these unit tests don't reach |

The repo has no coverage provider installed, so I linked `@vitest/coverage-v8` from a scratch directory for these runs and then removed the link. Nothing from that reached the PR.

**Verification:**
- **Browser gate:** the Chromium run passed 30/30 checks locally. Firefox and WebKit only ran in CI, and the gate run there passed.
- **Type check:** `tsc --noEmit` is clean.
- **Full vitest suite:**
  - The final run had 1698 passed and 1 failed. The failure is `test/git-remote/capability.test.ts › propagates a git failure`, the known bot-sandbox failure the PR body already notes.
  - An earlier run on the same tree had a second failure that I did not identify, because my output filter hid its name. It did not recur on the rerun, so I treated it as a flake, but that is unproven.

**Left for the panel:** `toEndoLocator`, `parseCapabilityFragment` and the `locator` / `/adopt` paths have no production callers yet, apart from `parseCapabilityFragment`'s internal use by `parseCapabilityUrl`. I kept them because the PR body assigns them to the successor job `build-minion-town-https-locators-proof-20261104`. If that job doesn't land, they become dead code.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr240-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1067069 cached reads)
- Output: 14588 tokens
- Cost: $1.1580618
- Wall-clock: 777s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
