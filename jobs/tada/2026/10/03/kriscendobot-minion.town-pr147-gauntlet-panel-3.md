Round 3 of the review panel on kriscendobot/minion.town PR #147 came back **must-fix**. I posted the verdict on the PR, and the next stage is the fix-loop.

**How it ran:** `panel.sh` ran in single-round mode on its own checkout of the PR head (`b93e5cc`), compared against the PR's frozen base `main-af7af61`. The PR changes only `designs/mcp-resources-getting-started.md`, which matches GitHub's file list, so the design panel (9 seats) ran. The critic seat timed out once after 1200s and passed on its second try. `panel.sh` exited 0 with the last line `design-panel single-round — must-fix`.

**Seat verdicts:** critic, skeptic, decomplector, copyeditor, pedant and novice asked for changes; the ergonomist left comments only; orthographer and thesaurus approved.

**Must-fix items:**
- **critic:** the build slices in § 8 are numbered as an execution order, but slice 4 says to capture the baseline *before* slice 2 deploys. Done in the listed order, the slice-2 deploy ships the guide first, and the before/after comparison in § 6.4 can't be made.
- **skeptic and decomplector:** § 4 promises "a pinned session never loses its files" because of a session idle timeout. `src/http.ts` has no such timeout. Even with one, a long-lived session could outlast the "newest five" copies and lose its files, and the design doesn't say what a read returns then.
- **novice:** "mount" / "mounted" is used throughout §§ 3.2–7 but never defined.
- **copyeditor:** § 3.1 says "three ways" and then lists five; a subject-verb agreement error in the § 3.2 table.

Several should-fix items are listed in the review as well.

**The review:** it went up as COMMENTED, not "request changes", because GitHub won't let the bot request changes on its own PR. The body carries the `<!-- disposition: must-fix -->` marker, a summary, and every seat's findings in full.

No garden code changed and nothing was committed.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr147-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (625681 cached reads)
- Output: 4602 tokens
- Cost: $0.6508802
- Wall-clock: 1911s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
