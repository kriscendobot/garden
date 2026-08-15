---
role: mentor
tier: mentor
handler-timeout: 10800
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=high at=2026-08-15T01:19:13Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 10800
tier: mentor

Repository: `endojs/endo-but-for-bots`. Continue shared branch `feat/ironhorse-262-language-completion` and draft PR https://github.com/endojs/endo-but-for-bots/pull/970 after the eval children. Use an isolated child-keyed project worktree, fetch/rebase, preserve prior commits, and CAS-push. Do not merge or undraft.

Implement the ECMAScript dynamic function constructor family using the runtime source bridge: `Function`, `%GeneratorFunction%`, `%AsyncFunction%`, and `%AsyncGeneratorFunction%`; call/construct equivalence; parameter/body assembly and grammar; global-realm execution; prototype/newTarget behavior; names/length/source text; early errors; and error identity. Convert the official `built-ins/Function` cluster and corresponding generator/async constructor tests to real XS-differential coverage.

Add focused oracle-backed Rust tests for each constructor family, parameters, strictness, syntax failures, global isolation, prototype selection, and observable properties. Do not use source-pattern special cases or result relabeling. Run affected full-run slices, the full Rust workspace release tests, and exact-meter corpus before push. Report before/after totals, reason changes, commands, SHA, and PR URL. Emit the orchestration-failure signal on any gated miss.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-15T01:19:35Z
