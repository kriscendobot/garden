---
ts: 2026-06-17T20:03:40Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/17/195920Z-dispatch-liaison-04eddf.md
---

First-time ferry of `endojs/endo-but-for-bots#435` (MERGED, the "drop the
pseudo-prototype intrinsic" redesign for `@endo/immutable-arraybuffer`) to a
new upstream PR. Multi-author salvage shape: every commit authored by
**Mark S. Miller <erights@users.noreply.github.com>**, committed by **Kris
Kowal <kriskowal@kriskowal.com>** (no `--reset-author` to kriskowal).

- **Upstream PR**: https://github.com/endojs/endo/pull/3308 (ready-for-review, not draft).
- **Branch / head**: `erights-immutable-arraybuffer-drop-pseudo-prototype` @ `1b8384d51`.
- **Base**: upstream `master` (was `a0f5d95ac` at open; verified live via `git ls-remote`).
- **Source**: `endo-but-for-bots#435` head `b1eceee2b`, base `4a04d078b` (an endo-master ancestor). Net diff applied cleanly onto current master with zero overlap, as predicted.

Logical series (4 commits, restaged from the 22-file net diff; content unchanged, regrouped + re-authored):

1. `925a74461` feat(immutable-arraybuffer)!: drop the pseudo-prototype; inherit from ArrayBuffer.prototype — `packages/immutable-arraybuffer/**` + `.changeset/drop-the-pseudo-prototype.md`.
2. `7d6f47d98` refactor(bytes): convert via the prototype method instead of the free function — `packages/bytes/src/to-immutable.js`.
3. `6d696e686` feat(ses): drop the %ImmutableArrayBufferPrototype% intrinsic and permits — `packages/ses/**`.
4. `1b8384d51` fix(pass-style): align byteArray brand check with the new immutable prototype shape — `packages/pass-style/**`.

All four: author `Mark S. Miller <erights@users.noreply.github.com>`, committer `Kris Kowal <kriskowal@kriskowal.com>`.

Verification:
- **Net-diff fidelity**: `diff <(git diff origin/master..HEAD) <(git diff 4a04d078b b1eceee2b)` byte-for-byte identical.
- **Trailers**: `interpret-trailers --parse` empty on all four; grep for claude/anthropic/generated/Co-Authored/fork-refs returns nothing.
- **Mergeable**: `MERGEABLE`, `isDraft: false`.
- **CI**: no checks reported yet at ferry time (just opened); shepherd handles CI follow-up.

Cross-link: created garden-side mirror comment on `endo-but-for-bots#435`
(`Mirror of https://github.com/endojs/endo/pull/3308 (head 1b8384d51).`),
comment id **4734718401**. No prior `Mirror of ` comment existed. No
upstream-side comment posted (per the 2026-05-29 directive). No comment on
`endojs/endo` under kriskowal.

Note: `packages/immutable-arraybuffer/DESIGN.md` (source content, preserved
verbatim) contains an oblique fork-side allusion ("the predecessor pull
request ... referenced in the comment whose identifier appears in the project
log"); it names no fork number and is part of the merged source body, so it
was left unaltered per the net-content-invariant rule. The boatman's
fork-ref discipline governs commit messages and the PR body, both of which
are clean.

Self-improvement: nothing this time. The dispatch prompt was unusually
complete (explicit per-commit author/committer formula, suggested grouping,
verification gates, net-content-invariant) and the multi-author salvage case
plus the source-content-vs-commit-message distinction are already documented
in `skills/pr-handoff/SKILL.md` § Attribution → Multi-author case and § Body
edits.
