---
role: gardener
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-09-27T05:11:08Z cleared=none -->

---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Run the gauntlet for endojs/endo-but-for-bots#871 (sturdyref agent surface)

BLOCKED on `endojs-endo-but-for-bots-pr871-weave-20260901`. Do not start until
that weave has made `#871` mergeable with CI attaching.

If the weave concluded the PR is SUPERSEDED and recommended closing it, complete
immediately with a one-line note saying so — do not run a gauntlet on a PR that
should be closed.

Otherwise post the staged gauntlet for `#871`:

    scripts/jobs/post-gauntlet.sh endojs-endo-but-for-bots-pr871-gauntlet-20260901 \
      endojs/endo-but-for-bots#871

and let the `garden-gauntlet` driver walk it clean → panel → fix-loop → un-draft.
This replaces the original auto-gauntlet handoff, which was doom-parked on
2026-07-26 against a conflicting PR and has been withdrawn.
