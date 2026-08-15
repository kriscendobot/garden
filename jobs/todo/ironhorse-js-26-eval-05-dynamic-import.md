---
role: mentor
tier: mentor
handler-timeout: 10800
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=high at=2026-08-15T04:04:11Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 10800
tier: mentor

Repository: `endojs/endo-but-for-bots`. Continue shared branch `feat/ironhorse-262-language-completion` and draft PR https://github.com/endojs/endo-but-for-bots/pull/970. Use an isolated child-keyed checkout, fetch/rebase, preserve all commits, and CAS-push. Keep the PR open and draft.

Implement executable Module-goal coverage and dynamic `import()` against the official XS oracle. Extend the harness from compile-only module handling to fixture resolution, linking/evaluation, namespaces, cyclic graphs, import promises/job draining, import attributes/options as required by the pinned corpus, and host resolve/load failures. Implement `XS_CODE_IMPORT` and the required `import.meta` behavior with a deterministic per-case host loader rooted at test262 fixtures. Do not call module cases covered until both engines actually execute them.

Add focused oracle-backed Rust regressions using `corpora-modules` and test262 fixtures for fulfillment, rejection, caching/identity, cycles, namespace values, and meta. Run the official dynamic-import/module slices, workspace release tests, and exact-meter corpus before push. No host-only exclusion unless XS truly cannot be an authority and the report cites the governing specification. Report before/after totals/reasons, commands, SHA, and PR URL. Emit the orchestration-failure signal on a gated miss.
