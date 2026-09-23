The weave is complete. The PR is now `MERGEABLE` (state `UNSTABLE` = mergeable with CI re-dispatched and running — exactly the intended outcome; the synthetic merge ref now exists so `pull_request` workflows fire, and the shepherd/conductor chain resumes via the event watcher).

## Completion report

**Job:** weave (rebase to clear conflicts) — kriscendobot/minion.town PR #20 (`feat: retire toy MCP tools for daemon guests`)

**What I found:** PR #20 was `mergeable: false` / `dirty` — its 3 commits sat on merge-base `14dae5c` while `main` had advanced to `289d1a3` (weblet gateway increments landed). Rebasing the head onto current `main` surfaced conflicts.

**What I did:**
- Rebased `feat/endo-daemon-guest-mcp-b5` (3 commits) onto `origin/main`.
- Resolved 3 content conflicts, all in the "retire toy tools" commit, reconciling the PR's *make `endoSock` required / always-mount the guest surface* change with main's independently-landed *weblet publish* feature (gated by `GATEWAY_STORE_DIR`):
  - `src/config.ts` — kept `endoSock: string` (required, defaults to prod socket) alongside main's `webletStoreDir?` / `webletParentDomain`.
  - `src/http.ts` — guest service now always constructed (toy tools retired), with the weblet publisher still wired when `webletStoreDir` is set and `publisherFor` passed through; `guest` mount object always present (dropped the now-dead `guestService ? … : undefined` ternary), carrying `weblets`.
  - `src/server.ts` — took the PR's toy-tool removal (dropped `minion_status`/`list_minions`/`summon_minion` and their now-unused `minions`/`counter`/`z`/`authorize`), preserving main's `registerWebletTools` behind the `weblets` flag.
- Fixed a silent semantic merge defect (not flagged as a conflict): main added a new test using `READONLY_SUB` while the PR deleted that constant, leaving an undefined reference. Restored the constant definition and folded the fix into the owning commit via autosquash, keeping a clean 3-commit history.

**Verification:** `npm run typecheck` clean; `npm test` → 217 passed / 3 skipped, all 24 suites green.

**Push:** force-pushed with lease to the PR head `feat/endo-daemon-guest-mcp-b5` (`aa716d6` → `749a02d`). PR #20 confirmed `MERGEABLE`; CI has re-dispatched. No upstream (agoric/agoric-sdk) interaction. The shepherd/conductor chain resumes automatically from here.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr20-weave-20260817.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s) (3 unmetered)
- Input: 91 tokens (3186939 cached reads)
- Output: 25067 tokens
- Cost: $2.9986774999999994 (3 engagement(s) unpriced)
- Wall-clock: 387s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
