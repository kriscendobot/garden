Done. Final state is coherent: draft PR opened, tests green, block honestly recorded, lessons captured.

## Completion report

**Job:** build invitation-only guest onboarding for minion.town (from merged design `designs/invitation-only-guest-onboarding.md`, PR #56).

**Dependency reconciliation (the core constraint).** The design's extend/accept flow (§§ 3.1–3.2) requires guest-native `guest.invite` / `guest.accept` on Endo's `EndoGuest`. I verified against `endo-but-for-bots` @ `llm` `packages/daemon/src/guest.js` that `EndoGuest` exposes **neither** — only `EndoHost` has invite/accept. That gap is owned by the still-in-progress garden job `endo-guest-invite-accept-design` (itself only a *design* job). The merged design forbids an app-mediated or host-authority fallback, so the full build is genuinely blocked. Per the job's instruction, I implemented the **smallest coherent slice that advances the design** and recorded the block — I did **not** emulate guest authority.

**What I built** (draft PR **https://github.com/kriscendobot/minion.town/pull/81**, `build/invitation-only-guest-onboarding`):
- `src/web/invitation-envelope.ts` — the § 2 fragment envelope (parse/build/validate `#v=1&invitation=<id>` / `#v=1&guest=<id>`) and § 4 credential-carry precedence, as pure string functions. The daemon formula-identifier grammar (`<64hex>:<64hex>`) is ported byte-for-byte from endo `llm` `formula-identifier.js`, so the browser rejects exactly what the daemon would.
- `src/web/invitation-session.ts` — a dependency-injected DOM adapter (location/history/localStorage) for startup resume, `history.replaceState` fragment normalization, the § 3.2 no-guest branch, and "forget this browser".
- `test/web/*` — **34 tests**, real execution evidence for the browser-state halves of design gates 1, 3, 6, 7, 8. I explicitly do **not** claim the live-CapTP halves of 7/8 or gates 4/5/9/10/11.
- A `## 10. Build progress` note in the merged design recording exactly what landed and what stays blocked.

**Evidence:** `npm run typecheck` clean; `npm test` = **333 passed / 5 skipped** (my 34 included). No live/production path touched (no Caddy flip, no `Superseded by` note, no account-store migration) — merging this slice activates nothing.

**OCapN CBOR frontend lessons (DoD item 3):** durably captured in **`designs/ocapn-cbor-browser-frontend-lessons.md`** — the three CapTP surfaces and why `captp-client.ts` can't be reused in the browser, codec/session/bootstrap boundaries, SES/lockdown in the browser, fragment-only credential handling, failure modes, and the tested recipe. It is written for absorption into the named primer artifact: **`designs/guest-primer.md`** on draft PR **kriscendobot/minion.town#78**.

**Follow-ups:** the CapTP-over-Noise/CBOR browser socket, the extend/accept transport, and the §§ 5–6 account-store migration are all unblocked only once `endo-guest-invite-accept-design` lands *and* Endo ships the guest-native methods with a retained same-daemon round-trip test. The draft PR's gauntlet is auto-staged from this report via the completion path.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-invitation-only-guest-onboarding.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 81 tokens (3837301 cached reads)
- Output: 46858 tokens
- Cost: $4.1759055
- Wall-clock: 674s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
