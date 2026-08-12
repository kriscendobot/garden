---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
role: gardener
requires: aws
handler-timeout: 7200

Production-state forensic investigation of minion.town. Deliverable is a written
report of what is TRUE of the running system, not a fix. Do not change
production. Do not open a PR from this job.

## Background

dckc reports that he obtained an **EndoHost bootstrap over WebSocket** on
minion.town. A peer job, `ebfb-guest-unconfined-from-tree`, already established
by live probe that on the `llm` tip and at minion.town's deployed Endo pin
(f66505034aaa54ac46294347b2bf0e14655b088a) the daemon's Guest facet does NOT
carry makeUnconfinedFromTree or the neighbouring unconfined/endowment-bearing
methods. Coordinate with that job rather than redoing its daemon-side work; it
is chasing the daemon and gateway code path. Your scope is the DEPLOYED SYSTEM'S
STATE.

Treat dckc's report as a true observation of his experience that our source
reading has not yet explained. The job is to find the explanation, not to decide
he is mistaken. If the evidence ends up genuinely contradicting the report, say
so with the evidence and say what would distinguish the remaining possibilities.

## Theories to distinguish

The maintainer is unsure which of two access shapes dckc is describing, and
distinguishing them is the first question:

1. **Direct WebSocket to minion.town.** He connected to a minion.town WebSocket
   endpoint and took the CapTP bootstrap it serves.
2. **A weblet's own powers WebSocket.** He is describing the powers a weblet
   receives over its own WebSocket connection, which is a different endpoint
   with a different bootstrap.

For each: identify the endpoint, what object is actually served as its
bootstrap, what that object's `__getMethodNames__()` returns on the RUNNING
system, and who can reach the endpoint (invitation or credential required, and
whether Caddy exposes it publicly). Add any third theory the evidence suggests;
these two are the maintainer's hypotheses, not a closed set.

## Inspect the production state

3. **dckc's account.** Find his account on the running instance and report what
   it actually holds: his guest identifier and, specifically, **what formula
   type that identifier corresponds to**. A guest identifier that resolves to a
   host-shaped formula would explain the report exactly, and that is the single
   highest-value fact in this job. Report the formula type verbatim rather than
   characterizing it.

4. **His MCP tools.** Enumerate what tools are available to him over MCP on the
   running system, and for each, what it can reach. The question behind this is
   whether any tool in his set is a path to host powers regardless of what his
   bootstrap object is.

## Method

- Prefer observing the running system over reading source. The peer job is
  already doing the source reading, and source has twice failed to explain the
  report.
- Read-only. Inspect state, enumerate capabilities, probe endpoints as a client.
  Do not modify accounts, revoke anything, or restart services; if you conclude
  something must be shut off, report that and let the maintainer decide.
- SSM host access to minion.town is available from an AWS-capable host; see the
  memory of the deployed topology and the existing minion.town operational
  notes.
- Record what you could NOT determine and why, distinctly from what you ruled
  out. An unexamined path is not a cleared path.

## Report

Message the maintainer with the answer to the two-theory question and the
formula type as soon as you have them, before finishing the rest. If any probe
reproduces host powers from an untrusted position, treat it as urgent, say so
immediately, and state plainly what an attacker could do and what would close it.

Keep specifics off public trackers. This is security-sensitive and dckc's
account state is another person's data: report it to the maintainer, not to any
public surface.

<!-- garden-reaped: 0 -->
