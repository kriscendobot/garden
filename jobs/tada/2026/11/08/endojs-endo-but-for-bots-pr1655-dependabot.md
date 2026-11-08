---
handed-off: fix-endojs-endo-but-for-bots-pr1655-pi-family-lockstep
deliverable-complete: false
---
# Botanist report: endojs/endo-but-for-bots#1655 (`@earendil-works/pi-ai` 0.87.1 → 1.4.0)

**Verdict: HELD, not MERGE-NOW, escalated to a fixer.** The PR stays open. The upgrade itself is clean, but CI is red because of how this PR splits the package family, and the repair needs version choices for other packages. That puts it beyond a mechanical fix I should push myself (botanist step 6, edge (c)).

## Diligence
- **Base check:** every site on `llm` is still at `^0.87.1` (resolved 0.87.1). The head is 1 commit ahead and 0 behind, so the PR is not superseded.
- **Diff shape:** clean. Only three `package.json` files (agent-tools, agentry, lal) and `yarn.lock` change.
- **Versions moved (all new lockfile entries; old versions kept):**
  - pi-ai 1.4.0
  - pi-telemetry 1.4.0
  - `@anthropic-ai/sdk` 0.129.0
  - openai 7.19.0

  All four are published through GitHub Actions trusted publishing with SLSA provenance. None is under 24 hours old, no new package names appear, and licenses are unchanged.
- **Maturity:** the freshest moved version is pi-telemetry 1.4.0 (2026-10-21T22:44Z), so the 7-day floor passed on 2026-10-28.
- **Advisories:** OSV and GHSA show nothing on either side of the bump.
- **Install:** I could not do the scripts-disabled install. `ensure-project-worktree.sh` failed with the known read-only-filesystem error in the monk sandbox, and the npm cache was also read-only. I cloned to `$TMPDIR` instead and read the registry tarballs directly.
- **Source read:** benign.
  - No install scripts and no `child_process`; the only filesystem writes are in `cli.js`, as before.
  - pi-telemetry is an in-memory API with no network, filesystem, or env access.
  - New network surface is the Radius gateway (`radius.pi.dev`) and local OAuth callback servers. Both run only when a caller explicitly uses those providers.
  - None of the tarballs ships a changelog, so no upstream prose was read or classified.
- **CI:** `lint` fails in `lint:types` for `@endo/agentry`, `@endo/lal` and `@endo/daemon` (TS2322 at `packages/agentry/src/harness/pi-agent.js:82`, plus several lal tests).
  - **Cause:** `@earendil-works/pi-agent-core` stays at `^0.87.1` and keeps its own nested copy of pi-ai 0.87.1. With two pi-ai copies, the types don't match, and the provider registry is split at runtime.
  - **Fix:** bump the whole family together. pi-agent-core 1.4.0 pins pi-ai 1.4.0 exactly, and sibling dependabot PR #1657 bumps pi-coding-agent.
  - I didn't wait for the other test legs once lint had failed for this real reason.

## Actions taken
- Posted the verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1655#issuecomment-6726671878
- Posted fixer job `fix-endojs-endo-but-for-bots-pr1655-pi-family-lockstep` with the full diagnosis and the lockstep task.
- Added a ledger row: `entries/2026/11/08/202551Z-message-botanist-509329.md`, status OPEN, escalated to fixer.
- The daily backstop recheck `dependabotany-recheck-endo-but-for-bots` already exists, so I didn't rewrite it. There is no maturity floor left to schedule a one-off recheck for.
- Sent the shared diligence to the #1657 botanist's inbox (`endojs-endo-but-for-bots-pr1657-dependabot`).

## Follow-ups
- Once the fixer lands the lockstep bump, the daily recheck gives the final verdict on #1655. #1657 is likely to become REJECT-superseded.
- A dependabot `groups:` entry for `@earendil-works/*` would stop this family from being proposed piecemeal. That's a project decision, and I flagged it as optional in the fixer job.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1655-dependabot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (4034467 cached reads)
- Output: 20823 tokens
- Cost: $2.1158813999999997
- Wall-clock: 1143s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
