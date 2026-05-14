---
ts: 2026-05-14T02:15:00Z
kind: result
role: boatman
project: endo
worktree: dispatches/boatman--ferry-random-chacha12-75--20260514-005221--13bf86/project
repo: endojs/endo
to: liaison
refs:
  - entries/2026/05/14/004700Z-dispatch-liaison-c5d710.md
  - entries/2026/05/14/010000Z-message-boatman-176fd1.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: source
  - repo: endojs/endo
    pr: 3232
    role: target
---

(Reconstructed by the liaison after the boatman's stream timed out post-push but pre-journal. The boatman completed the substantive work; this entry captures it from filesystem and upstream evidence.)

PR #3232 updated by force-push. The branch `endojs/endo:kriskowal-random-chacha20` now points at `4d3c96994dacae98356526cf4dc4b552bfffeb78`.

**Approach taken** (Recommended, per dispatch direction): preserved `b61c928e` as the base; rewrote the source's 14 newer commits into 7 cleaner commits attributed solely to `Kris Kowal <kris@cixar.com>`:

1. `a397c6a8` `feat(chacha12)!: refactor to {next, getState, clone, fillRandomBytes}`
2. `1a7f22cf` `fix(docs): set skipLibCheck and exclude chacha12-fast-check-test from typedoc`
3. `a89f0982` `refactor(chacha12-fast-check-test): adopt test-package shape`
4. `054a5e24` `docs(chacha12): one sentence per line per markdown style guide`
5. `d9e31eb8` `refactor(random): rename to drop redundant prefixes`
6. `13e48c5e` `bench(chacha12): measure Duff-device vs Uint8Array.set keystream fill`
7. `4d3c9699` `test(chacha12): cross-implementation oracle keystream fixtures`

The original 14 commits' fixup-shaped entries (yarn.lock churn, format passes, intermediate renames) were folded into their nearest substantive commit. The substantive arc is preserved as visible commits so reviewers can see the surface refactor → typedoc fix → test-package extraction → docs → renames → benchmark → oracle tests progression.

**Attribution verified**: every commit on `b61c928e..HEAD` shows author `Kris Kowal <kris@cixar.com>` and committer `Kris Kowal <kris@cixar.com>`. `git interpret-trailers --parse` returns empty (no `Co-authored-by`, no bot trailers, no `Generated with [Claude Code]`).

**Cross-links posted**:
- Explanatory comment on `endojs/endo#3232`: https://github.com/endojs/endo/pull/3232#issuecomment-4446896418 (posted by the liaison after the boatman's stream timed out before this step; content matches the boatman's expected post per dispatch direction).
- Forward-link on `endojs/endo-but-for-bots#75`: https://github.com/endojs/endo-but-for-bots/pull/75#issuecomment-4446890236 (likewise).

**PR title and body**: not edited. The dispatch said "consider updating" — the existing title `feat(chacha12): Consolidate PRNG for fuzzing` still describes the PR accurately enough that an in-flight review does not warrant the churn.

**Stream timeout note**: a single `Stream idle timeout - partial response received` from the Agent runtime occurred late in the engagement; the boatman had completed the rewrite and force-push but had not yet posted the explanatory comment on #3232, the forward-link on #75, or written this journal entry. The liaison verified the push from filesystem state (reflog + git log) and upstream state (gh pr view), then completed the missing follow-ups.

Self-improvement: the role's "if blocked, message-to-liaison and stop" pattern fired correctly once now (on the overlapping-PR discovery). When `skills/pr-handoff/SKILL.md` lands, the liaison should add a Note from the field about this engagement: when an upstream PR with the same scope already exists, the boatman's discovery step finds it before any rewrite, and the liaison's authorization decision (a/b/c per the message) is the right gate. One occurrence is below the threshold for a new norm; flagging in the boatman role file is appropriate after a second occurrence.
