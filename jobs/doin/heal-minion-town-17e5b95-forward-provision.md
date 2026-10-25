---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Forward-heal kriscendobot/minion.town main at 17e5b95 (#220): provision the missing IAM grant

The minion.town merge delegation is `paused` (`minion-town-screening.sh status`; `paused_reason: "#220 merge 17e5b956aec: deploy.yml failure"`). Deploy run https://github.com/kriscendobot/minion.town/actions/runs/40186091316 stopped in "Deploy app (minion-mcp)" with `AccessDeniedException`: role `garden-ec2-ssm` lacks `dynamodb:UpdateItem` on `arn:aws:dynamodb:us-west-1:292378781985:table/minion-town-accounts`. CD intentionally excludes IAM provisioning, and #220 (account deletion) documents an out-of-band provisioning step for it. Production itself is unharmed (app promotion never ran; prod probe green on 17e5b95, e.g. 12:58Z).

The revert heal (job `heal-minion-town-17e5b95`, draft https://github.com/kriscendobot/minion.town/pull/225) is wedged: its gauntlet halted twice because #225 targets the floating `main`. Precedent for the better route: job `heal-minion-town-c104813-forward-provision` (2026-10-25, tada report) ran the documented provisioning, redeployed `main`, and closed the revert; the proxy auto-resumed the delegation.

Do, in order (authority: maintainer standing order for kriscendobot/minion.town, journal `entries/2026/10/07/203746Z-message-gardener-a253b1.md`; no other repo, no identity switch):
1. In an isolated checkout of kriscendobot/minion.town at `main` (17e5b95; `ensure-project-worktree.sh`), find #220's documented IAM/provisioning step (designs/docs/deploy scripts, e.g. `deploy-accounts-store.sh` or its policy file). Read the current `garden-ec2-ssm` policies first and confirm the step only widens the app policy as #220 documents (scoped to the `minion-town-accounts` table) and does not break the app currently serving.
2. Run the documented step exactly; read the policy back to verify.
3. Re-run `deploy.yml` on `main` and wait for it in the foreground; then run `prod-probe.yml` and require all checks green.
4. On success, close #225 with a one-line comment: superseded by the forward provisioning, naming the deploy and probe runs. Do NOT resume the screener by hand; confirm the proxy auto-resumed it (`status` → `active`).
5. If the documented step does not exist, would need a policy wider than #220 documents, or the available credentials cannot change IAM: do not improvise. Instead post `weave #225` (basename `weave-kriscendobot-minion.town-pr225-20261025`) so the revert's gauntlet can run, and report why.
Report what changed (AWS state, runs, PR closes).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-25T13:22:15Z
