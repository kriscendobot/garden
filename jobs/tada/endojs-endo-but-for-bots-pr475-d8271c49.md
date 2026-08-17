Done. The attention directive routed to an authoritative audit reply on the PR.

## Completion report

**Job:** attention directive on endojs/endo-but-for-bots PR #475 — erights asked whether all non-test genuine-vs-emulated detection could use `ArrayBuffer.isView`, wanting a single committed fidelity loss.

**Preflight:** `pr-feedback-preflight.sh` returned exit 2 (HINT). Corroborated and rejected it as a false positive: the feedback comment (2026-08-17T23:49:27Z) **post-dates** every recent commit it matched on (latest 23:26:38Z), so this is a fresh reviewer question, not peer-resolved work. Proceeded.

**What I did:** Full audit of every non-test genuine-vs-emulated / immutable-vs-mutable test across `pass-style`, `bytes`, `hex`, `marshal`, `ocapn`, `ocapn-noise`, `immutable-arraybuffer`. Empirically verified the load-bearing claim in a shim probe: emulated wrapper → `isView=false`, `[i]=undefined`, `ownKeys=[]`, `toString='[object Object]'`, but `instanceof=true` and iterable; genuine → `isView=true`, indexable.

**Finding (the answer):** Two orthogonal axes are conflated in the question.
- **Genuine-vs-emulated** (does indexed read work) *is* `isView`: `bytes/from-immutable.js` and `ocapn-noise/network.js` already use it; the one remaining indexing-based check — `pass-style/byteArray.js`'s `ownIndexCount === 0 || === length` — *can* be recast as an `isView`-gated exact check.
- **Immutable-vs-mutable** (does TextDecoder/`set`/native `toHex` accept the buffer): `bytes/to-string.js`, `bytes/concat.js`, `bytes/compare.js`, `hex/encode.js`. `isView` is **wrong** here — a genuine `Uint8Array` over an immutable buffer is `isView=true` yet still needs copying, so genuine-immutable and emulated fall on the *same* copy side while `isView` splits them oppositely.
- The two pinned fidelity losses (index-read `undefined`, `toStringTag`) are used only *negatively* (readers route around them), never as explicit discriminators — so committing to `isView` as the single distinguisher is compatible with his goal.

**Delivered:** Posted the audit as a top-level PR comment (authorized: erights holds full maintainer authority + standing comment authorization on this repo), with a 👍 reactji on his comment. Comment: https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5321672547

**No code pushed** — deliberately. The nuanced answer is "mostly no for the copy-sites (orthogonal axis)"; a blanket `isView` swap there would reintroduce the exact index-read bug the recent commits just pinned. The one clean change (`byteArray.js` `isView`-gating, and optionally a `compare.js` index-in-place rewrite) touches the security-critical `passStyleOf` brand check, so I offered it explicitly and gated it on erights' go-ahead rather than pushing unasked mid-review.

**Follow-up:** If erights greenlights, land the `byteArray.js` `isView`-gated validator (and optional `compare.js` rewrite) as a fixer job on this PR branch.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr475-d8271c49.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1687572 cached reads)
- Output: 32380 tokens
- Cost: $2.67563
- Wall-clock: 505s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
