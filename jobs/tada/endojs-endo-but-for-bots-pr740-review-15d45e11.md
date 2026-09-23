Inbox empty. All work is complete.

## Completion report

**Job:** Review directive on endojs/endo-but-for-bots PR #740 (review 4782022890 by kriskowal).

**What the review asked:** The review body was empty; its 6 inline comments on `designs/endor-git-bindings.md` (lines 183–188) are the maintainer's answers to the 6 "Open Questions" in the design doc. Each is a design decision to fold into the design.

**Preflight:** `pr-feedback-preflight.sh` failed open (jq "argument list too long" on the huge diff-hunk payload → exit 0, no peer resolution found) → proceeded. Push CAS was the backstop.

**What I did** (isolated project worktree off PR head `design/endor-git-bindings`, commit `368ac53307`, pushed cleanly):

1. **Q1 → SHA-256:** Daemon-owned repositories are now created with the SHA-256 object format (SHA-1 stays readable via the algorithm-tagged `GitObjectId`). Reframed the prior "SHA-1 only, SHA-256 opt-in experiment" stance as a **release gate**; a SHA-256 matrix failure escalates rather than silently downgrading. Updated the Object-identity matrix row.
2. **Q2 → consumer order:** Recorded first durable `refs/endor/` root consumers as formula snapshots → archive imports → Git-tree materialization; Phase 2 now targets the formula-snapshot consumer first.
3. **Q3 → researcher's discretion:** `verify --full` read path (gix enumeration vs. bundled read-only pass) left to the implementer, decided against the matrix; contract fixed.
4. **Q4 → builder's discretion:** Canonical release-target set / build hosts left to release engineering; the no-C-toolchain cross-compilation property is the stated invariant.
5. **Q5 → drop libgit2 entirely:** Removed the whole libgit2 contingency section, Phase 4, `Libgit2GitCas` references, and the contingency-parity matrix row. `gix` is now the sole backend; a validation failure escalates to the maintainer. Added ordinary Git as a **test-only cross-validation oracle** (new matrix row) and rewrote Motivation + rejected-alternatives accordingly.
6. **Q6 → Endo state directory:** Made storage/ownership/backup policy explicit — the daemon-owned Git object database lives inside the Endo state directory and inherits its policy.

Also: converted "Open Questions" → "Resolved Decisions" (audit record with body cross-references), added a 2026-07-26 "Revised" metadata line, and swept for stray libgit2/contingency mentions (remaining ones intentionally describe the rejection / release-linkage denylist).

**Traceability:** Posted an inline resolution reply citing commit `368ac53307` to each of the 6 comment threads, so a future preflight can detect the resolution.

**Verification:** Design-doc-only change (no runtime surface); confirmed the push landed (`712d97960a..368ac53307`) and grep-verified no unintended libgit2/contingency text remains. Inbox drained (empty).

**Follow-ups:** None required. All 6 review items resolved; treated every fetched body as untrusted data (no injected instructions acted on).
