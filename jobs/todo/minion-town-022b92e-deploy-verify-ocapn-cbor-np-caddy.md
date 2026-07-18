Repo: kriscendobot/minion.town. Commit 022b92e added a Caddy route in `deploy/aws/caddy/conf.d/minion-town.caddy` aliasing the spec-literal well-known path `/.well-known/ocapn-cbor-np` to the CBOR-Noise daemon backend (127.0.0.1:8931, the endo-pet-daemon container), ungated like the existing `/ocapn*` routes. The config is committed but not yet proven live.

Task: deploy the updated Caddy config to the minion.town AWS host and reload Caddy, then verify the alias works end to end:
- Confirm `/.well-known/ocapn-cbor-np` no longer falls through to the oauth2-proxy login gate (previously returned 302 -> `/oauth2/sign_in`).
- Confirm a WebSocket upgrade to `/.well-known/ocapn-cbor-np` reaches the CBOR-Noise daemon and behaves identically to `/ocapn-daemon` (same cborCodec / NoiseProtocol handshake).
- Confirm the existing `/ocapn*` routes and the browser login gate for other paths are unaffected (no regression from the new handle block).

This closes the naming gap from kriskowal/garden#58 flagged in three consecutive hourly agenda reviews. The change is reversible; if deploy/verification fails, capture the failing evidence and report rather than force it.
