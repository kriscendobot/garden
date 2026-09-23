Restacked #702 onto bridge-3 `ff9f25c73`; pushed new draft head `67ba9519e` and commented on the PR.

Resolved the type conflict, retained the camelCase `sturdyRef` assertion, and skipped two commits already upstream.

Passed: daemon focused suites (26), sturdyref shim (8), pass-style (10 x3 configs), OCapN suites (26 x3 configs), TypeScript, ESLint (0 errors).

Blocked: daemon facet-boundary integration test cannot create its Unix socket because the isolated worktree path exceeds the kernel socket-path limit.
