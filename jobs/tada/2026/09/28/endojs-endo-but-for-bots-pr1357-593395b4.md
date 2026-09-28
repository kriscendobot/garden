## Completion report: endojs/endo-but-for-bots#1357, comment r4126953829

**The question:** kriskowal asked whether `--bare` rules out using a subscription, and asked for an empirical check.

**Answer: it does not.** `--bare` ignores the stored login and `CLAUDE_CODE_OAUTH_TOKEN`. But it does accept a subscription token passed in `ANTHROPIC_AUTH_TOKEN`, even with every confinement flag set. The design PR had drawn the opposite conclusion from the `--help` text.

**Preflight:** exit 2. The only reply on the thread was the watcher's "On it" acknowledgment, which resolves nothing, so I went ahead with the work.

**The test:** Claude Code 2.1.280, on this host's Max-subscription login, with no API key set. Each case ran `claude --bare -p "Reply with exactly: ok" --max-turns 1`.

| How the token was passed | Result |
| --- | --- |
| Stored login only | Failed: "Not logged in · Please run /login" |
| `CLAUDE_CODE_OAUTH_TOKEN` | Failed: "Not logged in · Please run /login" |
| `ANTHROPIC_AUTH_TOKEN` | **Worked.** Also worked with an empty `HOME`/`CLAUDE_CONFIG_DIR` and `--setting-sources "" --strict-mcp-config --tools ""` (`apiKeySource: none`) |
| `ANTHROPIC_API_KEY`, or an `apiKeyHelper` that prints the token | No result before the 120 s timeout |
| Control: `claude -p` without `--bare` | Worked |

**Caveat:** I used the login's short-lived access token (`sk-ant-oat01-`). I did not mint a new `claude setup-token`, which gives the same kind of token with a longer lifetime, so a `setup-token` run is still untested.

**What changed:**
- **Design fix, commit e235274b7c on `design/endo-claude-inference-backends`:** it adds a § *Subscription credentials under `--bare`* section with the results, plus a row in the sources table.
  - It corrects the credential row, the "Credential" point in the backend conclusion, and Decision 5, which now calls keeping subscriptions out of the Endo contract a policy choice, not a technical limit.
  - It rewrites Open question 1 so the remaining question is whether the subscription terms allow this use, and whether the broker should carry an OAuth token. The recommendation there is still (a), for the maintainer to decide.
- **Reply on the thread:** https://github.com/endojs/endo-but-for-bots/pull/1357#discussion_r4127084753 gives the results table, the caveat and a summary of the change.

**Follow-ups:**
- Optionally, repeat the test with a freshly minted `setup-token`.
- The maintainer needs to decide the policy part of Open question 1.
- Scratch files from the test were deleted.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1357-593395b4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1124791 cached reads)
- Output: 13127 tokens
- Cost: $0.9970182
- Wall-clock: 912s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
