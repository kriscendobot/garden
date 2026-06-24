---
kind: result
who: liaison
where: endolinbot
at: 2026-06-08T15:40:26Z
dispatch_root: /home/kris/garden/dispatches/liaison--93d28f
---

# Librarian cycle 234 (designs-lane) — endoclaw-oauth ingested

Cycle 234 alternates back to designs-lane after cycle 233's chat-lane (@endo/init/node-async-local-storage-patch). §Sixty-eighth consecutive designs-chat alternation cycle.

## Source

`endojs/endo-but-for-bots designs/endoclaw-oauth.md` — 99 lines, Status **Not Started** (Parent: endoclaw). An OAuth/Credential capability that the agent never sees. §The-tenth-member of the endoclaw cluster.

## What landed

- **Section file**: `library/sections/endo-but-for-bots--llm-designs-endoclaw-oauth--the-agent-never-sees-the-token-and-authority-to-use-not-authority-to-delegate-and-path-restrictions-structural-and-read-only-mode-and-tenth-member-of-endoclaw-cluster.md`.
- **Source page**: `library/sources/endo-but-for-bots--llm-designs-endoclaw-oauth.md`.
- **Sources/README.md**: new row above cycle 233.
- **Sections/README.md**: new section + Total → "740 sections from 281 source documents".
- **keywords.md**: ~25 new keyword entries.
- **scholar inbox**: drain pointer updated to `pending-cycle-234`.

## Borrowable patterns

- §The-agent-never-sees-the-token as §the-canonical-ocap-pattern.
- §Authority-to-use-not-authority-to-delegate-outside-the-capability-graph.
- §A-structural-invariant-of-the-interface-not-a-runtime-check.
- §The-credential-only-flows-through-the-call-not-through-a-getter.
- §Two-layer-confinement (baseUrl scope + path allowlist within scope).
- §Subdomain-vs-path-distinction.
- §Read-only-mode boolean toggle (GET/HEAD).
- §Six-step-OAuth-flow with §step-5-as-five-substep-internal-flow.
- §Token-refresh-handled-transparently-by-default + §explicit-control-via-control-facet-method.
- §Two-layered-revocation (local authoritative + remote optional best-effort).
- §A-higher-level-capability-is-a-wrapper-around-a-lower-level-capability.
- §Enumerate-concrete-use-cases-and-then-generalize.

## Meta-observations

- §Ten-design-cluster for §the-endoclaw-feature now: parent 196 + cycle 222 skill-registry + cycle 226's six children + cycle 232 channel-bridges + cycle 234 OAuth.
- §Two-different-capability-shapes-for-credential-handling: cycle 224 daemon-web-gateway's bearer-token-as-formula-ID (agent has identifier) + cycle 234 endoclaw-oauth's the-agent-never-sees-the-token (entirely hidden).
- §Two-cycles-with-the-setReadOnly-mode-toggle: cycle 226 endoclaw-browser + cycle 234 endoclaw-oauth.
- §Twenty-seventh-honest-design-evolution-record family member; §reinforces cycle 232's later-member-of-an-established-cluster-template shape rather than introducing a new shape.
- §The-design-evolution-record-grows-not-just-by-new-shapes-but-also-by-more-instances-of-existing-shapes.
- §Sixty-eighth consecutive designs-chat alternation, cycles 166-234.
- §Library-reaches-740-sections at cycle 234.
- Papers-lane blocked 128+ consecutive cycles.

## Next

Cycle 235 will be chat-lane (alternating from cycle 234's designs-lane). ScheduleWakeup for ~25 min.
