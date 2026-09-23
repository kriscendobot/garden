Worktree clean, PR #26 MERGED and CD-deployed. Everything is complete and verified. Here is my completion report.

---

## Completion report: arm the Increment-3 powers plane on live minion.town

**Decision: proceeded with the arming** (the escape-hatch conditions did not apply). The socket path was unambiguous and the blast radius bounded — no maintainer decision was needed:
- The `endo-daemon` is **already live** on the box (running since 2026-07-28), exposing its control socket at the exact path the unit comments prescribe: `/run/endo-daemon/endo.sock` (`srwxrwx--- endo-daemon:endo-daemon`).
- `minion-mcp` **already reaches this same socket** via group `endo-daemon`. Arming the gateway grants a capability posture minion-mcp already holds, against a hardened dedicated user. The gateway holds the daemon top-host cap but only ever calls `E(host).lookup(<powers>)`, presenting the resolved, publisher-attenuated object at the edge — never the host cap.

**What changed** (kriscendobot/minion.town PR #26, merged + CD-deployed):
- Uncommented three lines in `deploy/aws/systemd/endo-gateway.service`: `GATEWAY_ENDO_SOCK=/run/endo-daemon/endo.sock`, `SupplementaryGroups=endo-daemon`, `ReadWritePaths=/run/endo-daemon` (the last required because `ProtectSystem=strict` makes `/run` read-only), and rewrote the comment to document the armed state and revert path. CD (`deploy-endo-gateway.sh`) redeployed it; the gateway logs `powers plane : ENABLED`.

**Edge-verified against a live fixture** (a content+powers weblet I seeded — coordinated with the peer `weblet-edge-verify`, which seeds content-only and confirmed the powers fixture was mine to create). Powers object: a daemon pet `powers-fixture` = `Far('WebletPowers', {hello,echo,version})`, authority-free.
- `/.well-known/endo-captp`: real `@endo/captp` WSS client got a bootstrap whose surface is **exactly** `["__getMethodNames__","echo","hello","version"]` — `hello()`/`echo()`/`version()` returned correctly; `nonexistent()` rejected.
- `/.well-known/ocapn-bootstrap`: GET → `200` `endo:powers-fixture` (formula-id bearer line).
- Fail-closed holds: unknown hash / powerless weblet / non-powers path → WS upgrade refused (404, no 101), bootstrap 404; plain GET on a WS powers path → 426, never content.
- `ocapn-cbor`/`-syrup`: deliberate policy-close 4004 (untouched, per scope).

**Two findings reported to the PR** for the Increment-4 publish path:
1. `makeFsVhostTable` rejects any record without a valid `contentRoot`, so a **powers-only** weblet can't be expressed via the deployed fs source — every powers weblet must also carry content.
2. The vhost `powers` value must be a daemon **pet name**, not a raw formula id — `E(host).lookup(<formula-number>)` throws `Unknown pet name`, though code/design call it a "formula id".

**Follow-ups / left state:**
- The fixture (`powers-fixture` pet + weblet `f220b5fe…` / label `6iqll7…`) is left live for re-verification; teardown commands are in the PR comment. The peer's content fixture (`f45ulx…`) is untouched.
- The message to the peer was dead-lettered (they'd completed) → promoted to a job, so intent is preserved.
- Not addressed (out of scope, as instructed): `ocapn-cbor`/`-syrup` and the `@endo/ocapn` `llm`-branch pin.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-0bdfc2c-powers-plane-arm.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 104 tokens (5922269 cached reads)
- Output: 67903 tokens
- Cost: $6.164239500000001
- Wall-clock: 1243s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
