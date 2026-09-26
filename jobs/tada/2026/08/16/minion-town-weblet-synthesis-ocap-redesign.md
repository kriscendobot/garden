Done. Design delivered as PR #47.

## Completion report

**Job:** Redesign weblet publishing in kriscendobot/minion.town along object-capability lines, per @kriskowal's review closing PR #44.

**What I did**
- Read the closed PR #44 and its review, the current gateway implementation (`publish.ts`, `powers-source.ts`, `powers-plane.ts`, `guest-tools.ts`, `guest-control.ts`), and the existing `ocap-site-weblet-isolation.md` design to locate the exact seam the maintainer objected to.
- Confirmed the defect precisely: `weblet_publish` takes a caller-supplied `powers` **string**, stores it verbatim, and the powers plane resolves it at serve time via `E(daemonTopHost).lookup(...)` — **in the gateway's own top-host authority**. PR #44 blocklisted the host-shaped *results* of that resolution rather than removing the seam.
- Authored `designs/weblet-ocap-synthesis.md` and opened **https://github.com/kriscendobot/minion.town/pull/47** (branch `design/weblet-ocap-synthesis`).

**What the design says**
- **Publish is a guest-side synthesis**, mirroring the daemon's `makeWeblet`: the guest binds a weblet formula `{ content-lookup, powers }` from capabilities it holds. Powers is a pet name resolved in the guest's *own* scope by its *own* agent — a guest cannot name a Host it was not granted (introduction, not gateway name-resolution).
- **The gateway becomes a conduit, not a resolver** — it records only the weblet formula id and presents the pinned `powersFormulaId`, never calling `lookup` in its own authority on a caller string. This removes the entire host-escape class, so `assertValidPowers`'s string rules, `assertNotHostShaped`, and close code `4012` are deleted rather than retained (a table maps each PR #44 defense to why it's unnecessary).
- **Lookup-formula content indirection**: the content leg is a `lookup` formula into a guest-owned directory; `weblet_upgrade` re-points the directory entry to replace the named readable tree in place — same `<hash>.ocap.site` origin and powers, no re-mint. The weblet id binds the content-lookup formula id + powers formula id, so upgrades don't change identity.
- Covers the daemon model to mimic, MCP tool-surface changes, migration (legacy string-powers records become unservable — contained by having *no* resolver), acceptance criteria, and follow-on implementation units.

**How it satisfies the ocap premise:** empower only with held powers; synthesis not gateway service; introduction not name resolution (no caller-name-in-gateway-authority seam to defend); upgrade without re-minting.

**Follow-ups:** Design doc only — no code/DNS/cert/deploy change. Implementation is left to the five follow-on units enumerated in § 9; note the deliberate break that legacy string-powers vhost records become unservable and require republish.

Notably, `designs/weblet-gateway.md` is referenced throughout the current gateway source but does not exist in the repo — worth reconciling when the implementation lands.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-weblet-synthesis-ocap-redesign.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 41 tokens (1507543 cached reads)
- Output: 22592 tokens
- Cost: $2.1050424999999997
- Wall-clock: 351s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
