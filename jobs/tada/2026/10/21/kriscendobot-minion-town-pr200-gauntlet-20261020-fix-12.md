# Fix round 12: kriscendobot/minion.town PR #200

I applied all three must-fix items from the round-12 panel, pushed them as four follow-up commits, and CI is green on the new head `088b84ab`.

## Must-fix items (from panel review 5596708561, on head `9cd8a36a`)
- **Migrator 1: the guest-open check now accepts fewer credentials** (`d210c85`). I added a new DEPLOYMENT.md section, *Rolling out the settings menu and account deletion*. Its first step is a read-only `endo list` audit to run before deploying the app. It lists browser-guest handles (`web-<uuid>`) that have lost their `-agent` name, and old `web-open-` temporary names. It also explains why only renamed or removed guests are affected: since commit `7bfd379`, `POST /api/guest` has named every guest `web-<uuid>-agent`, and it is the only path that gives a browser a credential.
- **Migrator 2: deploy order and rollback** (`d210c85`). The steps are now in order:
  1. `deploy-accounts-store.sh`
  2. `deploy-app.sh`, with a check that `WEB_SIGN_OUT_PATH` is set on any `minion-mcp` unit not installed from this tree
  3. `deploy-caddy.sh`
  4. `deploy-www.sh`
  
  A new **Rollback** paragraph says the old app can be redeployed without touching the store. It also says the old app could reach a deleted guest's credential again while a peer still names it. That guest is empty and canceled and has no recovery bonds.
- **Decomplector 1: two mechanisms retire a bond** (`5730f5d`). I kept the complete deletion sweep and made deletion the only owner of a deleted guest's bonds. The design (`closed-beta-waitlist.md` § Settings menu) now says this is because erasure is a privacy promise. The comment in the recovery route that said the sweep "can miss" a bond is reworded: the route's dead-credential check now covers only guests that died some other way.

## Also applied
- **Saboteur 2** (`a2ca7f5`): a recovery-bond ledger entry that isn't valid JSON is now skipped instead of making every deletion of that guest fail. I added a regression test and confirmed it fails without the fix.
- **Saboteur 3** (`5730f5d`): when the final audit write fails, the cause is now logged instead of discarded.
- **Pruner 1–3** (`088b84a`): removed JSDoc comments that only repeat the member name, a pointer to a test file in a source comment, and change-history wording in a design table.

## Not addressed
These are all should-fix, not must-fix:
- Saboteur 1: re-deleting an already-deleted guest keeps adding audit lines.
- Migrator 3–5.
- Decomplector 2: deletion state is kept in three places.

## Verification
- **Typecheck:** clean.
- **Local tests:** 1479 passed, 2 failed.
  - `test/endo-guest-lockdown.test.ts` timed out under host load and passes when run alone.
  - `test/git-remote/capability.test.ts` still fails when run alone. The PR doesn't change that code, and I didn't confirm the cause (I suspect this host's git setup).
- **CI:** `ci-wait-merge.sh --no-merge` returned 0 (green). Both workflows passed: "test (typecheck + vitest)" and "clip frame browser gate".
- My first wait on CI was stopped by the tool's time limit. A second, independent run finished and gave the result above.
- I posted a summary of this round on the PR: https://github.com/kriscendobot/minion.town/pull/200#issuecomment-6311498089

The PR is still a draft. The driver posts panel round 13 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr200-gauntlet-20261020-fix-12.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (4448891 cached reads)
- Output: 21137 tokens
- Cost: $2.2428382
- Wall-clock: 1825s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
