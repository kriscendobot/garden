FIX round 1 on endojs/endo-but-for-bots PR #1388 is done: the panel's must-fix items are applied, pushed to the PR head, and CI is green (28 checks, 0 failed; `ci-wait-merge.sh` rc=0).

**Change:** I pushed one follow-up commit, `417e40391a`, to `design/ocapn-cloudflare-netlayer` with `safe-push-pr-head.sh` (advance mode, no rewind). It only edits `designs/ocapn-cloudflare-netlayer.md` (+144/-40).

**Must-fix items:**
- **novice:** I added a "Cloudflare vocabulary" primer covering isolate, Durable Object (DO), eviction and hibernation, service binding and `WorkerEntrypoint`, `RpcTarget` and stubs, Worker Loader and `globalOutbound`, DO facet, and Cap'n Web. It also explains what #78's web-key relay allowlist was.
- **decomplector (who owns the vat):**
  - The vat is now defined as the one DO or DO facet that holds the designator key. The supervisor is never a vat; it only routes frames.
  - A new `cf-facet` hint lets a caller reach a facet hosted inside a supervisor. The text notes that hints are not trusted, because the handshake checks the key.
  - The ownership map now matches this.
- **pedant:** I replaced every `…`, `→`, `↔` and `±` with ASCII (`...`, `->`, `<->`, `+/-`).

**Should-fix and comment items I also applied:**
- **critic:**
  - The byte-only `diagnose(data.slice(start))` in the error paths is replaced by a new `codec.diagnoseRemainder(message, reader)`.
  - The crossed-hellos text now says the design reuses the comparison *rule*, not the function itself.
- **skeptic:**
  - New verification row 9: Ed25519 signing works in a Worker. `@endo/ocapn` uses pure-JS `@noble/curves`, and workerd's WebCrypto also supports Ed25519 (checked against Cloudflare's docs).
  - New test-plan bullet with adversarial confinement probes.
  - The #78-allowlist claim now says only the HTTP relay goes away; the dial policy still decides which peers a facet may reach.
  - Revocation being per kind of object, not guaranteed by the network, is now listed under Known Gaps.
- **decomplector:** revocable forwarders are keyed on the swissnum (each grant), not the object, and the tradeoff is stated.
- **ergonomist:** `OcapnPort.open` is renamed `dial`, and both return shapes use `responderMailbox`.
- **pedant:** `## Open questions` is now `## Open Questions`.

**Not addressed (for panel-2 or the maintainer):**
- **decomplector:** labels in the tree codec still depend on position (#3). Whether the codec is chosen per network (#4) is still Open Question 1.
- **ergonomist:**
  - The factory name `makeCloudflareNetwork` still differs from its sibling netlayers.
  - Its full parameter shape is still not shown in one place.
- **pedant:** the `### The cf network` heading wording is unchanged.
- **pruner:** I did not trim the PR-body sections or remove the Design Decisions section.
- **decomplector (comment only):** the reorder buffer is kept.
- **Em dashes:** two remain. One is inside a verbatim quote of code, the other in the dckc attribution line of the Prompt section.

I did not re-run the panel; the driver posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1388-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (883937 cached reads)
- Output: 11362 tokens
- Cost: $1.0220034
- Wall-clock: 948s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
