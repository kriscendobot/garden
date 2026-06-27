Completed the job. Concise report follows.

---

**Job `scholar-author-concept-endoclaw` — complete.**

**What I did**
- Authored `library/concepts/endoclaw.md` from the parent source (`…endoclaw.md`, the OpenClaw-parity Reference design) and `…endoclaw-six-design-cluster.md`. The page opens with a specific abstract per `context-library`: what "endoclaw" names (OpenClaw / ClawdBot / Moltbot feature parity for an Endo-confined agent), the load-bearing **ambient-authority vs. object-capability** anchor, the shared two-facet control-pair template, a 12-row member-designs table, and the recurring **capability vs. design-pattern vs. UI-feature** classification (network-fetch / oauth / browser / webhooks / notifications / timer / skill-registry / channel-bridges = capabilities; proactive-messages = a composition pattern; voice = a UI feature). Twelve member sections cross-linked; See-also to object-capability, caretaker-pattern, distributed-confinement.
- Added 8 `keywords.md` rows → concept-id `endoclaw`, and the `concepts/README.md` index row.
- Light-cleaned the **10** residual verbatim `](endoclaw.md)` section-body links (9 endoclaw-cluster sections + 1 endopi cross-ref) to `](../concepts/endoclaw.md)`.

**Verification**
- `library-link-check.sh --all`: **zero** `endoclaw.md` dangling links — the cluster is cleared.
- `--files concepts/endoclaw.md`: all of the new page's outbound links resolve (OK).
- 166 unrelated library-wide dangling links remain (pre-existing standing-scan backlog, out of scope).

**Landing**
- Committed on a fresh detached worktree off `origin/journal2`, rebased onto tip, fast-forward pushed as `9840fa1db` to `journal2` (bot identity `endolinbot`). Did **not** touch the live `journal/` worktree. Posted a `result` journal entry (`111304Z-result-scholar-c0f1ba.md`). Worktree torn down. Inbox empty.

**Follow-ups:** none for endoclaw; the 166 residual dangling links are a separate repair backlog.
