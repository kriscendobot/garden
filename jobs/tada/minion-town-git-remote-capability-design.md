Done. Design PR opened and verified.

## Completion report

**Job:** `minion-town-git-remote-capability-design` (designer role, `kriscendobot/minion.town`)

**Deliverable:** `designs/git-remote-capability.md` — **draft PR [#41](https://github.com/kriscendobot/minion.town/pull/41)** against `main`. Mermaid validated (`OK flowchart-v2`); `no-latin-shorthand` and the repo's header-block/numbered-section conventions applied.

**What the design proposes.** Expose the Endo daemon's CAS as a **real git remote, one per guest, addressed by an unforgeable capability-URL** — stock `git clone`/`fetch`/`push` works, holding the URL *is* the authority to read/write/read+write refs into a CAS **partition**, and `git push` is the weblet publish action. 13 sections cover: the two-plane placement (data-plane protocol authorized by a control-plane capability, distinct from the world-readable `*.ocap.site` edge); the git-object↔CAS translation as **two honest storage strategies** (A: git objects interned behind a pluggable ODB, recommended first; B: CAS-native with synthesized objects, the mandate's preference but byte-stability-hard); the capability-URL authorization model (token in the Basic-auth password, TLS-only, rotatable/revocable); the weblet-write right as a **pet-named ocap**; CAS-as-source-of-truth serving; threat model; and metering.

**§ Research (cited, grounded).** Two subagents produced verified external prior art, folded into § 5 with URLs: smart-HTTP/protocol-v2 as the primary wire (`gitprotocol-http`/`-v2`); pluggable-ODB libraries (JGit DFS, libgit2 `git_odb_backend`, gitoxide, isomorphic-git); the `git-remote-<transport>` fast-import/export helper as the deferred alternative; capability-URL vs bearer-URL prior art (GitHub App tokens, W3C TAG capability-URL finding, Tyler Close web-keys); CAS-as-git-backend prior art (IPFS helpers, gitgres, disclaimed miscites: git-annex/Dolt/Oxen/Radicle). **The honest gap is stated: no mature system serves the *smart* wire from a genuinely foreign representation** — which is why Strategy A is recommended first. § 7 is grounded against the *actual* Endo inventory (`pet-store.js`, `directory.js`, `mail.js:adopt`), noting the pet-store's "re-bind a name to a fresh immutable blob" mutation model is already git-shaped.

**Reconciliation.** #39 (`git-content-substrate`, draft): **superseded in framing, partially reused in mechanism** (projector, mutable record, cache policy, `*.ocap.site` edge all retained) — § 8. #40 (`vitals-weblet`, open): **flagged in-text** as needing follow-up, **not rewritten**. The § 12 `endo-but-for-bots` follow-on work is **named, not actioned**.

**Follow-ups (not done, by design):**
- **Mark #39 "Superseded by"** — #39 is an unmerged draft branch, so its file cannot be edited from this PR; the supersede call is made explicitly in § 8, and the note lands when #39 is reconciled. I did **not** post a cross-link comment on #39 (posting on a maintainer-reviewed design PR needs per-action authorization).
- **#40 reconciliation** and the **`endo-but-for-bots` proposals** (§ 12) are the maintainer's call after review.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-git-remote-capability-design.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 83 tokens (5739328 cached reads)
- Output: 63003 tokens
- Cost: $11.5540135
- Wall-clock: 995s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
