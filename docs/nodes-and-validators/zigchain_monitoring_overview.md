# Monitoring ZIGChain Nodes and Validators

> **Audience & Scope**
>
> This guide is intended for **Linux-based servers (Debian/Ubuntu)** and for operators running ZIGChain **nodes and validators**. All commands assume shell access and basic system administration knowledge.

This page provides **step-by-step instructions** to set up monitoring for ZIGChain infrastructure using a proven, open-source stack:

- **Prometheus** – metrics collection
- **Grafana** – dashboards and visualization
- **Third-party validator monitoring tools** – optional, external solutions

---

## Architecture Overview

The recommended architecture separates monitoring from blockchain workloads:

- **ZIGChain nodes / validators** expose Prometheus metrics
- A **dedicated monitoring server** runs Prometheus and Grafana
- Optional **third-party validator monitoring tools** may run on the monitoring server

> **Best practice**: Do not install Prometheus or Grafana on validator machines.

---

## 1. Enable Prometheus Metrics on ZIGChain Nodes

ZIGChain nodes expose metrics through `zigchaind`.

### Steps (run on each node or validator)

> The following commands assume a **Linux server** with `sed` available.

1. Back up the configuration file:
   ```bash
   cp $HOME/.zigchain/config/config.toml $HOME/.zigchain/config/config.toml.bkup
   ```

2. Enable Prometheus metrics using `sed`:
   ```bash
   sed -i 's/^prometheus = false/prometheus = true/' $HOME/.zigchain/config/config.toml
   sed -i 's/^prometheus_listen_addr = .*/prometheus_listen_addr = ":26660"/' $HOME/.zigchain/config/config.toml
   ```

3. Restart the node:
   ```bash
   sudo systemctl restart zigchaind.service
   ```

4. Verify the metrics endpoint:
   ```bash
   sudo netstat -tulnp | grep 26660
   curl http://localhost:26660/metrics
   ```

---

## 2. Install Prometheus (Monitoring Server)

### Steps

1. Update the package index:
   ```bash
   sudo apt update
   ```

2. Install Prometheus and node exporter:
   ```bash
   sudo apt install prometheus
   ```

3. Check services:
   ```bash
   systemctl status prometheus.service
   systemctl status prometheus-node-exporter.service
   sudo netstat -tulnp | grep prometheus
   ```

Prometheus runs on port **9090**.

---

## 3. Configure Prometheus Targets

Prometheus must be told which nodes and validators to scrape.

### Steps (run on the monitoring server)

1. Edit the Prometheus configuration file:
   ```bash
   sudo vi /etc/prometheus/prometheus.yml
   ```

2. Inside the `scrape_configs` section, add a new job **exactly as shown below** (replace IP addresses as needed):
   ```yaml
     - job_name: testnet_servers
       # Job to grab data from testnet servers, all in the same job.
       static_configs:
         - targets: ['IP_NODE_1:26660','IP_NODE_2:26660','IP_VALIDATOR_1:26660']
   ```

3. Save and exit, then restart Prometheus:
   ```bash
   sudo systemctl restart prometheus.service
   sudo systemctl status prometheus.service
   sudo journalctl -u prometheus.service --no-pager
   ```

4. (Optional) Check installed Prometheus version:
   ```bash
   prometheus --version
   sudo apt list | grep prometheus/stable
   dpkg -l | grep prometheus
   ```

---

## 4. Install Grafana

### Steps

1. Install prerequisites:
   ```bash
   sudo apt-get install -y apt-transport-https software-properties-common wget
   ```

2. Add Grafana GPG key and repository:
   ```bash
   sudo mkdir -p /etc/apt/keyrings/
   wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
   echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
   ```

3. Install Grafana:
   ```bash
   sudo apt-get update
   sudo apt-get install grafana
   ```

4. Start and enable the service:
   ```bash
   sudo systemctl start grafana-server
   sudo systemctl enable grafana-server
   systemctl status grafana-server.service
   sudo netstat -tulnp | grep 3000
   ```

Grafana runs on port **3000**.

---

## 5. Connect Grafana to Prometheus

1. Open Grafana in a browser:
   ```
   http://<monitoring-server-ip>:3000
   ```

2. Log in (default credentials):
   - Username: `admin`
   - Password: `admin`

3. Go to **Connections → Data sources → Add data source**
4. Select **Prometheus**
5. Set URL:
   ```
   http://127.0.0.1:9090
   ```
6. Click **Save & Test**

---

## 6. Validator Monitoring Tools (Third-Party)

Validator-level metrics (such as uptime, missed blocks, or signing activity) are **not provided directly by ZIGChain software**.

Some operators choose to rely on **third-party tools** from the Cosmos ecosystem to obtain this kind of information. One commonly referenced example is *Cosmos Validator Watcher*, among others.

> ⚠️ **Important Disclaimer**
>
> - Any validator monitoring tool is **third-party software**, not developed, maintained, or audited by the ZIGChain team.
> - ZIGChain **does not endorse, guarantee, or rely on** any specific external monitoring tool.
> - APIs, metrics, behavior, and availability of third-party tools may change or break without notice.
> - Operators are solely responsible for evaluating, maintaining, and securing any external tooling they deploy.

If validator-level insights are required, operators should carefully review available ecosystem tools, validate their correctness, and understand their operational risks before using them in production.

---

## 7. View Metrics in Grafana

You can now build dashboards showing:

- Node health and resource usage
- Consensus metrics
- Validator uptime, voting power, and missed blocks

---

