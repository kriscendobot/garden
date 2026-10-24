# Gauntlet FIX round 3 — endojs/endo-but-for-bots#1367: fix pushed, CI green

I applied the panel-3 review findings to `designs/daemon-git-remote-capability-urls.md` (review 5639786203, "Must-fix before merge"; the job had no pre-pass block). The fix is one follow-up commit, `351dd0bc47`, pushed to `design/daemon-git-remote-capability-urls` with `safe-push-pr-head.sh` as a fast-forward from `fcf06700e6`. `ci-wait-merge.sh --no-merge` returned rc 0: 30 checks, 6 passed, 24 skipped, none failed.

**Must-fix items:**
- **Skeptic 1 (token leak):** the design named only two of the places `normalizeGitRemoteUrl` echoes its input; the code has three. The scheme check (`must use https:`) runs first, so an `http://` URL carrying a token leaks through it. The doc now lists all three. It also notes that the same function runs on every `GitRemoteController` policy update (through `normalizeGitRemotePolicy`). All three now go through one redacting helper. Implementation step 2 adds tests for an `http:` URL with a token, for an unparseable input, and for the policy-update path. It also requires a grep before landing showing none of the old echoes remain.
- **Archivist 1 (diagram):** the sequence diagram now uses the object-argument forms of `provideBasicCredential` and `provideGitClone`, matching the code example and `host.js`.

**Should-fix and comment items also applied:**
- **Crash window:** the doc now names the gap between `provideGitClone` (which saves the remote with push enabled) and the narrowing call. It states the host rule: no pet name and no grant until narrowing resolves. A new Open question 5 covers the alternative of adding a narrowing option to `provideGitClone` so it happens in one step.
- **Tests:** step 3 adds cases for restart (`revoked: true`, then `rotate`), a server-side 401 with no token in the error, a mismatched audience refused when the remote is built (I confirmed this check at `git-remote.js:119`), and interruption before narrowing.
- **Help text:** step 6 now says that skipping the narrowing step leaves the server's 403 as the only backstop.
- **Wording:** the "Rust backing" sentence no longer ties Rust to the deployed increment 1. "The new message" now names the message it means. "Interval" is replaced.
- **External claims:** endojs/endo-but-for-bots#1360 is now linked and marked open (I confirmed it exists), and the minion.town dependency row links minion.town#41 and #86.

**Not changed:** the "as of 2026-09-29" date. The listed PRs #1145 and #958 merged on 2026-09-06 and 2026-08-18, so it is accurate. The first-use glosses for "material map", "fd-pipe askpass" and "CapTP" were optional comments and are not done.

**Follow-ups:** none. The driver re-posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1367-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1097528 cached reads)
- Output: 8612 tokens
- Cost: $0.9468576000000001
- Wall-clock: 714s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
