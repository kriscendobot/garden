---
gate: orchestrated
orchestrated_by: moddable-10-0-0-xs-source-inventory-20261009-split
priority: normal
posted_by: producer
posted_at: 2026-10-10T00:00:36Z
---

---
role: researcher
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Moddable 10.0.0 XS inventory, part b

Research only; do not implement IronHorse ports. Scope: commits in Moddable-OpenSource/moddable between 2026-09-04 and 2026-10-08, ending at 5f215f776f93039755343dbe75a09aa2615045f4 (Moddable SDK 10.0.0 prerelease notes). For each item: relevant commit(s) with stable commit URLs, changed XS symbols/files, corresponding test262 test path(s) or spec expectation, concise behavioral expectation. Separate engine semantics from ECMA-419/device/Piu/board/TypeScript/xsdb work. Output a compact table, one row per item, as the completion report (durable artifact for successors). State uncertainties rather than guessing. Use the GitHub API/compare view or a shallow clone under $TMPDIR; do not do a full build.

Items: Math.round subnormals; Math.irandom integer math; charAt/charCodeAt 32-bit position truncation; String repeat/replace/search edge cases; the String.prototype.replace capture-group memory-safety fix; Symbol.for no-arg.
