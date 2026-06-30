Inbox is empty; work is complete. No garden-repo (main2) changes were warranted — this was a PR-review-comment directive routed to upstream design-doc work.

---

## Completion report — job `endojs-endo-but-for-bots-pr544-48da5b1e`

**Directive:** `attention` routed from an erights pr-review-comment (`r3496093493`) on `endojs/endo-but-for-bots#544` (the *Intra-Package Plain Re-Exports* design PR, draft, bot-authored). erights' point: the rule's protected surface is more general than `./index.js`/barrels — it is **all** modules a package's `package.json` `"exports"` map reaches; those surface modules must not be changed in this PR, and **none of their exports may be deprecated** by the refactor.

**Assessment:** PR #544 was under live, rapid line-by-line review (four gardeners alive on it concurrently; the branch advanced mid-job). The *generalization* half of erights' point was already banked earlier today (commit `d87ab191b`, restated through `6c81706d`): the *What the rule does not touch* section now frames the surface as "the whole `"exports"` map." The one genuinely-uncovered nuance was erights' explicit word **deprecate** — the doc stated "stays exactly as declared" and "never removes," but did not crisply rule out *deprecation* of surface-module exports.

**What I did:**
- Made a surgical one-clause edit to `designs/intra-package-plain-re-exports.md`: the public surface "stays exactly as declared: this refactor neither removes a surface module nor deprecates any export it provides." Pushed to the PR branch as commit **`ff8e7c20c`** via a rebase-retry CAS loop (landed on attempt 1, cleanly on top of two peers' concurrent commits — no conflict; a peer separately handled the line-45 run-on-sentence comment as `2086b493f`).
- Posted an inline reply to erights' thread (`r3496112129`) acknowledging both points and citing where each is now stated, following the thread's established one-reply-per-point convention.

**Deliberately skipped:** a top-level completion-summary comment. The PR is in an active multi-agent inline dialogue where each erights point gets a single anchored reply; a per-gardener top-level summary would be redundant noise. The inline reply is the correct, established acknowledgment channel here.

**No garden (main2) changes** — all work was upstream on the endo-but-for-bots PR branch.

**Follow-ups:** none owed by me. The doc's substance now fully reflects erights' comment; the remaining open review items on #544 (if any) are owned by the peer gardeners alive on their own comment jobs.
