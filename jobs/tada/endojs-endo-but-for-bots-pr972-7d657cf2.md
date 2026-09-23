Inbox empty. The work is complete.

## Completion report

**Job:** attention directive on endojs/endo-but-for-bots PR #972 — dckc's review comment (`5280941723`).

**The ask (untrusted comment, treated as data):** the PR's `docs/justin.md` cites the Justin grammar from `agoric-labs/jessica`; dckc pointed out that `endojs/Jessie/packages/parse` is more actively maintained and gave a specific revision to pin (`481af9f`, 2025-08-25).

**Preflight corroboration:** preflight returned exit 2 (HINT). I confirmed it fired only on the liaison's own acknowledgment reply — the last real PR commit was 2026-08-11, two days before dckc's 2026-08-13 comment, and there was no inline reply or commit resolving it. So this was genuine, unstarted work.

**What I did** (commit `9f14a243e7` on branch `design/justin-subset-pass-style`, pushed):
- Moved the grammar citation in `docs/justin.md` from the frozen `agoric-labs/jessica` to `endojs/Jessie/packages/parse`, pinned at `481af9f` (2025-08-25), keeping jessica as a labeled ancestral reference. Updated the source note, the "what Justin adds to JSON" list, the divergences intro, D1, the atoms table, the summary, and the References section.
- **Resolved open question D3.** I fetched and read the Jessie grammar at the pinned revision and verified it has a first-class `bigintLiteral <- < int > "n"` production (added in `3fe1ab2ea`, 2025-03-13), so the renderer's `4n` is exactly in-grammar rather than "ahead of the pinned grammar." Rewrote D3 as resolved and demoted it in the open-questions summary.
- **Documented a newly-admitted feature**: underscore digit separators (`1_000_000n`, `77855d53a`), which the grammar accepts but the renderer never emits.
- Verified D1/D2/D4/D5 are unaffected — I confirmed against `quasi-json.js` that the Jessie grammar still `FAIL`s on `__proto__` and admits no computed property names, and has no symbol/error/byteArray productions.
- Checked all internal anchor links I introduced resolve (fixed the D3 heading so its anchor matches the three links pointing at it).

**Reply:** posted a concise summary back to dckc as [PR comment `5281016821`](https://github.com/endojs/endo-but-for-bots/pull/972#issuecomment-5281016821).

**Verification:** grammar facts verified by direct reads of the Jessie source at the pinned commit (bigint production, underscore-separator commits, `__proto__` guard, no computed-property-name rule). This is a docs-only, no-runtime-code change; no test suite applies. The diff is prose only.

**Follow-ups / notes:** The PR remains **draft** by design — it is the working record for the maintainer to lock the dialect, and D1/D2/D4 still carry open questions for review (unchanged by this feedback). I did not un-draft it (this was a feedback/attention job, not a build). One pre-existing unrelated broken anchor (`#divergences-grammar-vs-implementation` vs the "…versus…" heading) was left untouched as out of scope. A peer also landed an unrelated commit (`5511d113d9`) on the branch during my work; my change rebased cleanly on top.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr972-7d657cf2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 63 tokens (2344986 cached reads)
- Output: 22230 tokens
- Cost: $2.5358179999999995
- Wall-clock: 360s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
