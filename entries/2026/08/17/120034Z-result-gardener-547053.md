---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-17T12:00:35Z
---
---
kind: result
role: warden
repo: endojs/endo-but-for-bots
project: endo
---

Panel seat `warden` on endojs/endo-but-for-bots PR #1014 (`feat(cli): endo http mk`, diff base `origin/llm`, head `aa5f94f898`). Per-juror block below.

### warden (SES / hardened-JS boundary, harden discipline, unguarded globals, prototype pollution)

**Verdict:** approve

**Findings:**

- `packages/cli/src/http-mk-policy.js:187` returns the assembled policy record unhardened, and `packages/cli/src/commands/http-mk.js:67` passes it (with the `parsePetNamePath` array) across CapTP via `E(agent).provideHttpClient`. Not a defect today: `@endo/captp` deep-hardens outbound arguments itself (`packages/captp/src/captp.js:549`, `serialize(harden([prop, args]))`), and `packages/cli/src/commands/mkhost.js` sets the same unhardened-record precedent. Two reasons to harden at construction anyway (should-fix, one line, `return harden({...})`): (a) the daemon twin that consumes this record already does exactly that (`packages/daemon/src/host.js:288` and its `return harden({ allowedOrigins: harden(...) })`), so the CLI-side assembler is the odd one out on a security-policy record; (b) the freeze is currently an invisible side effect of the send. `http-mk.js:80` reads `policy` after the `await`, so a later edit that writes to `policy` there (for example `policy.policyMode ??= 'strict'`) throws a TypeError in strict mode from a freeze no local code performed. [rule: roles/jurors/warden/AGENT.md, Operating norms: harden what crosses a vat or endo boundary]

- `packages/cli/src/http-mk-policy.js:11` (`HTTP_ORIGIN_SCHEMES`) and `:101` (`HTTP_POLICY_MODES`) are mutable module-scope arrays, and no export in this module is hardened. Same-compartment only, so no escalation path exists in the CLI's start compartment, and it is worth no more than a comment: still, this is the module that decides which schemes and which policy modes a minting verb accepts, and its daemon counterpart hardens both its constants and its exported normalizer. `packages/cli/src/grouped-help.js:117` is the in-package precedent. Comment-only. [proposed-rule: a module that makes a security decision (scheme allowlist, policy-mode allowlist, origin canonicalization) hardens its decision tables and its exported functions, even when it runs in the start compartment, so tampering is evident rather than silent.]

**Notes (out of scope but worth flagging):**

- No unguarded-global or prototype-pollution surface in the diff. Both allowlist checks use `Array.prototype.includes` over literal arrays rather than object-keyed lookup, and both array inputs are guarded with `Array.isArray` (`:98`, `:176`) rather than duck-typed on `length`, so a `__proto__` or `length`-getter input cannot steer either branch. `new URL` is the only intrinsic trusted for parsing, which is the right one for origin canonicalization.
- The docs added (changeset, `designs/cli-http-client.md`, `packages/lal/primer/cli-reference.md`) contain no `globalThis` initializer and no prototype-walking sample, so the recurring docs-as-attack-surface finding does not apply. The `--acknowledge-unbounded` gate is correctly described as a CLI confirmation rather than a daemon-enforced bound: `packages/daemon/src/host.js` accepts `policyMode: 'tofu-auto'` with no acknowledgment, so the gate is operator ergonomics, not a security boundary, and the prose does not overclaim.
- Boundary agreement checked empirically, not by reading: every canonical form the CLI emits satisfies the daemon's verbatim `parsed.origin === origin` assert (`packages/daemon/src/host.js:175`), including the cases the new tests pin (port 0, IPv6 literal with and without the default port, punycoded IDN host, trailing-dot host). The CLI is strictly narrower than the daemon on origins, which is the safe direction.

Self-improvement: nothing this time. The warden brief's "harden what crosses the boundary" norm held up as the citation for the one substantive finding, and its guidance to name the passing function and the boundary is what kept the finding from being a bare "not SES safe".
