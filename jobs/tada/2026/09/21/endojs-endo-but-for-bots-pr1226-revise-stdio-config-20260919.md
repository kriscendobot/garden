All verified. The PR is draft, head is my pushed commit `57dccee4b5`, and kriskowal's review is re-requested.

## Completion report

**Job:** Revise the stdio-MCP-scoped-to-one-guest design (endojs/endo-but-for-bots#1226) per kriskowal's CHANGES_REQUESTED review 5231787250.

**What I found on arrival:** A prior run of this job had already pushed the substantive simplification (commit `8515b8cdef`, 09-17, ~21 min after the review) but had **not** completed the definition of done — no summary comment was posted and the review was never re-requested, so the job stayed open. The pushed revision was high quality: it dropped the per-guest domain socket / named-pipe / facet-broker, rewrote § *Scoping* to the single-process daemon-client model with an honest runtime-vs-structural confinement account, added a § *Threading the formula id from configuration* (env var over stdin handshake, plus the inline-JSON → process-substitution → `0600`-temp-file ladder), and kept the OCapN offset-0 gateway framing as a hardening path.

**What I added:** The one directive nothing had actually done was the maintainer's *"check the approach against the actual daemon client API before landing."* I verified it against the repo and confirmed the simplification is realizable **with no new daemon surface**: `whereEndoSock` + `makeEndoClient` → `getBootstrap` → `E(bootstrap).host()` (matching `packages/cli/src/context.js`), and `E(host).lookupById(formulaId)` — guarded `M.call(IdShape).returns(M.promise())` on `HostInterface` in `packages/daemon/src/interfaces.js` — resolves a formula-identifier string to its value. I threaded these named symbols into § *Scoping*, § *Dependencies*, § *Package shape*, and the Status note (per the designer "cite internals by name" norm), replacing the previously abstract description. Committed as `57dccee4b5` (design file only; excluded a stray yarn-install unicode normalization of `packages/floot/package.json`).

**Definition of done:**
- ✅ Design reflects the env/formula-id + bootstrap-lookup approach, now with the concrete daemon-client API verified and cited.
- ✅ Still a **draft** design PR (#1226); architecture and unrelated sections intact — only review-touched sections changed.
- ✅ Review **re-requested** from kriskowal (now pending).
- ✅ Short summary comment posted ([#issuecomment-5768440199](https://github.com/endojs/endo-but-for-bots/pull/1226#issuecomment-5768440199)) covering the simplification, the config-threading ladder, and the API check.

**PR:** #1226, head `57dccee4b5`, draft, OPEN.

**Follow-ups (open questions left for the maintainer, unchanged):** whether the daemon should publish a per-session formula-id-scoped bootstrap (structural cross-guest isolation without the broker); confirming `claude`'s `--mcp-config` intake (inline-JSON support; single-read vs re-read) against the pinned CLI; and the cross-document reconciliation owed by `endo-claude.md` (its *Local deployment* / *Multiplexing by guest identifier* sections still describe the removed two-process broker split). Per the manual-gauntlet regime I left the PR draft and did not stage a gauntlet — the maintainer promotes with **run the gauntlet #1226** when ready.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1226-revise-stdio-config-20260919.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (2 unmetered)
- Input: 70 tokens (2997590 cached reads)
- Output: 19786 tokens
- Cost: $2.9552280000000004 (2 engagement(s) unpriced)
- Wall-clock: 395s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
