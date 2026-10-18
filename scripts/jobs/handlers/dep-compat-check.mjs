#!/usr/bin/env node
// dep-compat-check.mjs -- pure declaration-level compatibility checker.
//
// Reads { packageName, baseline, target, manifests } on stdin. `baseline` and
// `target` are the npm registry manifests for the outgoing and proposed
// versions; `manifests` are project package.json documents at the PR head.
// Prints one machine-shaped TSV proof of incompatibility, or nothing when the
// declarations do not prove one.
//
// A proof is about the BUMP, not the package: a conflict the outgoing version
// already has makes nothing worse, and proving it would close every later bump
// of that package the same way (endojs/endo-but-for-bots#1441, #1493). So each
// proof also requires the baseline to have been compatible, and a missing
// baseline proves nothing.

import { createRequire } from 'node:module';

const npmRoot = process.env.GARDEN_NPM_ROOT;
if (!npmRoot) {
  throw Error('GARDEN_NPM_ROOT is required');
}
const npmRequire = createRequire(`${npmRoot}/npm/package.json`);
const semver = npmRequire('semver');

let source = '';
for await (const chunk of process.stdin) source += chunk;
const input = JSON.parse(source);
const { packageName, baseline, target, manifests } = input;
if (!baseline || typeof baseline !== 'object') process.exit(0);

const clean = value =>
  typeof value === 'string' && /^[A-Za-z0-9@/._+*<>=~^| -]+$/.test(value);
const cleanPath = value =>
  typeof value === 'string' && /^[A-Za-z0-9._/-]+$/.test(value);
const validRange = value => clean(value) && semver.validRange(value) !== null;
const declarations = manifest => ({
  ...manifest.dependencies,
  ...manifest.devDependencies,
  ...manifest.optionalDependencies,
  ...manifest.peerDependencies,
});

// The baseline was compatible with a declared peer when it did not require
// that peer, or required a range that intersected the declaration. An
// unreadable baseline range is uncertainty, so it does not count.
const baselinePeerFits = (peer, declared) => {
  const peers = baseline.peerDependencies;
  if (peers === undefined) return true;
  if (!peers || typeof peers !== 'object') return false;
  const prior = peers[peer];
  if (prior === undefined) return true;
  return validRange(prior) && semver.intersects(declared, prior, { includePrerelease: true });
};

// Likewise for the Node floor: no engine declaration supports every floor.
const baselineNodeFits = floor => {
  const prior = baseline.engines?.node;
  if (prior === undefined) return true;
  return validRange(prior) && semver.satisfies(floor, prior, { includePrerelease: true });
};

const peerDependencies = target?.peerDependencies;
if (peerDependencies && typeof peerDependencies === 'object') {
  for (const [peer, required] of Object.entries(peerDependencies).sort()) {
    if (!clean(peer) || !validRange(required)) continue;
    for (const item of manifests) {
      const declared = declarations(item.manifest)[peer];
      if (!validRange(declared) || !cleanPath(item.path)) continue;
      if (
        !semver.intersects(declared, required, { includePrerelease: true }) &&
        baselinePeerFits(peer, declared)
      ) {
        process.stdout.write(
          ['incompatible', 'peer', peer, declared, required, item.path].join('\t') + '\n',
        );
        process.exit(0);
      }
    }
  }
}

const targetNode = target?.engines?.node;
if (validRange(targetNode)) {
  for (const item of manifests) {
    if (item.path !== 'package.json' && declarations(item.manifest)[packageName] === undefined) {
      continue;
    }
    const projectNode = item.manifest?.engines?.node;
    if (!validRange(projectNode) || !cleanPath(item.path)) continue;
    const floor = semver.minVersion(projectNode);
    // A project declaring support from this floor promises that the dependency
    // graph works there. Raising that floor is incompatible even if the two
    // unbounded ranges overlap at some later Node release. Only the bump that
    // raises the floor is proven: an outgoing version that already excluded
    // it makes the target no worse.
    if (
      floor &&
      !semver.satisfies(floor, targetNode, { includePrerelease: true }) &&
      baselineNodeFits(floor)
    ) {
      process.stdout.write(
        ['incompatible', 'node', floor.version, projectNode, targetNode, item.path].join('\t') + '\n',
      );
      process.exit(0);
    }
  }
}
