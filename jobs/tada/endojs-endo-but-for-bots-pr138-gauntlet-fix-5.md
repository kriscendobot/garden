Fix round 5 complete. CI is green.

## Completion report

**Job:** Gauntlet FIX round 5 for endojs/endo-but-for-bots PR #138 (`design(ocapn): per-agent @transports for OCapN/Daemon integration`).

**Panel verdict applied:** The panel-5 review (design panel, 8 seats: critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice) requested changes on `designs/ocapn-daemon-integration.md`. I applied every must-fix and should-fix item in one follow-up commit (`8b1e021dd`), pushed to the PR head via `safe-push-pr-head.sh` (advance mode, clean fast-forward `d387bf2f7 → 8b1e021dd`).

**Fixes made:**
- **skeptic (must-fix):** stale scheme `tcp+syrups` → `tcp-netstring` (9 sites) and `@endo/syrups` → `@endo/netstring` framing, matching the real registered netlayer (verified against `packages/daemon/src/networks/tcp-netstring.js`).
- **pedant (must-fix):** rewrote all 18 prose em-dashes as period/parens/colon; labeled #118 as Issue consistently.
- **copyeditor:** replaced the three U+2192 arrows with `->`; recast all first-person "we" to impersonal voice; made Design Decision #3 declarative and #10 non-imperative.
- **pedant (should-fix):** repointed #111/#112/#113/#122 links to `/pull/`; normalized "Design Decision #N" citation form and italic section-ref capitalization (`*Daemon Restart*`, `*Layer Cake*`).
- **ergonomist:** reconciled `formulateTransports`/`provideTransports` as one host method; added optional topic arg to `help()`; documented durable cross-invocation `<handle>` capture + `list --listeners`; justified the `agent <name> transports` grammar vs `--as`.
- **decomplector:** cut `listenPolicy` `'request'` to a boolean, deferring the daemon-mediated request mode.
- **novice:** enumerated `delegateFrom` and noted the options shape is non-exhaustive; glossed "Noise IK" at first use.
- **critic/skeptic:** stated per-scheme inbound demux selectors for non-`np` schemes; stated `listen` port/host precedence vs Decision #2; stated the loopback fast path still enforces policy; reconciled `allowedSchemes` vs `outboundPolicy.allowSchemes` precedence.

**CI:** `GARDEN_CI_DEADLINE_SECS=3600 ci-wait-merge.sh --no-merge` → **rc 0, CI GREEN** (5/5 checks, 0 failed).

**Follow-ups:** none. Panel re-run (panel-6) is the driver's responsibility, not this stage.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr138-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 180 tokens (9414658 cached reads)
- Output: 40624 tokens
- Cost: $7.035621000000001
- Wall-clock: 1031s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
