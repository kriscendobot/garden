All work complete. This was a production-containment job executed via SSM Run Command (no garden-repo source changes, so nothing to commit). Here is my report.

---

# Completion Report — `minion-town-containment-gateway-endo-sock`

**Outcome: contained and verified.** The minion.town weblet powers plane is failed closed, dckc's two `@agent` vhosts are de-registered, the unauthenticated reproduction now fails closed, and enumeration confirms those two were the **only** host-shaped exposures. Maintainer messaged after Step 1 and again with the blast radius. No code deployed; no public exploit specifics posted.

## Step 0 — Evidence preserved (read-only, before any change)

**`endo-gateway.service` as deployed** (`systemctl cat`, abridged): `User=endo-gateway`, `ExecStart=/usr/local/bin/node /opt/minion-town/dist/endo/gateway/main.js`, and the three powers-plane lines —
```
Environment=GATEWAY_ENDO_SOCK=/run/endo-daemon/endo.sock
SupplementaryGroups=endo-daemon endo-weblet-store
ReadWritePaths=/run/endo-daemon
```
No drop-ins existed. Started 2026-08-12 20:44:51 UTC. Content store `GATEWAY_STORE_DIR=/var/lib/endo-gateway/store`.

**The two offending vhost records (full contents, captured before removal):**
- `f1d754fc1efcf4483edfe1c0aac57070cf39eaece43bc8990b1ed7020c56cdd3.json` → `{"contentRoot":"e65de290…","powers":"@agent","owner":"https://cognito-idp.us-west-1.amazonaws.com/us-west-1_mDaTgjr1m 8929a9ae-b001-709d-02ea-e94df6225c0a"}`, published 2026-08-12 21:35:05Z. Base32 label = `6hlvj7a67t2eqpw74hakvrlqodhtt2xm4q54rgild3lqedcwzxjq` (**the reproduction target** — decode cross-checks).
- `fe0a8e602d181ffb6e87e4f2dba4701fd790e897165dbcc452a41707cb1748a0.json` → same `powers":"@agent"`, same owner sub `8929a9ae…`, published 2026-08-12 21:04:12Z. Label = `7yfi4ybndap7w3uh4tznxjdqd7lzb2exczo3zrcsuqlqpsyxjcqa`.

Both **confirmed from the record's own contents to carry powers string `@agent`** before removal (per the peer's warning to match on record files, not transcribed labels).

**Gateway access log (indicative, not authoritative — an attacker with host powers could alter logs):** `journalctl -u endo-gateway.service` shows the attacker/reporter driving the CapTP powers endpoint of vhost `fe0a8e602d18` from 21:27:58→21:39:40Z — the CapTP error notes are stamped `error:captp:endo-gateway:fe0a8e602d18:endo-captp`, and the returned method list proves the resolved object is the **full EndoHost**: `makeUnconfined, makeUnconfinedFromTree, evaluate, provideShell, endow, provideHost, provideGuest, stageTree, …`. Probes included `evaluate`, `remove`, `writeText`, a `lookup "plane"`. The `f1d754fc`/`6hlvj…` weblet was published later at 21:35:05Z.

## Step 1 — Powers endpoints failed closed

Installed reversible drop-in `/etc/systemd/system/endo-gateway.service.d/zz-containment-20260812.conf`:
```
[Service]
UnsetEnvironment=GATEWAY_ENDO_SOCK
SupplementaryGroups=
SupplementaryGroups=endo-weblet-store
```
`daemon-reload` + `restart`. Boot log now: **`powers plane : disabled (GATEWAY_ENDO_SOCK unset — /.well-known fails closed)`**. Kept `endo-weblet-store` group so the content plane still works; dropped `endo-daemon` (socket access) as defense-in-depth. **Rollback:** `rm` that file; `systemctl daemon-reload`; `systemctl restart endo-gateway.service`.

**The test that matters — unauthenticated reproduction re-run from off-host against `6hlvj7a…ocap.site`:**

