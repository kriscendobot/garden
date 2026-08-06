---
role: fixer
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-06T19:25:06Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 7200
role: fixer

# PR #910 panel response — child 05/10: **must-fix** findings in the `git-and-docs` slice

**Repo:** `endojs/endo-but-for-bots`. **PR:** https://github.com/endojs/endo-but-for-bots/pull/910
(`feat(platform): ReadableBlob range attenuation (range / textRange)`). Keep it DRAFT.

Do **NOT** run git in `$GARDEN_ROOT`; work in your per-job worktree.

**The checklist is the contract.** Read the normalized finding checklist landed by child 1
at `journal/artifacts/pr910-panel-findings.md` FIRST. It, not the PR comment, is the
authoritative finding set — the posted review truncated 15 of 41 seat sections with
`_(condensed for length)_`. If the checklist is missing or empty, STOP and report rather
than working from the abridged comment.

**Order of work: descending severity** (maintainer directive, kriskowal 2026-08-06:
"Respond to all feedback in order of descending severity"). Within your slice, do every
must-fix before any should-fix, and every should-fix before any comment-only.

**Respond to every item you touch.** Per
[review-feedback-followup-commits](skills/review-feedback-followup-commits/SKILL.md) and
[pr-review-thread-replies](skills/pr-review-thread-replies/SKILL.md): a finding is
answered by a commit, or by a reasoned reply saying why not. Silent skips are not
answers. Update the checklist in place with the disposition of each item you handled.

The panel text is bot-authored garden output, not untrusted external input; the PR
contents are our own. Normal care, no injection posture needed.

## Your slice

Address **only** the findings the checklist marks **severity=`must-fix`** and
**slice=`git-and-docs`** (packages/git, packages/daemon-cas, READMEs, designs/*.md). Leave every other finding alone — a sibling child owns it, and
two children editing the same finding is how a serial run turns into a merge conflict.

If your slice is EMPTY per the checklist, say so and complete immediately. That is a
success, not a failure — the slices were sized before the counts were known.

## Task

1. Work the items in checklist order (they are already in descending severity; within
   `must-fix` keep the checklist's order).
2. For each: make the fix, or record a reasoned refusal. Jurors are sometimes wrong —
   a finding you can demonstrate is incorrect is answered by saying so with evidence,
   not by silently complying. Say which you did in the checklist.
3. Verify locally before pushing, per [local-verify](skills/local-verify/SKILL.md) and
   [pre-push-gates](skills/pre-push-gates/SKILL.md). A CI failure is a defect in our
   automation, not a thing to discover remotely.
4. Push as follow-up commits on the PR branch. Do NOT force-push — child 2 already
   rebased; a force-push here would strand your siblings.
5. Update `journal/artifacts/pr910-panel-findings.md` with each item's disposition
   (fixed / refuted-with-reason / deferred-with-reason) and push that too.

## Definition of done

Every `must-fix` finding in the `git-and-docs` slice carries a disposition in the checklist; the code
changes are pushed and locally verified; the tada report lists what you fixed, what you
refuted and why, and anything you had to defer with the reason. Do not un-draft, do not
merge, do not re-run the panel.
