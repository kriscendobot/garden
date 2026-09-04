---
kind: result
role: decomplector
host: endolin-garden2-5bcdff64
at: 2026-09-04T09:36:13Z
---
kind: result
role: decomplector
repo: kriscendobot/minion.town
project: minion-town
pr: 89
seat: decomplector (design panel)
diff base: origin/main (HEAD 2dc21c2)

### decomplector

**Verdict:** request-changes

**Findings:**

- **must-fix** — § B.4 braids *"was this blob recently written"* with *"is this blob newly referenced"*, and CAS dedup severs the two. `internBlob` is **write-if-absent** (`src/endo/gateway/content-store.ts:206-223`): a blob a new publish *reuses* is never rewritten, so its mtime stays at its original intern time. Failure: clip1 names blob b; clip1 is unpublished (record gone, b orphaned, ages past `GRACE`); guest B publishes the same bytes → dedup hit, no write, mtime unchanged; the sweep runs before B's vhost record lands → b is unmarked **and** past grace → deleted, and B's clip is born serving a 404. The design's "airtight ordering" argument holds only for *written* blobs. Decomplect by making the in-flight reference an explicit **value** (a pending-root/lease record under `vhosts/` that the mark step reads and the publisher deletes on completion) rather than inferring it from filesystem metadata; a `utimes` bump on the dedup hit is the cheap patch that keeps mtime an honest reference proxy. § B.9 test 3 covers a shared blob across two *settled* records but not this in-flight case. [rule: roles/jurors/decomplector/AGENT.md § Secondary surface (invariant survivability)] [rule: skills/adversarial-tests/SKILL.md]

- **must-fix** — § B.3's load-bearing simplification, "the gateway's fs reference graph is fully determined by `vhosts/*.json` alone … the GC needs **no** daemon access", is not true of the deployed code. `src/endo/gateway/gateway.ts:205-209` resolves the root **live** from the guest directory's `front` over CapTP whenever a record carries `directoryId` and **no** `contentRoot`, and `listVhostRecords` admits exactly that record class (`src/endo/gateway/vhost-table.ts:216`: a valid `directoryId` passes with `contentRoot` absent). For such a live, served clip the mark step marks nothing, so its manifest and every blob are swept. The braid: the vhost record is treated as *the* reference when it is only a **cached snapshot** of a reference that lives in a mutable place (the guest directory entry) the GC cannot see. Either state and *enforce* the invariant (the sweep refuses to run when any record lacks `contentRoot`) or make daemon-resolved roots part of the mark; do not derive the "no daemon access" simplification from an unstated assumption. [proposed-rule: a design whose safety rests on an exhaustive-call-site claim ("X is the only reference") must enumerate the call sites and name the guard that keeps the set closed, not assert closure in prose]

- **should-fix** — § B.3/B.7 hardcode the root set as a `vhosts/` scan inside `computeLiveSet(records)`. Both findings above are new *classes of referrer*, not new logic. Take roots as data: `computeLiveSet(roots: Iterable<BlobRoot>)` fed by named root providers (settled vhost snapshot, pending-publish leases, directory-resolved roots), so a new referrer is a list entry rather than a rewrite of the sweep. [rule: roles/jurors/decomplector/AGENT.md § Operating norms (d) data > functions]

**Notes (out of scope but worth flagging):**

- Part A (a dated, immutable verification transcript) and Part B (a design § B.7 says a follow-on `build` will revise) share one document and one lifecycle; amending B later mutates the place holding A's evidence. Splitting them, as § A.4's correction was split out into `clip-ocap-synthesis.md`, keeps the value immutable. [proposed-rule: a design document should not carry both a dated verification record and a not-yet-implemented design; the record is a value, the design is a place]
- Credit where the design decomplects well: § B.7's pure `computeLiveSet`/`computeOrphans` core with a thin fs driver separates policy from mechanism, and § B.8 correctly refuses to reach into the guest's namespace, stating the Endo dependency instead of inventing gateway authority over it. [rule: roles/jurors/decomplector/AGENT.md § Operating norms]
- § B.4's `GRACE` and § B.5's cadence are the only two knobs; both are stated as configurable with a default. No complaint.

Self-improvement: the decomplector brief's "cite the design section and the braided concerns" is what made both must-fixes actionable, but neither would have surfaced from the design text alone — each needed a read of the code the design cites (`internBlob`'s write-if-absent, `gateway.ts`'s live-front fallback). Proposal forwarded in this entry: the decomplector's operating norms should say that when a design's simplification is a *claim about existing code* ("X is the only reference", "the graph is determined by Y alone"), the seat verifies the claim against the cited files rather than reading only the design; on a design-plus-code repo that is where the braid hides.
