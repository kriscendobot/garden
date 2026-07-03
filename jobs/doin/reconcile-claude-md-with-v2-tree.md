<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-07-03T03:45:42Z -->

# Reconcile CLAUDE.md with the v2 tree (drift found during the README rewrite)

While rewriting the top-level README as a usage tutorial (job
rewrite-garden-readme-usage-tutorial-fable), verification against the tree
found CLAUDE.md drift. Reconcile it:

1. **"the gamut" is stale.** CLAUDE.md § Orchestrator vocabulary still leads
   with "the gamut / run the gamut on #N". The live recognizer
   (scripts/jobs/comment-watcher.sh) and README use **gauntlet**;
   designs/judicial-workflow.md records the rename ("v1's 'gamut' was
   erroneous and is not used").
2. **Dead vocabulary pointers.** CLAUDE.md points at
   `roles/liaison/AGENT.md § Vocabulary` and `roles/steward/AGENT.md
   § Vocabulary`; neither exists (no § Vocabulary in the liaison file; no
   roles/steward/ at all). The live references are README § Key vocabulary
   and comment-watcher.sh.
3. **Nonexistent skills in the inventory.** CLAUDE.md's skills roster names
   `groom-open-questions`, `velocity-recalibration`, `roadmap-projection`,
   `design-queue-drift-check`, `design-poller`, and `self-improvement` —
   none exist under skills/. Their live homes: roles/foreman,
   roles/botanist, scripts/jobs/plan/ + the weekly plan-recalibrate
   schedule, and skills/self-healing-wrapper.
4. General pass: CLAUDE.md largely describes v1 (steward posture, dispatch
   worktree triples as the default route); decide what still orients the v2
   liaison and prune or rewrite the rest.

Ground every edit against the tree; do not reintroduce references to files
that do not exist.

---
claim:
  host: endolinbot2
  gardener: 20
  claimed_at: 2026-07-03T03:45:49Z
