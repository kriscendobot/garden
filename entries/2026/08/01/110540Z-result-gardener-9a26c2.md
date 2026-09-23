---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-01T11:05:48Z
---
---
kind: result
role: warden
repo: kriscendobot/minion.town
project: minion-town
pr: 17
---

Panel seat `warden` on kriscendobot/minion.town#17 ("feat(dev): guest mode in the demo CLI, with a load-bearing session-pin refresh test"), diff base `af3057499622978cb2d36bf078d1c067aeb7b007`, head `2d57d34e72fb7daeabd02a9b2217669f5aa8c693`.

### warden (SES / hardened-JS boundary, harden discipline, unguarded globals, prototype pollution)

**Verdict:** comment-only

**Findings:**

- (should-fix, non-blocking) `src/auth/scopes.ts` has no lockdown-side declaration, and `dev/client.ts:55` now statically imports it into a process that never runs `@endo/init`. Every module near this repo's `lockdown()` line states its side explicitly: `src/endo/guest-tools.ts:23`, `src/endo/captp-client.ts:37`, `src/endo/guest-control.ts:22`, `src/http.ts:32`, `src/server.ts:41`, `src/endo/root-ctl.ts:120`. The module is pure constants today, so the import is safe. The gap is that nothing tells the next editor that a stray `@endo/*` import there breaks `npm run client` and the lockdown-free `server.ts` test path. One header line in the `guest-tools.ts:23` form closes it. [rule: src/endo/guest-tools.ts § lockdown-free declaration]

- (comment-only) `dev/client.ts:168` is the repo's lone unguarded `content` cast. `test/auth.test.ts:54`, `test/endo-guest-lockdown.test.ts:45`, `test/endo-guest-tools.test.ts:56` and `test/endo-daemon-integration.test.ts:141` all spell it `content?: ... ?? []`. Verified not a defect at the pinned `@modelcontextprotocol/sdk` 1.29.0: `CallToolResultSchema.content` carries `.default([])` and the zod parse runs inside `callTool`, so it is inside the try the PR deliberately narrowed. Matching the sibling form costs nothing and survives an SDK bump. [rule: test/endo-guest-lockdown.test.ts § textOf]

- (comment-only) `test/endo-guest-http.test.ts:181` newly asserts a refreshed credential gets a live, serving session. Correct, and the per-call re-check in `src/server.ts` (`authorize` / `authorizeGuest`) means a downscoped refresh is still denied at call time. Residual worth recording: `tools/list` is served from the set mounted at initialize and is never re-intersected with the presenting credential's effective scopes, so a downscoped token still sees `guest_*` it cannot invoke. Metadata disclosure only, pre-existing, not this PR's to fix. [proposed-rule: a tool-list response should be filtered by the presenting credential's effective scopes, not only by the session's mount-time set]

**Notes (out of scope but worth flagging):**

- Clean on the seat's core surface. Nothing in the diff crosses a vat or CapTP boundary, so no `harden()` is missing; there is no `globalThis` write, no prototype walk, and no untrusted key indexed into an object. The README additions document environment variables only, with no unguarded-global sample. [rule: roles/jurors/warden/AGENT.md § Operating norms]
- `dev/client.ts:85-92` validates `MCP_GUEST_OPERATION` against a closed tuple via `Array.prototype.includes` and exits 2. That is the pollution-safe form; an object-index lookup here is the recurring bug this seat looks for. [rule: skills/adversarial-tests/SKILL.md]
- `dev/mock-as.ts:43` (`jti` from `node:crypto` `randomUUID`) is what makes `test/endo-guest-http.test.ts:157` non-vacuous. Correct source of randomness, and the assertion that depends on it is present.
- `dev/oauth-client.ts:23-29` plus the "granted-or-requested" label is a real boundary-honesty improvement: the demo no longer asserts a grant it did not verify. The guest mode also requests only `SCOPES.TOOLS` and `SCOPES.GUEST`, which is the least-authority shape the seat wants to see next to a `read-only` attenuation demo.

Self-improvement: the seat brief's "unguarded globals in a docs-only PR are the recurring warden finding" primed a README sweep that found nothing, while the load-bearing item was a missing lockdown-side declaration on a module newly pulled across the dev/src line. Proposing to the gardener that `roles/jurors/warden/AGENT.md` § Operating norms add a third standing check: when a diff adds an import from a lockdown-free entrypoint into a module that does not declare its side of the `lockdown()` line, flag the missing declaration. This repo maintains that convention on six modules and it is invisible to a seat reading only the diff.
