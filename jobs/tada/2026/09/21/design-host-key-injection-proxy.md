Inbox empty. The job is complete.

## Completion report

**Job:** `design-host-key-injection-proxy` (designer role) — design a host-side dynamic API-key injection proxy to replace/augment container-recreation for key changes.

**What I did:**
- Verified the groundwork the job cited rather than re-deriving it: read `seed-api-key-handoff.sh` (the allowlist `/run/environment.d` bridge, confirmed the exact key set and its recreate-to-rotate constraint), `comment-provenance.sh`'s "FAIL OPEN, NEVER CLOSED" posture, the `subscription-budget-model` / `fleet-gh-identity` designs for the two fail-posture precedents and the per-host-credential reality, and the model-selection worker-kind→provider map for the routing table's hostnames.
- Wrote `designs/host-key-injection-proxy.md` (~3 screens): a **scoped** TLS-terminating HTTP(S) forward proxy (allowlist == routing table, `CONNECT`-passthrough for everything else), an explicit **ownership map** (container client / host proxy / credential store), a mermaid architecture diagram, and a firm position on each of the job's real questions.
- **Validated the mermaid fence parses** (`OK flowchart-v2`, exit 0) before committing, per the mermaid-validation skill.

**Positions taken (with open questions for the maintainer):**
- **Blast radius:** the proxy *shrinks* the container-side surface (container holds no keys under full-replace) while the host already held every key — net improvement, not a new concentration; the one genuinely new secret is the CA private key.
- **Fail-closed**, not fail-open (budget-gate lineage) — a direct-with-baked-key fallback would resurrect a rotated-away credential; I named the resulting single-point-of-failure cost honestly and recommended lowering its probability over a security-regressing fallback.
- **Full-replace** of `seed-api-key-handoff.sh` as end-state; **systemd encrypted credentials** as the host store (SSM allowed where AWS access exists); **one proxy per host**; client `HTTPS_PROXY` cooperation flagged as unverified.

**What changed:**
- Design content landed direct on `main2` (commit `005be4285d6`).
- Opened **draft PR kriscendobot/garden#107** against a frozen `main2-5fdb7e9` base (the pre-design snapshot), diff = the single design file, body carries the `<!-- garden-design-open-questions -->` marker. This is the open-questions answer-surface per the garden carve-out.

**Follow-ups:**
- The PR is left **draft** as required; the maintainer promotes it to design-panel review with **run the gauntlet #107** when ready. I did not un-draft it or stage a gauntlet (manual-gauntlet regime).
- The design's open questions block implementation until decided (fail-closed vs cold-start bootstrap, bridge retirement, credential store per host, CA custody/rotation, empirical client-proxy verification, build-vs-adopt, allowlist maintenance).

Self-improvement: nothing this time — the frozen-base open-questions-PR path and its sensors worked as documented.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-host-key-injection-proxy.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1515697 cached reads)
- Output: 18701 tokens
- Cost: $2.1965835
- Wall-clock: 336s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
