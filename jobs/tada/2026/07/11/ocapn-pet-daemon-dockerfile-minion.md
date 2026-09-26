The full Endo Pet Daemon is deployed and serving OCapN-Noise over WebSocket on minion.town, with the deploy artifacts, README, and a captured bootstrap transcript landed on the WS branch (draft PR #684).

## Completion report

**Job:** Reproducible Dockerfile for the full Endo Pet Daemon on minion.town (WS+Noise). This job had been reaped/requeued once; a prior run authored the artifact set but never got the container serving or captured a transcript.

**What I found on arrival:** the WS branch already carried the full artifact set (`packages/daemon/deploy/` Dockerfile, boot script, client, deploy script, Caddy snippet). The image was built and the Caddy route added, but **no container was running** — and the running-but-earlier container was **hung at "installing @nets/ocapn"** with no in-container listener, while `phase_location` had passed on a **stale location file** persisted in the `/data` volume.

**Root cause I fixed:** the entrypoint's `@nets/ocapn` install (`storeValue` + `makeUnconfined` + `move`) is not restart-safe. With `--restart unless-stopped` on a persisted volume, a reboot re-runs it against a pet store that already holds `@nets/ocapn`, and it **hangs on the name collisions**. I made the boot idempotent — it now `lookup(['@nets','ocapn'])`s first and reuses the persisted formula (re-instantiation re-binds the WS listener), only installing from scratch on a fresh volume — and unlinks any stale location file at boot so the deploy script never reads a prior boot's designator.

**What I deployed & proved (real SSM-captured runs on `i-0380cd68b90020fad`):**
- **Image:** `endo-pet-daemon:ocapn-ws`, rebuilt from HEAD; `better-sqlite3` + `@ipshipyard/node-datachannel` **compile in-image** (host stays clean — no imperative `apt-get`).
- **Runtime:** Docker 29.1.3; container `endo-pet-daemon`, `--restart unless-stopped`, `127.0.0.1:8931→8930`, volume `endo-daemon-data:/data`.
- **Caddy route:** `wss://minion.town/ocapn-daemon` → `127.0.0.1:8931` (ungated), added alongside the standalone demo's `/ocapn` (left untouched, still active). `caddy validate` = Valid.
- **Peer round-trip:** a local peer reached the full daemon's `EndoOcapnBootstrap` (swissnum `endo-bootstrap`) over `wss://minion.town/ocapn-daemon` — `getNodeId`, `help`, `getAgentBinding`, `getGreeter` all succeeded, `RESULT ok:true`.
- **Restart idempotency verified:** after `docker restart`, the guard hit the reuse path, **node id stayed stable** (`a6cd6e01…`, persistent agent identity) while the Noise session designator rotated, no hang, and the peer **still reached the bootstrap**.

**Landed on the WS branch `claude/endo-daemon-ocapn-ws-FkmHO` (draft PR #684):**
- `b51293a41` — restart-idempotent boot script + deploy `README.md`.
- `535643d90` — captured transcript (`packages/daemon/deploy/transcripts/minion-ocapn-daemon-bootstrap.txt`; `.txt` because the repo `.gitignore` drops `*.log`).

**Tentative choices** (all documented in the README): base `node:22-bookworm` glibc arm64; Docker runtime; loopback publish `:8931`; persistent named volume; `ws:url` hint rewrite to the public endpoint; box-local Caddy edit. No upstream ferry, per spec.

**Follow-ups:** (1) the standalone demo's own README references a `transcripts/…​.log` that was never committed for the same `*.log` gitignore reason — a pre-existing latent gap, not touched here. (2) The daemon's persistent identity lives only in the Docker named volume; a volume wipe mints a new node id.
