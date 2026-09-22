---
gate: deferred
priority: normal
posted_by: designer
posted_at: 2026-09-22T01:47:05Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Evaluate default reauth escalation once the browser OAuth relay lands

**Parked / gated.** Do NOT promote until the deferred **browser OAuth relay**
(the remote-OAuth alternative to the `claude setup-token` path, described in
`kriscendobot/minion.town:designs/claude-agents-capability.md` § and referenced
by `designs/claude-agent-credential-reauth.md`) has made real progress. This job
tracks that dependency; it evaluates next steps, it does not build the relay.

## Why this exists

kriskowal's review of minion.town PR #96 (review 5272974950), open-question 4:
a browser-only or MCP-only operator cannot complete `claude setup-token`, so it
cannot finish reauthentication until the browser OAuth relay lands. Directive:
"We can fall through to manual reauthentication until our OAuth relay makes
progress. We should not block. We should, however track the progress of the
dependencies and post a job gated on those to evaluate the next steps."

The reauth design (PR #96) does the non-blocking half now: the root-user pass
falls through to manual `setup-token` reauth for every deployment, and a
browser-only principal simply parks losslessly. This job owns the deferred half.

## Dependencies to track (the "OAuth relay" progress signal)

- minion.town: `designs/claude-agents-capability.md` § browser OAuth relay (the
  deferred remote-OAuth alternative to setup-token).
- Endo-side OAuth relay foundation, e.g. board bases
  `ebfb-endo-gateway-oauth-flow-design`, `design-endoclaw-oauth-caretaker-attenuation`,
  and the `minion-town-oauth-stage1` / `minion-town-oauth-stage2` line.

Promote this job only after one of the above delivers a usable browser OAuth
relay that a browser-only/MCP-only principal can complete.

## The evaluation (what to decide when promoted)

Once the relay is usable, design/decide whether the credential-reauth escalation
can become the **default for every guest** (including browser-only and MCP-only
operators) or must stay **CLI-conditioned** (offered as default only for guests
whose operator has a local CLI). This re-opens the delegated-operator question
deferred in `designs/claude-agent-credential-reauth.md` § "Follow-up,
deliberately deferred": who may select/replace the operator, how a non-root
principal receives only the authority to reauthenticate one account, how delivery
survives restart, and how an unreachable operator falls back.

Route to a designer. Output: an update to (or successor of)
`designs/claude-agent-credential-reauth.md`.

Origin: PR #96 review comment
https://github.com/kriscendobot/minion.town/pull/96#discussion_r4067419982
