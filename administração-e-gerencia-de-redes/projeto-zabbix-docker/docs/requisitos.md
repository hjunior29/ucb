# 📋 Requisitos do Sistema - Zabbix Docker

## 💻 Requisitos Mínimos de Hardware

### Para Demonstração/Teste:
- **CPU**: 2 cores
- **RAM**: 4 GB disponível
- **Armazenamento**: 10 GB livres
- **Rede**: Conexão à internet para download das imagens

### Para Produção (pequeno porte):
- **CPU**: 4 cores
- **RAM**: 8 GB
- **Armazenamento**: 50 GB (SSD recomendado)
- **Rede**: 100 Mbps

### Para Produção (grande porte):
- **CPU**: 8+ cores
- **RAM**: 16+ GB
- **Armazenamento**: 200+ GB (SSD obrigatório)
- **Rede**: 1 Gbps

## 🖥️ Sistemas Operacionais Suportados

### Testado e Suportado:
- ✅ **Ubuntu** 20.04, 22.04, 24.04
- ✅ **CentOS/RHEL** 7, 8, 9
- ✅ **Debian** 10, 11, 12
- ✅ **Windows** 10, 11 (com Docker Desktop)
- ✅ **macOS** 10.15+ (com Docker Desktop)
- ✅ **Fedora** 35+

## 🐳 Requisitos de Software

### Obrigatórios:
1. **Docker** versão 20.10.0 ou superior
2. **Docker Compose** versão 2.0.0 ou superior
3. **Git** (para clonar repositório)

### Verificação:
```bash
# Verificar Docker
docker --version
docker info

# Verificar Docker Compose
docker compose version

# Verificar Git
git --version
```

## 🌐 Requisitos de Rede

### Portas Utilizadas:
- **80**: Interface web do Zabbix (HTTP)
- **10050**: Zabbix Agent (passivo)
- **10051**: Zabbix Server (ativo)
- **3306**: MySQL (interno ao Docker)

### Conectividade:
- Acesso à internet para download de imagens
- Acesso às redes que serão monitoradas
- Protocolos: HTTP, HTTPS, SNMP, ICMP

## 📦 Recursos Docker

### Imagens Utilizadas:
- `zabbix/zabbix-server-mysql:alpine-7.0-latest` (~200 MB)
- `zabbix/zabbix-web-apache-mysql:alpine-7.0-latest` (~300 MB)
- `zabbix/zabbix-agent:alpine-7.0-latest` (~50 MB)
- `mysql:8.0` (~500 MB)

### Espaço Total: ~1.5 GB

### Volumes Docker:
- `mysql-data`: Dados do banco MySQL
- `zabbix-server-data`: Configurações do servidor

## ⚡ Requisitos de Performance

### Monitoramento Básico (até 100 hosts):
- **CPU**: 2 cores, 2.4 GHz
- **RAM**: 4 GB
- **I/O**: 100 IOPS

### Monitoramento Médio (100-1000 hosts):
- **CPU**: 4 cores, 2.4 GHz
- **RAM**: 8 GB
- **I/O**: 500 IOPS

### Monitoramento Avançado (1000+ hosts):
- **CPU**: 8+ cores, 2.4+ GHz
- **RAM**: 16+ GB
- **I/O**: 1000+ IOPS

## 🔒 Requisitos de Segurança

### Recomendações:
- Firewall configurado (apenas portas necessárias)
- Senhas forte para usuários
- Certificados SSL/TLS para HTTPS
- Backup regular dos dados
- Atualização regular das imagens

### Configurações de Firewall:
```bash
# Ubuntu/Debian
sudo ufw allow 80/tcp
sudo ufw allow 10050/tcp
sudo ufw allow 10051/tcp

# CentOS/RHEL
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=10050/tcp
sudo firewall-cmd --permanent --add-port=10051/tcp
sudo firewall-cmd --reload
```

## ⏰ Sincronização de Tempo

### Obrigatório:
- Sincronização NTP em todos os sistemas
- Timezone configurado corretamente
- Diferença máxima de 1 segundo entre componentes

### Configuração:
```bash
# Ubuntu/Debian
sudo timedatectl set-ntp true
sudo timedatectl set-timezone America/Sao_Paulo

# CentOS/RHEL
sudo chronyd
sudo timedatectl set-timezone America/Sao_Paulo
```

## 📊 Capacidade de Monitoramento

### Limites Recomendados por Configuração:

| Configuração | Hosts | Items/seg | NVPS* | Triggers |
|--------------|-------|-----------|-------|----------|
| Mínima       | 50    | 200       | 500   | 500      |
| Básica       | 100   | 500       | 1,000 | 1,000    |
| Padrão       | 500   | 2,000     | 5,000 | 5,000    |
| Avançada     | 1,000 | 5,000     | 10,000| 10,000   |

*NVPS = New Values Per Second

## 🧪 Ambiente de Teste

### Para o Vídeo/Demonstração:
- **Laptop/Desktop** com 8 GB RAM
- **Docker Desktop** instalado
- **Conexão à internet** estável
- **Navegador** moderno (Chrome, Firefox, Safari)
- **Software de gravação** (OBS, Loom, etc.)

### Verificação Pré-Gravação:
```bash
# Verificar recursos disponíveis
free -h
df -h
docker system df

# Testar conectividade
ping google.com
docker pull hello-world
```

## 🔧 Troubleshooting Comum

### Problemas de Memória:
- Aumentar swap se necessário
- Configurar limites Docker adequados
- Monitorar uso com `docker stats`

### Problemas de Performance:
- SSD recomendado para I/O intensivo
- Ajustar parâmetros MySQL
- Configurar cache adequado

### Problemas de Conectividade:
- Verificar firewall/iptables
- Testar conectividade SNMP
- Verificar rotas de rede