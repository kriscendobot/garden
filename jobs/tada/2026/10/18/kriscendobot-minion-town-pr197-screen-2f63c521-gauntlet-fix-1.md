I applied the panel's round-1 must-fix items and pushed them to PR #197, but CI never ran. At the 3600s deadline both CI runs were still queued, so `ci-wait-merge.sh` ended with rc 4 (still pending). Whether the change passes in CI is unknown.

**Local checks on the pushed head `a643682`:**
- `test/shell-clip.test.ts`: 97/97 passed.
- Typecheck: clean.
- Chromium browser gate: 30/30 passed, including the new control check. Firefox and WebKit were not run locally.
- Full vitest suite: 3 failures, all in files this PR does not touch (`tools/claude-harness/*.test.mjs` and one `test/git-remote/capability.test.ts` case).

**Two commits pushed** with `safe-push-pr-head.sh` (`962b72c..a643682`):
- **`cd94f49` fix(shell):**
  - **Live frame only when served:** `frameConfiguration` now frames a clip live only when `serving === true`. A missing flag shows the inert card, and its test now expects that (locksmith, breaker).
  - **Late loads ignored:** `createLiveFrameWatch.arm` returns a generation number, and `loaded(generation)` only settles the current navigation. Each navigation gets its own load listener, removed when the next one starts. A superseded clip's late `load` can no longer cancel the newer clip's timeout. A `securitypolicyviolation` arriving after load no longer triggers the fallback (wire-watcher, integrator, corner-prober).
  - **Frame type:** `FrameConfiguration` is now a live/inert union (typist).
  - **New tests:** a property test of which clips frame live versus inert (fast-checker), a stale-load case, and a violation-after-load case.
  - **Design doc:** fixed the contradiction in its open questions, and § 3.2 now describes the load correlation and the serving rule.
- **`a643682` test(browser-gate):**
  - **Top-navigation check:** the top-navigation/popup check now fails unless the live frame and its script are present (prover).
  - **New control check:** a clip served without `frame-ancestors` and X-Frame-Options does load in the hostile parent. This proves the hostile-ancestor checks would fail if those controls were removed (prover).
  - **Workflow:** it now derives `HOME` from the running user instead of hardcoding `/root` (transplanter). Its header no longer cites the nonexistent § 3.7.
  - **Cleanup:** renamed shorthand identifiers (stylist), removed banner comments (archivist), and trimmed the module preamble (pruner).

I posted a summary comment on the PR (issuecomment-6244856122) for the scribe item.

**Not done:**
- **Changeset (releaser):** not added. The repo has no `.changeset` setup and the package is private; the changeset-auditor seat came to the same conclusion.
- **Shared base32 code (purist):** the shell keeps its own copy of the base32 decoder. Sharing the gateway's would need a bundling step the shell doesn't have.
- **PR body trim (pruner):** I didn't shorten the body; I posted the summary comment instead.
- **Remaining race:** a stale `load` event already queued on the same iframe element before the new listener is attached could still settle the newer watch. Fully closing that would mean replacing the iframe element on each navigation.

**Follow-up:** about 50 minutes after the push, no run had started on minion.town and 7 were queued. The self-hosted `ci-minion-town` runners appear offline. This host's PAT can't read runner status to confirm, so someone should check them.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr197-screen-2f63c521-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (3777070 cached reads)
- Output: 24852 tokens
- Cost: $2.1563740000000005
- Wall-clock: 4510s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
