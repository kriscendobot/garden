## Completion report: build-npm-minion-town-dev-registry

I built the registry and the minion.town hosting code the design asks for, as two draft PRs. CI is green on both. Nothing is deployed yet: the registry is not live at npm.minion.town, and the minion.town side is provisioning code only, with no DNS, secret, service or Caddy site created.

Governing designs (from the `design-npm-minion-town-dev-registry` report): endojs/endo-but-for-bots#1361 and kriscendobot/minion.town#134.

Opened: https://github.com/endojs/endo-but-for-bots/pull/1362
Opened: https://github.com/kriscendobot/minion.town/pull/135

### endojs/endo-but-for-bots#1362 (draft, base `llm-3aa902d`)
- **New package:** `@endo/npm-registry-server` (private). It is an npm-protocol registry that stores content in a sha256 file CAS and keeps its tables in SQLite.
- **Publish:**
  - Requires a bearer grant with a package allowlist.
  - Accepts exactly one `<v>-dev.<YYYYMMDDHHMMSS>.g<sha>` version with its matching `dev-YYYY-MM-DD` tag.
  - Computes the integrity hashes on the server and extracts tarballs with size and path-traversal limits.
  - Refuses a publish whose declared dependencies differ from the tarball's `package.json`.
  - Makes a version visible in one transaction, with an audit row. An identical retry is a no-op; different bytes get a 409.
- **Dist-tags:** only date tags and `dev-latest`, and they only move forward.
- **Serving:**
  - Full and abbreviated package metadata, per-version manifests, dist-tags and tarballs.
  - Every tarball URL points at the registry itself, never at another host.
  - Packages not published here are fetched on demand from one pinned upstream, verified against its integrity hash, stored and re-served.
  - When the upstream is down, cached metadata is still served, and clients are never redirected elsewhere.
- **Programs:** `npm-registry-server` checks the store is complete before it starts listening. `npm-registry-admin` lists, issues and revokes grants and runs the same check.
- **Commits:** `yarn.lock` is in its own commit.
- **Tests:** 13 pass. One runs the real npm CLI end to end:
  - it publishes two dev packages with `--tag`, then runs `whoami` and `view`;
  - a plain `latest` publish is refused;
  - a cold install with the registry as the only registry pulls an upstream-only transitive dependency;
  - the install is repeated from a second empty cache with the upstream shut down, and succeeds.
- **Manual smoke test** against the real registry.npmjs.org: `npm install @endo/patterns` and Yarn 4 `yarn add @endo/patterns` each resolved 13 transitive packages, all through the local registry.
- **CI fixes during the run:**
  - `SECURITY.md` had to match the standard template.
  - Node's built-in `fetch` throws unhandled errors under SES lockdown when upstream connections drop. I replaced it with a small adapter over Node's core `http`/`https` client, which never follows redirects. Production would have hit this too.

### kriscendobot/minion.town#135 (draft, base `main-c6788df`)
This is phase 1 of the design ("provisioning code, still dark"): merging it deploys nothing.
- **Service:** a systemd unit, `npm-minion-registry.service`, that listens only on `127.0.0.1:3003` as its own user.
- **Deploy script (`deploy-npm-registry.sh`):**
  - builds from a pinned `llm` commit;
  - checks the live store with the new release before switching over;
  - probes health and rolls back to the previous release on failure.
- **One-time scripts:**
  - `deploy-npm-registry-dns.sh` creates exactly the `npm.minion.town` A record and takes no arguments.
  - `deploy-npm-registry-secret.sh` creates or rotates the publisher secret and delivers it without the token appearing in SSM command text.
- **Supporting files:**
  - a start-up check script;
  - a backup/restore script;
  - a runbook (`deploy/aws/npm-registry/README.md`);
  - a section in `DEPLOYMENT.md`.
- **Caddy site:** kept outside `conf.d/`, so a merge can't switch on the public host before DNS exists.
- **Checks:** shellcheck is clean and the repo's CI passes.

### Divergences and gaps (also written in the PR bodies)
- **Directory-tree interface:** the registry reads package versions from its own tables, not through the npm-registry-as-directory-tree interface, which hasn't landed. The Endo design allows a temporary stand-in only if the HTTP handler is written against that interface, and this one isn't.
- **Links in tarballs:** tarballs containing hard or symbolic links are refused, including upstream ones, so such a dependency returns a 502 instead of installing.
- **Upstream metadata:** fetched in npm's abbreviated form to keep responses small, so upstream-only packages show fewer informational fields.
- **Pin:** `NPM_REGISTRY_ENDO_COMMIT` is empty and the deploy script refuses to run until #1362 merges on `llm`.
- **PR gate:** minion.town#135's body cites the design by PR number, not file path, because the design isn't merged. The PR-opening gate refused the path form since it couldn't read the file. With the design file present, it passes.

### Follow-ups
- Both PRs need a manual "run the gauntlet".
- After #1362 merges:
  - set the pin;
  - run the runbook's steps: deploy the service, deliver the secret, create DNS, move the Caddy site into `conf.d/`;
  - run the design's § 10 live acceptance test;
  - only then add the CD target.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-npm-minion-town-dev-registry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 230 tokens (19196428 cached reads)
- Output: 119983 tokens
- Cost: $8.194977600000001
- Wall-clock: 3780s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
