Panel stage complete.

**What I did:**
- Resolved PR #56 head (`kriscendobot/minion.town`, branch `design/invitation-only-guest-onboarding`) and got an isolated project worktree of the head.
- Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode against the worktree with base `main` (normalized to `origin/main` by the script — correctly scoping the diff to the single 254-line design file `designs/invitation-only-guest-onboarding.md`, not a stale local `main`).
- The design panel fanned 7 seats (copyeditor, critic, decomplector, ergonomist, novice, pedant, skeptic); all completed `ok`. Panel exited 0 with disposition **must-fix** (all 7 seats returned request-changes).
- Posted the aggregated 7-seat verdict to PR #56 as a `gh pr review`. GitHub forbids request-changes on a self-authored PR (author = `kriscendobot` = the pinned bot identity), so it landed as a **comment** review carrying the `must-fix` disposition in a header and the `garden-gauntlet` marker.

**What changed:** one review comment on kriscendobot/minion.town#56. No repo/code changes.

**Substance of the must-fix findings** (for the next fix stage): the design claims "no code moves / gate not yet live," but `ACCOUNT_AUTOPROVISION=on` is already set in the production unit — so it needs an explicit disposition for identities already auto-provisioned with no `invited_by` (critic, skeptic); the app-mediated `memberAgent.invite()` path names no grounded interface and may collapse the capability-graph claim to a DB annotation (critic); row-as-projection vs. per-request admission gate contradiction (decomplector); `guest_contacts`/`guest_list` duplicate the same directory + `slot`/`petName` term drift (ergonomist); em-dash and typist-hostile glyph sweeps, list-parallelism (pedant, copyeditor); undefined `E(...)`/`iss+sub`/membrane jargon (novice).

**Follow-up:** none for this stage — it ran exactly one round and stopped as specified. The gauntlet's next stage (fix-loop) owns remediation.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr56-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 58 tokens (1994389 cached reads)
- Output: 12252 tokens
- Cost: $2.1099375
- Wall-clock: 336s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
