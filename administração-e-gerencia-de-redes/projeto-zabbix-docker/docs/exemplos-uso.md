# 📊 Exemplos de Uso - Zabbix para Monitoramento de Rede

## 🌐 Cenários Reais de Monitoramento

### 1. 🏢 Pequena Empresa (50-100 dispositivos)
**Equipamentos típicos:**
- 2-3 switches de acesso
- 1 roteador de borda
- 1 firewall
- 10-20 servidores
- 30-50 estações de trabalho

**Métricas monitoradas:**
- Disponibilidade (uptime)
- Tráfego de rede por interface
- CPU e memória dos servidores
- Espaço em disco
- Temperatura dos equipamentos

### 2. 🏭 Média Empresa (100-500 dispositivos)
**Infraestrutura típica:**
- Core switches redundantes
- Múltiplos switches de acesso
- Roteadores WAN
- Load balancers
- Servidores virtualizados
- Storage dedicado

**Funcionalidades avançadas:**
- Mapas de rede dinâmicos
- Alertas escalonados
- Relatórios SLA
- Integração com ITSM

### 3. 🌍 Grande Empresa (500+ dispositivos)
**Ambiente complexo:**
- Data centers múltiplos
- WAN/MPLS
- Cloud híbrida
- Aplicações críticas
- Compliance rigoroso

## 🔧 Configurações por Tipo de Dispositivo

### 📡 Switches e Roteadores Cisco

#### Template: Template Net Cisco IOS SNMP
**Itens monitorados:**
- Interfaces físicas (status, tráfego, erros)
- CPU (1min, 5min)
- Memória (used, free, utilization %)
- Temperatura (environment sensors)
- Fan status
- Power supply status

**Exemplo de configuração SNMP:**
```bash
# No dispositivo Cisco
snmp-server community public ro
snmp-server community private rw
snmp-server location "Datacenter A - Rack 10"
snmp-server contact "admin@empresa.com"

# No Zabbix - Host configuration
Host name: SW-CORE-01
IP: 192.168.1.10
Port: 161
SNMP community: public
Template: Template Net Cisco IOS SNMP
```

### 🖥️ Servidores Linux

#### Template: Template OS Linux by Zabbix agent
**Métricas principais:**
- CPU utilization (system, user, iowait)
- Memory usage (available, used, cached)
- Disk space (/, /var, /tmp, /home)
- Network interfaces (eth0, eth1)
- System load (1min, 5min, 15min)
- Process monitoring

**Instalação do Agente:**
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install zabbix-agent

# Configurar
sudo nano /etc/zabbix/zabbix_agentd.conf
# Server=192.168.1.100
# Hostname=SRV-WEB-01

# Iniciar serviço
sudo systemctl enable zabbix-agent
sudo systemctl start zabbix-agent
```

### 🖥️ Servidores Windows

#### Template: Template OS Windows by Zabbix agent
**Monitoramento específico:**
- Performance Counters
- Windows Services
- Event Log monitoring
- IIS statistics (se aplicável)
- SQL Server metrics

**Instalação do Agente Windows:**
```powershell
# Download e instalação
Invoke-WebRequest -Uri "https://cdn.zabbix.com/zabbix/binaries/stable/7.0/7.0.0/zabbix_agent2-7.0.0-windows-amd64-openssl.msi" -OutFile "zabbix-agent.msi"
msiexec /i zabbix-agent.msi /quiet SERVER=192.168.1.100 HOSTNAME=SRV-WIN-01
```

### 🛡️ Firewalls pfSense

#### Template: Template Net pfSense SNMP
**Métricas de segurança:**
- Active connections
- Blocked/passed packets
- VPN tunnels status
- Gateway monitoring
- Rules statistics

### ☁️ Ambientes Virtualizados

#### VMware vSphere
**Template:** Template App VMware
- Host performance (CPU, memory, storage)
- VM inventory e status
- Datastore capacity
- Network usage
- Health sensors

#### Hyper-V
**Template:** Template App Microsoft Hyper-V
- Virtual machine status
- Resource allocation
- Performance counters
- Replica status

## 🏗️ Arquiteturas de Monitoramento

### 🌟 Arquitetura Simples (Rede Única)
```
[Zabbix Server] ← → [Devices/Servers na mesma rede]
```
- Monitoramento direto via SNMP/Agent
- Ideal para pequenas empresas
- Latência baixa, configuração simples

### 🌐 Arquitetura com Proxy (Redes Remotas)
```
[Zabbix Server] ← → [Zabbix Proxy] ← → [Remote Site Devices]
```
- Proxy em cada site remoto
- Reduz tráfego WAN
- Cache local de dados
- Funcionamento offline temporário

### 🏢 Arquitetura Distribuída (Multi-tenant)
```
[Zabbix Server Cluster] 
    ↓
