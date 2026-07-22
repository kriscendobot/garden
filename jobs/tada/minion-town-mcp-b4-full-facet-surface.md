Implemented and pushed B4 on PR #19: full guest facet tools, evaluator-only `guest_eval`, `mcp/guest` authorization wiring, and TTL suspension coverage.

Validated deployed edge: two Cognito identities had isolated directories; suspension denied the same session after 61.0s. Temporary validation scopes/accounts were restored. PRM advertises `mcp/guest`.

Local verification: typecheck, build, and Vitest: 136 passed, 3 skipped.
