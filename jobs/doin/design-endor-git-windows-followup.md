---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-09-16T10:39:07Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Follow-up: Windows (MSVC) support for endor-git bindings

Deferred follow-up requested in kriskowal's 2026-08-17 review of
endojs/endo-but-for-bots#987 ("Linux good enough at first pass. Post a
plan to follow-up about Windows.").

The `designs/endor-git-bindings.md` design ships GNU/Linux first and
explicitly defers native Windows artifacts. This plan tracks the deferred
Windows work so it is not lost:

- Decide the Windows ABI target: is the GNU (MinGW) ABI sufficient for the
  standalone binary via Zig cross-compilation, or must release engineering
  add native MSVC artifacts?
- Validate the libgit2 + `git2`/`libgit2-sys` vendored source build under
  Zig cc for the Windows target, and run the native-execution matrix on
  Windows before declaring the target supported (per the phased-delivery
  cross-build gate).
- Fold the outcome back into the design's "Resolved decisions" and the
  Verification gates / Phased delivery sections.

Promote when the GNU/Linux first pass has landed and Windows becomes the
next release target.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-16T10:39:20Z
