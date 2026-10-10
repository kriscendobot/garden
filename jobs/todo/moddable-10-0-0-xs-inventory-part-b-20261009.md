---
role: researcher
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-10T00:03:48Z cleared=none -->

---
role: researcher
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Moddable 10.0.0 XS inventory, part b

Research only; do not implement IronHorse ports. Scope: commits in Moddable-OpenSource/moddable between 2026-09-04 and 2026-10-08, ending at 5f215f776f93039755343dbe75a09aa2615045f4 (Moddable SDK 10.0.0 prerelease notes). For each item: relevant commit(s) with stable commit URLs, changed XS symbols/files, corresponding test262 test path(s) or spec expectation, concise behavioral expectation. Separate engine semantics from ECMA-419/device/Piu/board/TypeScript/xsdb work. Output a compact table, one row per item, as the completion report (durable artifact for successors). State uncertainties rather than guessing. Use the GitHub API/compare view or a shallow clone under $TMPDIR; do not do a full build.

Items: Math.round subnormals; Math.irandom integer math; charAt/charCodeAt 32-bit position truncation; String repeat/replace/search edge cases; the String.prototype.replace capture-group memory-safety fix; Symbol.for no-arg.

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-10-10T00:43:04Z -->
