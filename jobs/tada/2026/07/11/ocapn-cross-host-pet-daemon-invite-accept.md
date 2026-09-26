The job is complete. Here is my report.

---

## Completion report — `ocapn-cross-host-pet-daemon-invite-accept` (M5 builder)

**Draft PR:** https://github.com/endojs/endo-but-for-bots/pull/693 — `demo(daemon): true cross-host Pet-Daemon invite/accept over wss + Noise (M5)`, **draft**, stacked on `claude/endo-two-daemon-invite-accept-FkmHO` (PR #688). No upstream ferry.

### What I proved (real execution, observed)

I ran a **local full Endo Pet Daemon** in the garden container and paired it with the **minion.town full Pet Daemon** — two real daemons on different hosts — through the **invite/accept workflow** over `wss://minion.town/ocapn-daemon` + Noise IK + CBOR, then round-tripped a capability. Captured tail of the live run (committed as `transcript-cross-host.txt`):

```
local: ✓ paired with minion.town Pet Daemon
local: local pet names after accept: [...,"minion","ws-listen-addr"]
local: ✓ invitation bound the minion.town peer under pet name "minion"
local: ← remote result: 2 + 3 = 5
local: ← remote greeting: "hello local Pet Daemon in the garden container from minion.town"
local: CROSS-HOST DEMO PASSED
```

- minion (via SSM + `docker exec` into `endo-pet-daemon`) minted an invitation (`E(host).invite`) and published a `Far` capability; its `at` hint carried a **loopback** `ws:url` and the Noise **designator** `ce47e379…`.
- local rewrote **only** the `ws:url` transport hint → `wss://minion.town/ocapn-daemon` (the Noise handshake authenticates the designator, not the URL), `E(host).accept(...)`ed — binding minion under a durable pet name — and invoked the minion-published capability across the single bidirectional Noise session: `E(adder).add(2,3) ⇒ 5` (computed on minion) and a remote greeting with a live local argument.
- **Local TCP** companion (`transcript-tcp-local.txt`): re-ran PR #688's two-daemon TCP+CBOR+Noise invite/accept fresh in this env → `DEMO PASSED` (`add ⇒ 5`, Far identity preserved). minion blocks non-443, so remote TCP is out of scope; TCP is shown locally, WS cross-host, as the task specifies.

### Landed (`packages/daemon/demo/cross-host-invite-accept/`, commit `f7cd3994b`)

`minion-mint-invitation.mjs`, `local-accept-invitation.mjs` (with the `rewritePublicWsUrl` public-endpoint rewrite), `minion-ssm.py` (boto3 SSM helper — no `aws` CLI in the container), `run-cross-host.sh`, `README.md`, and both transcripts.

### Environment gaps I worked around
- **No Docker locally** → ran the full Pet Daemon as a plain node process (`yarn install` + native build).
- **`/tmp` is `noexec`** → native `better-sqlite3`/`node-datachannel` builds failed; fixed by pointing `TMPDIR` at the exec-capable home mount for the install only (the daemon's unix socket must stay on a short path like `/tmp`, else the ~108-char `sun_path` limit is exceeded). Documented in the README.
- **No `aws` CLI** but `~/.aws` creds present → `pip install --user boto3` + a small SSM helper.

### Gap vs. the full CLI pet-name invitation flow
This drives the **programmatic** host facet (`invite`/`accept`/`evaluate` — the objects the `endo invite`/`endo accept` subcommands wrap), not the CLI binaries: reaching minion's host facet needs its control socket (via `docker exec`), since the public `wss://` surface exposes only the network-level `EndoOcapnBootstrap`. The invite/accept workflow itself — mint, accept, durable guest + peer-info registration on **both** sides (confirmed minion registered the accepting peer), capability round-trip — is exercised end-to-end and cross-host. Driving the `endo` CLI over an interactive shell on minion, and mutual (bidirectional-dialable) pairing, remain follow-ups.

### Housekeeping
minion daemon and its state left untouched (still running, 8h+ uptime); removed the one-off probe scripts I copied in.
