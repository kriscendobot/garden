Verified on the remote. Work complete.

---

## Completion report

**Job:** `agoric-3-proposals-316-missing-proposals` (issue-kriskowal-garden-20)

Added the passed agoric-3 governance proposals the repo was missing after `110:upgrade-22`, working entirely on a newly created **kriscendobot fork** of `Agoric/agoric-3-proposals`. No interaction of any kind with upstream `Agoric/agoric-3-proposals` (no PR, comment, link, or reference to issue #316).

**Fork:** https://github.com/kriscendobot/agoric-3-proposals
**Branch:** `add-proposals-111-116` · **Commit:** `8156e21`

### What I did
1. Forked `Agoric/agoric-3-proposals` (didn't exist before), cloned it, and studied the per-proposal conventions (README §Files, CONTRIBUTING, and the `dockerfileGen`/`proposals.ts` type switch in `packages/synthetic-chain`).
2. Verified **every** proposal against the live chain (`cosmos/gov/v1/proposals/<id>`): confirmed PASSED status, extracted each proposal's real message type and, for core-evals, the exact `evals[].js_code` and `json_permits` verbatim.
3. Authored 5 proposal directories following the recent templates (`106:ymax-alpha4`, `100:ymax-alpha1`, `97:drop-ist`), each with `package.json`/`test.sh`/`yarn.lock`/`README.md` and the on-chain artifacts:
   - **111:ymax-beta** — CoreEvalProposal (4 evals)
   - **112:reserve-liquidate** — CoreEvalProposal (1 self-contained eval, no bundles)
   - **114:qstn-survey** — CoreEvalProposal (2 evals)
   - **115:qstn-survey-2** — CoreEvalProposal (1 eval, QSTN follow-on)
   - **116:mint-inflation-bounds** — gov-v1 mint `MsgUpdateParams`, modeled via the EVAL stage (typed as `ParameterChangeProposal` because `dockerfileGen` throws on unrecognized types; `eval.sh` submits the real gov-v1 message).
4. Committed, pushed to the fork, and commented the summary + fork/branch/commit URLs on garden issue #20 (left open for the submitter to close).

### Decisions / exclusions
- **113** (`MsgRecoverClient`, IBC light-client recovery) — an unsupported proposal type in this repo; omitted, same posture the repo takes toward text proposals. Flagged to the maintainer.
- **117** — REJECTED on-chain, excluded per the issue. **118** — TextProposal, out of scope, omitted.

### Known gap / follow-up
The 111/114/115 core-evals reference installed bundles by id (`b1-…`, listed in each README). I did **not** include the `b1-<hash>.json` bundle files, so those three EVAL stages aren't yet build-replayable. I confirmed the mainnet RPC indexes the `MsgInstallBundle` txs and each carries `endoZipBase64Sha512` (= the `b1-` hash), so the bundles are recoverable by matching install txs or rebuilding from source tags — a sizable, separable follow-on. 112 and 116 are complete.

**Self-improvement:** noted (first occurrence, not yet encoded) — agoric-3-proposals core-eval directories can be reconstructed verbatim from the gov-v1 API `.messages[].content.evals[]` (js_code + json_permits), and referenced bundles are recoverable via `MsgInstallBundle` txs whose `endoZipBase64Sha512` equals the `b1-` bundle id. Worth an Agoric-proposal-extraction skill if this recurs.