[Load Balancer]
    ↓
[Multiple Zabbix Frontends]
```
- Alta disponibilidade
- Escalabilidade horizontal
- Separação por cliente/departamento

## 📊 Dashboards Personalizados

### 🎯 Dashboard NOC (Network Operations Center)
**Widgets essenciais:**
- Mapa de rede em tempo real
- Top 10 interfaces por utilização
- Problemas ativos por severidade
- SLA dos serviços críticos
- Eventos recentes (últimas 4h)

**Configuração:**
```json
{
  "name": "NOC Dashboard",
  "widgets": [
    {"type": "networkmap", "size": "large"},
    {"type": "tophosts", "criteria": "network_traffic"},
    {"type": "problems", "severity": "high"},
    {"type": "sla", "services": ["Internet", "ERP", "Email"]}
  ]
}
```

### 📈 Dashboard Executivo
**KPIs principais:**
- Uptime geral da infraestrutura
- Incidentes por mês
- MTTR (Mean Time to Repair)
- Crescimento de tráfego
- Investimento vs. disponibilidade

### 🔧 Dashboard Técnico
**Métricas operacionais:**
- CPU/Memory top consumers
- Disk space trending
- Network utilization heatmap
- Security events
- Backup status

## 🚨 Configuração de Alertas

### ⚡ Alertas Críticos (Severidade Alta)
```yaml
Triggers:
  - Device Down (ping fail > 3 min)
  - Interface Down (critical links)
  - High CPU (> 90% for 5 min)
  - Low Disk Space (< 10% remaining)
  
Actions:
  - Email para equipe técnica
  - SMS para gerente de TI
  - Ticket automático no sistema
  - Integração Slack/Teams
```

### ⚠️ Alertas de Warning
```yaml
Triggers:
  - High Memory Usage (> 85% for 10 min)
  - Interface Errors (> 1000/hour)
  - Temperature High (> 60°C)
  
Actions:
  - Email para administradores
  - Log no sistema de eventos
```

### 📊 Relatórios Automatizados

#### Relatório Semanal de Infraestrutura
- Disponibilidade por dispositivo
- Top 10 problemas da semana
- Tendências de crescimento
- Recomendações de otimização

#### Relatório Mensal SLA
- Uptime por serviço
- Impacto dos incidentes
- Comparativo com mês anterior
- Metas vs. realizado

## 🔍 Casos de Uso Específicos

### 1. 🏥 Ambiente Hospitalar
**Requisitos críticos:**
- Uptime de 99.99%
- Monitoramento 24/7
- Compliance HIPAA
- Equipamentos médicos IoT

### 2. 🏭 Ambiente Industrial
**Monitoramento OT/IT:**
- PLCs e SCADA
- Sensores IoT
- Redes Profibus/Modbus
- Integração com MES/ERP

### 3. 🛒 E-commerce
**Métricas de negócio:**
- Performance de aplicação
- Tempo de resposta transações
- Disponibilidade checkout
- CDN performance

### 4. 🏫 Ambiente Educacional
**Características:**
- Sazonalidade (períodos letivos)
- Múltiplos campi
- Recursos limitados
- Compliance LGPD

## 💡 Melhores Práticas

### 🎯 Nomenclatura Padronizada
```
Hosts: [TIPO]-[LOCAL]-[NUMERO]
Exemplos: SW-CORE-01, RTR-WAN-02, SRV-WEB-03

Templates: Template [Vendor] [Model] [Protocol]
Exemplos: Template Cisco 2960 SNMP, Template Dell R730 Agent
```

### 📋 Documentação
- Manter inventário atualizado
- Documentar customizações
- Versionar configurações
- Backup regular das configurações

### 🔧 Otimização Performance
- Ajustar intervalos de coleta
- Usar bulk SNMP quando possível
- Configurar housekeeping adequado
- Monitorar próprio Zabbix

### 🚀 Automação
- Templates padronizados
- Discovery rules eficientes
- Actions bem configuradas
- Scripts de manutenção