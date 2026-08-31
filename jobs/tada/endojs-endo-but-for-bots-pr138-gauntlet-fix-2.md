CI is green. All four panel must-fix items applied and pushed.

## Completion report

**Job:** Gauntlet FIX round 2 — endojs/endo-but-for-bots PR #138 (design doc `designs/ocapn-daemon-integration.md`).

**Panel round-2 must-fix items applied** (one commit `8bbf51bf6`, pushed to PR head `design/ocapn-daemon-integration`):

1. **skeptic #1 — stale `@nets` netlayer inventory.** Corrected the Problem-section list: removed the never-existent `libp2p`, added `iroh`, and added the already-landed daemon-side OCapN-Noise netlayer (`packages/daemon/src/networks/ocapn.js`, registered at `@nets/ocapn` by `setup-ocapn.js`, landed 2026-08-25). Verified against the base checkout's actual `packages/daemon/src/networks/` contents.
2. **skeptic #2 — Affected Packages reconciliation.** Rewrote the `packages/ocapn-noise-network/` bullet to state that the `np` netlayer already exists as `ocapn.js`/`setup-ocapn.js`, and that this design **repurposes** it as the shared per-daemon substrate the per-agent proxy fronts rather than building a parallel new package; noted the per-identity register/revoke substrate `@endo/ocapn-noise`'s `network.js` already provides.
3. **ergonomist #1 — undeclared `revokeTransports`.** Declared `revokeTransports(petName): Promise<void>` on the daemon-side `HostInterface` with signature, semantics (whole-agent kill-switch, idempotent), and an explicit granularity contrast against the CLI `revoke <handle>` and exo `disconnect`/`shutdown` to resolve the naming collision.
4. **copyeditor/pedant — typist-hostile code point.** Replaced U+2194 `↔` at line 376 (`A↔B`) with ASCII (`A and B`). Confirmed no other hostile arrows/code points remain (only allowed em-dashes).

**CI:** green — `rollup-terminal … total=5 failed=0 → CI GREEN` (rc 0).

**Scope note:** should-fix items (list-conjunction consistency, subsection ordering, CLI verb-set naming, `connect` hints param, loopback policy path, etc.) were left for the driver's next panel round per the fix-stage's must-fix-only mandate; the line-17 rewrite happens to also satisfy pedant's should-fix list-conjunction point there.

**Follow-ups:** none for this stage. The driver re-posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr138-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1501371 cached reads)
- Output: 11452 tokens
- Cost: $1.6293825
- Wall-clock: 558s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
