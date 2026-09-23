All verifications pass and my inbox is empty. This was a deploy-and-verify job against the project's live AWS host — no garden-source change to commit.

## Completion report

**Job:** Deploy the `022b92e` Caddy change (alias `/.well-known/ocapn-cbor-np` → CBOR-Noise daemon `127.0.0.1:8931`) to the minion.town AWS host and prove it live.

**Deploy status:** PR #11 merged to `main`, and the repo's continuous-deployment workflow (`.github/workflows/deploy.yml`) auto-ran `deploy-caddy.sh` on the merge — run `29656856940`, **success** at 18:57Z (base64 → SSM `tee` → `caddy validate` gate → `systemctl reload caddy`). I confirmed the live box via SSM: the new `handle /.well-known/ocapn-cbor-np*` block is present in `/etc/caddy/conf.d/minion-town.caddy`, Caddy is `active`, and the daemon container listens on `127.0.0.1:8931` (with the demo listener still on `:8930`). No hand re-deploy was needed — the idempotent config was already applied and validated.

**End-to-end verification (against the public `https://minion.town`):**

1. **No longer falls through to the login gate** — `GET /.well-known/ocapn-cbor-np` returns `426 Upgrade Required` (body `Upgrade Required`), *identical* to the reference `GET /ocapn-daemon`. Previously this path returned `302 → /oauth2/sign_in`; it now reaches the daemon.
2. **WebSocket upgrade reaches the CBOR-Noise daemon, identical to `/ocapn-daemon`** — a raw TLS WS handshake to both paths returns `101 Switching Protocols` with a valid `Sec-WebSocket-Accept`, and neither sends initial server bytes (correct OCapN-over-Noise posture: the Noise IK initiator/client sends first). Both `handle` blocks reverse_proxy to the *same* backend `127.0.0.1:8931`, so the cborCodec/NoiseProtocol handshake is identical by construction. Wildcard sub-paths (`/.well-known/ocapn-cbor-np/foo`) also route to the daemon (`426`).
3. **No regression** — `/ocapn-daemon` (`426`) and `/ocapn` (demo listener `:8930`, `426`) are unaffected; the browser login gate still holds for other paths: `/` → `302 /oauth2/sign_in?rd=/`, `/account` → `302 …?rd=/account`, and an unrelated `/.well-known/whatever` → `302` (the new handle block did **not** broaden the well-known exemption).

**Outcome:** The naming gap from kriskowal/garden#58 (flagged in three consecutive hourly agenda reviews) is closed and proven live. Change is reversible; nothing forced. No follow-ups.
