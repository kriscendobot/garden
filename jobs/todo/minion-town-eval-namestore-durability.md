---
handler-timeout: 10800
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-05T11:42:48Z cleared=none -->

# Evaluation 2/8: name-store durability (`writeText`/`readText`/`has`/`remove`)

## Campaign context (identical preamble in every `minion-town-eval-*` child)

You are running one evaluation in a campaign probing the minion.town MCP
guest tool surface AS DOCUMENTATION: can a fresh agent, armed with nothing
but the tools' own names, descriptions, and input schemas, accomplish a
non-trivial task against the live daemon guest? The endpoint is real, live
infrastructure — real spend, real pages served to the public internet. Work
carefully, keep probes bounded, and clean up after yourself.

### Bootstrap (environment setup — NOT part of the evaluated surface)

1. Mint a client-credentials token: read the Cognito client secret from AWS
   Secrets Manager secret `minion/test-cc-client` (region `us-west-1`;
   client id `52ivub038n2dnvnk134s6vkqp1`, client name `minion-mcp-test-cc`),
   then POST to
   `https://minion-town.auth.us-west-1.amazoncognito.com/oauth2/token` with
   `grant_type=client_credentials` and `scope=mcp/tools mcp/guest`. NEVER
   print, log, or commit the secret or the token; hold both only in
   environment variables. If this host has no AWS credentials, or the token
   comes back without the `mcp/guest` scope, report that as an
   environment/deployment gap and finish with the failure contract below —
   do not work around it via any admin or break-glass path.
2. Configure an MCP client against `https://minion.town/mcp` (streamable
   HTTP) with the token as a Bearer `Authorization` header — e.g. a scratch
   MCP config in your job worktree for a `claude -p` sub-invocation, or any
   MCP client with a bearer-token hook. Confirm the minion-town tools
   (`status`, `list`, `listSites`, `publish`, `upgrade`, `unpublish`,
   `adopt`, `dismiss`, `resolve`, `send`, `listMessages`, `evaluate`,
   `writeText`, `readText`, `has`, `remove`) appear in `tools/list`.

### Ground rules

- From bootstrap onward, your ONLY documentation is the tool names,
  descriptions, and input schemas themselves. Do not read minion.town or
  endo source, deployment docs, garden designs, or other evaluations'
  reports. Trial and error against the live surface is the point.
- Namespace every pet name and content path you create with the prefix
  given below. Touch nothing outside your prefix: the guest identity behind
  the test client is SHARED; names you did not create are not yours to
  remove, unpublish, or dismiss.
- Clean up on exit: remove your pet names, unpublish your sites (verify the
  page actually stops being served), dismiss only messages you produced.

### Required report shape

1. **Deliverable + verification evidence** — what you built, the exact
   verification commands/scripts, and their observed output.
2. **Documentation-quality findings**, three subsections:
   - *Clear from the schema alone* — what worked first try, as described.
   - *Needed trial and error* — what the descriptions under- or
     mis-specified; quote the description text against observed behavior.
   - *What a future skill should tell the next agent* — concrete,
     imperative sentences.
3. **Call transcript summary** — tools called, call counts, notable errors.

If the deliverable is not achieved, still write the full report (a failed
evaluation is itself a documentation finding) and end it with these exact
two lines, in this order:

```text
<<<GARDEN-ORCHESTRATION-FAILED>>>
<<<GARDEN-JOB-COMPLETE>>>
```

## This evaluation (prefix: `ev2-`)

**Deliverable.** A durability/persistence characterization of the name-store
quartet — `writeText`, `readText`, `has`, `remove` — as a table of claims
versus observed behavior. Cover at minimum:

- Round trip: `writeText` a multi-line UTF-8 value (include a non-ASCII
  character), `readText` it back, byte-compare.
- `has` before and after `writeText`; after `remove`; `remove` of an absent
  name (the surface claims a clean no-op — what actually comes back?).
- `readText` of a never-written name. The surface's own language promises a
  clean "no such name" result rather than an error — quote what you actually
  observe (result shape, error shape, message text) and whether the tool
  description prepared you for it.
- Overwrite: `writeText` twice under one name; which value survives?
- Name grammar edges, one probe each: a 255-character name, a name with an
  interior space, a unicode name, and one deliberately past the boundary
  (256 characters) — record the rejection text verbatim.
- Cross-session durability: mint a SECOND token (same client), open a fresh
  MCP session, and `readText` a value written in the first session. The
  daemon's durability claim ("survives restarts") cannot be exercised from
  the guest surface — if you find no way to force a restart-equivalent, say
  exactly that in the report; the untestability is itself a finding.

**Required verification.** The report's table must show, for every row, the
literal call arguments (minus any secrets), the literal observed result, and
a pass/fail against what the schema text led you to expect.

**Cleanup.** `remove` every `ev2-` name; confirm with `has`/`list`.
