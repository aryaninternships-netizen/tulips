#!/bin/bash
# Deploy Kismis ka बगीचा to production.
# Vercel account: aryaninternships-netizen (aryaninternships@gmail.com)
# Project:        kismis-ka-bageecha
# GitHub:         aryaninternships-netizen/tulips
# Domain:         redmantis.in  (A @ -> 76.76.21.21 at GoDaddy, www 308s to apex)
set -e
cd "$(dirname "$0")"
VT=$(security find-generic-password -a "$USER" -s vercel-aryaninternships -w)
GT=$(gh auth token -u aryaninternships-netizen)
MSG="${1:-Update}"
git add -A && git commit -qm "$MSG" || echo "(nothing to commit)"
REM=$(git remote get-url origin)
git remote set-url origin "https://aryaninternships-netizen:${GT}@github.com/aryaninternships-netizen/tulips.git"
git push -q origin HEAD || true
git remote set-url origin "$REM"
vercel deploy --prod --yes --token="$VT" | grep -iE "error|Production|Aliased"
