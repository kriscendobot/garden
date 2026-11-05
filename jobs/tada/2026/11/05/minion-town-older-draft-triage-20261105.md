---
handed-off: endojs-endo-but-for-bots-pr1652-body-prune-20261105
deliverable-complete: false
---
# Triage: older `kriscendobot/minion.town` PRs

I triaged all 48 open PRs last updated before 2026-10-20 against `main` at `7a0bcc90`. **I closed 2 and left 46 open.** I changed no PR's code, base or draft state, posted no jobs, made no garden commits, and did not touch `endojs/endo-but-for-bots`.

**Limits on this evidence:**
- This host's PAT can't read `statusCheckRollup`, so any CI status comes from PR comments and is not current.
- The next verbs are recommendations for the supervisor.
- **Added class:** the job's three classes didn't fit some PRs, so I added **other**. These have no matching unchecked item in issues 58 or 89 and no superseder I can name, so they stay open.

## Closed: superseded or already landed
- **#131:** superseded; commit `2e563013` (via #220) removed the "Copy guest URL" button this PR fixes.
- **#189:** already landed; #194 and #197 shipped the approved contract, and `clip-shell-framework.md` § 3.1-3.2 records it. § 3.2 still links to #189 for the full contract, which stays readable on the closed PR.

## Serves an unchecked objective
- **#183:** objective, #89 item 4 (credentials on `@secrets`); parked `pr183-open-findings-fix` names it, and #241 now deprecates the subscription path; next: fix.
- **#186:** objective, #89 item 6 (root canary path); live validation is still blocked; next: weave.
- **#171:** objective, #89 item 1 production validation, though that box is already checked; a parked `node-observed-interpreter` job is blocked on it; next: weave.

## Probe or design awaiting a decision
- **#37:** design; approved by the maintainer, gauntlet halted on its floating base, and a parked build is blocked on it; next: weave, then merge.
- **#78:** design; guest primer, and #235 still treats its staging as the open question; no verb until decided.
- **#85:** build awaiting a design decision; maintainer changes requested, redirected through #88 and #142; next: fix after those decide.
- **#88:** design; the immutable-clip redirect, cited by the parked workbench build; no verb until decided.
- **#95:** design; the guest-surface documentation contract has no review yet; no verb until decided.
- **#101:** design; kumavis's mecatl evaluation has no decision; no verb.
- **#105:** probe; #148 landed the CLI backend, but parked `claude-cli-production-canary` names this PR and owns closing it, so I left it.
- **#106:** probe; a hold comment says not to rebase or promote it; no verb.
- **#114:** design; SIWE recovery has no review; no verb until decided.
- **#115:** probe; no OpenAI key was available, so the gap report is the deliverable; no verb.
- **#116:** probe; stacked on #105's frozen base; no verb.
- **#123:** design for the #58 endor item; no verb until decided.
- **#124:** design; sharding sibling of the platform plans; no verb until decided.
- **#125:** design; alternative-host sibling for the #58 distributed-store item; no verb until decided.
- **#126:** design for the #58 distributed-store and DynamoDB items; no verb until decided.
- **#127:** design; Cloudflare sibling for the #58 distributed-store item; no verb until decided.
- **#142:** design; a parked gutter-mint job is blocked on it, and its gauntlet halted on a CI billing block; next: run the gauntlet.
- **#147:** design; #235 says to close this when #235 merges, so it isn't superseded yet; no verb.
- **#168:** design; `main` has only the unread bond ledger (#218), and I found no bond list or remove UI; no verb until decided.
- **#173:** design; gauntlet at review budget, with the evidence-first rotation policy undecided; no verb until decided.
- **#177:** design; § 12 Q1 (Model S or P) is undecided; no verb until decided.
- **#191:** design; the maintainer's changes-requested review was answered by a revision; parked `ocapn-canary-live-run-2` cites it; no verb until decided.

## Other: left open
- **#58:** browser e2e suite not on `main`; next: weave, then run the gauntlet.
- **#59:** daemon listener docs not on `main`; the refresh was pushed after changes were requested; next: weave, then run the gauntlet.
- **#82:** `main` still intersects token scopes with no implied-scope expansion; next: weave.
- **#84:** CLIPOMETER isn't on `main`; parked clipometer jobs cover the same area but don't name this PR; next: weave.
- **#100:** clip publish hardening not on `main`; next: weave.
- **#108:** both holdout packages still run `node --test`; next: weave, then run the gauntlet.
- **#121:** half moot because #198 deleted `guest.html`, but the design callout isn't on `main`; next: fix.
- **#129:** #198 deleted `guest.js`, but the pasted-URL defect looks live: `home.js` reads the fragment only at load and has no `hashchange` listener (read only, not reproduced); next: fix.
- **#132:** blocked; endo #1333 and #1360 are still open and `main` still uses `adopt-locator`; no verb until they merge.
- **#133:** SIWE recovery bond not built, and the `guest.html` it edits is gone; next: fix.
- **#141:** `main`'s design still says port 3003; next: weave, then run the gauntlet.
- **#151:** JavaScript-only migration, bottom of the stack; `main` still has 57 `.sh` files; next: weave.
- **#152:** same stack, follows #151; next: weave after #151.
- **#153:** same stack and not a draft; its fix stage was doom-parked; next: weave after #152.
- **#154:** top of the stack, with 32 conflicts against `main`; next: weave after #153.
- **#170:** the `guest.html` it edits is gone, and `main` has no encrypted fragment storage; #240 is only related; next: weave and fix.
- **#178:** git-remote push caps with no conflicts; next: weave.
- **#179:** gutter names; parked ordered-gutter plans cite it, and it has 7 conflicts; next: weave.
- **#180:** git-remote binding; un-draft is withheld by the phase ledger; next: weave.
- **#181:** served clip build; waits on #177's Q1; next: weave after that.
- **#202:** Chat clip; its base #201 has merged, and it has 19 conflicts; next: weave.

## Follow-ups for the supervisor
- **#129:** this is the one finding that suggests a live user-facing defect. If it reproduces on the current landing page, it needs a fix ported to `home.js`.
- **#105:** this is effectively superseded by #148, but only the parked canary job can close it.
- **Other class:** these 21 PRs don't advance issues 58 or 89, so the supervisor may want to decide whether to spend gauntlet budget on them.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-older-draft-triage-20261105.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1828095 cached reads)
- Output: 31688 tokens
- Cost: $2.2205390000000005
- Wall-clock: 687s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
