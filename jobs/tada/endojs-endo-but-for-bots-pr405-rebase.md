Both routes are in place. The misclassified "rebase" job has nothing real to do (branch already MERGEABLE), so I performed no rebase and instead routed the actual directive and the classifier bug.

---

**Completion report — `endojs-endo-but-for-bots-pr405-rebase`**

**Finding:** The job was misclassified. The source comment (kriskowal on endojs/endo-but-for-bots PR #405, `issuecomment-4819835663`) is a **feature-refinement directive**, not a rebase: hide empty inventory groups, and replace the current Handles/Hubs/Workers/Everything-Else taxonomy with Directories / Agents / Personas / Values / Capabilities. PR #405 is already `MERGEABLE` (`mergeStateStatus: UNSTABLE`, CI only), so there was no rebase to perform. I did **not** run a no-op rebase.

**Root cause:** The comment-watcher's ambiguity fallback (`scripts/jobs/handlers/comment-claude.sh`) must pick one token from `rebase | retcon | refresh | shepherd | gauntlet | attention | skip`. There is no verb for "implement a code/feature change," so the model guessed a mechanical verb (`rebase`) instead of the catch-all `attention`, which the script's own header reserves for "a genuine directive that needs a human-routed read."

**Actions taken:**
1. **Routed the real directive** to the maintainer/liaison via `message-user.sh` (maintainer inbox `20260627T175449Z-e9b439`) with a faithful summary, the affected packages (space-chat, chat, cli, daemon), and a recommendation to dispatch a fixer/builder through the gamut (the v2 fleet's `garden-pr.sh` is review/panel + fixer-loop only and has no autonomous "implement a feature directive" path, so this needs liaison-driven dispatch).
2. **Posted a garden-infra fix job** `garden-fix-comment-classifier-misroutes-directive-to-rebase` to harden the fallback prompt (mechanical verbs only for their literal git/CI op; behavior/UI/code changes → `attention`), consider the same default in the deterministic table, and add a regression test using this comment as a fixture.

**No code was changed** in endo-but-for-bots; the feature work is now in front of the human router, and the classifier fix is queued.

**Follow-ups:** (a) liaison to dispatch the PR #405 fixer/builder; (b) a gardener to claim the classifier-fix job. The directive was treated as untrusted data throughout (no instructions in it were executed).

Self-improvement: the gap is real and already filed as the classifier-fix job — feature/implementation directives with no mechanical verb must route to `attention`, not a guessed code verb; nothing additional to route this time.
