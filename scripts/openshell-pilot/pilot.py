#!/usr/bin/env python3
"""Host-only OpenShell v0.1.2 pilot; standard library only."""
import argparse
import ctypes
import datetime
import fcntl
import hashlib
import json
import os
from pathlib import Path
import platform
import pwd
import re
import secrets
import shutil
import subprocess
import sys
import tarfile
import time

VERSION = "0.1.2"
COMMIT = "1358941b818d4126a7374aaf5216d87fc960e122"
NAME = "garden-openshell-pilot"
MARKER = "garden-openshell-pilot-v1\n"
CHECKSUMS = {
    "x86_64": {
        "openshell": "7eb6917285331a09e3300266a0558616481a5e9927cae2612ea07c4045b6dd6f",
        "openshell-gateway": "218d887845b3a020ab7535c9985eb9c666d6938f144044957f8b82b42892aadb",
    },
    "aarch64": {
        "openshell": "9880c5776688231d5242deb046cdee361734f94901b9123949a0baf29fdadd9e",
        "openshell-gateway": "8ec1b6ca5b71ef5085fa51f3244d719a541e8f0d58cc569c7a0d6705b6204397",
    },
}
UNITS = (NAME + "-podman.service", NAME + "-gateway.service")
FORBIDDEN = {".claude", ".codex", ".ssh", ".aws", "ferry", "maintainer"}


class PilotError(Exception):
    pass


def require(condition, message):
    if not condition:
        raise PilotError(message)


def in_container():
    if any(Path(p).exists() for p in ("/.dockerenv", "/run/.containerenv", "/run/systemd/container")):
        return True
    if os.environ.get("container"):
        return True
    try:
        if re.search(r"docker|containerd|libpod|lxc", Path("/proc/1/cgroup").read_text()):
            return True
    except OSError:
        return True
    detector = shutil.which("systemd-detect-virt")
    return bool(detector and subprocess.run([detector, "--container", "--quiet"], check=False).returncode == 0)


def host_guard():
    require(platform.system() == "Linux", "This pilot requires the Linux host.")
    require(not in_container(), "HOST ONLY: leave the garden container. No install, socket, or user unit is allowed here.")
    require(os.getuid() != 0, "Run as the host's ordinary user, never root or sudo.")
    require(platform.node().split(".")[0] == "endolin-garden2", "This trial is restricted to host endolin-garden2.")


def safe_path(path):
    path = Path(path).expanduser().absolute()
    require(not any(part in FORBIDDEN for part in path.parts), "Refusing a credential/maintainer path.")
    require("/.config/gh" not in str(path) and "auth.json" not in path.parts
            and ".credentials.json" not in path.parts, "Refusing an authentication path.")
    for ancestor in (path, *path.parents):
        require(not ancestor.is_symlink(), "Symlink paths are refused: " + str(ancestor))
    require(".." not in path.parts, "Path traversal is refused.")
    return path


def owned_directory(path):
    path = safe_path(path)
    marker = path / ".pilot-owned"
    if path.exists():
        require(path.is_dir() and path.stat().st_uid == os.getuid(), "Directory is not user-owned: " + str(path))
        require(marker.is_file() and not marker.is_symlink() and marker.read_text() == MARKER,
                "Refusing an unmarked existing directory: " + str(path))
    else:
        path.mkdir(parents=True, mode=0o700)
        marker.write_text(MARKER)
    path.chmod(0o700)


def write_json(path, value):
    temporary = path.with_suffix(path.suffix + ".new")
    temporary.write_text(json.dumps(value, indent=2) + "\n")
    temporary.replace(path)


def clean_environment(home):
    return {"HOME": str(home), "USER": pwd.getpwuid(os.getuid()).pw_name,
            "LOGNAME": pwd.getpwuid(os.getuid()).pw_name, "PATH": "/usr/bin:/bin",
            "LANG": "C.UTF-8", "OPENSHELL_TELEMETRY_ENABLED": "false",
            "AWS_EC2_METADATA_DISABLED": "true"}


def unit_word(value):
    return json.dumps(str(value).replace("%", "%%").replace("$", "$$"))


