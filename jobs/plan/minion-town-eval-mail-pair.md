---
gate: orchestrated
orchestrated_by: minion-town-eval-campaign
priority: normal
handler-timeout: 14000
posted_by: design-minion-town-eval-campaign
posted_at: 2026-09-01T19:38:13Z
---

# Evaluation 7/8: ocap mail between two distinct guests

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

## This evaluation (prefix: `ev7-`)

**Deliverable.** The ocap message-passing primitives exercised as a PAIR of
distinct guest identities — `send`, `listMessages`, `adopt`, `resolve`,
`dismiss` between two different callers exchanging a value — not a single
guest talking to itself. This is the part of the surface no prior evaluation
touched.

**Second identity (environment setup, exempt from the no-docs rule).**
Identity A is the campaign's shared test client (bootstrap above). Identity
B must be a DIFFERENT OAuth subject, because the daemon keys each guest on
the token's issuer+subject. The garden's proven path to a second subject is
`skills/minion-town-mcp-playwright-login/SKILL.md` (Cognito GitHub
federation via a Playwright-driven browser); its GitHub login step is a
HUMAN checkpoint. Request that checkpoint from the maintainer EARLY — send
via `message-user.sh` as your first act, before the single-guest work below,
and drain your inbox at natural checkpoints while you proceed. Identity
bootstrap is environment, not the evaluated surface; the skill and this
paragraph are fair game, the tool surface documentation rules still apply to
everything after authentication.

**Scenario once both identities are live.**
- Discover from the schemas alone how one guest ADDRESSES another (`send`'s
  recipient parameter: what does its description say a recipient can be?).
  If two guests cannot reach each other through the guest surface alone —
  if introduction requires the daemon owner or some out-of-band step — that
  unreachability, and how legibly the errors explain it, is the central
  finding. You may ask the maintainer (same inbox channel) to perform a
  host-side introduction if and only if the surface itself offers no path;
  record that dependency explicitly.
- B sends A a message carrying a value (whatever attachment shape the
  schema offers); A `listMessages`, `adopt`s the value under an `ev7-` pet
  name, reads it back, and answers — use whatever request/response shape
  the schemas expose (`resolve`, a response name, a reply send).
- Both sides `dismiss` processed messages and confirm their inboxes reflect
  it.

**Fallback.** If no second identity is obtainable within your handler
budget, run the single-guest approximation (send to your own inbox and to
any special recipients the schema names, adopt/dismiss on it), report the
two-identity blocker as the primary finding, and finish with the failure
contract from the preamble.

**Required verification.** The second-guest MCP transcript itself is the
verification: literal `listMessages` output on both sides at each step
(redact nothing but tokens). No curl/Playwright needed beyond the login
skill's own flow.

**Cleanup.** Dismiss every message this evaluation produced on BOTH sides;
remove `ev7-` names from both guests.
