Completed the attention directive on kriskowal/garden #9.

**What the directive asked:** the maintainer pointed to the "inquisitor" tool (Agoric/agoric-sdk#11282), which tests an upgrade from a chain snapshot, and asked me to propose a shell script that ssh's into a chain follower, produces a snapshot, and scp's it back — noting the bot cannot run this itself.

**What I did:**
- Traced inquisitor's actual input: `inquisitor.mjs` takes one positional arg, a `swingstore.sqlite`, and reads the captured height from the store's `host.height` key. Confirmed from agoric-sdk master that the swing-store lives at `<cosmos-home>/data/agoric/swingstore.sqlite` (default home `~/.agoric`). So the "chain snapshot" inquisitor wants is a consistent copy of the follower's swing-store DB.
- Wrote `scripts/agoric/fetch-chain-snapshot.sh` (new `scripts/agoric/` dir). It ssh's into a follower, produces a transactionally-consistent copy via SQLite `VACUUM INTO` (safe against the live node, no WAL/SHM needed), supports a `--halt-height N` mode to stop the node for deterministic upgrade-block alignment then restart, runs `PRAGMA integrity_check`, compresses (zstd/gzip auto), verifies a sha256 match after transfer, and prints the captured height plus the exact inquisitor follow-on commands. Parameterized for ssh target, remote home, node stop/start commands, output path, compression.
- Validated: `bash -n` clean, **shellcheck clean**, `--help` and the missing-`--host` error path smoke-tested.

**What changed:**
- Committed `scripts/agoric/fetch-chain-snapshot.sh` to `origin/main2` (commit `d920afa63`; lands on next deploy).
- Posted the proposal as a comment on issue #9 (https://github.com/kriskowal/garden/issues/9#issuecomment-4836814906) as `kriscendobot`: rationale, approach, usage, committed path, and the full script in a collapsed block.

**Follow-ups / open questions surfaced to the maintainer in the comment:** the script assumes default cosmos home `~/.agoric`, `sqlite3` present on the follower, and `sudo systemctl stop/start agd` to halt. I asked the maintainer to confirm these against their actual followers, and offered to switch the deterministic mode to a cosmos-native halt-at-height path if their followers expose one. No upstream agoric/agoric-sdk interaction was performed (scope respected; all references are read-only).

Self-improvement: nothing this time.
