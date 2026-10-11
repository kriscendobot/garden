---
title: "ADR 0045: Exact Debian projection, worker construction, and archive inspection"
source: docs/decisions/0045-debian-package-worker-custody.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [node-packaging, software-supply-chain, capability-security]
status: current
---

> Abstract: An accepted Debian projection binds paths, modes, target architecture, dependencies, tool identity, deterministic staging, compatible-worker execution, and complete archive inspection without installation.

### Derive an exact Debian projection before construction

Add a typed Debian projection that is included in the apt packager identity and whose
generated control bytes are an exact `PackageInput`. It binds:

- the source `PackagePlan` identity;
- Debian package name and semantic version;
- target architecture mapped from the accepted target and observed worker architecture
  (`x86_64` to `amd64`, `arm64` or `aarch64` to `arm64`), with no ambient fallback to
  `all`;
- every logical input to one canonical absolute package path and exact file mode;
- every entrypoint to a unique `/usr/bin/<name>` installed path;
- specification and SBOM resources beneath
  `/usr/share/doc/<package>/literate-ai/`;
- remaining product files beneath `/usr/lib/<package>/`;
- every external runtime requirement to an exact Debian package coordinate derived
  from the accepted resolved CycloneDX closure; and
- the bound Debian tool identity and reproducibility policy.

An external runtime requirement without one unambiguous accepted Debian coordinate is a
typed refusal. Display names such as `locked root language runtime` are never converted
into package names by string guessing. Duplicate, reserved, case-fold-colliding or
escaping installed paths are refused before staging.

### Bind native tooling and deterministic inputs

Introduce a `dpkg-deb` tool binding containing the resolved executable path, executable
digest, bounded version probe and fixed arguments. Recheck the executable before and
after every invocation. Construction stages only exact plan inputs beneath a fresh
directory inside worker `OBJ_DIR`, assigns declared modes, root ownership metadata and
one fixed timestamp, and invokes `dpkg-deb` with deterministic compression and
root-owner-group behavior. Locale, timezone, umask and `SOURCE_DATE_EPOCH` are fixed and
bound by the packager identity.

The staged control archive contains only the generated `control` file. Maintainer
scripts, conffile declarations and triggers are outside this first contract and are
refused. Construction never installs, publishes or executes package payloads.

### Execute where the package tools and target are valid

Local construction is allowed only when the controller itself is the selected healthy,
compatible Linux worker. Otherwise the controller sends a serializable package request
through the selected worker transport. The request binds the worker catalog and fresh
observation, Debian projection, plan, exact input blob references, deadline and output
bounds. The worker returns immutable `.deb` bytes plus bounded inspection evidence;
the controller rehashes both before admitting them to package custody.

Package dispatch uses the production command or SSH actuation boundary from ADR 0044;
a controller callback that happens to run locally is not remote evidence. Package bytes
remain below worker and controller `OBJ_DIR` roots, and credentials or private worker
locations never enter project authority.

### Inspect the complete archive without installing it

Verification starts from the recorded outer digest in a fresh directory. The bound
Debian inspection tool emits control fields plus control and filesystem tar streams.
The verifier parses those streams without installing or executing the package and
requires:

- exact package, version, architecture and dependency fields;
- no undeclared control members or maintainer scripts;
- exactly the projected payload paths, types, ownership and modes;
- exact content digests for every regular file;
- only the explicitly projected entrypoint links, when links are used; and
- no absolute, traversal, device, FIFO, socket, hard-link or unbounded archive member.

Construction and verification use separate fresh staging roots. Verification does not
trust the construction tree, construction command output or the package result's file
list in place of inspecting the returned bytes.

Source: [docs/decisions/0045-debian-package-worker-custody.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0045-debian-package-worker-custody.md) at commit `fcc40bc6`.