class Pilot:
    def __init__(self):
        self.home = safe_path(Path.home())
        base = Path(os.environ.get("XDG_STATE_HOME", self.home / ".local/state"))
        self.state = safe_path(base / "openshell-pilot")
        require(self.state.is_relative_to(self.home) and self.state != self.home,
                "XDG_STATE_HOME must be below your home, outside /tmp.")
        self.prefix = safe_path(self.home / ".local/lib/openshell-pilot")
        self.units = safe_path(self.home / ".config/systemd/user")
        self.runtime = Path("/run/user") / str(os.getuid()) / "openshell-pilot"
        self.socket = self.runtime / "podman.sock"
        self.environment = clean_environment(self.state / "home")
        self.environment.update({
            "XDG_CONFIG_HOME": str(self.state / "config"),
            "XDG_STATE_HOME": str(self.state / "state"),
            "XDG_DATA_HOME": str(self.state / "data"),
            "XDG_CACHE_HOME": str(self.state / "cache"),
            "XDG_RUNTIME_DIR": str(self.runtime.parent),
            "DBUS_SESSION_BUS_ADDRESS": "unix:path=" + str(self.runtime.parent / "bus"),
            "TMPDIR": str(self.state / "temporary"),
        })
        self.checks = []

    def initialize(self):
        owned_directory(self.state)
        for name in ("home", "config", "state", "data", "cache", "temporary"):
            (self.state / name).mkdir(exist_ok=True, mode=0o700)

    def record(self, name, passed, detail):
        result = {"check": name, "status": "PASS" if passed else "FAIL", "detail": detail}
        self.checks.append(result)
        print(f"{result['status']} {name}: {detail}", flush=True)
        return passed

    def save(self, phase):
        write_json(self.state / (phase + "-results.json"), {
            "time": datetime.datetime.now(datetime.timezone.utc).isoformat(),
            "host": platform.node(), "kernel": platform.release(), "version": VERSION,
            "source": COMMIT, "checks": self.checks,
        })

    def run(self, command, *, environment=None, timeout=120, check=True, input_text=None):
        result = subprocess.run([str(p) for p in command], env=environment or self.environment,
                                input=input_text, capture_output=True, text=True, timeout=timeout, check=False)
        if check and result.returncode:
            # Provider errors can contain submitted secrets. Never echo subprocess output.
            raise PilotError(f"{Path(command[0]).name} {command[1] if len(command) > 1 else ''} failed (exit {result.returncode}); output withheld to protect credentials")
        return result

    def systemctl(self, *arguments, check=True):
        environment = dict(self.environment, DBUS_SESSION_BUS_ADDRESS="unix:path=" + str(self.runtime.parent / "bus"))
        return self.run(["/usr/bin/systemctl", "--user", *arguments], environment=environment, check=check)

    def podman(self, *arguments, **options):
        return self.run(["/usr/bin/podman", "--root", self.state / "containers",
                         "--runroot", self.runtime / "storage", *arguments], **options)

    def cli(self, *arguments, environment=None, **options):
        return self.run([self.prefix / "bin/openshell", "--gateway", NAME,
                         "--gateway-endpoint", "https://127.0.0.1:17670", *arguments],
                        environment=environment, **options)

    def preflight(self):
        self.checks = []
        dependencies = {
            "podman": "ROOT (Debian/Ubuntu): apt install podman",
            "newuidmap": "ROOT: apt install uidmap", "newgidmap": "ROOT: apt install uidmap",
            "unshare": "ROOT: apt install util-linux", "findmnt": "ROOT: apt install util-linux",
            "openssl": "ROOT: apt install openssl", "systemctl": "ROOT: apt install systemd",
            "loginctl": "ROOT: apt install systemd", "curl": "ROOT: apt install curl",
        }
        for command, remedy in dependencies.items():
            self.record(command, bool(shutil.which(command)), "available" if shutil.which(command) else remedy)
        user = pwd.getpwuid(os.getuid()).pw_name
        for kind in ("subuid", "subgid"):
            path = Path("/etc") / kind
            entries = path.read_text().splitlines() if path.exists() else []
            found = any(len(parts := row.split(":")) == 3 and parts[0] in (user, str(os.getuid()))
                        and parts[2].isdigit() and int(parts[2]) >= 65536 for row in entries)
            self.record(kind, found, ">=65536 subordinate IDs" if found else
                        f"ROOT: allocate a NON-OVERLAPPING range in /etc/{kind} for {user}; administrator chooses range")
        if shutil.which("unshare"):
            self.record("user namespaces", self.run(["unshare", "--user", "--map-root-user", "true"], check=False).returncode == 0,
                        "unshare probe; if denied, ROOT review user.max_user_namespaces and AppArmor unprivileged-userns policy; no automatic sysctl changes")
        if shutil.which("loginctl"):
            linger = self.run(["loginctl", "show-user", user, "--property=Linger", "--value"], check=False)
            self.record("linger", linger.returncode == 0 and linger.stdout.strip() == "yes",
                        f"ROOT/POLKIT if absent: loginctl enable-linger {user}")
        unified = Path("/sys/fs/cgroup/cgroup.controllers").exists()
        self.record("cgroup v2", unified, "ROOT if absent: enable unified cgroup v2 at boot")
        if shutil.which("systemctl"):
            manager = self.systemctl("show", "--property=ControlGroup", "--value", check=False)
            group = Path("/sys/fs/cgroup") / manager.stdout.strip().lstrip("/")
            controllers = group / "cgroup.controllers"
            delegated = (manager.returncode == 0 and bool(manager.stdout.strip()) and controllers.exists()
                         and {"cpu", "memory", "pids"} <= set(controllers.read_text().split()))
            self.record("user cgroup delegation", delegated,
                        "cpu/memory/pids available to host user manager; ROOT if absent: review user@.service Delegate= and re-login")
        architecture = platform.machine()
        self.record("architecture", architecture in CHECKSUMS, architecture)
        abi = -1
        if architecture in CHECKSUMS:
            library = ctypes.CDLL(None, use_errno=True)
            abi = library.syscall(444, 0, 0, 1)  # landlock_create_ruleset VERSION, x86_64/aarch64
        self.record("Landlock", abi >= 3, f"queried ABI {abi}; require >=3. ROOT if absent: kernel/LSM configuration, not just version number")
        actions = Path("/proc/sys/kernel/seccomp/actions_avail")
        self.record("seccomp user-notify", actions.exists() and "user_notif" in actions.read_text().split(),
                    "kernel action availability; active notification/ADDFD/task-memory qualification occurs at sandbox startup")
        if shutil.which("findmnt"):
            prefix_parent = self.prefix
            while not prefix_parent.exists():
                prefix_parent = prefix_parent.parent
            for label, target in (("prefix executable filesystem", prefix_parent),
                                  ("state executable filesystem", self.state), ("host /tmp noexec", Path("/tmp"))):
                options = self.run(["findmnt", "--noheadings", "--output", "OPTIONS", "--target", target], check=False)
                noexec = "noexec" in options.stdout.strip().split(",")
                if target == Path("/tmp"):
                    self.checks.append({"check": label, "status": "PASS" if noexec else "WARN",
                                        "detail": "noexec present" if noexec else "executable; pilot never installs or persists state here"})
                    print(self.checks[-1])
                else:
                    self.record(label, options.returncode == 0 and not noexec,
                                "ROOT if noexec: provide an executable user-owned home filesystem")
        self.save("preflight")
        require(not any(c["status"] == "FAIL" for c in self.checks), "Preflight failed. Apply the printed host prerequisites deliberately, then rerun. No sudo was run.")

    def install(self):
        self.preflight()
        owned_directory(self.prefix)
        binary_directory = self.prefix / "bin"
        binary_directory.mkdir(exist_ok=True)
        architecture = platform.machine()
        for binary, digest in CHECKSUMS[architecture].items():
            target = binary_directory / binary
            receipt = target.with_suffix(".sha256")
            if target.is_file() and receipt.is_file() and hashlib.sha256(target.read_bytes()).hexdigest() == receipt.read_text().strip():
                continue
            triple = architecture + "-unknown-linux-" + ("musl" if binary == "openshell" else "gnu")
            archive = self.state / "temporary" / (binary + ".tar.gz")
            url = f"https://github.com/NVIDIA/OpenShell/releases/download/v{VERSION}/{binary}-{triple}.tar.gz"
            self.run(["curl", "--fail", "--location", "--proto", "=https", "--proto-redir", "=https",
                      "--max-time", "180", "--output", archive, url], timeout=200)
            require(hashlib.sha256(archive.read_bytes()).hexdigest() == digest, "Pinned archive checksum mismatch; nothing executed")
            with tarfile.open(archive) as package:
                members = [m for m in package.getmembers() if m.isfile() and Path(m.name).name == binary]
                require(len(members) == 1, "Expected exactly one release binary")
                content = package.extractfile(members[0]).read()
            temporary = target.with_suffix(".new")
            temporary.write_bytes(content)
            temporary.chmod(0o755)
            temporary.replace(target)
            receipt.write_text(hashlib.sha256(content).hexdigest() + "\n")
            archive.unlink()
        write_json(self.state / "release.json", {"version": VERSION, "source": COMMIT, "archives": CHECKSUMS[architecture]})
        print("Installed pinned CLI and gateway in " + str(binary_directory))

    def installed(self):
        for binary in ("openshell", "openshell-gateway"):
            target = self.prefix / "bin" / binary
            require(target.is_file(), "Run install first.")
            require(hashlib.sha256(target.read_bytes()).hexdigest() == target.with_suffix(".sha256").read_text().strip(), "Installed binary hash changed")
            require(VERSION in self.run([target, "--version"]).stdout, "Unexpected binary version")

    def certificate(self, name, extensions):
        directory = self.state / "tls"
        directory.mkdir(exist_ok=True)
        key, certificate = directory / (name + ".key"), directory / (name + ".crt")
        if certificate.exists():
            require(key.is_file(), "Partial TLS state; uninstall and reinstall")
            return
        self.run(["openssl", "req", "-x509", "-newkey", "rsa:3072", "-nodes", "-days", "7",
                  "-subj", "/CN=" + name, "-keyout", key, "-out", certificate, "-addext", extensions])

    def setup_tls(self):
        self.certificate("ca", "basicConstraints=critical,CA:TRUE")
        directory = self.state / "tls"
        if not (directory / "signing.pem").exists():
            self.run(["openssl", "genpkey", "-algorithm", "Ed25519", "-out", directory / "signing.pem"])
            self.run(["openssl", "pkey", "-in", directory / "signing.pem", "-pubout", "-out", directory / "public.pem"])
            (directory / "kid").write_text(secrets.token_hex(16))
        for name, extensions in {
            "server": "subjectAltName=IP:127.0.0.1,DNS:localhost,DNS:host.openshell.internal\nextendedKeyUsage=serverAuth\n",
            "client": "extendedKeyUsage=clientAuth\n",
            "echo": "subjectAltName=DNS:host.openshell.internal,IP:127.0.0.1\nextendedKeyUsage=serverAuth\n",
        }.items():
            certificate = directory / (name + ".crt")
            if not certificate.exists():
                self.run(["openssl", "req", "-new", "-newkey", "rsa:3072", "-nodes", "-subj", "/CN=" + name,
                          "-keyout", directory / (name + ".key"), "-out", directory / (name + ".csr")])
                extension_file = directory / (name + ".extensions")
                extension_file.write_text(extensions)
                self.run(["openssl", "x509", "-req", "-days", "7", "-in", directory / (name + ".csr"),
                          "-CA", directory / "ca.crt", "-CAkey", directory / "ca.key", "-CAcreateserial",
                          "-extfile", extension_file, "-out", certificate])
            self.run(["openssl", "x509", "-checkend", "3600", "-noout", "-in", certificate])
        client = self.state / "config/openshell/gateways" / NAME / "mtls"
        client.mkdir(parents=True, exist_ok=True)
        for source, target in (("ca.crt", "ca.crt"), ("client.crt", "tls.crt"), ("client.key", "tls.key")):
            shutil.copyfile(directory / source, client / target)

    def render_units(self):
        self.units.mkdir(parents=True, exist_ok=True)
        environment = [f"{key}={value}" for key, value in self.environment.items()]
        podman_command = ["/usr/bin/env", "-i", *environment, "/usr/bin/podman", "--root", str(self.state / "containers"),
                          "--runroot", str(self.runtime / "storage"), "system", "service", "--time=0", "unix://" + str(self.socket)]
        gateway_command = ["/usr/bin/env", "-i", *environment, str(self.prefix / "bin/openshell-gateway"),
                           "--config", str(self.state / "gateway.toml")]
        for unit, command in zip(UNITS, (podman_command, gateway_command)):
            dependencies = f"Requires={UNITS[0]}\nAfter={UNITS[0]}\n" if unit == UNITS[1] else ""
            readiness = ""
            if unit == UNITS[1]:
                readiness = "ExecStartPre=" + " ".join(map(unit_word, [
                    "/usr/bin/curl", "--fail", "--silent", "--max-time", "3", "--retry", "15",
                    "--retry-all-errors", "--retry-delay", "1", "--unix-socket", self.socket,
                    "http://localhost/_ping"])) + "\n"
            content = (f"# {MARKER}[Unit]\nDescription=Garden OpenShell host pilot\n{dependencies}"
                       "[Service]\nType=simple\nUMask=0077\nDelegate=yes\nRestart=on-failure\nRestartSec=3\n"
                       f"RuntimeDirectory=openshell-pilot\nRuntimeDirectoryMode=0700\nRuntimeDirectoryPreserve=yes\nWorkingDirectory={unit_word(self.state)}\n"
                       f"{readiness}ExecStart={' '.join(map(unit_word, command))}\nTimeoutStopSec=90\n"
                       "[Install]\nWantedBy=default.target\n")
            path = safe_path(self.units / unit)
            require(not path.exists() or path.read_text().startswith("# " + MARKER), "Refusing unrelated unit: " + str(path))
            path.write_text(content)

    def health(self, socket_only=False):
        if socket_only:
            result = self.run(["curl", "--fail", "--silent", "--max-time", "2", "--unix-socket", self.socket,
                               "http://localhost/_ping"], check=False, timeout=5)
            return result.returncode == 0 and result.stdout.strip() == "OK"
        try:
            return self.cli("gateway", "info", "--output", "json", check=False, timeout=8).returncode == 0
        except subprocess.TimeoutExpired:
            return False

    def wait_health(self, socket_only=False):
        for _ in range(45):
            if self.health(socket_only):
                return
            time.sleep(1)
        raise PilotError("Service did not become healthy; inspect journalctl --user -u " + (UNITS[0] if socket_only else UNITS[1]))

    def prepare_images(self):
        receipt = self.state / "images.json"
        if receipt.exists():
            images = json.loads(receipt.read_text())
            for image in images.values():
                self.podman("image", "exists", image)
            return images
        images = {}
        for name, reference in (("base", "docker.io/library/ubuntu:24.04"),
                                ("runtime", f"ghcr.io/nvidia/openshell/sandbox:{VERSION}"),
                                ("supervisor_base", f"ghcr.io/nvidia/openshell/supervisor:{VERSION}")):
            self.podman("pull", reference, timeout=600)
            images[name] = self.podman("image", "inspect", "--format", "{{.Id}}", reference).stdout.strip()
        context = self.state / "build"
        context.mkdir(exist_ok=True)
        shutil.copyfile(self.state / "tls/ca.crt", context / "pilot-ca.crt")
        shutil.copyfile(Path(__file__).with_name("workload.py"), context / "workload.py")
        (context / "Containerfile").write_text(
            f"FROM {images['base']} AS workload\n"
            "RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends python3 curl git gh awscli ca-certificates && rm -rf /var/lib/apt/lists/*\n"
            "RUN mkdir -p /sandbox && chown 1000:1000 /sandbox && printf 'synthetic-landlock-canary' > /forbidden-canary\n"
            "COPY workload.py /usr/local/lib/openshell-pilot-workload.py\n"
            "COPY pilot-ca.crt /usr/local/share/ca-certificates/pilot.crt\n"
            "RUN update-ca-certificates\nENV HOME=/sandbox\nUSER 1000:1000\nWORKDIR /sandbox\n"
            f"FROM {images['supervisor_base']} AS supervisor\n"
            "COPY --from=workload /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt\n")
        for name in ("workload", "supervisor"):
            tag = f"localhost/{NAME}-{name}:{VERSION}"
            self.podman("build", "--target", name, "--tag", tag, "--file", context / "Containerfile", context, timeout=900)
            images[name] = self.podman("image", "inspect", "--format", "{{.Id}}", tag).stdout.strip()
        write_json(receipt, images)
        return images

    def configure_gateway(self, images):
        quote = lambda value: json.dumps(str(value))
        tls = self.state / "tls"
        content = f'''[openshell]
version = 2
[openshell.gateway]
name = "{NAME}"
bind_address = "127.0.0.1:17670"
compute_driver = "podman"
guest_tls_ca = {quote(tls / 'ca.crt')}
guest_tls_cert = {quote(tls / 'client.crt')}
guest_tls_key = {quote(tls / 'client.key')}
[openshell.gateway.tls]
cert_path = {quote(tls / 'server.crt')}
key_path = {quote(tls / 'server.key')}
client_ca_path = {quote(tls / 'ca.crt')}
[openshell.gateway.mtls_auth]
enabled = true
[openshell.gateway.gateway_jwt]
signing_key_path = {quote(tls / 'signing.pem')}
public_key_path = {quote(tls / 'public.pem')}
kid_path = {quote(tls / 'kid')}
gateway_id = "{NAME}"
[openshell.drivers.podman]
socket_path = {quote(self.socket)}
network_name = "{NAME}"
grpc_endpoint = "https://127.0.0.1:17670"
default_image = {quote(images['workload'])}
sandbox_runtime_image = {quote(images['runtime'])}
supervisor_image = {quote(images['supervisor'])}
image_pull_policy = "never"
enable_bind_mounts = false
allow_driver_config = true
sandbox_pids_limit = 128
health_check_interval_secs = 10
'''
        (self.state / "gateway.toml").write_text(content)
        self.run([self.prefix / "bin/openshell-gateway", "config", "preflight", "--path", self.state / "gateway.toml"])

    def up(self):
        self.preflight()
        self.installed()
        safe_path(self.runtime).mkdir(exist_ok=True, mode=0o700)
        require(self.podman("info", "--format", "{{.Host.Security.Rootless}}").stdout.strip() == "true",
                "Dedicated Podman store did not report rootless mode")
        self.setup_tls()
        self.render_units()
        self.systemctl("daemon-reload")
        self.systemctl("enable", "--now", UNITS[0])
        self.wait_health(socket_only=True)
        images = self.prepare_images()
        self.configure_gateway(images)
        self.systemctl("enable", UNITS[1])
        self.systemctl("restart", UNITS[1])
        self.wait_health()
        for binary in ("podman", "openssl"):
            version = self.run([binary, "--version" if binary == "podman" else "version"]).stdout.strip()
            self.record(binary + " version", True, version)
        self.record("gateway authenticated health", True, "mTLS gateway info; Podman socket health gated startup")
        self.save("up")

    def down(self):
        # Rootless Podman containers can outlive its API service. Stop them too.
        gateway = safe_path(self.units / UNITS[1])
        if gateway.exists():
            require(gateway.read_text().startswith("# " + MARKER), "Unowned unit")
            self.systemctl("disable", "--now", UNITS[1])
        if (self.state / "containers").exists():
            self.podman("stop", "--all", "--time", "20", timeout=90)
        for unit in UNITS[:1]:
            path = safe_path(self.units / unit)
            if path.exists():
                require(path.read_text().startswith("# " + MARKER), "Unowned unit")
                self.systemctl("disable", "--now", unit)
        print("Pilot containers and host user units stopped; state retained.")

    def uninstall(self):
        self.down()
        if (self.state / "containers").exists():
            self.podman("system", "reset", "--force", timeout=180)
        for unit in UNITS:
            path = self.units / unit
            if path.exists():
                path.unlink()
        self.systemctl("daemon-reload")
        for directory in (self.prefix, self.state):
            if directory.exists():
                owned_directory(directory)
                shutil.rmtree(directory)
        if self.runtime.exists():
            shutil.rmtree(self.runtime)
        print("Removed dedicated units, container store, pilot prefix and state. Supplied credential files are yours to revoke and remove.")

    def report(self):
        lines = ["# OpenShell host pilot results", "", f"Release: v{VERSION}; source: `{COMMIT}`.",
                 "", "These are host observations, not a production security attestation.", ""]
        for phase in ("preflight", "up", "test"):
            path = self.state / (phase + "-results.json")
            if not path.exists():
                lines.extend([f"{phase}: NOT RUN", ""])
                continue
            results = json.loads(path.read_text())
            lines.extend([f"{phase}: {results['time']}; host `{results['host']}`; kernel `{results['kernel']}`.", "",
                          "| Check | Result | Detail |", "| --- | --- | --- |"])
            for row in results["checks"]:
                cells = [str(row[key]).replace("|", "\\|").replace("\n", " ") for key in ("check", "status", "detail")]
                lines.append("| " + " | ".join(cells) + " |")
            lines.append("")
        for filename in ("release.json", "images.json"):
            if (self.state / filename).exists():
                lines.extend([filename + ":", "```json", (self.state / filename).read_text().strip(), "```", ""])
        lines.extend(["Follow-up: review failures and skipped stages before changing scope. No fleet, subscription OAuth, Codex authentication directory, SSH key, or ferry credential is authorized.", ""])
        target = self.state / ("openshell-pilot-results-" + datetime.date.today().isoformat() + ".md")
        target.write_text("\n".join(lines))
        print(target)


