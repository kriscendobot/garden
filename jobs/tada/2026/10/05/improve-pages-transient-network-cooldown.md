**Completion report: improve-pages-transient-network-cooldown**

The Pages watcher now uses the host-wide gh-api cooldown. Before, it warned and retried on its own every 120s tick whenever the network dropped. Pushed to `main2` as `4470b8a1705`.

**What changed in `scripts/jobs/pages-watcher.sh`**
- **Check before running:** right after the drain check, the watcher calls `api_cooldown_active rest && exit 0`. While a cooldown is live, a tick does no GitHub calls, no journal fetch and logs nothing. It checks only the REST cooldown because `gh run list` is a REST call, so a GraphQL-only cooldown set by `ci:*:rollup` doesn't silence it.
- **Starting the cooldown:** `classify_source_failure` is now the single place that sorts source failures. Every transient kind starts the shared cooldown with `start_api_cooldown`, which takes a lock and starts it atomically:
  - **Network loss:** tag `pages:<repo>:net`, default window.
  - **GitHub hourly-quota refusal:** tag `pages:<repo>:primary-quota`, held for the full hour from `api_primary_quota_secs`.
  - **HTML/5xx/decoder errors:** tag `pages:<repo>`.
- **One warning per outage:** only the tick that opens the window logs a warning. A tick that finds a window already open stays quiet and never extends it. This covers both the first pass and the network check on the post-401 retry.
- **Still fails closed:** a transient failure exits 0 with no job and no guessed state. A structural failure (such as a real 404) still dies loudly and starts no cooldown. A persistent 401 keeps its warning on every tick.

**What changed in `scripts/jobs/test/pages-watcher-test.sh`**
- Each case now gets its own `GARDEN_API_COOLDOWN_DIR`, so a cooldown started by the tests can't silence another case or the live host.
- Case I now checks that the HTML error started the cooldown, and case J checks that a 404 started none.
- New cases:
  - **L:** network loss starts a host-wide cooldown tagged `net` with the short default window, and that tick logs exactly one warning.
  - **M:** while the cooldown is live, a tick never calls the source, logs nothing, posts no job and doesn't move the expiry.
  - **N:** a GraphQL-only cooldown doesn't block the REST source, and an outage under it opens the host-wide cooldown, with that tick owning the warning.
  - **O:** a quota refusal sets a cooldown longer than the 900s cap that applies when no window is requested.
  - **P:** an expired cooldown is cleared and the red Pages run gets its shepherd job.
- The suite passes 38/38. shellcheck reports only info-level `A && B || C` notes, a pattern this suite already used.

**Follow-ups (not done):** a source timeout (rc 124/137 with empty stderr) still dies loudly instead of starting the cooldown. `receipt-watcher.sh` treats that case as transient, and the Pages watcher could do the same if timeouts turn up in the logs.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-pages-transient-network-cooldown.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (738170 cached reads)
- Output: 12399 tokens
- Cost: $1.046886
- Wall-clock: 156s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
