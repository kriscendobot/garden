Panel round 5 on kriscendobot/minion.town PR #192 came back **must-fix**, and the verdict is posted on the PR.

**What ran**
- I got an isolated project checkout of `kriscendobot/minion.town@fix/node-install-root-ownership` at head `46ef5fc`.
- I ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against base `origin/main-30a4c62`. It exited 0 with disposition `must-fix`.
- Before the seats ran, the pre-pass checks forced the pruner over the PR description (its concision check fired) and forced the decomplector's "is this mechanism needed?" question (the same mechanism has failed review in several rounds).

**Verdict:** 34 seats ran. Seven requested changes: locksmith, saboteur, breaker, purist, wire-watcher, pruner and decomplector. The must-fix findings, deduplicated:
1. **`sudo` runs before the trust check.** `ensure_setfacl` runs `sudo env … apt-get` before the `/usr/local` check. Root's `sudo` path searches `/usr/local/bin` first, so a planted `env` there runs as root. The guard test scans the heredoc source, where `$ENSURE_SETFACL` is still unexpanded, so it misses this.
2. **Only Node's own files are checked.** Other files in `/usr/local/bin` and `/usr/local/sbin` were also writable by the build uid, and they survive. Later bare `sudo <cmd>` calls in each deploy script find them before the system binaries.
3. **Decomplector: replace the verifier rather than patch it again.** The last several rounds kept hardening the same in-place check of the shared `/usr/local`. The seat recommends installing Node into a root-owned tree named by its checksum (`/opt/node/<sha256>` plus a `current` symlink), the layout `deploy-npm-registry.sh` already uses for releases.
4. **Pruner: concision.** The PR body is 384 words, over the threshold. The trusted-PATH comment is repeated in three deploy scripts, and some test comments narrate the code below them. Purist rates item 1 as should-fix rather than must-fix.

**Posted:** https://github.com/kriscendobot/minion.town/pull/192#pullrequestreview-5547360687, against commit `46ef5fc`.
- It went up as a COMMENT review, not request-changes, because GitHub doesn't let the bot request changes on its own PR. Earlier rounds on this PR were posted the same way.
- The full aggregate is 90KB, over GitHub's 65,536-character limit for a review body. The posted review (about 59KB) starts with a "Garden panel — round 5: **must-fix**" header and the deduplicated findings above. It then has the seven request-changes seats in full and as many other seats as fit. The last 17 seats appear only as a list of their verdicts. That full aggregate is only in the scratch run directory, which is not kept.

**Follow-up:** The decomplector's redesign suggestion (item 3) is a structural choice the next fixer round should weigh before applying more patches to the verifier.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr192-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1027695 cached reads)
- Output: 6787 tokens
- Cost: $0.8493670000000001
- Wall-clock: 1095s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
