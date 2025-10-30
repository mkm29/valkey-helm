# valkey

![Version: 0.8.0](https://img.shields.io/badge/Version-0.8.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 8.1.4](https://img.shields.io/badge/AppVersion-8.1.4-informational?style=flat-square)

A Helm chart for Kubernetes

**Homepage:** <https://valkey.io/valkey-helm/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| raven |  | <https://github.com/mk-raven> |
| mkm29 |  | <https://github.com/mkm29> |

## Source Code

* <https://github.com/valkey-io/valkey-helm.git>
* <https://valkey.io>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| auth.acl.config | string | `""` |  |
| auth.acl.defaultUserPassword | string | `""` |  |
| auth.acl.existingSecret | string | `""` |  |
| auth.acl.existingSecretDefaultUserKey | string | `""` |  |
| auth.acl.existingSecretSentinelUserKey | string | `""` |  |
| auth.acl.password | string | `""` |  |
| auth.acl.sentinelUserPassword | string | `""` |  |
| auth.enabled | bool | `false` |  |
| config.logLevel | string | `"notice"` |  |
| config.mode | string | `"standalone"` |  |
| config.sentinel | string | `""` |  |
| config.valkey | string | `""` |  |
| dataStorage.accessModes[0] | string | `"ReadWriteOnce"` |  |
| dataStorage.annotations | object | `{}` |  |
| dataStorage.className | string | `""` |  |
| dataStorage.enabled | bool | `false` |  |
| dataStorage.labels | object | `{}` |  |
| dataStorage.requestedSize | string | `""` |  |
| deploymentStrategy | string | `"RollingUpdate"` |  |
| env | object | `{}` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"docker.io/valkey/valkey"` |  |
| image.tag | string | `"9-trixie"` |  |
| imagePullSecrets | list | `[]` |  |
| initSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| initSecurityContext.runAsGroup | int | `1000` |  |
| initSecurityContext.runAsNonRoot | bool | `true` |  |
| initSecurityContext.runAsUser | int | `1000` |  |
| metrics.image.pullPolicy | string | `"IfNotPresent"` |  |
| metrics.image.repository | string | `"ghcr.io/oliver006/redis_exporter"` |  |
| metrics.image.tag | string | `"v1.79.0"` |  |
| nameOverride | string | `""` |  |
| networkPolicy | object | `{}` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext.fsGroup | int | `1000` |  |
| podSecurityContext.fsGroupChangePolicy | string | `"OnRootMismatch"` |  |
| podSecurityContext.runAsGroup | int | `1000` |  |
| podSecurityContext.runAsUser | int | `1000` |  |
| replicaCount | int | `1` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `1000` |  |
| sentinel.announce.enabled | bool | `false` |  |
| sentinel.downAfterMilliseconds | int | `30000` |  |
| sentinel.extraConfigs | list | `[]` |  |
| sentinel.extraSecrets | list | `[]` |  |
| sentinel.failoverTimeout | int | `180000` |  |
| sentinel.metrics.enabled | bool | `false` |  |
| sentinel.metrics.exporter.args | list | `[]` |  |
| sentinel.metrics.exporter.command | list | `[]` |  |
| sentinel.metrics.exporter.extraEnvs | object | `{}` |  |
| sentinel.metrics.exporter.extraVolumeMounts | list | `[]` |  |
| sentinel.metrics.exporter.image.<<.pullPolicy | string | `"IfNotPresent"` |  |
| sentinel.metrics.exporter.image.<<.repository | string | `"ghcr.io/oliver006/redis_exporter"` |  |
| sentinel.metrics.exporter.image.<<.tag | string | `"v1.79.0"` |  |
| sentinel.metrics.exporter.port | int | `9122` |  |
| sentinel.metrics.exporter.resources | object | `{}` |  |
| sentinel.metrics.exporter.securityContext | object | `{}` |  |
| sentinel.metrics.podMonitor.additionalLabels | object | `{}` |  |
| sentinel.metrics.podMonitor.annotations | object | `{}` |  |
| sentinel.metrics.podMonitor.enabled | bool | `false` |  |
| sentinel.metrics.podMonitor.extraLabels | object | `{}` |  |
| sentinel.metrics.podMonitor.honorLabels | bool | `false` |  |
| sentinel.metrics.podMonitor.interval | string | `"30s"` |  |
| sentinel.metrics.podMonitor.metricRelabelings | list | `[]` |  |
| sentinel.metrics.podMonitor.podTargetLabels | list | `[]` |  |
| sentinel.metrics.podMonitor.port | string | `"metrics"` |  |
| sentinel.metrics.podMonitor.relabelings | list | `[]` |  |
| sentinel.metrics.podMonitor.sampleLimit | bool | `false` |  |
| sentinel.metrics.podMonitor.scrapeTimeout | string | `""` |  |
| sentinel.metrics.podMonitor.targetLimit | bool | `false` |  |
| sentinel.metrics.prometheusRule.enabled | bool | `false` |  |
| sentinel.metrics.prometheusRule.extraAnnotations | object | `{}` |  |
| sentinel.metrics.prometheusRule.extraLabels | object | `{}` |  |
| sentinel.metrics.prometheusRule.rules | list | `[]` |  |
| sentinel.metrics.service.annotations | object | `{}` |  |
| sentinel.metrics.service.enabled | bool | `true` |  |
| sentinel.metrics.service.extraLabels | object | `{}` |  |
| sentinel.metrics.service.ports.http | int | `9122` |  |
| sentinel.metrics.service.type | string | `"ClusterIP"` |  |
| sentinel.metrics.serviceMonitor.additionalLabels | object | `{}` |  |
| sentinel.metrics.serviceMonitor.annotations | object | `{}` |  |
| sentinel.metrics.serviceMonitor.enabled | bool | `false` |  |
| sentinel.metrics.serviceMonitor.extraLabels | object | `{}` |  |
| sentinel.metrics.serviceMonitor.honorLabels | bool | `false` |  |
| sentinel.metrics.serviceMonitor.interval | string | `"30s"` |  |
| sentinel.metrics.serviceMonitor.metricRelabelings | list | `[]` |  |
| sentinel.metrics.serviceMonitor.podTargetLabels | list | `[]` |  |
| sentinel.metrics.serviceMonitor.port | string | `"metrics"` |  |
| sentinel.metrics.serviceMonitor.relabelings | list | `[]` |  |
| sentinel.metrics.serviceMonitor.sampleLimit | bool | `false` |  |
| sentinel.metrics.serviceMonitor.scrapeTimeout | string | `""` |  |
| sentinel.metrics.serviceMonitor.targetLimit | bool | `false` |  |
| sentinel.parallelSyncs | int | `1` |  |
| sentinel.port | int | `26379` |  |
| sentinel.quorum | int | `2` |  |
| sentinel.resources | object | `{}` |  |
| service.annotations | object | `{}` |  |
| service.enabled | bool | `true` |  |
| service.nodePort | int | `0` |  |
| service.port | int | `6379` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `false` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| tolerations | list | `[]` |  |
| topologySpreadConstraints | list | `[]` |  |
| valkey.extraConfigs | list | `[]` |  |
| valkey.extraSecrets | list | `[]` |  |
| valkey.initResources | object | `{}` |  |
| valkey.metrics.enabled | bool | `false` |  |
| valkey.metrics.exporter.args | list | `[]` |  |
| valkey.metrics.exporter.command | list | `[]` |  |
| valkey.metrics.exporter.extraEnvs | object | `{}` |  |
| valkey.metrics.exporter.extraVolumeMounts | list | `[]` |  |
| valkey.metrics.exporter.image.<<.pullPolicy | string | `"IfNotPresent"` |  |
| valkey.metrics.exporter.image.<<.repository | string | `"ghcr.io/oliver006/redis_exporter"` |  |
| valkey.metrics.exporter.image.<<.tag | string | `"v1.79.0"` |  |
| valkey.metrics.exporter.port | int | `9121` |  |
| valkey.metrics.exporter.resources | object | `{}` |  |
| valkey.metrics.exporter.securityContext | object | `{}` |  |
| valkey.metrics.podMonitor.additionalLabels | object | `{}` |  |
| valkey.metrics.podMonitor.annotations | object | `{}` |  |
| valkey.metrics.podMonitor.enabled | bool | `false` |  |
| valkey.metrics.podMonitor.extraLabels | object | `{}` |  |
| valkey.metrics.podMonitor.honorLabels | bool | `false` |  |
| valkey.metrics.podMonitor.interval | string | `"30s"` |  |
| valkey.metrics.podMonitor.metricRelabelings | list | `[]` |  |
| valkey.metrics.podMonitor.podTargetLabels | list | `[]` |  |
| valkey.metrics.podMonitor.port | string | `"metrics"` |  |
| valkey.metrics.podMonitor.relabelings | list | `[]` |  |
| valkey.metrics.podMonitor.sampleLimit | bool | `false` |  |
| valkey.metrics.podMonitor.scrapeTimeout | string | `""` |  |
| valkey.metrics.podMonitor.targetLimit | bool | `false` |  |
| valkey.metrics.prometheusRule.enabled | bool | `false` |  |
| valkey.metrics.prometheusRule.extraAnnotations | object | `{}` |  |
| valkey.metrics.prometheusRule.extraLabels | object | `{}` |  |
| valkey.metrics.prometheusRule.rules | list | `[]` |  |
| valkey.metrics.service.annotations | object | `{}` |  |
| valkey.metrics.service.enabled | bool | `true` |  |
| valkey.metrics.service.extraLabels | object | `{}` |  |
| valkey.metrics.service.ports.http | int | `9121` |  |
| valkey.metrics.service.type | string | `"ClusterIP"` |  |
| valkey.metrics.serviceMonitor.additionalLabels | object | `{}` |  |
| valkey.metrics.serviceMonitor.annotations | object | `{}` |  |
| valkey.metrics.serviceMonitor.enabled | bool | `false` |  |
| valkey.metrics.serviceMonitor.extraLabels | object | `{}` |  |
| valkey.metrics.serviceMonitor.honorLabels | bool | `false` |  |
| valkey.metrics.serviceMonitor.interval | string | `"30s"` |  |
| valkey.metrics.serviceMonitor.metricRelabelings | list | `[]` |  |
| valkey.metrics.serviceMonitor.podTargetLabels | list | `[]` |  |
| valkey.metrics.serviceMonitor.port | string | `"metrics"` |  |
| valkey.metrics.serviceMonitor.relabelings | list | `[]` |  |
| valkey.metrics.serviceMonitor.sampleLimit | bool | `false` |  |
| valkey.metrics.serviceMonitor.scrapeTimeout | string | `""` |  |
| valkey.metrics.serviceMonitor.targetLimit | bool | `false` |  |
| valkey.resources | object | `{}` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
