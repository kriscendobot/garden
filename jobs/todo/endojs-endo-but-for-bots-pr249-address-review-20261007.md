---
role: fixer
tier: mentor
arc: unallocated
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-10-10T11:04:12Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Address the outstanding CHANGES_REQUESTED review on https://github.com/endojs/endo-but-for-bots/pull/249.

Unaddressed requests from review https://github.com/endojs/endo-but-for-bots/pull/249#pullrequestreview-5095793109:
- Refresh and pin the merge base to a current frozen `llm-<hash>` branch.
- Expand the design to cover shim implementation, compartment-mapper ramifications, and the IronHorse engine.
- Add hardened test262 cases to the design phase.
- Resolve the inline design directions: define `importNow` as returning after the first initialization turn while `import` awaits completed exports; design virtual module sources and synchronous/asynchronous initialization around the proposed import calling convention, checking the standards proposal naming.

Evidence: no commits address the review; the only later current-history commit is an empty CI nudge (`76d43d5c719e`). Preserve the row classification: arc unallocated, milestone -.
