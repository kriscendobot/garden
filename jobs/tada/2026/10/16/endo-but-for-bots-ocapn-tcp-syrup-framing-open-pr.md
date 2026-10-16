The draft PR is open: **https://github.com/endojs/endo-but-for-bots/pull/1479**

- **Branches:** it goes from `docs/ocapn-tcp-syrup-framing-status` into the frozen base `llm-61cd656`. The head is still at c5bcbca27, the commit the job named, so I left it unchanged. It touches only `designs/ocapn-tcp-syrup-framing.md` and `designs/README.md`.
- **Title and body:** both are exactly as the job gave them, including the phase and evidence ledger.
- **Job marker:** I opened the PR with `ensure-pr.sh` using the predecessor's base, so the PR carries the marker `garden-job: endo-but-for-bots-ocapn-tcp-syrups-framing-build`. I checked that it is there.
- **Retry:** the first `ensure-pr.sh` run failed with a GitHub TLS handshake timeout and opened nothing. The second run opened #1479.

**Follow-up:** the gauntlet for #1479 is not staged yet. `ensure-pr.sh` could not record the PR on the board, because there is no `work/endo-but-for-bots-ocapn-tcp-syrups-framing-build` record on this host (that job was claimed on another host). Stage it from this report, or run "run the gauntlet #1479" if it does not get staged.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-but-for-bots-ocapn-tcp-syrup-framing-open-pr.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (229890 cached reads)
- Output: 2894 tokens
- Cost: $0.455978
- Wall-clock: 79s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
