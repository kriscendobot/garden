---
handler-timeout: 10800
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-04T06:49:08Z cleared=none -->

# Evaluation 1/8: static publish (baseline/control)

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

## This evaluation (prefix: `ev1-`)

**Deliverable.** Publish a brand-new clip (site) with purely static content:
one HTML page titled "Garden Static Baseline" whose body contains a fixed
sentinel string of your choosing beginning `ev1-sentinel-`. No scripts, no
dynamic behavior. This is the campaign's control: the simplest possible
publish, so later evaluations' friction can be attributed to their added
complexity rather than to the basic publish path.

**Additional duty (campaign bootstrap verification).** Before any guest tool
call, decode the access token's payload (base64, locally — do not print the
signature or the raw token) and record in the report which scopes were
actually granted. A missing `mcp/guest` scope is a deployment regression the
whole campaign needs surfaced early and legibly.

**Required verification.**
- `curl` the served URL: HTTP 200, sentinel present in the body, a sensible
  `Content-Type`. Curl a second time to confirm the response is stable.
- `listSites` (or whatever enumeration the schema offers) reflects the new
  site; record how the tool output names/addresses it and whether the served
  URL was discoverable from tool output alone (versus guessed).

**Cleanup.** Unpublish the clip; `curl` again and record precisely what a
de-published URL returns (status code, body). Remove any `ev1-` pet names;
confirm with `list`/`has`.




<!-- garden-reaped: 2 -->

<!-- garden-transient-elapsed: kind=exit0 through=2 values=117,41 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: hermit
  tier: 
  provider: local
  model: 
  claimed_at: 2026-09-04T07:16:22Z
