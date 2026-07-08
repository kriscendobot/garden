Empty inbox. The job is complete. This job mutated only the project repo (both PRs pushed); my garden worktree has no `main2` changes to commit.

Summary of what I did:

## Completion report

**Job:** attention directive from @kriskowal on endojs/endo-but-for-bots #632 — "apply to #631 #630" the permission @erights granted in issue #632.

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (no prior peer resolution) → proceeded.

**Context:** Issue #632 is Mark S. Miller (@erights) granting @kriscendobot standing permission to reuse/adapt/derive-from his public texts, on the sole condition that adaptations keep making clear they are *derived from* the original but *are not* the original. Both #630 (Grant Matcher Puzzle translation) and #631 (thesis-translation design) were drafts explicitly gated on exactly this author permission. The garden's own standing-permission record already landed on main2 (commit `7aa0b6b21`); this job applies the grant to the two project PRs.

**Changes (project repo, isolated per-branch worktrees):**
- **#630 `docs/grant-matcher.md`** (branch `docs/grant-matcher-puzzle`, commit `1146118c6`): replaced the "Licensing is unresolved / do not merge" attribution block with a record of the granted permission and its one condition (citing #632), noting the page already honors it and continues to cite the original on erights.org as authoritative.
- **#631 `designs/thesis-translation.md`** (branch `design/thesis-translation`, commit `e9a0e51d8`): recorded the grant in § Provenance, marked Open-question 1 (publication gate) **RESOLVED**, and updated the intro and draft-status notes so a phase PR no longer waits on the permission question — only on the remaining open questions.

Both pushed cleanly to their head branches (CAS push loop, bot identity).

**Judgment call:** I did **not** un-draft or merge either PR. The directive was to *apply* the grant, and each PR carries other unresolved reasons to stay draft (category placement + unrun docs build on both; ferry intent + URL shape on #631). Un-drafting is a larger, separately-authorized action; I documented the remaining draft reasons in each PR comment.

**Acknowledgment:** `+1` reactji on kriskowal's directive comment; a record comment posted to each PR (#630 and #631) noting what changed, that the permission gate is resolved, that erights.org citations are retained per kriskowal's note, and which draft reasons remain.

**Follow-ups (not in scope here):** resolving the remaining open questions (ferry, URL shape, category) and a verified docs build before either PR leaves draft.
