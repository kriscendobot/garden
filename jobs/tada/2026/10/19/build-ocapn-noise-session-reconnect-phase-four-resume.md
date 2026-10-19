I didn't build Phase 4 and opened no pull request, because the job contradicts itself.

**Why:**
- The job asks for Phase 4 of `designs/ocapn-noise-session-reconnect.md`, "Reconnect with Resume": a `RESUME` / `RESUME-ACK` handshake that keeps using the same Noise keys and nonce counters (the CipherState) across TCP reconnects. It also says the Rekey-only wire contract from endojs/endo-but-for-bots#1487 applies.
- endojs/endo-but-for-bots#1487 (still an open draft, held after its review panel passed) rewrites that design to "Rekey on every reconnect; no Resume". It deletes Option Resume, the `RESUME` / `RESUME-ACK` records and Phase 4 from the plan.
- Its reason is that continuing the CipherState means a crash-restore or a forked copy of that state reuses a `(key, nonce)` pair. Under ChaCha20-Poly1305 that reveals the XOR of two plaintexts and the authentication key.
- Phase 3 (endojs/endo-but-for-bots#1481, branch `build/ocapn-noise-session-reconnect-rekey`) already does Rekey on every reconnect over the Phase 2 queue (endojs/endo-but-for-bots#1478). Anything built as Phase 4 would break the contract the job tells me to follow, so there is nothing compliant left to build.

**Open decision:** the Resume-vs-Rekey question (C1) on endojs/endo-but-for-bots#1487 still needs the maintainer's confirmation. If they want a Resume path anyway, that PR requires a nonce-safe version instead of continuing the CipherState: a fresh key derived for each reconnect from the session keys, plus a cap on how many times keys can be derived before a full rekey.

**What I did:**
- Checked for a pull request from an earlier attempt at this job; there is none.
- Read the Phase 4 section of the design and the changes endojs/endo-but-for-bots#1487 makes to it.
- Messaged the maintainer through the liaison (inbox/maintainer, msg `…-20572d9e0e42`) with these findings. I offered to post a new build job for the nonce-safe Resume, stacked on endojs/endo-but-for-bots#1481, if they reply "build nonce-safe resume". Since this session ends now, a reply will become a fresh job instead of reaching me. Otherwise Phase 4 is retired, and Phase 5 (crossed-hellos) can go ahead on endojs/endo-but-for-bots#1481; it doesn't depend on Resume.

**Follow-ups:** the maintainer needs to confirm C1 on endojs/endo-but-for-bots#1487. Whoever posts these phase jobs should stop posting Phase 4 Resume jobs while the Rekey-only contract stands.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ocapn-noise-session-reconnect-phase-four-resume.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (421170 cached reads)
- Output: 4827 tokens
- Cost: $0.554526
- Wall-clock: 222s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
