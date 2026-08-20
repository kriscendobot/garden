once: 2026-08-22T04:10:00Z
job_basename_prefix: build-endor-git-bindings-zig
---
---
role: builder
target: endojs/endo-but-for-bots@llm
posted_by: liaison (interactive session, maintainer-directed, deferred dispatch)
posted_at: 2026-08-20 (scheduled 2026-08-19, fires 2026-08-22)
---

# Build: Endor libgit2 bindings with Zig cross-builds

Source: maintainer (kriskowal) comment on the merged design PR —
https://github.com/endojs/endo-but-for-bots/pull/987#issuecomment-5337796794
(verbatim: "Please post a builder to attempt this next week, after the quota
reset on Friday at 9pm.") This job was deliberately held and dispatched by
the schedule skill to fire only after that quota reset, per the maintainer's
own timing instruction — do not treat the delay as neglect if you're
auditing job-age.

## What to build

PR #987 ("design(endor): bind libgit2 with Zig cross-builds",
`design/endor-git-bindings-zig` → merged to `llm` at `d165f03d9`) revised
`designs/endor-git-bindings.md` to make pinned, statically linked libgit2
the shared implementation seam with Minion Town: safe Rust + FFI boundaries,
the Minion CAS/SQLite adapter contract, and a Zig cross-build + native-run
matrix for Windows/macOS/Linux. Its own "Upgrade Considerations" section
states plainly: "Design only. A later builder introduces the new crate and
release lanes." — that builder is this job.

Read `designs/endor-git-bindings.md` on `endojs/endo-but-for-bots@llm` in
full before starting; it is the authoritative spec (Security/Scaling/
Testing/Compatibility considerations sections in the merged PR body are a
summary, not the full design). It back-references
https://github.com/kriscendobot/minion.town/blob/main/designs/git-remote-capability.md#5--research--how-much-of-gits-wire-protocol-and-the-prior-art
for the pluggable-ODB / Git-server research context — read for grounding,
not as a dependency to build.

Per the design's own Testing Considerations, the deliverable needs: shared
filesystem + custom-backend conformance suites, stock-Git protocol
transcripts from Minion Town, native execution on every release target,
linkage audits, sanitizer coverage, and reproducibility checks. Scope the
first PR to the smallest coherent vertical slice if the full matrix doesn't
fit one build (mirrors how PR #48/#49 scoped git-content-substrate) —
state explicitly in the PR body what's deferred and why, rather than
silently shipping a partial matrix.

## Process

Standard builder flow — the draft PR auto-runs the gauntlet (clean → panel
→ fix-loop → un-draft; CLAUDE.md § Orchestrator vocabulary, *build #N*). Do
not treat this as a probe (`gap-revealing-build`) unless you find the design
underspecified enough that a probe is the right call — the design reads as
build-ready, not tentative.
