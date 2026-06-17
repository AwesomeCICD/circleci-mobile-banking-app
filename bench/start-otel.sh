#!/usr/bin/env bash
# Start the benchmark OTEL stack, using /tmp bind mounts when Desktop paths fail.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="${BENCH_OTEL_ROOT:-/tmp/demo-react-miniapps-bench}"

mkdir -p "$DEST/otel" "$DEST/prometheus" \
  "$DEST/grafana/provisioning/datasources" \
  "$DEST/grafana/provisioning/dashboards" \
  "$DEST/grafana/dashboards"

cp "$ROOT/bench/otel/collector.yaml" "$DEST/otel/"
cp "$ROOT/bench/prometheus/prometheus.yml" "$DEST/prometheus/"
cp -r "$ROOT/bench/grafana/provisioning/." "$DEST/grafana/provisioning/"
cp "$ROOT/bench/grafana/dashboards/"* "$DEST/grafana/dashboards/" 2>/dev/null || true

export BENCH_OTEL_ROOT="$DEST"
docker compose -f "$ROOT/bench/docker-compose.yml" -f "$ROOT/bench/docker-compose.otel-local.yml" up -d

curl -fsS -o /dev/null http://localhost:9091/-/healthy
curl -fsS -o /dev/null http://localhost:9090/-/ready
echo "OTEL stack up: pushgateway :9091  prometheus :9090  grafana :3000  otlp :4317"
