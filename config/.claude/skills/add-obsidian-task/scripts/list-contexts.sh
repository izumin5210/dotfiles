#!/bin/bash
set -euo pipefail
obsidian tags | grep "^#task/ctx/" | sed 's|#task/ctx/||'
