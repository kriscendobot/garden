from_host: endolin-garden2-5bcdff64
from: gardener:compose-review-requests-budget-reached-20261007
reply_to: compose-review-requests-budget-reached-20261007
msg_key: review-request-kriscendobot-minion-town-pr151
notice_count: 1
first_seen: 2026-10-07T22:13:18Z
last_seen: 2026-10-07T22:13:28Z
sent_at: 2026-10-07T22:13:28Z
---
Review request: kriscendobot/minion.town JavaScript-only deploy migration stack (gauntlets reached their review budgets)
Review in order, starting from the bottom:
1. https://github.com/kriscendobot/minion.town/pull/151 chore: begin JavaScript-only script migration (draft, +1448/-363)
2. https://github.com/kriscendobot/minion.town/pull/152 chore: convert provisioning deploy scripts to JavaScript (draft, +3351/-1476)
3. https://github.com/kriscendobot/minion.town/pull/153 chore: convert CD deploy scripts to JavaScript (2b). Not part of this request: its gauntlet passed panel round 1 and it is already un-drafted, but it sits between kriscendobot/minion.town#152 and kriscendobot/minion.town#154.
4. https://github.com/kriscendobot/minion.town/pull/154 chore: finish JavaScript-only deploy migration (draft, +3035/-1577)
Arc: garden-upkeep.

What it does: replaces the deploy/provisioning shell scripts (and their python3/zip dependencies) with Node JavaScript, adds a JS-only gate, and converts the remote root programs to templated scripts with tests.
The end state is that deploy tooling is JavaScript only, apart from a few named scripts that still use python3 (deploy-siwe-thunk.sh, deploy-oauth2-proxy.sh, common.sh).

CI: all four heads green (3/3 checks each): kriscendobot/minion.town#151 `b3cacfeff3`, kriscendobot/minion.town#152 `d58c74c6d9`, kriscendobot/minion.town#153 `2ca6c15ca1`, kriscendobot/minion.town#154 `69b78b94ac`.
Stack hygiene: the frozen bases are stale. kriscendobot/minion.town#152 is based on a snapshot 20 commits behind kriscendobot/minion.town#151's head, and kriscendobot/minion.town#153 is 6 behind kriscendobot/minion.town#152's head. The bottom base `main-a378bb3` is 59 commits behind main. Expect a restack/weave before merge.

Why it didn't converge: each PR ran 6 panel/fix rounds (all ended 10-04). Round 6 was down to 3 request-changes seats on each PR, and each round's blockers were closed, but each new round found a fresh set, mostly real security or correctness edges in the converted scripts. Fix round 6 says it addressed every round-6 must-fix below; no panel has checked the result.

kriscendobot/minion.town#151, round 6 (3 request changes, 6 comment-only, 22 approve):
- Converted scripts exited 0 without running `main()` when invoked through a symlink, so the fail-closed preflight, the `inspect-image.js` CI gate and the Caddy installer could silently pass. Fixed in all seven entry points, with a symlink test.
- The `replace` to `replaceAll` fix in tools/vendor-endo-claude.js had no test. Now an exported helper with a two-occurrence test.
- A commit pointed deploy-npm-registry.sh at a renamed file. History rewritten so the rename lands with its callers.
- Not done: the integrator's optional regroup of the 12 review-round fix commits into one per conversion. Comment-only items left: property tests, the `df --output` parse, an operator note about moved entry points, a c8 report.

kriscendobot/minion.town#152, round 6 (3 request changes):
- breaker: `collectZipEntries` (deploy/aws/scripts/lib/zip.js) silently dropped symlinked files from Lambda zips. Now follows links like `zip -r`, and a broken link or a loop throws.
- integrator: the PR description overclaimed "no python3 or zip". Narrowed.
- scribe: a missing fix-loop summary comment (the third time on this PR). Posted; scribe's proposed change to skills/pr-creation-flow was not made.
- Still open, security-relevant: `preservedPoolFields` in deploy-pre-token-gen.js omits `UserPoolAddOns` (advanced security) and the SMS/email message fields, so each run resets them. The old shell script had the same gap; it needs its own fix.

kriscendobot/minion.town#154, round 6 (3 request changes, 11 comment-only, 17 approve):
- wire-watcher: the Node tarball was extracted into /usr/local as root without a hash check (pre-existing in the .sh). Now `resolveNodeTarball` reads SHASUMS256.txt and the remote programs run `sha256sum -c` first. deploy-app.js turned out to have the same gap and was fixed too.
- saboteur: malformed `ENDO_CLAUDE_*` unit lines were silently dropped. Now they fail the deploy.
- breaker: the root-script builders didn't validate agent and snapshot names. Now validated, with hostile-input and `bash -n` tests.
- Not done: a PR-body note that JS `quote(agent)` closes a real injection hole in the old script; the reaper "always exits 0" test check; module comments lost in conversion; property tests for `sha256File` and `quote()`; a slow regex in remote-template.js; one standard way to fill in remote programs.

Look at first: the code that runs as root on hosts, because that is where every round found something. Start with the remote-program builders and quoting in kriscendobot/minion.town#154 (remote-template.js, provision-guest-reminders.js, the `.remote.txt` templates), then the run-directly guard and inspect-image gate in kriscendobot/minion.town#151. Then decide whether the `UserPoolAddOns` reset should block kriscendobot/minion.town#152 or go to a follow-up.

No GitHub review was requested and nothing was approved.
