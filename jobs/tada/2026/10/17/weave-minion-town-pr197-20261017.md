I rebased kriscendobot/minion.town#197 onto current `main` and force-pushed the new head. GitHub now reports the PR as MERGEABLE. I did not merge it.

**What changed**
- The head `feat/clip-live-frame` moved from `f55f6a2` to `2f63c52`. It sits on `main` `3a2c120`, which is the #190 clip-gutter-reorder merge; the PR was 21 commits behind before.
- The PR's single commit carried over intact, touching the same 8 files.
- The base stays `main`, as the job named. I did not cut a frozen `main-<sha>` branch, so this PR uses the live `main` rather than a pinned snapshot.

**Conflict in `designs/clip-shell-framework.md`** (Open questions item 4, the clip-id model)
- `main` (#190) had added a paragraph on how the saved gutter order (`clip-orders/`) depends on whether #85 or #88 lands.
- The PR had rewritten the same spot to give the approved #189 direction: one clip id throughout, the locator only in the URL fragment, and the live frame using the listed id.
- I kept both. The PR's #189 text comes first, then main's gutter-order paragraph, reworded slightly to follow it. Nothing from either side was dropped. This was the only conflict; the other files, including `shell.js` and the tests, merged cleanly.

**Tests after the rebase**
- `npm ci` and `npm run typecheck` both passed.
- `test/shell-clip.test.ts`: 93 of 93 passed.
- Full `npm test`: 1229 passed, 11 skipped, 1 failed. The failure is `test/git-remote/capability.test.ts`, the test "propagates a git failure rather than reporting the ref absent". The PR doesn't touch that file, and it matches the known false failure caused by the garden's git wrapper in this environment. I did not run it against `main` to confirm the same failure there.
- I did not run the new browser-gate workflow locally; it runs on Chromium, Firefox and WebKit in CI.

**Next:** the proxy should re-screen head `2f63c52` and post a fresh conductor. I left no comment on the PR, since the job didn't authorize one.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `f55f6a211481efe2afb16c987e2c9e30df0afc91`; this job presented `2f63c521fd047440f376ad0731337c9a3b06e677`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/weave-minion-town-pr197-20261017.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (603941 cached reads)
- Output: 3342 tokens
- Cost: $0.5981322
- Wall-clock: 93s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
