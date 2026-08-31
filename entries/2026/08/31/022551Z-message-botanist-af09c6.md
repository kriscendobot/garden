---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-08-31T02:25:54Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/1094

# Dependabotany ledger: endojs/endo-but-for-bots — PR #1094 REJECT (terminal)

**PR #1094** `@vitejs/plugin-react` 4.7.0 → 6.1.0 (devDependency of `@endo/chat`).
**Verdict: REJECT** — closed 2026-08-31, verdict comment posted
(https://github.com/endojs/endo-but-for-bots/pull/1094#issuecomment-5472930945).

**Reason:** plugin-react 6.x requires peer `vite: ^8.0.0` exclusively (the 6.0.0
major removed Babel and now imports `vite/internal`, a Vite-8-only subpath).
`@endo/chat` pins `vite: ^6.0.0` → `vite@6.4.2`, so 6.1.0 breaks
`packages/chat/vite.config.js` with `ERR_PACKAGE_PATH_NOT_EXPORTED` and reddens
lint/test/cover/build (run 33332416110); base `llm` is green on the same checks.
Absorbing 6.x requires a separate Vite 6→8 major migration in the chat package —
a project design decision out of scope for this bump, not a mechanical
consequence of the upgrade. Reachable ceiling on Vite 6 is plugin-react 5.2.0
(maintainer choice; Dependabot will not offer it while the constraint is `^4.0.0`).

**Diligence (bump otherwise clean):** not superseded (base at 4.7.0, no sibling
PR moves the package). Transitive set: +3 (`@vitejs/plugin-react@6.1.0`,
`@babel/parser@7.28.3`, `@babel/traverse@7.29.0`), −21 (whole `@babel/*`
toolchain dropped — net reduction). Freshest moved version 6.1.0 published
2026-08-20T02:49:46Z (maturity floor 2026-08-27, already past — not the blocker).
No OSV advisory on either side of any moved version. Releaser strengthened:
6.1.0 via GitHub Actions npm trusted publishing (OIDC) + provenance attestation
vs 4.7.0's `vitebot` token. Source read of the 6.1.0 tarball: no install/postinstall
scripts, no bin, sole dep `@rolldown/pluginutils`, dist clean; install with
scripts disabled.

**Terminal:** no embargo, no recheck one-shot, no ledger row to re-sweep. If a
future Vite 8 adoption lands, Dependabot will re-propose or the PR can be reopened.

Self-improvement: nothing this time.
