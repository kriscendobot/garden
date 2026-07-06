# Transcript durability (the archive)

How the garden keeps its own session transcripts instead of letting Claude Code
delete them, and how to browse one later. Two postures ship together:

- **Deletion is disabled fleet-wide.** Claude Code deletes session transcripts
  after `cleanupPeriodDays` (default 30). The garden sets `cleanupPeriodDays:
  36500` ("effectively never") — the `garden` launcher seeds it into every new
  instance's `~/.claude/settings.json`, and `transcript-capture.sh` reconciles the
  same key on every existing host each tick (settings.json is gitignored, so it
  cannot propagate via git — both prongs are required). This half needs **no
  arming**; it is on the moment this build deploys.
- **Transcripts are archived** into a dedicated `transcripts2` orphan branch on a
  configurable remote, gzip-compressed and lightly redacted, keyed by host. This
  half is **inert until you arm a transcripts remote** — until then every host
  still disables deletion and **spools** its finished transcripts locally
  (`$GARDEN_STATE/transcripts/spool`), losing nothing; only the push is gated.

Design and rationale: [`designs/transcript-journal-capture.md`](../../designs/transcript-journal-capture.md).

## Arming the archive (maintainer-only, deliberate)

Transcripts are the fleet's raw working memory — tokens that scrolled through a
shell, maintainer email, private reasoning. Publishing them is not a default any
agent picks, so the remote is per-instance journal config and arming is your
call.

1. **Create a remote to hold the branch.** A **dedicated private repo** is
   recommended (e.g. `kriskowal/garden-transcripts`); grant the bot push access.
   Using the garden's own origin is possible but **it is public** — that would
   publish the fleet's transcripts to the world.
2. **Point the fleet at it:**

   ```sh
   scripts/jobs/set-transcripts-remote.sh git@github.com:kriskowal/garden-transcripts.git
   ```

   This CAS-writes `config/transcripts-remote` on `journal2`. The next
   `garden-transcript-capture` tick on each host (hourly, at :20) reads it, drains
   its spool, and pushes. If the `transcripts2` branch does not exist on the
   remote yet, the first push creates it.
3. **Record it** with a journal `message` entry (the arming is a standing state
   change), and — because local `~/.claude` disk no longer self-prunes — post a
   fleet notice so every liaison surfaces the disk-posture change:

   ```sh
   scripts/jobs/send-msg.sh role/liaison "transcript durability is armed; local ~/.claude no longer self-prunes — size disk accordingly"
   ```

Left unarmed, nothing breaks: deletion stays disabled and transcripts spool
locally until you arm a remote (spooled entries drain on the first armed tick).

## Where transcripts land

```
transcripts/<GARDEN>/<encoded-cwd>/<session-id>.jsonl.gz   # one per captured session
index/<GARDEN>.tsv                                          # one appended row per capture
```

`<GARDEN>` is the host identity, so hosts never write each other's paths and
concurrent pushes conflict only at the CAS. Each `index/<GARDEN>.tsv` row is
`captured_at  session_id  job_base(or -)  encoded_cwd  raw_bytes  gz_bytes  raw_mtime`.
The encoded cwd of a gardener job contains `gardener-wt-<base>`, so the job base
is recoverable from the path alone.

## Browsing a transcript

Clone the transcripts remote's branch (or reuse a host's capture clone at
`$GARDEN_STATE/transcripts/clone`):

```sh
git clone --branch transcripts2 <transcripts-remote> /tmp/transcripts
# find a job's transcript across all hosts by its base:
ls /tmp/transcripts/transcripts/*/*gardener-wt-build-thing*/
# read one:
git -C /tmp/transcripts show transcripts2:transcripts/<host>/<dir>/<sid>.jsonl.gz | gunzip | less
```

Secrets in known shapes (GitHub tokens, `sk-ant-…`, `Authorization: Bearer …`)
are masked with `…REDACTED` before storage — defense in depth behind the
private-remote scoping, which is the primary guarantee. No redaction list is
complete; keep the remote private.

## Rotation (the escape hatch, if the branch ever grows too large)

With capture-on-completion each transcript is committed about once, so history
overhead stays near the tree size and this is unlikely to bite for years. No
pruning is built. If the branch ever needs shrinking, **rotate, don't rewrite**:

```sh
git -C <clone> tag transcripts2-archive-<year> transcripts2
git -C <clone> push origin transcripts2-archive-<year>
# then start a fresh orphan transcripts2 (delete the branch on the remote and let
# the next capture tick re-init it), keeping the tagged snapshot for cold storage.
```

File an issue when the corpus first warrants it rather than pre-optimizing.

## Knobs

| Env | Default | Meaning |
| --- | --- | --- |
| `GARDEN_TRANSCRIPTS_BRANCH` | `transcripts2` | the orphan branch transcripts live on |
| `GARDEN_TRANSCRIPTS_SPOOL` | `$GARDEN_STATE/transcripts/spool` | per-host completion-hook staging dir |
| `GARDEN_TRANSCRIPT_IDLE_SECS` | `21600` (6h) | a session is swept only once idle this long |

The optional local janitor (delete originals already archived) and a
`find-transcript.sh` wrapper are deferred follow-ons, not part of this build.