def arguments(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("preflight", "install", "up", "test", "report", "down", "uninstall"))
    parser.add_argument("--dry-run", action="store_true", help="print plan only; permitted in a container; no subprocesses or writes")
    parser.add_argument("--github", action="store_true")
    parser.add_argument("--github-token-file")
    parser.add_argument("--github-login")
    parser.add_argument("--github-repository", help="owner/disposable-repository")
    parser.add_argument("--aws", action="store_true")
    parser.add_argument("--aws-credentials-file", help="owner-only JSON containing throwaway temporary STS source credentials")
    parser.add_argument("--aws-role-arn")
    parser.add_argument("--aws-region")
    parser.add_argument("--aws-bucket")
    parser.add_argument("--attest-throwaway-read-only", action="store_true")
    return parser.parse_args(argv)


def validate_arguments(options):
    optional = options.github or options.aws or any((options.github_token_file, options.github_login,
               options.github_repository, options.aws_credentials_file, options.aws_role_arn,
               options.aws_region, options.aws_bucket, options.attest_throwaway_read_only))
    require(not optional or options.command == "test", "Credential flags are only valid for test.")
    for enabled, values, name in ((options.github, (options.github_token_file, options.github_login, options.github_repository), "GitHub"),
                                  (options.aws, (options.aws_credentials_file, options.aws_role_arn, options.aws_region, options.aws_bucket), "AWS")):
        require(not any(values) or enabled, name + " requires its explicit stage flag")
        require(not enabled or all(values), name + " requires all stage parameters")
    require(not (options.github or options.aws) or options.attest_throwaway_read_only,
            "Real stages require --attest-throwaway-read-only; never supply garden or maintainer credentials")
    for path in (options.github_token_file, options.aws_credentials_file):
        if path:
            safe_path(path)


def main():
    options = arguments()
    validate_arguments(options)
    if options.dry_run:
        print(json.dumps({"mode": "DRY RUN ONLY (no checks executed)", "command": options.command,
                          "version": VERSION, "host": "endolin-garden2", "driver": "rootless Podman",
                          "units": UNITS, "stages": ["synthetic"] + (["github"] if options.github else []) + (["aws"] if options.aws else []),
                          "state": "$XDG_STATE_HOME/openshell-pilot (default $HOME/.local/state/openshell-pilot)",
                          "prefix": "$HOME/.local/lib/openshell-pilot"}, indent=2))
        return
    host_guard()
    os.umask(0o077)
    pilot = Pilot()
    pilot.initialize()
    with (pilot.state / "lock").open("w") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        if options.command == "test":
            sys.modules.setdefault("pilot", sys.modules[__name__])
            from stages import test
            test(pilot, options)
        else:
            getattr(pilot, options.command)()


if __name__ == "__main__":
    try:
        main()
    except (PilotError, OSError, subprocess.TimeoutExpired, ValueError) as error:
        print("FAIL: " + str(error), file=sys.stderr)
        sys.exit(1)