| | `/.well-known/ocapn-bootstrap` | `/.well-known/endo-captp` (WS) |
|---|---|---|
| **Before** | `HTTP 200` body `endo:@agent` | `101 Switching Protocols` |
| **After** | **`HTTP 404 "no such weblet"`** | **`426 Upgrade Required`, upgrade refused** |

No CapTP host obtainable. Survives a subsequent gateway restart (drop-in is persistent). Step 1 alone closes **every** powers weblet globally.

## Step 2 — Two `@agent` vhosts de-registered

Moved both record files to `/var/lib/endo-gateway/store/vhosts-revoked-20260812/` (preserved for evidence + rollback). After a confirming gateway restart, both URLs `404` on root and bootstrap with **no** WS `101`; a content-only weblet still serves `200` (proving the removal, not just the powers disable, took effect).

## Verification — what's up, what breaks

- **Daemon & non-weblet surfaces UP:** `endo-daemon.service` active, socket `/run/endo-daemon/endo.sock` untouched; `minion-mcp`/`oauth2-proxy`/`caddy`/`endo-ocapn-daemon` all active; `minion.town/` `302`, `/.well-known/ocapn-cbor-np` `426` (untouched, as required), `/ocapn-daemon` `426`, MCP `401`.
- **What this BREAKS (cost carried until the fix deploys):** ALL powers weblets are down globally — every weblet with a `powers` field `404`s on its powers endpoints. Content-only weblets and every non-weblet surface are unaffected.

## Step 3 — Blast radius (read-only): only dckc's two were host-shaped

Gateway resolves powers via `E(host).lookup(<raw powers string>)` in the daemon **top-host** scope (`powers-source.js:112`; no scheme parsing). Resolving every powers string a publisher actually used, against the live daemon:

| vhost | powers string | owner | published | resolves to | host-shaped? |
|---|---|---|---|---|---|
| `f1d754fc…` | `@agent` | dckc `8929a9ae…` | 08-12 21:35:05Z | `Object[Alleged: EndoHost]` | **YES** — de-registered |
| `fe0a8e60…` | `@agent` | dckc `8929a9ae…` | 08-12 21:04:12Z | `Object[Alleged: EndoHost]` | **YES** — de-registered |
| `f220b5fe…` | `powers-fixture` | (none) | 08-05 15:52Z | `WebletPowers` `[echo,hello,version]` | no — safe fixture |
| `a0eeea3c…` | `formula:live-deploy-verification` | `e9a9096e…` | 08-09 18:56Z | throws `Unknown pet name` | no — inert/fail-closed |
| `2f3b45dc…`,`ad37858b…`,`cf17d39f…` | (no `powers`) | — | — | content only | no |

**dckc's two `@agent` vhosts were the only host-shaped exposures; no other publisher's weblet was exposed.** Caveat for the fix: `@agent`/`@host`/`@self`/`@main`/`cw` all sit in the same top-host namespace the gateway looks up, so any publisher *could* have written a host-shaped string — the defect is the gateway resolving in the top host; the fix must resolve in an attenuated scope.

## Follow-ups (not in scope here)
- Permanent fix: job `minion-town-weblet-powers-host-escape-fix` (not deployed). A CD gateway redeploy will **not** re-arm (drop-in survives fragment reinstall) but would leave the two records un-removed — re-run the de-registration if they reappear.
- Two peer forensics jobs (`ebfb-guest-unconfined-from-tree`) separately confirmed the daemon-guest `makeUnconfinedFromTree` path is **not** exposed at the deployed pin — a distinct surface from this gateway defect.
- Updated the `minion-town-deployed-topology` memory to record the containment (it previously said the powers plane was "ARMED").

Bounds honored: dckc's account untouched; no code deployed; no exploit specifics on any public tracker; maintainer notified after Step 1 and again with the enumeration.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-containment-gateway-endo-sock.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 47 tokens (2252330 cached reads)
- Output: 44898 tokens
- Cost: $3.3775020000000007
- Wall-clock: 739s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
