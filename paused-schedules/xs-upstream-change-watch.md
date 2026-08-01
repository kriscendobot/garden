cadence: weekly
last_dispatched: 2026-07-28T22:50:02Z
job_basename_prefix: xs-upstream-watch
---
WEEKLY XS-upstream watch → project engine-relevant changes to our Rust port (project
xs2rust-endor). Each dispatch is one engagement:

1. Determine the XS / Moddable version currently SYNCHRONIZED in endo — the moddable
   commit/tag that endo's xsnap package vendors (packages/xsnap; the recorded XS version
   / moddable pin). Read it from endo (read-only; the endojs/endo-but-for-bots fork or
   upstream endo).
2. Watch XS UPSTREAM (Moddable-OpenSource/moddable) release notes and the changes SINCE
   that synchronized version — new releases, tags, and commits to the XS engine
   (interpreter, bytecode, GC, parser/lexer, value/stack handling, JSON, typed arrays —
   the pieces the port reimplements). Read-only on upstream.
3. Identify which changes are RELEVANT to the Rust port (engine-semantics changes the
   Rust reimplementation must mirror to stay faithful). Ignore build-system, tooling,
   platform, and docs churn that does not affect engine semantics.
4. If there ARE new engine-relevant changes, POST A JOB (scripts/jobs/post-job.sh) to
   PROJECT them to the Rust port: name the specific XS commits/releases and what each
   implies for xs2rust-endor. Use a DETERMINISTIC basename keyed by the XS upstream
   range/sha (e.g. project-xs-changes-to-endor-<short-sha>) so a later week does NOT
   duplicate an already-posted projection; only post for changes not already tracked on
   the board / in xs2rust-endor.
5. If nothing engine-relevant is new since endo's synced version (or since the last
   projection), NO-OP: report "no new engine-relevant XS changes since endo's synced
   version <X>" and complete.

Bounds: read-only on Moddable upstream and endo; experiment only on bot forks; the
projection job targets the xs2rust-endor project. No upstream PRs or comments.
