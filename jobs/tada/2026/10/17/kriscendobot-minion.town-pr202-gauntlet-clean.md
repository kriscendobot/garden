The clean stage for kriscendobot/minion.town PR #202 is done with no changes: nothing was pushed, and CI is green at head `761001afc4`.

**Coverage:** every new chat helper in `clips/new-clip/model.js` is used by `main.js` and tested in `test/chat-clip.test.ts`. That covers `validateChatText`, `normalizePeers`, `normalizeMessages`, `messageParts`, `repliedTo` and `previewText`. The one exception is `CHAT_POLL_MS`, a timing constant that only `main.js` uses. The tests also check that the clip power's chat methods compile and are present. `test/chat-clip-daemon.test.ts` runs two guests against a real daemon, and the PR adds it to `.github/workflows/test.yml` as a new CI step. The builder's last commit added tests for declining a request and for refusing anyone outside the clip's peers.

**Dead code:** none was left behind. The lines removed in `src/endo/gateway/new-clip.ts` are doc and `NEW_CLIP_FORMS` updates. The ones in `dev/new-clip-stack.ts` are a mint helper that moved, not abandoned code.

**CI:** `ci-wait-merge.sh kriscendobot/minion.town 202 --no-merge` returned rc 0. This host's token can't read the PR's check summary, so the script read the Actions runs API instead. It sees only Actions runs: here the single "test (typecheck + vitest)" run, which passed. Any commit statuses or non-Actions check runs were not visible to it.

The PR is still a draft, as expected at this stage. No follow-ups.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr202-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 70 tokens (2333249 cached reads)
- Output: 13006 tokens
- Cost: $1.6881617999999996
- Wall-clock: 3662s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
