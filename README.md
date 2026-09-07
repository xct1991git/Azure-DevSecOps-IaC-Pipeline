# Pipeline Automatizado de DevSecOps para IaC en Azure (Coste: 0€)

[![DevSecOps IaC Security Pipeline](https://github.com/xct1991git/azure-devsecops-iac-pipeline/actions/workflows/devsecops.yml/badge.svg)](https://github.com/xct1991git/azure-devsecops-iac-pipeline/actions/workflows/devsecops.yml)

Implementación de **Shift-Left Security** de nivel empresarial para Infraestructura como Código (IaC) en Microsoft Azure. Este proyecto aplica cumplimiento normativo continuo, escaneo de secretos y comprobaciones de postura de seguridad estática en cada cambio de código sin generar costes de facturación en la nube (0,00 € de gasto operativo).

---

## 🎯 Arquitectura y Objetivos de Seguridad

En la ingeniería cloud moderna, detectar vulnerabilidades *después* del despliegue resulta costoso y arriesgado. Este proyecto integra barreras de seguridad automáticas directamente en el ciclo de vida de Pull Requests y *pushes*:

1. **Defensa contra Fuga de Secretos:** Impide que credenciales en texto plano, tokens o claves API se suban al control de versiones.
2. **Auditoría de Seguridad y Cumplimiento:** Analiza automáticamente las plantillas de Terraform contra los estándares CIS Microsoft Azure Foundations Benchmark e ISO 27001.
3. **Validación y Formateo Canónico:** Garantiza la coherencia del código, la integridad estructural y la sintaxis declarativa oficial.
4. **Diseño a Coste Cero:** Todo el escaneo se procesa en los *runners* gratuitos de GitHub Actions, sin necesidad de aprovisionar recursos facturables en Azure.

---

## 🛠️ Stack Tecnológico y Herramientas

| Componente | Herramienta / Tecnología | Propósito |
| :--- | :--- | :--- |
| **Proveedor Cloud** | Microsoft Azure | Proveedor destino de IaC (`azurerm`) |
| **Motor IaC** | HashiCorp Terraform | Definición declarativa de recursos cloud |
| **Escaneo de Secretos** | Gitleaks (`gitleaks-action`) | Detecta credenciales, claves privadas y tokens expuestos |
| **Postura de Seguridad** | Bridgecrew Checkov | Análisis estático de malas configuraciones y normativas CIS |
| **Sintaxis y Linter** | Terraform CLI (`setup-terraform`) | Formateo canónico (`fmt`) y validación estática (`validate`) |
| **Orquestación** | GitHub Actions | Ejecución paralela y automatizada del pipeline |

---

## 🔍 Fases de Seguridad del Pipeline

El flujo de trabajo ejecuta tres tareas independientes y en paralelo ante cada `push` o `pull_request` a la rama `main`:

```text
[ Git Push / PR ]
       │
       ├──► Trabajo 1: Detección de Fuga de Secretos (Gitleaks)
       │         └── Analiza el historial de commits en busca de credenciales
       │
       ├──► Trabajo 2: Cumplimiento y Postura IaC (Checkov)
       │         └── Audita las directivas de seguridad de Terraform
       │
       └──► Trabajo 3: Validación de Sintaxis y Formato
                 ├── terraform fmt -check
                 ├── terraform init -backend=false
                 └── terraform validate
