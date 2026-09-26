Completed read-only production forensics; no production data, configuration, deployment, or repository files were changed.

Findings:

- Recovered 12 formulated `evaluate` expressions:
  - `"1+1"` at 21:29:06, 21:29:42, 21:30:12, 21:30:25, 21:30:43, and 22:15:09Z.
  - `"{ answer: 42, ok: true }"` at 21:29:07 and 22:15:10Z.
  - `"'hello from evaluate'"` at 21:29:07 and 22:15:11Z.
  - Twice around 22:03Z:
    ```
    (() => {
      let count = 0;
      const counter = Far('Counter', {
        incr: () => { count += 1; return count; },
        decr: () => { count -= 1; return count; },
        read: () => count,
        reset: () => { count = 0; return count; },
        help: () => 'eval counter over CapTP (no filesystem, no node_modules)',
      });
      return counter;
    })()
    ```
  Earlier failed `evaluate` calls logged only arity errors, not their arguments.

- `lookup("plane")` occurred at 21:29:08 and again at 22:15:11Z; both returned `Unknown pet name "plane"`. No present or WAL-historical `plane` binding was found.

- At 21:31:04Z, `writeText` created readable blob content exactly `"hi from weblet host"` and transiently bound it as `scratch-note`. The path argument’s original representation was not retained. Four additional readable blobs at 21:59:13–16 contain `"0"`, `"1"`, `"2"`, and `"1"`; their names/arguments were not logged. A 21:39:40 `writeText` attempt failed because seven arguments were supplied, but their values were not retained.

- Three recorded `remove` calls at 21:31:24Z failed because argument zero was a copy-array rather than a string. Argument values were not retained. Successful mutations are silent, so transient WAL bindings cannot be matched verbatim to individual calls.

- The exposed `fe0a8e602d18` CapTP session continued through at least 22:15:11Z, not merely 21:39. Gateway error routing directly associates the 22:02 and 22:15 formulas with `endo-gateway:fe0a8e602d18:endo-captp`.

Persistent residue:

- 66 session-minted formula rows remain: 22 scratch mounts, 13 workers, 12 evals, six readable trees, five `make-unconfined`, three `make-from-tree`, and five readable blobs.
- Seven top-host pet names remain:
  - `cmount`, `cmount2`
  - `counter-tree`, `counter-tree2`
  - `scratch-counter`
  - `counter`
  - `cw`
- Historical-only names recovered from the WAL include `scratch-worker`, `w2`, `scratch-note`, `scm`, `mu-tree`, `mu-result`, and `scratch-tree-unconfined-34f184`.
- Session-created store blobs, mount directories, worker records, and source artifacts remain under `/var/lib/endo-daemon/state/endo`. No daemon-UID writes outside `/var/lib/endo-daemon` were found during the interval.
- No session worker process is currently running. One worker apparently survived until the 22:27 daemon restart; the remaining workers exited promptly. Bound formulas may still be instantiated by an authorized local daemon client.
- No new retention, synced-store, delegated-capability, or mail/message record attributable to the session was found.
- The residue is not publicly reachable after powers containment. It belongs to system daemon node `9b03…`; the public OCapN route terminates a separate container daemon at node `a6cd…`, whose database had no August 12 writes. Local socket/top-host principals can still reach the bindings and known formula IDs.

Network and client attribution:

- No VPC flow logs, Caddy access logs, CloudWatch traffic logs, host network audit history, or equivalent egress record exists. Recovered code used local modules; one exact URL specifier, `https://6hl...ocap.site/make.mjs`, failed as `Invalid URL` before loading. Consequently, daemon-initiated egress cannot be conclusively excluded.
- Gateway logs contain 34 error-context references for `fe0a8e602d18` and none for `f1d754fc…`, but do not retain source addresses or successful-call records. No independent record can determine whether anyone besides dckc accessed either URL. The daemon-side logs were writable by a holder of the exposed powers, so their absence is not proof of absence.

The maintainer was notified promptly of the live residue, corrected daemon reachability boundary, and extended 22:15 session attribution. Follow-up is a maintainer decision on preserving or removing the seven bindings and 66 formulas; removal was intentionally not performed.

Self-improvement: correlate formula timestamps with gateway CapTP error routing and daemon node identities before assigning provenance or public reachability.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-dckc-session-residue-forensics.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1201s

<!-- garden-usage-end -->
