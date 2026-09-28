# Completion report — `mentat-minion-town-alt-hosts-backend-plan`

**Deliverable:** design file `designs/alt-hosts-backend.md` in `kriscendobot/minion.town`, opened as **draft PR [#125](https://github.com/kriscendobot/minion.town/pull/125)** (head `design/alt-hosts-backend`, frozen base `main-f69bf87` — the same snapshot the sibling design PRs #123/#124 use). Left draft per the manual-gauntlet regime; promote with **run the gauntlet #125**.

**What the design says.** For each of Hetzner, DigitalOcean, fly.io, and exe.dev it answers the job's five questions (content store, formula store + accounts/ledger database, compute, networking/TLS including the `*.ocap.site` DNS-01 wildcard, ops burden), all vendor facts from first-party docs fetched 2026-09-28 with citations and flags on anything unverified. Key conclusions:

- **Adapter reuse:** Hetzner Object Storage, DO Spaces, and Tigris reuse the (planned) S3 content-store adapter **unchanged**; exe.dev reuses it via one designed-in `S3_SIGNING=ambient|proxy` knob for its credentials-never-in-the-VM storage broker. No provider needs a non-S3 content adapter. The one genuinely new adapter is a SQL `AccountStore`+`CreditLedger` (SQLite + Postgres flavors) replacing DynamoDB off-AWS.
- **Code-verified corrections:** there is no S3 content-store adapter yet (fs-only today; `content-store-s3` is the planned seam), and `src/` has exactly two lazy, config-gated AWS SDK imports — the design pins the portable subset the future adapter must honor.
- **Findings that change plans:** LiteFS is effectively dead (LiteFS Cloud sunset 2024-10-15; docs warn against autostop) — the fly.io SQLite lane is **Litestream to Tigris**; Hetzner object storage is EU-only and US Hetzner compute lost its price edge in the June 2026 repricing; exe.dev VMs are never quiesced, offer no raw TCP (blocks the OCapN port), and gate wildcard TLS on the Teams plan — real, but an experiment target, not a plannable backend.
- **Recommended order:** fly.io → DigitalOcean → Hetzner (jumps the queue if an EU posture is wanted) → exe.dev on an experiment track. Consistent with PR #123's open question 1 and PR #124's pilot suggestion.

**Open questions for the maintainer** (§ 8 of the design): confirm the order; keep Cognito cross-cloud vs. commission a provider-free OIDC issuer design; one global `ocap.site` edge vs. per-deployment parent domains; Caddy-on-fly vs. collapse into the fly proxy; EU-resident offering; exe.dev intent (Teams plan / private context); per-provider spending authorization.

**Proposed build sequence** (suggested basenames, not posted): `build-minion-town-sql-store-adapter`, `build-minion-town-content-store-s3-portability`, `build-minion-town-deploy-fly`, `probe-minion-town-fly-restore-drill`, `build-minion-town-deploy-digitalocean`, `build-minion-town-deploy-hetzner-eu`, `probe-minion-town-exedev-vm`.

**Follow-ups / notes:** cross-repo Endo implications are in a clearly marked § 7 (no edits to endojs/endo-but-for-bots made or proposed). The job-inbox drain was offline both attempts (journal clone timeout, rc=75 connectivity) — no messages were readable; nothing was owed on the bus. No cloud accounts or resources were created and nothing was spent.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/mentat-minion-town-alt-hosts-backend-plan.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (3624636 cached reads)
- Output: 46972 tokens
- Cost: $16.569408000000003
- Wall-clock: 1376s
- Model(s): claude-fable-5 ×1

<!-- garden-usage-end -->
