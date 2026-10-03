---
role: web-designer
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-10-03T06:16:11Z cleared=none -->

---
role: web-designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

---
role: web-designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Garden book: integrate the Codex-generated illustrations and publish

**Repo update (2026-10-01): the book now lives at
[kriscendobot/garden-book](https://github.com/kriscendobot/garden-book)**,
not in the journal. Read `journal/projects/garden-book/README.md` for the
project's rules of engagement, and `build/README.md` in the repo for the
build/publish mechanics and current edition.

You were promoted because `book-codex-illustrations` reached `tada/` — that
means its PR is *open*, not necessarily *merged*, and it ran independently
of (possibly in parallel with) `book-title-audience-pass`, which may not
even have finished yet. **Do not build from an unmerged or partial state.**
This is the same "wait for the real artifact, not just a job's completion"
shape as `skills/chained-followup/SKILL.md` — apply it here across two
predecessor PRs instead of one.

## Task

1. **Find both PRs.** Read `book-codex-illustrations`'s `jobs/tada/` report
   for its PR URL. Read `book-title-audience-pass`'s `jobs/tada/` report for
   its PR URL — if that job hasn't completed yet at all, this counts as
   "not ready," same as its PR being unmerged (see step 3).
2. **Check both PRs' real state**, each via `gh pr view <url> --json
   state,mergedAt,isDraft` — never assume from either job's mere completion.
3. **If either is missing (job not done yet) or open (PR not merged):**
   park a notice that waits for whichever is NOT ready yet (prefer blocking
   on the unmerged PR's URL directly if you have it — `blocked_on` resolves
   on either merge or close for a PR URL — or on the job's own basename if
   it hasn't completed at all yet), with a body that repeats this same
   three-step check when promoted. Do not proceed past this step on a guess.
   If a PR was closed without merging, message the maintainer inbox
   (`scripts/jobs/message-user.sh <this-job-base>`) naming which one and
   stop that thread — don't build from a declined PR's sibling alone without
   flagging it.
4. **Once both are confirmed merged:** proceed. Read `art/MANIFEST.md` and
   every asset it lists. **Integrate the art with judgment, not by pasting
   everything in.** The prior design pass already established a
   Tufte-influenced, garden-book-inspired visual language (restrained, high
   data-ink-ratio, earth-and-leaf palette) — these new illustrations should
   extend and harmonize with that, not compete with it or clash in
   color/tone. Decide which pieces actually earn a place (title page
   background, chapter dividers, a body-background texture, a figure placed
   where it genuinely adds something) versus which should be left unused
   because they don't fit well once you see them in context. Cite which you
   used and why, and which you skipped and why, in your completion report.
5. **Keep it inline and same-origin.** Fold the assets into `styles.css` /
   the HTML generation in `build.py` as inline markup, not as separate
   fetched files (the clip's CSP is same-origin only — see
   `skills/minion-town-clip-publishing/SKILL.md` for the exact constraint).
6. **Don't regress readability or the phone-width layout.** Background art
   behind body text needs to stay low-contrast enough that text stays
   genuinely readable; check phone width too, the way the original design
   pass did.
7. Commit this integration work on its own branch/PR against `main` (same
   one-PR-per-job convention) **or**, if it's a small enough change that the
   project's rules of engagement would call it routine, use your judgment —
   but either way, once the integration is actually on `main`, run the
   build/publish steps in `build/README.md` yourself (this is the step that
   finally produces a new live edition, which is why everything above had to
   be confirmed merged first) and update its Edition line (keep prior
   editions listed as history). Report the new URL, which illustrations you
   used and where, and which you left out, in your completion report and
   via `scripts/jobs/message-user.sh <this-job-base>`.


## Re-park note (2026-10-03, prior claimant of `book-illustrations-integrate`)

Checked at promotion: `book-title-audience-pass` → PR
https://github.com/kriscendobot/garden-book/pull/3 is **MERGED**
(2026-10-03T05:29:31Z). `book-codex-illustrations` → PR
https://github.com/kriscendobot/garden-book/pull/4 was still **OPEN (draft)**,
its gauntlet in flight, so this job was re-parked blocked on #4. When promoted,
re-run the three-step check above anyway (#4 may have been *closed* rather than
merged — in that case message the maintainer and stop, per step 3).
