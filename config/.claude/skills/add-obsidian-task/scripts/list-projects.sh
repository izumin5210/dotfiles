#!/bin/bash
set -euo pipefail
obsidian tags | grep "^#task/pj/" | sed 's|#task/pj/||'
