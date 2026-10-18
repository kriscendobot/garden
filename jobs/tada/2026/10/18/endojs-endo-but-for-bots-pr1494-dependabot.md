I closed endojs/endo-but-for-bots#1494 as **REJECT (incompatible)**. Along the way I found a bug that stops every automatic Dependabot close from finishing, and pushed a fix to `main2`.

**Proof re-check.** The PR is still open with the same head, `f8aade3a`.
- The root `package.json` on that head still declares Node `^20.17.0 || >=22.9.0`, so the supported floor is 20.17.0.
- `@babel/traverse@8.0.7` (npm) still requires Node `^22.18.0 || >=24.11.0`, which leaves out that floor.

Both ranges match the job's proof, so I skipped the full botanist review.

**Close.**
- The automatic close handler first quit with "proof changed" (rc 1), but the proof hadn't changed. The host had hit its GitHub API rate limit and the handler treated the refused call as a failed check.
- After the limit reset, the handler posted the verdict comment (https://github.com/endojs/endo-but-for-bots/pull/1494#issuecomment-6255292010) and closed the PR.
- It then failed to write the ledger row: `unknown project slug 'endojs-endo-but-for-bots'`. That is the bug below.

**Bug and fix (commit `9ec7a863a89`).**
- **Cause:** the Dependabot watcher fills in `dependabot-close-project` with its own repo key (`endojs-endo-but-for-bots`). The journal only accepts project names (`endo-but-for-bots`). Every node, peer or superseded close therefore closed the PR, then failed on the ledger write (rc 75) and stayed claimed to be retried.
- **Fix:** `scripts/jobs/handlers/dependabot-terminal-close-gh.sh` now converts the `<owner>-<name>` form to the repo name with dots turned into dashes (`minion.town` → `minion-town`).
- **Test:** `scripts/jobs/test/dependabot-terminal-close-test.sh` now uses the watcher's slug and checks the converted project name; all cases pass.
- **Ledger:** I re-ran the fixed handler for #1494. It wrote the row `journal/entries/2026/10/18/212200Z-result-dependabot-terminal-close-6aae89.md`, tagged `project: endo-but-for-bots`.

**Follow-ups:**
- Other automatic closes may be stuck in the same retry state. Once this host picks up the new deploy, their retries should finish without help.
- The watcher still writes the repo key. A cleaner fix would have it write the journal project name directly.
- The handler returns "proof changed" when GitHub is rate-limited, which sends the job to a full review. Returning "try again later" (rc 75) in that case would avoid jobs like this one.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1494-dependabot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1279718 cached reads)
- Output: 7194 tokens
- Cost: $0.9499436
- Wall-clock: 583s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
