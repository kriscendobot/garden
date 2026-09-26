Landed commit `bc4ef70` on `kriscendobot/minion.town` main.

- Wired `GATEWAY_STORE_DIR` and `MINION_TOWN_DOMAIN` into `minion-mcp.service`.
- Added the `endo-weblet-store` shared group, setgid/group-write store reconciliation, and the required `ReadWritePaths` sandbox exception while preserving separate service users.
- Made both app and gateway deployment paths idempotently establish permissions; updated fixture seeding and deployment documentation.
- CD run `31330105201` completed successfully from push alone. Live services reported active, correct environment/group/sandbox settings, and publish tools mounted.
- Verification: all 214 runnable tests passed; 3 integration tests skipped as configured. Typecheck, shell syntax, and systemd unit verification passed.
- Live Increment-4 DoD passed using two PKCE identities: publish returned a hash origin; edge GET served matching content; native `endo-captp` bootstrapped `echo`, `hello`, and `version`; second-identity unpublish returned `not-owner`; both reserved prefixes were rejected; zero-cost `[weblet-charge]` logs were observed.
- On-demand TLS issued a distinct Let’s Encrypt HTTP-01 certificate for the published origin. First GET took 5.7s versus 59ms afterward, confirming the per-origin issuance cost. DNS-01/stable-alias cutover remains deferred as required.
- Removed the test publications, temporary Cognito identity, and temporary credentials.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr27-4460deb-deploy-wiring.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 607s

<!-- garden-usage-end -->
