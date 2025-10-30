# Valkey Architecture Diagrams

This document provides comprehensive architecture diagrams for Valkey in both standalone and Sentinel modes.

## Table of Contents

- [Valkey Architecture Diagrams](#valkey-architecture-diagrams)
  - [Table of Contents](#table-of-contents)
  - [Valkey Standalone Architecture](#valkey-standalone-architecture)
    - [Standalone Mode Components](#standalone-mode-components)
  - [Valkey Sentinel Mode Architecture (High Availability)](#valkey-sentinel-mode-architecture-high-availability)
    - [Sentinel Mode Components](#sentinel-mode-components)
  - [Sentinel Failover Sequence](#sentinel-failover-sequence)
    - [Failover Process (6 Steps)](#failover-process-6-steps)
  - [Key Features](#key-features)
    - [Standalone Mode](#standalone-mode)
    - [Sentinel Mode (High Availability)](#sentinel-mode-high-availability)
    - [Comparison Table](#comparison-table)
    - [Monitoring Recommendations](#monitoring-recommendations)
    - [Security Considerations](#security-considerations)
  - [Additional Resources](#additional-resources)

______________________________________________________________________

## Valkey Standalone Architecture

A single-instance deployment suitable for development, testing, or non-critical workloads.

```mermaid
graph TB
    subgraph "Client Layer"
        C1[Client App 1]
        C2[Client App 2]
        C3[Client App N]
    end

    subgraph "Valkey Server"
        direction TB
        NET[Network Layer<br/>TCP/Unix Socket]
        CMD[Command Processor]

        subgraph "Core Engine"
            MEM[(In-Memory<br/>Data Store)]
            EVICT[Eviction Policy<br/>LRU/LFU/TTL]
            EXP[Expiration Handler]
        end

        subgraph "Persistence Layer"
            RDB[RDB Snapshots<br/>Point-in-time dumps]
            AOF[AOF Log<br/>Append-only file]
            SYNC[Background Save<br/>BGSAVE/BGREWRITEAOF]
        end

        subgraph "Module System"
            MOD[Extension Modules<br/>Custom commands]
        end
    end

    subgraph "Storage"
        DISK[(Persistent Storage<br/>RDB + AOF files)]
    end

    subgraph "Monitoring & Metrics"
        METRICS[Prometheus Exporter<br/>Port 9121]
        MON[Monitoring Tools<br/>Grafana/Datadog]
    end

    C1 --> NET
    C2 --> NET
    C3 --> NET

    NET --> CMD
    CMD --> MEM
    CMD --> MOD

    MEM --> EVICT
    MEM --> EXP

    MEM -.->|Async Write| RDB
    MEM -.->|Async Write| AOF

    RDB --> SYNC
    AOF --> SYNC

    SYNC --> DISK
    DISK -.->|Recovery| MEM

    CMD -.->|Metrics| METRICS
    MEM -.->|Stats| METRICS
    METRICS --> MON

    style C1 fill:#4CAF50,stroke:#388E3C,color:#fff
    style C2 fill:#4CAF50,stroke:#388E3C,color:#fff
    style C3 fill:#4CAF50,stroke:#388E3C,color:#fff
    style NET fill:#2196F3,stroke:#1976D2,color:#fff
    style CMD fill:#2196F3,stroke:#1976D2,color:#fff
    style MEM fill:#FF9800,stroke:#F57C00,color:#fff
    style EVICT fill:#FFC107,stroke:#FFA000,color:#000
    style EXP fill:#FFC107,stroke:#FFA000,color:#000
    style RDB fill:#9C27B0,stroke:#7B1FA2,color:#fff
    style AOF fill:#9C27B0,stroke:#7B1FA2,color:#fff
    style SYNC fill:#9C27B0,stroke:#7B1FA2,color:#fff
    style DISK fill:#607D8B,stroke:#455A64,color:#fff
    style METRICS fill:#00BCD4,stroke:#0097A7,color:#fff
    style MON fill:#00BCD4,stroke:#0097A7,color:#fff
    style MOD fill:#795548,stroke:#5D4037,color:#fff
```

### Standalone Mode Components

- **Network Layer**: Handles TCP/Unix socket connections
- **Command Processor**: Parses and executes Valkey commands
- **In-Memory Data Store**: Core key-value storage with O(1) operations
- **Eviction Policies**: LRU, LFU, or TTL-based memory management
- **Expiration Handler**: Automatically removes expired keys
- **RDB Snapshots**: Point-in-time binary dumps for backup/recovery
- **AOF Log**: Append-only command log for durability
- **Module System**: Custom commands and data types
- **Prometheus Exporter**: Real-time metrics on port 9121

______________________________________________________________________

## Valkey Sentinel Mode Architecture (High Availability)

Production-ready deployment with automatic failover and high availability.

```mermaid
graph TB
    subgraph "Client Layer"
        C1[Client App 1]
        C2[Client App 2]
        C3[Client App N]
        SDK[Valkey Client SDK<br/>Sentinel-aware]
    end

    subgraph "Sentinel Cluster - Quorum Based Monitoring"
        S1[Sentinel 1<br/>Port 26379]
        S2[Sentinel 2<br/>Port 26379]
        S3[Sentinel 3<br/>Port 26379]

        S1 -.->|Gossip Protocol| S2
        S2 -.->|Gossip Protocol| S3
        S3 -.->|Gossip Protocol| S1
    end

    subgraph "Valkey Primary Node"
        direction TB
        P[Valkey Primary<br/>Port 6379<br/>Read/Write]
        P_MEM[(In-Memory Store)]
        P_PERSIST[RDB + AOF<br/>Persistence]

        P --> P_MEM
        P_MEM -.-> P_PERSIST
    end

    subgraph "Valkey Replica 1"
        direction TB
        R1[Valkey Replica 1<br/>Port 6379<br/>Read-Only]
        R1_MEM[(In-Memory Store)]
        R1_PERSIST[RDB + AOF<br/>Persistence]

        R1 --> R1_MEM
        R1_MEM -.-> R1_PERSIST
    end

    subgraph "Valkey Replica 2"
        direction TB
        R2[Valkey Replica 2<br/>Port 6379<br/>Read-Only]
        R2_MEM[(In-Memory Store)]
        R2_PERSIST[RDB + AOF<br/>Persistence]

        R2 --> R2_MEM
        R2_MEM -.-> R2_PERSIST
    end

    subgraph "Monitoring & Alerting"
        METRICS[Metrics Exporter]
        ALERT[Alert Manager]
        DASH[Grafana Dashboard]
    end

    %% Client connections
    C1 --> SDK
    C2 --> SDK
    C3 --> SDK

    SDK -.->|1. Discover Primary| S1
    SDK -.->|1. Discover Primary| S2
    SDK -.->|1. Discover Primary| S3

    SDK ==>|2. Write Requests| P
    SDK -->|2. Read Requests| R1
    SDK -->|2. Read Requests| R2

    %% Sentinel monitoring
    S1 -.->|Health Check<br/>PING every 1s| P
    S1 -.->|Health Check| R1
    S1 -.->|Health Check| R2

    S2 -.->|Health Check| P
    S2 -.->|Health Check| R1
    S2 -.->|Health Check| R2

    S3 -.->|Health Check| P
    S3 -.->|Health Check| R1
    S3 -.->|Health Check| R2

    %% Replication
    P ==>|Async Replication<br/>Command Stream| R1
    P ==>|Async Replication<br/>Command Stream| R2

    %% Failover process
    S2 -.->|3. Quorum Vote<br/>on Failure| S1
    S3 -.->|3. Quorum Vote| S1
    S1 -.->|4. Promote Replica<br/>to Primary| R1
    S1 -.->|5. Reconfigure<br/>Replication| R2
    S1 -.->|6. Notify Clients<br/>New Topology| SDK

    %% Monitoring
    P -.-> METRICS
    R1 -.-> METRICS
    R2 -.-> METRICS
    S1 -.-> METRICS

    METRICS --> DASH
    METRICS --> ALERT

    %% Styling
    style C1 fill:#4CAF50,stroke:#388E3C,color:#fff
    style C2 fill:#4CAF50,stroke:#388E3C,color:#fff
    style C3 fill:#4CAF50,stroke:#388E3C,color:#fff
    style SDK fill:#66BB6A,stroke:#43A047,color:#fff

    style S1 fill:#FF5722,stroke:#E64A19,color:#fff
    style S2 fill:#FF5722,stroke:#E64A19,color:#fff
    style S3 fill:#FF5722,stroke:#E64A19,color:#fff

    style P fill:#2196F3,stroke:#1976D2,color:#fff
    style P_MEM fill:#64B5F6,stroke:#42A5F5,color:#fff
    style P_PERSIST fill:#90CAF9,stroke:#64B5F6,color:#000

    style R1 fill:#9C27B0,stroke:#7B1FA2,color:#fff
    style R1_MEM fill:#BA68C8,stroke:#AB47BC,color:#fff
    style R1_PERSIST fill:#CE93D8,stroke:#BA68C8,color:#000

    style R2 fill:#9C27B0,stroke:#7B1FA2,color:#fff
    style R2_MEM fill:#BA68C8,stroke:#AB47BC,color:#fff
    style R2_PERSIST fill:#CE93D8,stroke:#BA68C8,color:#000

    style METRICS fill:#00BCD4,stroke:#0097A7,color:#fff
    style ALERT fill:#FF9800,stroke:#F57C00,color:#fff
    style DASH fill:#00BCD4,stroke:#0097A7,color:#fff
```

### Sentinel Mode Components

- **Sentinel Cluster**: 3+ nodes (odd number) for quorum-based decisions
- **Gossip Protocol**: Sentinels communicate via pub/sub
- **Health Monitoring**: PING checks every 1 second
- **Quorum Voting**: Majority agreement required for failover
- **Primary Node**: Handles all write operations
- **Replica Nodes**: Handle read operations, can be promoted
- **Async Replication**: Commands streamed from primary to replicas
- **Sentinel-aware Clients**: Automatically discover current primary
- **Failover Time**: Typically 30-60 seconds

______________________________________________________________________

## Sentinel Failover Sequence

### Failover Process (6 Steps)

1. **Detection**: Sentinels detect primary failure via health checks (5s timeout)
1. **SDOWN → ODOWN**: Subjective down becomes objective down with quorum agreement
1. **Leader Election**: One Sentinel elected to manage failover via voting
1. **Replica Selection**: Best replica chosen based on:
   - Replication offset (lowest lag)
   - Priority configuration
   - Replication ID match
1. **Promotion**: Selected replica promoted to new primary (`SLAVEOF NO ONE`)
1. **Reconfiguration**:
   - Other replicas reconfigured to replicate from new primary
   - Sentinels update their configuration files
   - Clients notified of new topology

______________________________________________________________________

## Key Features

### Standalone Mode

**Advantages:**

- Simple deployment and configuration
- Lower resource overhead (single node)
- Fast performance (no replication overhead)
- Suitable for development/testing

**Limitations:**

- Single point of failure
- No automatic failover
- Downtime during maintenance
- No read scaling

**Best For:**

- Development environments
- Non-critical workloads
- Caching layers with acceptable data loss
- Testing and CI/CD pipelines

### Sentinel Mode (High Availability)

**Advantages:**

- **Automatic Failover**: 30-60 second recovery time
- **High Availability**: 99.9%+ uptime with proper configuration
- **Read Scaling**: Distribute reads across replicas
- **Data Durability**: Multiple copies of data
- **Zero-downtime Maintenance**: Perform maintenance on replicas

**Configuration Requirements:**

- **Minimum 3 Sentinels**: Required for quorum (prevents split-brain)
- **Odd Number of Sentinels**: Ensures clear majority (3, 5, 7, etc.)
- **Geographic Distribution**: Deploy across availability zones
- **Quorum Configuration**: Typically set to `(N/2) + 1` where N = total Sentinels

**Replication:**

- **Asynchronous**: Primary doesn't wait for replica acknowledgment
- **Eventually Consistent**: Small lag (typically \<100ms)
- **Full Resync**: New replicas get full dataset snapshot
- **Partial Resync**: Recovering replicas catch up via backlog

**Best For:**

- Production workloads requiring high availability
- Applications that cannot tolerate extended downtime
- Read-heavy workloads (scale reads with replicas)
- Enterprise deployments

### Comparison Table

| Feature             | Standalone              | Sentinel Mode             |
| ------------------- | ----------------------- | ------------------------- |
| **Availability**    | Single point of failure | 99.9%+ uptime             |
| **Failover**        | Manual                  | Automatic (30-60s)        |
| **Data Durability** | Single copy             | Multiple copies           |
| **Read Scaling**    | No                      | Yes (via replicas)        |
| **Complexity**      | Low                     | Medium                    |
| **Minimum Nodes**   | 1                       | 6 (3 Valkey + 3 Sentinel) |
| **Resource Usage**  | Low                     | Medium-High               |
| **Maintenance**     | Requires downtime       | Zero-downtime possible    |
| **Cost**            | Low                     | Medium                    |

### Monitoring Recommendations

For both modes, monitor these key metrics:

- **Memory Usage**: `used_memory`, `used_memory_rss`, `mem_fragmentation_ratio`
- **Operations**: `instantaneous_ops_per_sec`, `total_commands_processed`
- **Connections**: `connected_clients`, `rejected_connections`
- **Persistence**: `rdb_last_save_time`, `aof_last_rewrite_time`
- **Replication** (Sentinel only): `master_repl_offset`, `slave_repl_offset`, `repl_backlog_size`
- **Sentinel Health**: `sentinel_masters`, `sentinel_sentinels`, `sentinel_running_scripts`

### Security Considerations

- Enable ACLs (Access Control Lists) for authentication
- Use TLS/SSL for encrypted connections
- Do not support legacy `requirepass` for password protection
- Disable dangerous commands (`FLUSHALL`, `CONFIG`, etc.)

______________________________________________________________________

## Additional Resources

- [Valkey Documentation](https://valkey.io/docs/)
- [Valkey Sentinel Guide](https://valkey.io/topics/sentinel/)
- [Valkey Replication](https://valkey.io/topics/replication/)

______________________________________________________________________

**Last Updated**: 2025-10-30
