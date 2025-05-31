# Jellyfin GPU Exporter

A lightweight Prometheus exporter that monitors the NVIDIA GPU usage inside a running **Jellyfin Docker container**.

This exporter runs independently, calls `nvidia-smi` inside the Jellyfin container using `docker exec`, and exposes metrics on `/metrics` for Prometheus scraping.

---

## 📦 Features
- GPU presence check
- Memory usage (used/total)
- Utilization percentage
- Temperature (°C)
- Power draw (watts)
- Number of active GPU processes
- Error counter (for failed scrapes)

---

## 🚀 Getting Started

### 1. Build the image (optional)
```bash
git clone https://github.com/youruser/jellyfin-gpu-exporter.git
cd jellyfin-gpu-exporter
docker build -t ajwest3d/jellyfin-gpu-exporter:latest .
```

### 2. Run the exporter
```bash
docker run -d \
  --name jellyfin-gpu-exporter \
  -e TARGET_CONTAINER=jellyfin \
  -e EXPORTER_PORT=9109 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -p 9109:9109 \
  ajwest3d/jellyfin-gpu-exporter:latest
```

- `TARGET_CONTAINER`: Name of your Jellyfin container (default: `jellyfin`)
- `EXPORTER_PORT`: Port to expose metrics on (default: `9109`)

> 🔐 Note: Mounting Docker socket allows this container to run `docker exec` commands into Jellyfin. Only do this on trusted hosts.

---

## 📈 Metrics exposed
| Metric Name | Description |
|-------------|-------------|
| `jellyfin_gpu_ok` | 1 if GPU is available, else 0 |
| `jellyfin_gpu_memory_used_mebibytes` | Memory used (MiB) |
| `jellyfin_gpu_memory_total_mebibytes` | Total memory (MiB) |
| `jellyfin_gpu_utilization_percent` | GPU usage (%) |
| `jellyfin_gpu_temperature_celsius` | GPU temp (°C) |
| `jellyfin_gpu_power_draw_watts` | Estimated power usage (W) |
| `jellyfin_gpu_process_count` | Number of active GPU processes |
| `jellyfin_gpu_exporter_errors_total` | Exporter errors total counter |

---

## 📡 Prometheus config
```yaml
- job_name: 'jellyfin-gpu'
  static_configs:
    - targets: ['localhost:9109']
```

---

## 🧪 Local test
Visit the metrics endpoint in a browser:
```
http://localhost:9109/metrics
```

You should see all metrics in Prometheus format.

---

## 🛠 Future Ideas
- Multi-container support
- Multi-GPU support
- Label per GPU index
- Optional metrics filtering

---

## 📄 License
MIT

---

Built with ❤️ by [@ajwest3d](https://hub.docker.com/u/ajwest3d)
