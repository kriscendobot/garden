---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-10-06T21:59:13Z
job: issue-kriscendobot-garden-120
claim: 2b522fb45a6e4714
---
Ingested https://jasvir.github.io/secretseal/ into the journal library and reported the Minion Town findings on https://github.com/kriscendobot/garden/issues/120#issuecomment-6026215635 (issue left open).

Library changes:
- Added source `library/sources/web--secret-seal.md` with four sections covering request-carrier leakage, fragment and Performance Timeline exposure, opaque handles and revelation boundaries, and framework controls plus leak canaries.
- Added topic `http-secret-handling`; integrated the sections into `capability-security`, `oauth-credentials`, `worker-observability`, and `testing`.
- Added concepts `request-carrier-leakage`, `fragment-held-credential`, and `leak-canary-testing`, plus keyword/source/concept indexes.
- Regenerated `library/sections/README.md` and topic counts after landing.

Minion Town finding: the durable guest formula identifier currently lives in a URL fragment and `localStorage` and is normalized back into the fragment. Secret Seal shows that this remains exposed to same-origin code, extensions, history, copied URLs, crash/session tooling, and Navigation Timing even after same-document `replaceState`. Recommended an expiring single-use bootstrap redeemed atomically into less-portable browser state, followed by a genuinely clean navigation; explicit invitation TTL/hash-at-rest semantics; and carrier-specific leak-canary tests across the deployed logging, tracing, browser, and failure paths. Existing standard Authorization carriers, hardened session-cookie flags, no-store/no-referrer responses, CSP, and hash-only revocable git-token storage are directionally aligned.

Foreign-content gate: direct fetch, 60,060 bytes, SHA-256 `def69ed7510d522d759684a9b0d201b5a65dcfeb57b74ca2c6538c36298e92d3`; Jev `jev-1.13.0` classified injection 0.06 (clean), slant neutral/0.72, policy proceed; usage 16,930 input and 71 output tokens.

Verification: `library-link-check.sh --source-slug web--secret-seal` passed; `regenerate-topics-counts.sh --check` reported current/idempotent; source-slug prefix check passed. Minion Town targeted Vitest run passed 6 files / 122 tests covering fragment/session behavior, guest HTTP headers and self endpoints, and git capability/protocol behavior at `be0edb8`. GitHub issue state rechecked OPEN after comment.

Follow-ups: no Minion Town code was changed because the issue requested ingestion and findings. The recommended browser-credential redesign and leak-canary suite remain implementation work if the maintainer elects to pursue them.

Self-improvement: nothing this time.
