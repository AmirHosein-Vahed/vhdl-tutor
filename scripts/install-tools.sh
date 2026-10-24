#!/usr/bin/env bash
# Install GHDL and GTKWave.
#
#   scripts/install-tools.sh            system install (uses sudo)
#   scripts/install-tools.sh --rootless install GHDL under ~/.local, no root
#
# The rootless path downloads the Debian packages and unpacks them; it works on
# Ubuntu/Debian where apt-get download is available. GTKWave is not unpacked
# rootlessly because it needs a pile of GTK dependencies; use Surfer instead.

set -euo pipefail

ROOTLESS=0
[ "${1:-}" = "--rootless" ] && ROOTLESS=1

have() { command -v "$1" >/dev/null 2>&1; }

if have ghdl; then
  echo "GHDL already installed: $(ghdl --version | head -1)"
else
  if [ "$ROOTLESS" -eq 0 ] && have sudo && sudo -v 2>/dev/null; then
    echo "== installing ghdl and gtkwave with apt =="
    sudo apt-get update
    sudo apt-get install -y ghdl gtkwave
  else
    echo "== installing GHDL into ~/.local (no root) =="
    have apt-get || { echo "error: apt-get not found; install GHDL from https://github.com/ghdl/ghdl/releases"; exit 1; }
    tmp=$(mktemp -d)
    trap 'rm -rf "$tmp"' EXIT
    (
      cd "$tmp"
      apt-get download ghdl ghdl-common ghdl-mcode
      for deb in ./*.deb; do dpkg-deb -x "$deb" root; done
    )
    dest="$HOME/.local/opt/ghdl"
    rm -rf "$dest"
    mkdir -p "$dest" "$HOME/.local/bin"
    cp -a "$tmp/root/usr/bin" "$dest/"
    cp -a "$tmp/root/usr/lib" "$dest/"

    cat >"$HOME/.local/bin/ghdl" <<'WRAPPER'
#!/bin/sh
# Rootless GHDL installed by vhdl-tutor. GHDL looks for its precompiled
# libraries relative to GHDL_PREFIX; the Debian layout nests them per backend.
prefix="$HOME/.local/opt/ghdl/lib/ghdl"
for backend in mcode llvm gcc; do
  if [ -d "$prefix/$backend/vhdl" ]; then
    export GHDL_PREFIX="$prefix/$backend/vhdl"
    break
  fi
done
exec "$HOME/.local/opt/ghdl/bin/ghdl-$backend" "$@"
WRAPPER
    chmod +x "$HOME/.local/bin/ghdl"
    echo "installed $("$HOME/.local/bin/ghdl" --version | head -1)"
    case ":$PATH:" in
      *":$HOME/.local/bin:"*) ;;
      *) echo "note: add ~/.local/bin to PATH:  export PATH=\"\$HOME/.local/bin:\$PATH\"" ;;
    esac
  fi
fi

if ! have gtkwave && ! have surfer; then
  echo
  echo "No waveform viewer found. Either:"
  echo "  sudo apt-get install gtkwave"
  echo "  or install Surfer: https://surfer-project.org (single binary, GHW/VCD)"
fi

if ! have yosys; then
  echo
  echo "Optional: Yosys + ghdl-yosys-plugin for topic 10 (synthesis awareness)."
  echo "  sudo apt-get install yosys"
  echo "  https://github.com/ghdl/ghdl-yosys-plugin"
fi
