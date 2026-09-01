---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Bug found during an MCP-tool documentation evaluation (2026-09-01, liaison
session): `mcp__minion-town__publish` fails unconditionally for at least one
guest, blocking the ability to publish any new clip from that guest.

## Repro

Every `publish` call from the affected guest returns:

```
⛔ Invalid pet name "@main"
```

Reproduced identically across 13 attempts, varying every documented input:

- `powers` set to `"sites"` (the exact name `publish`'s own tool description
  points to — "register it through your sites power"), and three other pet
  names the guest independently held capabilities under — same error in every
  case.
- `content` varied from a single trivial file (`bytes` decoding to `"test"`)
  to a full real 3-file page — same error.
- Removed an unrelated pet name from the guest in case directory-iteration
  during publish was implicated — same error.
- Retried after a wait (ruling out transience).

Control checks on the same guest/session behaved normally throughout:
`upgrade` against an existing owned clip returned its documented,
expected "not yet supported on the live daemon @sites path" error (not this
bug); `has`, `readText`, `writeText`, `remove`, `listSites`, and `status` all
worked as documented.

## Diagnosis (inferred from evidence, not confirmed against source)

`status`/`list` on the affected guest already show several `@`-prefixed
reserved pet names — `@agent`, `@host`, `@mail`, `@nets`, `@planes`, `@self` —
present from first use, evidently seeded by the platform through a path the
ordinary MCP tool surface doesn't expose. `@main` is conspicuously absent from
that set. `publish` appears to require an internal `@main` entry that this
particular guest was never provisioned with, and — since `has`'s own name
validator rejects any pet name containing `@` — there is no tool-reachable way
for a guest to create or repair this client-side. This reads as a guest-
provisioning gap (a missing seed step for some guests, possibly ones
provisioned via a particular pathway or after a particular date), not a
`publish`-input usage error: the failure is unconditional and independent of
every documented `publish` argument.

## What to do

1. Find the guest-provisioning code path that seeds the `@agent`/`@host`/
   `@mail`/`@nets`/`@planes`/`@self` pet names and determine why `@main`
   isn't among them for the affected guest (and whether it's missing for
   guests generally, or only some).
2. Fix the provisioning gap (or, if `@main` is meant to be created lazily on
   first `publish`, fix whatever is failing in that lazy-creation path).
3. Verify the fix with the exact repro above: a fresh `publish` call with
   `powers: "sites"` and a trivial one-file payload should succeed and return
   a hash/URL.
4. If the affected guest from this evaluation can be identified and repaired
   directly (rather than only fixed for guests provisioned from here on),
   do so — a full odometer-styled visitor-counter clip is already built and
   ready to publish at
   `/home/kris/garden/scratch/mcp-clip-eval-odometer-counter/clip/` (local
   evaluation artifacts only, not committed anywhere — read it if useful, but
   don't assume it's still present by the time you claim this job; rebuild
   from the report if needed).

## Cross-reference

Documented in the garden's `skills/minion-town-clip-publishing/SKILL.md`
(landed `main2` commit `226d6db06c`) alongside other clip-building gotchas
found in the same evaluation. Update that skill's "known bug" note once this
lands, noting the fix and (if relevant) which guests were affected.
