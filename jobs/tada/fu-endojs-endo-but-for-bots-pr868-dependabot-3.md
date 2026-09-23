Amended `roles/botanist/AGENT.md` on `main2` so the dependabot maturity floor derives from the freshest version that moved anywhere in the lockfile, not the headline dependency's publish date. Pushed as `5950325550`.

**What changed** (one file, `roles/botanist/AGENT.md`):

- **§ Posture** — split the ambiguous sentence. The embargo bullet no longer names "the upstream publish date"; a new adjacent bullet states the rule outright: the floor is the publish instant of the freshest version moved anywhere in the lockfile, headline or transitive, plus 7 days. It carries the #868 evidence (headline `eslint-plugin-unicorn@72.0.0` from 2026-07-14 whose floor had already passed, versus `globals@17.8.0` at 3h 26m and `baseline-browser-mapping@2.11.4` at 4h 55m, 12 days apart) and requires naming the version the floor came from whenever it is not the headline.
- **Step 2** — while enumerating the transitive set, record which version holds the newest publish instant, since it is the floor's base.
- **Step 7** — "7 days past the upstream publish date" becomes 7 days past the freshest moved version, explicitly not the headline.
- **Step 8** — MERGE-NOW's "≥7 days old" and EMBARGO's "<7 days old" both restated against the floor; EMBARGO also records the version the floor came from.
- **§ Autonomous disposition** — the EMBARGO ledger row now records the freshest-moved-version instant plus the name/version it belongs to; the one-shot recipe's `floor=` line and its comment, which read "upstream publish instant of the headline upgrade" and were the strongest pointer the wrong way, now read `<freshest-moved-version-publish-ISO>` with a comment saying it is the max over the moved set. The MERGE-NOW gate's maturity leg restated the same way.
- **§ Anti-patterns** — added "do not read the maturity floor off the headline package", with the reason (a months-old headline says nothing about the hours-old transitives its diff drags in).

The ceil-to-hour + 15m epsilon arithmetic, the daily backstop, and the CVE-repair exemption are untouched; only what feeds `floor` changed.

**Follow-ups:** the originating message `inbox/liaison/20260728T011523Z-add2c0.md` is still unread in the liaison's inbox — I left it for the liaison to drain rather than marking it read from a gardener job. Existing dependabotany ledger rows written under the old reading may carry headline-derived floors that are too early; a recheck firing against one would re-derive correctly under the new text, but nothing sweeps the already-recorded one-shot fire times.
