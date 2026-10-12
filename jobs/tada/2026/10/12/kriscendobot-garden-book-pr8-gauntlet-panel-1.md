I ran panel round 1 on kriscendobot/garden-book PR #8 and posted the verdict: **must-fix**. I did not fix anything, un-draft the PR, or run a second round.

- **Run:** `panel.sh` ran in single-round mode on an isolated checkout of `book-reader-exposure-copyedit` at head `2d0cc32`. I compared against the PR's real merge-base SHA (`e6f2790…`) instead of the frozen branch name `main-e6f2790`. All seats completed and `panel.sh` exited 0. The PR-body concision probe also fired, so the pruner reviewed the description too.
- **Must-fix (archivist seat):** ch8 § 8.7 still says `roles/accountant/` doesn't exist, but it now exists on `main2`. The PR's own `editorial/reader-exposure-map.md` already flags this as stale.
- **Should-fix:**
  - The typist seat found typist-hostile characters `→` and `×` in `editorial/reader-exposure-map.md`.
  - The pruner wants the "What changed, by chapter" and "The ledger" sections of the PR description trimmed.
  - The corner-prober wants the target document named next to a bare "§ Addendum" in ch3, and a check that "the audit" in ch8 is introduced before it is first referenced.
- **Other seats:** The archivist also flagged a possible wrong location for the "conductor" entry in the exposure map. Everything else was comment-only or approve.
- **Review posted as a comment, not request-changes:** GitHub refuses request-changes on a PR the bot opened itself. The review states "Disposition: must-fix" and "treat this as REQUEST CHANGES" at the top. It was submitted 2026-10-12T19:43:53Z. The panel aggregate is posted in full under that header.
- **Issue references:** The bot's `gh` wrapper blocked the first post because the text had bare `#N` references alongside another repository's name. I put them in backticks so they don't link.

**Follow-ups:**
- The fix stage needs to know the panel verdict on this PR is a COMMENTED review, not CHANGES_REQUESTED. Bot-authored PRs will always hit this.
- Several seats asked for confirmation that the build never renders `editorial/`. The assessor checked: the build only picks up `chapters/ch*.md` files, so it holds.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-book-pr8-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1103274 cached reads)
- Output: 4966 tokens
- Cost: $0.8643268
- Wall-clock: 181s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
