Done. All four steps complete and the cutover is verified live.

---

**Completion report — job `journal-readme-is-bulletin`**

The journal's landing page is now the bulletin; the old layout doc moved to `DESIGN.md`. All four steps done and the cutover is live.

**Step 1 — bulletin retargeted (main2 @ `9e44bc4d`)**
- `scripts/jobs/bulletin.sh`: changed output target from `bulletin.md` → `README.md` everywhere (write at ~L224, `git add` at ~L225, idempotency-compare read at ~L208, header comments). Freshness line, `## Latest` narrative, cost gate, durable cursor, and quiet-on-success behavior left intact. Added a one-line note in the dashboard intro pointing to `DESIGN.md` for the layout.
- `scripts/jobs/test/run-test.sh`: the three bulletin assertions now check `$BV/README.md`.
- `roles/journalist/AGENT.md`: "single writer of `journal/README.md`" with the DESIGN.md pointer.
- `designs/job-board.md`: layout reference repointed to `journal/DESIGN.md`.
- `bash -n` clean on both scripts; `shellcheck` clean (only a pre-existing SC2034 on `GARDEN_TAG`, consumed by sourced `common.sh`, unrelated to this change).

**Step 2 — design doc moved aside (journal2 @ `d92b3b8a`)**
- `git mv README.md DESIGN.md` with a pointer banner at the top of `DESIGN.md` noting the live dashboard is now `README.md`.
- `git rm bulletin.md` (clean removal, no tombstone).

**Step 3 — service redeployed (I did restart it; cutover confirmed)**
- Fast-forwarded the garden root `/home/kris` (clean tree) from `38ac085d` → `9e44bc4d` so the service runs the new `bulletin.sh`.
- `systemctl --user restart garden-bulletin.service`. The next tick **posted `journal/README.md`** as the bulletin (stamped `2026-06-24T20:12:47Z`); `origin/journal2` advanced to `d9eb853e`. Verified: `README.md` is the Garden bulletin, `DESIGN.md` holds the layout narrative, `bulletin.md` is gone.
- ⚠️ Note for the maintainer: the unit is `Type=oneshot` wrapping an infinite loop, so `systemctl restart` blocks indefinitely (systemd reports the unit perpetually `activating/start` even though the loop runs and posts normally). This is a pre-existing unit-file quirk I did not introduce; the service is functionally healthy. Worth changing to `Type=simple` in a follow-up so systemd's state model matches reality.

**Step 4 — docs reconciled**
- Top-level `README.md` already states "The journal's `README.md` is the maintainer dashboard" — now accurate, left as-is.
- `CLAUDE.md` has no `journal/bulletin.md` reference.
- Only remaining `bulletin.md` mentions are inside this job's own spec file (`jobs/doin/journal-readme-is-bulletin.md`), which clears on completion.

**SHAs:** main2 `9e44bc4d`, journal2 `d92b3b8a` (my commit) → `d9eb853e` (after the service posted the first README.md bulletin).

**Follow-up:** convert `garden-bulletin.service` from `Type=oneshot` to `Type=simple` so `systemctl restart`/state reporting behaves correctly.
