---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Increment 3 (the OCapN/CapTP powers plane, commit f0c6ed7, merged as PR #24) shipped but is **inert in production**: every `/.well-known/*` powers endpoint is gated on `GATEWAY_ENDO_SOCK`, and the deployed `endo-gateway.service` does not set it — so unset ⇒ no HardenedJS/CapTP load and all four endpoints fail closed. Decide and execute the arming on the live minion.town box.
Work in a per-job worktree of `worktrees/kriscendobot-minion.town`; read `designs/weblet-gateway.md` § 6 and the `deploy/aws/systemd/endo-gateway.service` comments that document enabling it. Land the unit change through a PR on the fork (CD deploys `main` automatically), then edge-verify against a seeded weblet whose vhost record carries a `powers` formula:
- `/.well-known/endo-captp`: a real `@endo/captp` WS client gets a bootstrap whose method surface is exactly the granted powers.
- `/.well-known/ocapn-bootstrap`: HTTP GET → the powers locator (formula-id bearer line).
- Fail-closed still holds: unknown hash, powerless weblet, or a non-powers path ⇒ WS upgrade refused (no 101), bootstrap 404; a plain GET to a WS powers path ⇒ 426, never weblet content.
Depends on the fixture seeding in `minion-town-0bdfc2c-weblet-edge-verify` — coordinate with that job rather than duplicating the seed.
Do **not** attempt to unblock `/.well-known/ocapn-cbor` / `-syrup`: those deliberately policy-close 4004 pending the maintainer-gated pin of the fork's unpublished `llm`-branch `@endo/ocapn` (`makeOcapn`+`locator`+Noise WS), which is out of scope here. If arming `GATEWAY_ENDO_SOCK` in production turns out to need a maintainer decision (socket path, blast radius of exposing daemon powers at the public edge), stop and report that instead of guessing.
