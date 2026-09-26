Pushed to `main2` (`7ac0d1da5..3acbb62ef`) on the first try.

## Completion report

**Job:** fix inaccuracies in the README "Build and enter the container" section.

**What I did:** Verified every command, flag, env var, and filename in the section against the actual sources of truth. My worktree's `garden` and `scripts/jobs/common.sh` are byte-identical to the deployed root checkout (confirmed by `diff`), so the reads below are the deployed truth.

**Verification (all grounded, nothing guessed):**
- `./garden build` / `./garden` / `./garden reset` — all three exist (`garden:56-58, 60-67, 124-129`; confirmed by running `./garden --help`). **Accurate** — the top "known suspect" (`./garden build`) is real, not a fiction.
- Bind-mount of the dir as container home, surviving `reset` — `garden:103`, and `reset` only `docker rm`s the container. **Accurate.**
- `.garden` is gitignored — `git check-ignore` → `.gitignore:23 /.[!.]*`. **Accurate.**
- `GARDEN_HOSTNAME` (default `endolinbot`) / `GARDEN_CONTAINER` semantics — `garden:8-9, 96-97`. **Accurate.**
- `GARDEN_SHARD` — **is honored by the code**: the `garden` launcher reads it (`garden:16`) and seeds `.garden` from it at creation (`garden:86-88`). It is a real launcher-time seed var, not a wrong alias. **Accurate as far as it went.**

**The one inaccuracy found and corrected:** The section attributed the shard identity that "keys job claims" to `GARDEN_SHARD`/`.garden` but **never named `GARDEN`**, the runtime var `common.sh` actually reads (`common.sh:39-72`: precedence `GARDEN` env → `.garden` file → `hostname -s`). A reader could not reconcile the doc with the code — which is exactly the ambiguity the directive flagged. I rewrote the identity paragraph to make the chain explicit: `GARDEN_SHARD` seeds `.garden` at creation; every fleet script then reads that file as its runtime `GARDEN` identity; and an exported `GARDEN` does **not** reach the systemd `--user` units, which is why the durable file exists (grounded in `common.sh:48-53`, `garden:46-47`). Doc and code now agree on the record.

**Net result:** GARDEN_SHARD, GARDEN_HOSTNAME, GARDEN_CONTAINER, `.garden`, and the three `./garden` subcommands are all confirmed real and correctly described; the only edit was to name the runtime `GARDEN` key so the two-var (seed → file → runtime) design is legible.

**Follow-ups:** None required. (One further real gotcha exists but is out of this section's scope: a *live* edit of `.garden` on a running pool is not auto-detected and needs a pool restart — `common.sh:60-66`. I did not document it here to keep the getting-started section focused; a maintainer may want it noted in the bring-up section if desired.)
