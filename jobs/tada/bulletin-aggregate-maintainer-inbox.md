## Completion report — `bulletin-aggregate-maintainer-inbox`

**What I did**

1. **Aggregated the maintainer inbox into the bulletin (the required gap).** Added a top "Messages to the maintainer" section to `scripts/jobs/bulletin.sh`. It enumerates `inbox/maintainer/unread/` (the same source `maintainer-watch.sh` reads) and renders each unread message with everything needed to act on it: its **id** (filename minus `.md`), the originating doer (**`reply_to`**), the **sender** (`from`), and a **one-line summary** (first non-empty body line after the frontmatter). Parsed with `sed`/`awk`, no LLM dependency. Empty inbox renders `(no pending maintainer messages)`.

2. **Brought it closer to the v1 dashboard.** Consulted `journal-v1:README.md` (the prior "Bulletin board" — *Recent engagements* + *Pending kriskowal reviews*, a "what needs a human" board). Reframed the bulletin header as "the maintainer dashboard: what needs a human first, then ongoing autonomous work," and ordered the maintainer-messages section ahead of the existing deterministic sections. A header comment notes the optional `GARDEN_BULLETIN_HANDLER` is the right place for a GitHub-backed *Pending kriskowal reviews* enrichment (it needs network state, so it stays out of the deterministic core).

3. **Preserved the design contract.** Kept all existing deterministic sections (Board / Watch set / Hosts / Recent progress), the timestamp-ignoring idempotence check, and the CAS commit-and-push-to-`journal2` with backoff. Ran the script live: it regenerated and pushed `journal/bulletin.md`, which now shows the new section.

4. **Confirmed the cadence.** `garden-bulletin.timer` is **enabled and firing every 5 min** (`OnUnitActiveSec=5m`, next fire was ~5 min out at check time). It's a `systemd --user` host-local timer driving a per-host deterministic recompute that pushes idempotently to the shared journal — a host-local timer is the correct shape here, so no `set-schedule.sh` journal-shared schedule is warranted.

**Verification**
- Aggregation logic dry-tested against a synthetic message: correctly emits id, `from`, `reply_to`, and one-line summary.
- `shellcheck scripts/jobs/bulletin.sh`: only the **pre-existing repo-wide baseline** findings (SC1091 source-not-followed; SC2034 `GARDEN_TAG` consumed by `log()` in `common.sh`; SC2034 `attempt` loop counter) — identical to `maintainer-watch.sh`/`inbox-send.sh`. My edit introduced **zero** new findings.

**SHAs**
- `scripts/jobs/bulletin.sh` → `main2` @ **`aaebba9b`** (bot identity `endolinbot`, pushed to `origin/main2`).
- Regenerated `journal/bulletin.md` → `journal2` @ **`515a31a5`** (pushed to `origin/journal2`).

**Follow-ups (optional)**
- A `GARDEN_BULLETIN_HANDLER` that fetches kriskowal's pending-review set would fully restore the v1 *Pending kriskowal reviews* section; it's intentionally left to the handler since it requires GitHub state and must not break the deterministic tick.
- The maintainer-messages section is currently empty only because the live inbox holds no unread messages right now; it will populate automatically on the next tick once any gardener posts via `message-user.sh`.
