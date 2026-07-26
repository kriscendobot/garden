Implemented and pushed two tested follow-up commits to PR #4:

- `9c5a5a1 fix(harness): retain host error diagnostics`
  - Preserves host stacks, records tool failures in host-only events, and returns only an opaque failure to role programs.
- `a99c87b fix(harness): timestamp compartment messages`
  - Adds a host-owned timestamp before hardening compartment assistant messages.

Verified: `npm test` passed; `node bin/finbot-dispatch --seed=7` passed with `WALLET TOUCHED: false`; GitHub CI `test` passed. PR remains draft and is ready for panel re-review.

Follow-up required before Fable sign-off: `timeoutMs` cannot preempt a non-yielding `llmProgram` running on the host thread. A sound untrusted-program boundary requires a Worker-based per-turn runner with JSON-only message transport, host-side tool mediation, and worker termination on timeout. No documentation-only security claim was made.
