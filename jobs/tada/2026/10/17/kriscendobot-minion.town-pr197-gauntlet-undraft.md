## Completion report: kriscendobot-minion.town-pr197-gauntlet-undraft

PR #197 in kriscendobot/minion.town ("feat(shell): frame a served clip live from its own ocap.site origin") is now out of draft and ready for review. It is still at the head the panel passed, `f55f6a211481efe2afb16c987e2c9e30df0afc91`.

**What I did**
1. **Advisory appellate pass:** I ran `claude -p` (sonnet) over the 1512-line diff. It found no blocking defects. It is advisory only and did not gate the un-draft. Its notes, for the maintainer or a follow-up:
   - **CI trust boundary:** `browser-gate.yml` runs on `pull_request` and defaults to `self-hosted` runners. It starts a root container with `--ipc=host` and runs `npm ci` on the PR's lockfile. That is a risk if fork or untrusted PRs are ever accepted. The third-party actions are also not pinned to a SHA.
   - **Emulated headers:** the gate checks emulated headers (`apexHeaders()` and `ISOLATION_HEADERS`) and the committed config text, not what Caddy actually sends. Running an end-to-end smoke test against the deployed host would close that gap.
   - **Shell message listener:** confirm that the shell's `message` listener, if it has one, checks the origin, since the `allow-scripts` clip frames can `postMessage` the shell.
   - **Shared cookies:** sibling `*.ocap.site` clips are on the same site, so they could share `Domain=ocap.site` cookies. This only matters if clips use cookies.
   - **Missing `serving` field:** a clip with no `serving` field is treated as served, so an unserved clip can show a blank frame until the 15s timeout. This is a minor correctness point.
2. **Pre-mutation check:** the PR was `state=OPEN`, `isDraft=true`, and its head matched the panel's commit.
3. **Un-draft:** I ran `gh pr ready`, which succeeded.
4. **Post-check:** `isDraft=false`, and the head still equals `f55f6a2…`.

**What changed:** only the PR's draft status. I made no commits to the garden or the project repo.

**Follow-ups:** none required. The CI trust-boundary note is the one worth a look if this repo ever accepts PRs from outside contributors.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr197-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (173516 cached reads)
- Output: 1766 tokens
- Cost: $0.4124872
- Wall-clock: 52s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
