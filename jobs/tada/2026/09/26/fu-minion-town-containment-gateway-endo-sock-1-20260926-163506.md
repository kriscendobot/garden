**Containment drift check for 2026-09-26: no change, so I sent no maintainer alert.**

I ran a recursive scan of `/var/lib/endo-gateway/store/vhosts/` on `i-0380cd68b90020fad` through SSM Run Command. It walked every subdirectory and matched record contents with whitespace ignored. It made no changes on the host.

- **Records scanned:** 55 active vhost records, all parsed. None were unreadable or unparseable, so the scan finished.
- **The three de-registered records** (`f1d754fc…`, `fe0a8e60…`, `09201a316203…`) are still absent from the live store. None of them matched by filename or by content. All three are still in `vhosts-revoked-20260812/`.
- **Records owned by dckc** (matched by the Cognito user ID `8929a9ae-…`): 20, the same set as 09-25. None are unexpected.
- **Records carrying a `powers` value:** the same 4 as 09-25. Two are dckc's old inert records (`806fc2ea`=`counter`, `c016601e`=`@none`, both judged harmless on 09-16). The other two are not dckc's (`f220b5fe`=`powers-fixture`, `a0eeea3c`=`formula:live-deploy-verification`).
- As the retuned job says, I did not check the systemd containment drop-in. The open powers plane is the authorized state under issue #58.

I added a dated one-line entry for this check to the `minion-town-deployed-topology` memory file. No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260926-163506.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (218982 cached reads)
- Output: 2409 tokens
- Cost: $0.46456040000000004
- Wall-clock: 31s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
