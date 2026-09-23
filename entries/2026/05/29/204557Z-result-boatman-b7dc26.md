---
ts: 2026-05-29T20:45:57Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/05/29/204257Z-dispatch-liaison-47755a.md
---

Shape-2 re-ferry of endo-but-for-bots#244 onto the existing upstream PR endojs/endo#3263 (force-push to `kriskowal-eslint-numeric-separators-style`). The change adds eslint-plugin-unicorn's `numeric-separators-style` to the `@endo/internal` preset plus the 47-file autofix migration.

**Conflict-handling outcome: CLEAN.** The 9-commit range (`master-814dfa1`..`63a1a6068` on the source) cherry-picked onto current `origin/master` (`c49fb048b`) with zero conflicts. The byte-for-byte net-diff comparison confirms why: `diff <(git diff origin/master..HEAD) <(git diff base..source)` returned 0 lines, so master gained no overlapping edits in the touched files since the frozen base. No mechanical autofix re-run was needed; the recompute is a pure attribution rewrite of identical content.

**Attribution + trailers.** All 9 commits normalized to author AND committer `Kris Kowal <kriskowal@kriskowal.com>` (source mixed `endolinbot <main.barn5084@fastmail.com>` and `kris@cixar.com`). The `(#244)` suffix stripped from the syrup-frame subject. Per-commit `interpret-trailers --parse` empty on every commit; no Co-Authored-By / Generated-with-Claude-Code trailers present in any body.

**Net-diff / file-set vs source: identical.** 47 files, +468/-99, matching `gh pr diff 244` intent exactly (line numbers identical too, since the base content of touched files was unchanged on current master).

**Force-push:** `+ 512438a27...46de1875b HEAD -> kriskowal-eslint-numeric-separators-style (forced update)`. New upstream head `46de1875b`. Lease target `512438a275bbcebdaa81eafa34c324af22f5197a` matched #3263's prior head.

**Post-push state:** `mergeable: CONFLICTING → MERGEABLE` (cleared as expected). `reviewDecision: REVIEW_REQUIRED` unchanged; only a `turadg` COMMENTED existed (no approval to dismiss). PR remains OPEN, non-draft. CI freshly triggered, all checks pending at report time (run 26661285543 et al.); shepherd handles CI follow-up.

**Garden-side cross-link (CREATED):** `Mirror of https://github.com/endojs/endo/pull/3263 (head 46de1875b).` on endo-but-for-bots#244, comment id 4579718869, https://github.com/endojs/endo-but-for-bots/pull/244#issuecomment-4579718869. No prior mirror comment existed. Upstream-side symmetric cross-link handed to steward via the message entry below (no steward this session; recorded for the next cycle).

Title and body of #3263 left unchanged (same change, same shape).

Self-improvement: nothing this time.
