---
handler-timeout: 10800
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-05T14:28:03Z cleared=none -->

# Evaluation 6/8: publish lifecycle (`upgrade`/`unpublish`)

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

## This evaluation (prefix: `ev6-`)

**Deliverable.** A characterization of the publish lifecycle:
`publish` → `upgrade` → `unpublish` → re-`publish`, with error-legibility
grades at each transition. Concretely:

1. Publish a fresh clip v1 containing sentinel `ev6-v1`; verify by `curl`.
2. `upgrade` it to v2 (sentinel `ev6-v2`). The tool surface documents an
   "upgrade is not yet available when publishing is served live" case:
   deliberately drive into whatever path the documentation warns about. If
   you hit the error, grade it as documentation: does it name the condition,
   the cause, and a workable alternative, in language a fresh agent can act
   on without source access? If the upgrade instead succeeds, verify v2 is
   served (curl for `ev6-v2`, absence of `ev6-v1`) and report that the
   documented limitation appears stale — also a documentation finding.
3. `unpublish`; record precisely what the URL returns afterward (status
   code, body, caching artifacts) and how quickly; confirm site enumeration
   no longer lists it.
4. Re-publish under the SAME site name with sentinel `ev6-v3`: is the name
   reusable after unpublish? Record friction verbatim.

**Required verification.** `curl` transcripts at every step (status line +
grep for the sentinel), plus the enumeration output before/after unpublish.

**Cleanup.** Unpublish the final clip; verify unserved; remove `ev6-` names.
