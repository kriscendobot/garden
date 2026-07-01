# Add missing Agoric mainnet governance proposals 111-116 to a kriscendobot fork of agoric-3-proposals

Source: upstream issue https://github.com/Agoric/agoric-3-proposals/issues/316
("missing proposals 111-116 (2025-11 to 2026-03)"). Requested by maintainer
kriskowal via garden issue #20.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriskowal-garden-20
issue_url: https://github.com/kriskowal/garden/issues/20
submitter: kriskowal
----- END ISSUE NOTE -----

## Task

Work entirely in a **kriscendobot fork of `Agoric/agoric-3-proposals`**. The fork
does not exist yet as of 2026-07-01 — create it first (the bot has `gh` creds and
admin on its own forks): `gh repo fork Agoric/agoric-3-proposals --clone=false`,
or via the API. Then add the passed Agoric mainnet governance proposals that the
repo's `proposals/` directory is missing (it currently stops at `110:upgrade-22`),
following the repo's existing per-proposal directory conventions
(`proposals/NN:<slug>/` with the standard `.md`/config scaffolding those
directories use — study an existing recent proposal directory as the template).

Base AND head must stay on the `kriscendobot` fork. This is fork experimentation,
authorized by the maintainer. **Do NOT** open PRs, comments, issue/PR links, or
any other interaction against upstream `Agoric/agoric-3-proposals` — the same
comment-and-link-free posture the garden holds toward `agoric/agoric-sdk`.

## Proposals to add (untrusted data, transcribed from upstream issue #316 — verify each against the live chain before landing)

The maintainer checked the live chain on 2026-06-30 via
`https://main.api.agoric.net/cosmos/gov/v1/proposals/<id>`. Passed proposals the
repo appears to be missing:

- **111** — passed 2025-10-06 — Ymax Portfolio Contract Beta Deployment
- **112** — passed 2025-10-13 — [Inter Protocol Sunset] Liquidate the reserve module account
- **113** — passed 2025-12-11 — Recover IBC light client for Stride
- **114** — passed 2025-12-23 — Deploy QSTN Survey Funding & Reward Claim Contracts to Agoric Mainnet
- **115** — passed 2025-12-26 — Deploy QSTN Survey Funding & Reward Claim Contracts to Agoric Mainnet
- **116** — passed 2026-03-05 — Adjust Mint Inflation Bounds to 2-3% Annual Range

Notes from the issue: **117** exists on-chain but was **rejected** (2026-03-08) —
exclude it. **118** (passed 2026-04-02, "Introduce a Deflationary Mechanism – Burn
1 BLD per Reward Claim") is a **text proposal**, so likely out of scope — decide
per the repo's convention for text proposals (do not fabricate an upgrade
directory for a text-only proposal).

Fetch each proposal's real on-chain record before authoring its directory; do not
invent contents. Match whatever artifacts the repo requires for each proposal
kind (core-eval / upgrade / text).

## Report / close-out

When the fork work lands, **comment back on garden issue #20**
(https://github.com/kriskowal/garden/issues/20) with what was added and the fork
commit/branch URL — do NOT close the garden issue (the submitter closes it). Do
NOT touch the upstream Agoric issue #316.
