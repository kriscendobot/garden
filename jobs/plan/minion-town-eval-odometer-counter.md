---
gate: orchestrated
orchestrated_by: minion-town-eval-campaign
priority: normal
handler-timeout: 10800
posted_by: design-minion-town-eval-campaign
posted_at: 2026-09-01T19:38:13Z
---

# Evaluation 3/8: dynamic durable state — odometer visitor counter

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

## This evaluation (prefix: `ev3-`)

**Deliverable.** Publish a brand-new clip (NOT an upgrade of anything) whose
page shows a visitor counter: horizontally centered, styled as a mechanical
odometer (wheel/drum aesthetic), whose count is backed by genuine durable
SERVER-side state. A client-only fake (localStorage, a random number, a
client-side increment) does not satisfy the deliverable. How — and whether —
the guest tool surface lets a published clip run per-request server-side
logic is precisely what this evaluation measures: discovering the supported
mechanism (or crisply demonstrating its absence) from the tool descriptions
alone is the finding. If server-authoritative state is genuinely not
expressible, build the closest honest approximation, label it as such on the
page, and report the capability gap with the exact schema language that left
it unexpressed.

Note for the report: a prior ad hoc evaluation of this same shape was run by
the garden's liaison, but its report never surfaced anywhere discoverable.
You are reproducing it independently; do not go hunting for its artifacts,
and if `listSites` happens to show a counter-like site you did not create,
leave it alone and note the sighting.

**Required verification.**
- `curl` the page twice; extract and compare the rendered count (or the
  state endpoint backing it) showing monotone increase across loads.
- A Playwright script loading the page in fresh, cookie-less browser
  contexts at least three times, asserting the displayed count strictly
  increases — proof the state lives server-side, not per-client.
- Reconnect with a freshly minted token/session and confirm the count
  persisted (did not reset with your MCP session).

**Cleanup.** Unpublish the clip and verify it stops being served; remove all
`ev3-` pet names.
