---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
role: builder
handler-timeout: 7200

Repo: endojs/endo-but-for-bots
Open a NEW, narrow PR against `llm` adding the `endo http mk` CLI verb on top of
`llm`'s already-landed HTTP client. Then close
https://github.com/endojs/endo-but-for-bots/pull/286 as superseded in part,
citing your new PR.

WHY, so you do not re-litigate it. #286 (`feat(daemon,cli): endo http mk Phase 1`)
was written before `llm` landed a superseding implementation of the same
capability. `llm` now has packages `exo-http-client`
(`makeHttpClientAndControl`), `fetch`, and `http-confine`, plus a policy-based
daemon formula: `formulateHttpClient(policy, ...)`,
`getHttpClientControlForClient`, and `host.makeHttpClient(policy)` returning one
client with a WeakMap-held control. #286 implements the SAME `http-client` formula
type a DIFFERENT way (a paired `http-controller`+`http-client`,
`formulateHttpClient(allowedOrigins, ...)`,
`host.makeHttpClient(controllerName, clientName, allowedOrigins)` returning a
named pair). A weaver already attempted the rebase, found duplicate
`const formulateHttpClient` (hard redeclaration), two incompatible `http-client`
formula shapes, and clashing host-method signatures, and correctly aborted
without force-pushing.

But #286 is NOT fully superseded. Verified 2026-08-17: of the 44 CLI commands on
`llm`, NONE is http or fetch related. The CLI surface is the stranded value.

TAKE from #286 (branch `feat/cli-http-client-mk-phase-1`, head e7cc732ef):
- `packages/cli/src/commands/http-mk.js`
- `packages/cli/test/http-mk-command.test.js`
- the `packages/cli/src/endo.js` command wiring
- `.changeset/cli-http-mk-phase-1.md` and `designs/cli-http-client.md`, both
  REVISED to describe the verb sitting on `llm`'s policy-based client rather than
  the formula pair that no longer exists
- `designs/README.md`'s entry, reconciled with its existing note that formula
  packaging was "superseded in part by endo-fetch"

DROP entirely (these are the collision):
- `packages/daemon/src/http-client.js` and its two tests
- the #286 changes to `packages/daemon/src/{host.js,formula-type.js,interfaces.js,
  daemon.js,types.d.ts,help-text-data.js,help.md}` and `package.json`
- `packages/daemon/test/formula-type.test.js`, `tsconfig.composite.json`
Re-derive whatever daemon-side wiring the CLI verb genuinely needs FROM `llm`'s
current shape. Do not port #286's versions of these files.

Check `packages/http-confine/src/http-confine.js` separately: `http-confine`
exists on `llm`, so #286's change there may be an independent fix worth keeping
or may already be landed. Decide on the evidence and say which.

The CLI verb's surface must follow `llm`'s `host.makeHttpClient(policy)`, so the
verb takes a POLICY, not `(controllerName, clientName, allowedOrigins)`. If the
policy shape cannot express what `allowedOrigins` expressed, STOP and report that
gap rather than inventing a translation: that would be a design question, not a
build.

Do NOT carry over the maintainer approval on #286 (kriskowal, 2026-08-15T06:09Z).
It predates recognition of the collision and does not apply to this rework. The
new PR goes through the normal draft-plus-gauntlet path.

When closing #286, leave a comment explaining that the daemon formula was
superseded by exo-http-client + endo-fetch while the CLI verb was not, and link
the replacement PR.

<!-- garden-reaped: 0 -->
