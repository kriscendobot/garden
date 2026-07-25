---
role: fixer
---

Panel findings for https://github.com/kriscendobot/finbot/pull/4 (head 895ae4822d3c0f36c4026c9bcbddcbcc59f81c62; diff base origin/main) require changes.

The resumed code-panel evidence contains 16 completed seat blocks and multiple request-changes / must-fix findings. Address these in-scope security and correctness defects, then run relevant tests and push to the existing head branch:

- packages/harness/sandbox/permissive.js:203 returns a live compartment-authored object into the host. Copy and validate the return at the boundary before spawn.js reads content, tool names, or tool arguments. Add regression coverage for malformed/getter or proxy-shaped returns.
- Do not transitively harden live host console and fetch endowments, since this can freeze host process state. Vend suitably attenuated capabilities or adjust the hardening boundary.
- Reassess errorTaming: unsafe now that untrusted role programs execute in the compartment.
- Cover new error paths: invalid/non-function source, invalid source syntax, non-serializable input, and unavailable requested tools. Define a BigInt-safe boundary representation or a precise error path for finbot amount-bearing messages.
- Align whitespace-only llmProgram validation between schema and runner, and avoid duplicated input global plus function-argument delivery unless both channels are justified.

Do not merge. Report the commit SHA and real test evidence.
