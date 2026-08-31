CI is green. The fix stage is complete.

## Completion report

**Job:** endojs/endo-but-for-bots PR #241 gauntlet — FIX round 3 (design `designs/familiar-run-apps-vfs.md`).

**Panel-3 verdict (must-fix):** request-changes from critic, skeptic, ergonomist, pedant; comment-only from decomplector, copyeditor, novice. I applied every request-changes finding plus the cheap copyeditor flow fix.

**Changes pushed** (commit `e5a582bdb`, follow-up on head `design/familiar-run-vfs-apps`):

- **critic/skeptic — schema-sharing contradiction:** dropped the "The schema is shared" claim in § Endor cross-references; it violated `registry-capability.md` § Non-Goals. Rewrote to state the two lanes meet only at the `EndoRegistry` capability shape and CAS contents, never at the SQLite schema.
- **critic/skeptic — mis-cited spawn/relay mechanism:** retargeted Case 2's supervisor/spawn citations off `daemon-endo-rust-sqlite.md` (which contains zero "unconfined") onto the real owners — `daemon-endor-architecture.md` § Worker platforms (the `"node"` platform, fd 3/4 CBOR relay) and `daemon-make-archive.md` §§ Phase 6/8 (host-side `makeUnconfined`/`makeUnconfinedFromTree`). Added `daemon-make-archive.md` to Dependencies and corrected the two existing Dependency rows.
- **skeptic — false "no Rust equivalent" claim:** rewrote § Divergence to say Case 2 *wraps* endor's existing `"node"` worker platform, adding only eject-to-scratch + re-eject discipline.
- **skeptic — Alternatives #2 self-contradiction:** added a paragraph explaining why that rejection (Case-1-scoped) does not carry to Case 2 (directory-walking is the requirement there; scratch-dir reuse is governed by § Re-eject discipline).
- **skeptic — test-catalog gap:** added four Case 1 acceptance tests (re-walk-to-fixed-point, unsatisfiable `(name,major)` fail-closed, unprovided-peer fail-closed, missing-optional runtime error).
- **ergonomist:** reconciled the `endor run`/`endo run` verb collision (same dispatch aliased across Rust- and Node-hosted lanes); gave Case 2 a uniform `@endo/errors`-shaped failure matching Case 1 (updated § Shape step 4, the exit-code test, and a new "Uniform failure shape" note); specified the Lal-caplet guest authorization surface via a new § Guest access subsection forward-referencing `lal-fae-form-provisioning.md`.
- **pedant/copyeditor:** normalized British `-ise/-ised` spellings to the American corpus default, fixed `re-used`→`reused`, and de-wedged the Case 2 supervisor definition from its connective.

All 15 design cross-references still resolve; README "Updated" date already 2026-08-31.

**CI:** GREEN — 5/5 checks, 0 failed (`ci-wait-merge` rc 0, `--no-merge`).

**Follow-ups:** none. The should-fix items from the comment-only jurors (decomplector's copy-on-reuse argument, novice's glossary-ordering, several copyeditor sentence-splits) were not addressed as they are non-blocking; the driver re-posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr241-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 98 tokens (4029120 cached reads)
- Output: 26179 tokens
- Cost: $3.651947
- Wall-clock: 768s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
