---
handler-timeout: 10800
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-05T14:37:04Z cleared=none -->

# Evaluation 8/8: deliberate error and edge-case probes

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

## This evaluation (prefix: `ev8-`)

**Deliverable.** A graded catalog of error messages as documentation, from
deliberate edge-case and misuse probes. One shot per shape — never repeat a
probe that errored, never flood, create nothing you don't immediately clean
up. Probe at minimum:

- `publish` under a reserved content path: something under `gateway/` and
  something under `.well-known/`.
- `publish` (or any tool that names a power/value) naming a pet name the
  guest does not hold.
- `adopt` with an out-of-range message number, and with a nonexistent edge
  name on a real message (send yourself one `ev8-` message to probe
  against).
- `resolve` of a nonexistent request.
- `send` to a nonexistent recipient.
- Malformed pet names, one call each: a name containing `@`, one containing
  `/`, the name `.`, an empty string, a 256-character name.
- `readText` of a name bound to something that is not text, if you can
  arrange one under `ev8-`.

For every probe record: the literal call, the full error verbatim, and a
grade on three axes — does it identify WHICH input was bad, WHAT rule it
violated, and WHAT to do instead? Would a fresh agent recover without source
access? Note the best and worst error in the set.

**Required verification.** The catalog itself, with verbatim errors. After
cleanup, show enumeration output demonstrating the probes left no `ev8-`
residue (and that the reserved-path publishes did not partially land).

**Cleanup.** Dismiss the self-sent message; remove any `ev8-` names;
unpublish anything that unexpectedly published.
