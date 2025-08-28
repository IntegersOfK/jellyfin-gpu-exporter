# Jellyfin GPU Exporter


A lightweight Prometheus exporter that monitors NVIDIA GPU usage for Jellyfin, supporting both **Docker containers** and **host/LXC** deployments.

This exporter runs independently, calls `nvidia-smi` (either inside a Docker container or directly on the host/LXC), and exposes metrics on `/metrics` for Prometheus scraping.

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

#### Docker mode (default)
```bash
docker run -d \
  --name jellyfin-gpu-exporter \
  -e TARGET_CONTAINER=jellyfin \
  -e EXPORTER_PORT=9109 \
  -e USE_DOCKER=true \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -p 9109:9109 \
  ajwest3d/jellyfin-gpu-exporter:latest
```


#### Host/LXC mode (no Docker)
You can run the exporter directly on the host or inside an LXC container with access to the NVIDIA GPU. The following steps will set up a Python virtual environment, install dependencies, and run the exporter as a service with minimal manual steps.

##### Quick Setup
```bash
git clone https://github.com/IntegersOfK/jellyfin-gpu-exporter.git
cd jellyfin-gpu-exporter
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
deactivate
sudo cp -r . /opt/jellyfin-gpu-exporter
sudo chown -R nobody:nogroup /opt/jellyfin-gpu-exporter
```

##### Example systemd service file
Create `/etc/systemd/system/jellyfin-gpu-exporter.service`:

```ini
[Unit]
Description=Jellyfin GPU Exporter
After=network.target

[Service]
Type=simple
User=nobody
WorkingDirectory=/opt/jellyfin-gpu-exporter
Environment=USE_DOCKER=false
Environment=EXPORTER_PORT=9109
ExecStart=/opt/jellyfin-gpu-exporter/venv/bin/python /opt/jellyfin-gpu-exporter/jellyfin_gpu_exporter.py
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

##### Enable and start the service
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now jellyfin-gpu-exporter
```

> 📝 The exporter will now run in a sandboxed Python venv as the `nobody` user. Adjust user/group as needed for your environment.

- `USE_DOCKER`: Set to `false` to run directly on the host/LXC (default: `true`).
- `TARGET_CONTAINER`: Only needed in Docker mode. Ignored in host mode.
- `EXPORTER_PORT`: Port to expose metrics on (default: `9109`).

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

> In host/LXC mode, the `container` label will be set to `host`.

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
