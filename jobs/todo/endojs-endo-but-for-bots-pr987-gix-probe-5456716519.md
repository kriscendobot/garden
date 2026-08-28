---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=high at=2026-08-28T19:19:11Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Probe: implement the Endor Git seam with gix for a side-by-side backend comparison

Repository: `endojs/endo-but-for-bots`.

Source directive: https://github.com/endojs/endo-but-for-bots/pull/987#issuecomment-5456716519

This is one of two parallel, gap-revealing builder probes. Implement the `gix`
variant independently so the maintainer can compare it with the sibling
`libgit2` probe. Follow `skills/gap-revealing-build/SKILL.md`: open a DRAFT probe
PR, keep it draft, do not start the normal gauntlet, and make the gap report the
primary deliverable.

Use current `llm` as the common source baseline, including the merged PR #987
design (`designs/endor-git-bindings.md`) and the merged PR #872 Phase 1 gix work.
Preserve useful existing work, but attempt the same practical seam and test
surface as the libgit2 variant wherever gix permits it. In particular, examine
filesystem object/ref storage, a capability-selected custom object/reference
backend, SHA-1 and SHA-256 behavior, reference compare-and-swap, bounded blocking
execution, and the authority boundary. Do not silently substitute a different
contract when gix lacks a stable mechanism: stop at the ambiguity or library gap
and record it in the structured report.

Cross-platform artifacts are a load-bearing output. Attempt native and cross
builds for the repository's supported Linux, macOS, and Windows targets as far
as available infrastructure permits. Record, in a dedicated `Backend comparison`
section in the PR body and completion report, the exact matrix of:

- target triple and host;
- compile, link, native-run, and cross-run result;
- produced artifact type, size, dynamic dependencies, and bundled/native code;
- toolchain, SDK, runner, or linker prerequisite;
- reproducibility and sanitizer/audit result;
- first failure point and whether it is backend-specific or infrastructure-only.

Also report dependency graph/build time, unsafe-code or FFI surface, binary-size
impact, supported Git features needed by the common seam, and implementation
complexity using concrete counts where practical. Cite commands and observed
output for every claim described as verified. Existing PRs #872 and
`kriscendobot/endo-but-for-bots#4` are prior art, not substitutes for this
comparable probe artifact.

Use an isolated project worktree keyed by this job base and use
`scripts/jobs/gardening/ensure-pr.sh` for PR identity. If a platform cannot be
executed on available runners, preserve the build attempt and report it as not
verified rather than inferring runtime support.
