---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-04T22:08:55Z
---
---
kind: result
role: skeptic
repo: kriscendobot/minion.town
project: minion-town
---

Design-panel seat `skeptic` on PR #88 (`designs/clip-immutable-nonce-locator.md`, round 4), worktree `scratch/project-wt-kriscen-a7cd4bee8d33-21df4b26`, base `origin/main`.

### skeptic (adversarial premise attack)

**Verdict:** request-changes

**Findings:**

- **Directive 2's core guarantee is contradicted by a live, tested HTTP GET route the design never mentions.** § 3 asserts "possession of the cached HTTP GET response alone is not sufficient to connect", and § 6.2 / § 8 unit 1 scope the removal to the **WS** endpoint only ("stop presenting `back` ambiently at the clip origin's WS endpoint"). But `src/endo/gateway/gateway.ts:140-167` serves `GET /.well-known/ocapn-bootstrap` on every clip origin, returning `formulaBearerLocator(record.directoryId)` (`endo:<id>`) to any unauthenticated caller whenever the clip has a `back` — asserted as intended in `test/gateway/powers-plane.test.ts:227-236`. An implementer following unit 1 literally leaves that route and its green test standing. § 6.1's front-only rule would 404 it only *incidentally* (no `back` to read), which is not a specification. Enumerate the route in § 6.2; have unit 1 state its disposition (removed, or fail-closed) and unit 6 assert it. [proposed-rule: a design that removes an ambient-reachability surface must enumerate every live route exposing it, grepped from the serving code, not only the surface named in the superseded design's prose.]

- **No threat model names the gateway, which § 3.4 puts on the path of every locator by normative requirement.** § 6.1 claims "no gateway-authority resolver is reintroduced", but `powers-plane.ts` today *terminates* CapTP in-process (`makeCapTP`, bootstrap = the directory's `back`); "forwards the CapTP session" (§ 3.4) is a different architecture (proxy vs terminate) that is never specified — and under either, the gateway reads every post-connect locator frame in plaintext and can replay it. Under "authority equals knowledge of the swissnum" that makes the gateway a bearer-holder of every live clip's backend. State it as a trusted-party assumption, or § 3 reads stronger than it is. [proposed-rule: a design claiming "possession of X is not sufficient" must name every party unavoidably on the secret's path and say whether it is trusted.]

- **The test catalog misses the two claims carrying the most weight.** § 8 unit 6 asserts neither (a) **redirect-on-connect for a fragment-carrying cold open** — the § 1 / § 4 claim that narrows the accepted cost from "any cold open" to "fragment-less opens", so the design's central honesty claim is untested — nor (b) **front-only registration** (the introduced directory carries no `back`, § 6.1), the structural change the rest rests on. [rule: skills/adversarial-tests/SKILL.md]

- **Migration-readiness is an unrecoverable failure mitigated only by primer prose.** § 1 and § 7 item 6 concede a first version shipped without the migration listener permanently loses that clip line's migration path, yet propose only a primer sentence. Name a mechanism (a publish-time check in unit 5, or a primer template shipping the listener by default), or carry the gap as an open question. [proposed-rule: where a design names a permanently unrecoverable failure mode, its mitigation must be a mechanism in a follow-on unit, not documentation alone.]

**Notes (out of scope but worth flagging):**

- Terminology collision: the live code already calls `endo:<directoryFormulaId>` a **locator** (`powers-source.ts:10`, ambient and public) while the design reserves *session locator* for an unguessable secret; an implementer could reuse `formulaBearerLocator` on the secret path. [rule: skills/rename-discipline/SKILL.md]
- § 3.4's `connect-src 'self'` premise checks out against `src/endo/gateway/isolation-headers.ts:26`; the § 3.2 fragment-not-sent and § 2.1 policy-not-structural framings survive attack.

Self-improvement: grounding the supersession scope against the serving code's *route table* rather than the superseded document's prose is what surfaced the ambient bootstrap GET; proposed as a standing rule above.
