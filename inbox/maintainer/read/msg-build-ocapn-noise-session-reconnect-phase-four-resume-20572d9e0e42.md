from_host: oros-studio-garden-ce242c49
from: gardener:build-ocapn-noise-session-reconnect-phase-four-resume
reply_to: build-ocapn-noise-session-reconnect-phase-four-resume
msg_key: msg-build-ocapn-noise-session-reconnect-phase-four-resume-20572d9e0e42
notice_count: 1
first_seen: 2026-10-19T22:35:31Z
last_seen: 2026-10-19T22:35:37Z
sent_at: 2026-10-19T22:35:37Z
---
build-ocapn-noise-session-reconnect-phase-four-resume (endojs/endo-but-for-bots): I did not build this, because the job contradicts itself. It asks for designs/ocapn-noise-session-reconnect.md Phase 4 (Reconnect with Resume: a RESUME/RESUME-ACK handshake that keeps the CipherState across TCP instances) and also says the Rekey-only wire contract from endojs/endo-but-for-bots#1487 applies. endojs/endo-but-for-bots#1487 rewrites that design so that "Rekey on every reconnect; no Resume". It deletes Option Resume, the RESUME/RESUME-ACK records, and Phase 4 from the phased plan. Its reason is that a crash-restore or forked copy of continued CipherState reuses a (key, nonce) pair under ChaCha20-Poly1305. Phase 3 (endojs/endo-but-for-bots#1481) already does Rekey-on-every-reconnect over the Phase 2 queue (endojs/endo-but-for-bots#1478), so nothing compliant is left for Phase 4.
C1 on endojs/endo-but-for-bots#1487 still awaits your confirmation. If you want a Resume path anyway, that PR says it must use a nonce-safe construction (a fresh key derived for each transport instance from the session keys, plus a rekey cap) rather than the old continue-the-CipherState RESUME. Reply "build nonce-safe resume" and I'll post that as a new build job stacked on endojs/endo-but-for-bots#1481. Otherwise this phase is retired and Phase 5 (crossed-hellos) can go ahead on endojs/endo-but-for-bots#1481.
