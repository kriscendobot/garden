---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-01T10:46:28Z
---
---
project: minion-town
repo: kriscendobot/minion.town
pr: 17
seat: assessor
---

Panel seat `assessor` on https://github.com/kriscendobot/minion.town/pull/17
("test(endo): exercise guest tools through PKCE demo"), diff base
`af3057499622978cb2d36bf078d1c067aeb7b007`, head
`760c9ee155fe1bf8487fc4d7d9d1d7405769791a`. Two files: `dev/client.ts`,
`test/endo-guest-http.test.ts`.

### assessor

**Verdict:** request-changes

**Findings:**

- `dev/client.ts:75-83` (must-fix) The post-restart read check has no failing
  branch. `guest_read_text` returns an absent name as a NON-error `ok()` result
  (`src/endo/guest-tools.ts:154-157`, a deliberate contract), so a value that did
  not survive the restart prints `guest_read_text: OK (no such name:
  "mcp-note")` and `main()` resolves with exit 0. The read result is never
  compared to `guestText` in either mode. A total durability failure is
  indistinguishable from a pass, both to a reader skimming for the checkmark and
  to any script that shells out. Fix: compare the returned text to `guestText`
  and exit non-zero on mismatch. [rule: skills/regression-evidence/SKILL.md]

- `dev/client.ts:29,57-66` (must-fix) `MCP_GUEST_OPERATION` is an unvalidated
  free string whose fallthrough branch is the destructive one. Only the exact
  value `read` skips the write; `READ`, `read-only`, or a typo takes the write
  branch, writing the value the post-restart check exists to find already
  present. The mode meant to prove durability manufactures its own pass. Fix:
  validate against a closed set and throw on an unrecognized value.
  [proposed-rule: a mode selector whose wrong branch fabricates the evidence the
  mode gathers must be validated against a closed set, never left as a
  not-equal fallthrough.]

- `test/endo-guest-http.test.ts:150-158` (must-fix) The "refreshed token" is not
  reliably a different credential, so the new title and the PR body's "proving
  session pinning accepts token refresh" are not always earned. Both flows send
  identical `sub`/`idp`/`scope`/`resource`/`client_id`, and `oauth2-mock-server`
  7.2.0 builds the payload with no `jti` and no nonce (`dist/lib/
  oauth2-issuer.js` `buildToken`: `iss`, `iat`, `exp`, `nbf`, plus the hook's
  claims); RS256 signing is deterministic. When both flows land inside one
  wall-clock second the second JWT is byte-identical and the test degenerates to
  the pre-existing same-token case. Cheap fix: pass a differing non-identity
  claim (a distinct `email`) on the second flow so the bytes must differ while
  `iss`+`sub` match, and assert `refreshedAliceToken !== aliceToken`.
  [rule: skills/regression-evidence/SKILL.md]

- `dev/client.ts:6-8` (should-fix) `npm run client -- guest` cannot exercise the
  guest tools under the documented invocation (after `npm run dev`). Two gates
  block it, neither documented: `endoSock` defaults undefined
  (`src/config.ts:161`) so no `guest_*` tool mounts and each call fails with an
  opaque SDK "tool not found"; and nothing in the repo puts `mcp/guest` into
  effective scopes (`ROLE_SCOPES.guest` is `[mcp/tools]`,
  `src/auth/accounts.ts:50`; `config/policy.json` grants it to no identity), so
  `authorizeGuest` (`src/server.ts:154`) denies even with `ENDO_SOCK` set. The
  PR body cites a working local run; the environment that made it work is not in
  the PR. [rule: roles/COMMON.md § Reporting]

**Notes (out of scope but worth flagging):**

- `test/endo-guest-http.test.ts:172` `expect(res.status).not.toBe(403)` also
  passes on a 400 or a 500. Pre-existing, but this PR retitles the test to claim
  more, which raises the bar on the assertion.
  [rule: skills/regression-evidence/SKILL.md]

- `dev/client.ts:22` guest mode requests `mcp/minions:write`, which no call in
  that mode uses. [proposed-rule: a demo mode requests only the scopes its own
  calls need.]

- The remaining diff hunks in both files are prettier reflow with no behavior
  change; no findings there.

Not verified: no test or demo was executed. Findings 1, 2 and 4 are read from
the diff against the surrounding sources cited; finding 3 is read from the
published `oauth2-mock-server@7.2.0` tarball's `dist/lib/oauth2-issuer.js`.

Self-improvement: `skills/regression-evidence/SKILL.md` covers "a test that
passes whether or not the implementation is correct", but the sharpest instances
in this diff are not tests: they are a demo CLI whose success path cannot report
failure, and a mode selector whose wrong branch writes the evidence it should
have found. Proposing to the liaison that the skill grow a short "checks outside
the test suite" clause so a seat has a rule to cite when a validation script,
not a test, is the thing that cannot fail.
