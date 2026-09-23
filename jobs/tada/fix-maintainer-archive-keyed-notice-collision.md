Done. All work complete and verified.

## Completion report

**Job:** fix `maintainer-archive.sh` cannot archive a recurring keyed notice (bare `git mv` collision)

**Root cause:** `maintainer-archive.sh` moved messages with a bare `git mv unread/<id> read/<id>`. Watchdog/reaper notices use stable dedup-keyed filenames (one keyed message per open condition), so when a condition re-opens after a prior archive, the same `unread/<key>.md` is recreated and `git mv` fatals forever because `read/<key>.md` already exists — burning the full 50-attempt backoff on every retry.

**Fix (option b — preserve both, per `designs/watchdog-notice-dedup.md`, which treats recurrence as signal):**
- Added an `archive_dest()` helper. The non-colliding first archive is unchanged (`read/<key>.md`). On collision it archives to `read/<stem>.<disambiguator>.md`, using the notice's own recurrence timestamp (preference order `last_seen` → `sent_at` → `first_seen`, sanitized to the ref-safe charset), falling back to a short content hash so no earlier archived copy is ever lost or overwritten.
- `maintainer-reply.sh` archives through this same tool (lines 53, 74), so its reply path is fixed transitively — no separate bug there.

**Two follow-up self-caught bugs** (found while archiving the real backlog): `tr -c SET ''` is a GNU-tr error (empty replacement) that silently killed the timestamp path — switched to `tr -cd`; and a multi-pattern `sed | head -1` picked the first timestamp *in the file* (`first_seen`) rather than the intended `last_seen` — made preference explicit. Both hardened in the test.

**Test:** `tests/checks/test_maintainer_archive_recurring_keyed_notice.sh` drives the tool against a throwaway journal and asserts a keyed notice archives cleanly three times running, preserving each prior copy, with the second copy disambiguated by its `last_seen`. Verified it fails against the old bare-`git mv` version (6 failures) and passes on the fix (11/11).

**The 7 stuck messages:** archived with the fixed tool (not hand-moved), via an isolated clone pushing to the real `journal2`. Re-clone confirms **0 stuck remaining**; each now has both its original `read/<key>.md` and a preserved recurrence copy. (The 7 recurrence copies carry the hash fallback suffix, since they were archived in the first run before the `tr` fix — correct and unique; future archives use the timestamp form.)

**Commits pushed to main2:** `52f554ef25`, `4403831613`, `05ea654094`.

**Follow-ups:** none. The fix is live on `main2` and takes effect fleet-wide on the next deliberate deploy; the archives are already landed on `journal2`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-maintainer-archive-keyed-notice-collision.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 69 tokens (2721410 cached reads)
- Output: 28661 tokens
- Cost: $2.897737
- Wall-clock: 507s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
