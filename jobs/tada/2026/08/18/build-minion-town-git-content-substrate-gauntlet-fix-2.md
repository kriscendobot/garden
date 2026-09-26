Fix round 2 complete. All panel round-2 must-fix items applied, pushed as a follow-up commit, CI green.

## Completion report

**Job:** Gauntlet FIX round 2 — kriscendobot/minion.town PR #48 (`feat/git-content-substrate-serving`).

**Panel verdict read:** the round-2 request-changes review (28 seats, 10 request-changes). Applied all must-fix items in one follow-up commit `bcbabed`:

1. **HTTP framing corruption on non-UTF-8 HTML** (6 seats) — rewrote the serve-time sentinel swap in `content-server.ts` as a **byte-level Buffer splice** instead of a lossy `utf8` decode/re-encode. The sentinel and active root share an identical pure-ASCII 64-hex frame, so the swap is now length-preserving on any bytes; `Content-Length` is exact for GET and HEAD even on latin-1/windows-1252 documents.
2. **weblet_publish seize/hijack** (4 seats) — `advanceVhostContentRoot` now returns `conflict` for any advance onto a record that exists but isn't `mutable: true`.
3. **Unvalidated `limits`** — `content-source` clamps each field to `Math.min(caller, DEFAULT)` and rejects non-finite/non-positive.
4. **Self-closing raw-text tag** — `<script …/>`/`<title/>`/`<style/>` no longer open a raw-text region.
5. **`.content` reserved-prefix propagation** — tool description, `publish.ts` header, `publish.test.ts` Proven list + rejection assertions.
6. **Type/doc honesty** — `publishContentTree` typed `FsBackedInterner`; `MAX_HTML_REWRITE_BYTES` derived from the projection per-file limit; `expectedOldRoot`→`expectedContentRoot`; `§ 1.3`/`§ 1.5` → `§ 1 decision 3`/`5` across all 7 sites.
7. **Naming gate** — `tmp`→`temporaryFile`, `ATTR_RE`→`ATTRIBUTE_RE`, `SUBRESOURCE_ATTRS`→`SUBRESOURCE_ATTRIBUTES`.
8. **Process** — posted the completion-summary comment naming the head SHA and per-item changes.

**Added regression tests:** non-UTF-8 framing (GET+HEAD), seize refusal, limits clamp/reject, self-closing raw-text, `.content` reserved-prefix rejection.

**Verification:** `tsc --noEmit` clean; full suite **275 passed / 3 skipped**. Pushed to the PR head via `safe-push-pr-head.sh` (`c0109c8..bcbabed`). CI watched bounded → **GREEN** (rc 0).

**Follow-ups:** none from this stage; the supervising driver re-posts panel round 3. PR remains draft (no un-drafting until a subsequent panel passes).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-git-content-substrate-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 155 tokens (9308177 cached reads)
- Output: 52458 tokens
- Cost: $7.4328305000000015 (1 engagement(s) unpriced)
- Wall-clock: 727s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
