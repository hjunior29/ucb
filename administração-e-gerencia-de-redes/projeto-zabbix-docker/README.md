# 📊 Projeto Zabbix Docker - Monitoramento de Rede

## 🎯 Sobre o Projeto

Este projeto demonstra a implementação do **Zabbix** usando **Docker** para monitoramento de rede e infraestrutura. O Zabbix é um software de gerenciamento de redes de código aberto que pertence à área de **Monitoramento e Análise de Performance**.

### 🔧 Área de Gerenciamento de Redes: **Monitoramento e Performance**

O Zabbix atua na área de:
- **Monitoramento de dispositivos de rede** (switches, roteadores, firewalls)
- **Análise de performance** e tráfego de rede
- **Coleta de métricas SNMP** (v1, v2c, v3)
- **Alertas proativos** e notificações
- **Geração de relatórios** e dashboards

## 🚀 Como Funciona

O Zabbix utiliza diferentes métodos para coletar dados:

1. **Agentes Zabbix**: Software instalado nos dispositivos monitorados
2. **SNMP**: Protocolo padrão para monitoramento de dispositivos de rede
3. **Verificações simples**: ICMP ping, verificações de porta TCP/UDP
4. **JMX**: Monitoramento de aplicações Java
5. **Descoberta automática**: Detecção automática de dispositivos na rede

### 📈 Funcionalidades Principais

- ✅ **300+ templates pré-configurados** para diferentes vendors
- ✅ **Dashboards interativos** com gráficos em tempo real
- ✅ **Mapas de rede** visuais e dinâmicos
- ✅ **Sistema de alertas** flexível e escalável
- ✅ **API REST** para integração com outros sistemas
- ✅ **Multi-tenancy** para ambientes corporativos

## 📋 Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- **Docker** (versão 20.10 ou superior)
- **Docker Compose** (versão 2.0 ou superior)
- **Git** para clonar repositórios
- **Pelo menos 4GB de RAM** disponível
- **Conexão com a internet** para download das imagens

### Verificação dos Pré-requisitos

```bash
# Verificar versão do Docker
docker --version

# Verificar versão do Docker Compose
docker compose version

# Verificar espaço em disco (recomendado: pelo menos 10GB livres)
df -h
```

## 🛠️ Instalação e Configuração

### Passo 1: Clonar o Projeto

```bash
git clone [URL_DO_SEU_REPOSITORIO]
cd projeto-zabbix-docker
```

### Passo 2: Iniciar os Serviços

```bash
# Iniciar todos os serviços do Zabbix
docker compose up -d

# Verificar se os containers estão rodando
docker compose ps
```

### Passo 3: Aguardar Inicialização

Os serviços podem levar de 2-5 minutos para inicializar completamente. Monitore os logs:

```bash
# Acompanhar logs do servidor Zabbix
docker compose logs -f zabbix-server

# Acompanhar logs da interface web
docker compose logs -f zabbix-web
```

### Passo 4: Acessar a Interface Web

- **URL**: http://localhost
- **Usuário**: `Admin`
- **Senha**: `zabbix`

## 🎮 Uso Básico

### 1. Primeiro Acesso

1. Acesse http://localhost no seu navegador
2. Faça login com `Admin` / `zabbix`
3. **IMPORTANTE**: Altere a senha padrão em `Administration > Users`

### 2. Monitorar o Servidor Local

O Zabbix já vem configurado para monitorar o próprio servidor:

1. Vá para `Monitoring > Hosts`
2. Clique em `Zabbix server`
3. Acesse `Monitoring > Latest data` para ver métricas em tempo real

### 3. Adicionar Dispositivos de Rede

#### Via SNMP (Dispositivos de Rede):

1. `Configuration > Hosts > Create host`
2. Configure:
   - **Host name**: Nome do dispositivo
   - **IP address**: IP do dispositivo
   - **Groups**: Network devices
   - **Templates**: Template/Net/[Vendor] SNMP

#### Via Agente Zabbix:

1. Instale o agente no servidor alvo
2. Configure o IP do Zabbix server no agente
3. Adicione o host na interface web

### 4. Configurar Alertas

1. `Configuration > Actions > Trigger actions`
2. Configure condições e ações
3. Defina métodos de notificação (email, SMS, etc.)

### 5. Criar Dashboards

1. `Monitoring > Dashboard`
2. Clique em `Edit dashboard`
3. Adicione widgets com gráficos, mapas e métricas

## 📊 Exemplos de Monitoramento

### Métricas Básicas de Rede:
- **Largura de banda** (upload/download)
- **Latência** e **packet loss**
- **Status de interfaces** (up/down)
- **Utilização de CPU e memória** em dispositivos

### Dispositivos Suportados:
- **Roteadores**: Cisco, Juniper, MikroTik
- **Switches**: HP, Dell, Aruba
- **Firewalls**: pfSense, Fortinet, SonicWall
- **Servidores**: Linux, Windows, VMware
- **Aplicações**: Apache, Nginx, MySQL, PostgreSQL

## 🔧 Scripts Auxiliares

O projeto inclui scripts para facilitar o gerenciamento:

```bash
# Iniciar serviços
./scripts/start.sh

# Parar serviços
./scripts/stop.sh

# Reset completo (apaga dados)
./scripts/reset.sh
```

## 🌐 URLs e Portas

| Serviço | URL/Porta | Descrição |
|---------|-----------|-----------|
| Interface Web | http://localhost | Interface principal do Zabbix |
| Zabbix Server | localhost:10051 | Comunicação com agentes |
| Banco de dados | localhost:3306 | MySQL (apenas interno) |

## 🔒 Segurança

### Configurações Recomendadas:

1. **Alterar senhas padrão** imediatamente
2. **Configurar HTTPS** para produção
3. **Restringir acesso** por IP quando possível
4. **Atualizar regularmente** as imagens Docker
5. **Configurar backup** dos dados

### Comandos de Backup:

```bash
# Backup do banco de dados
docker compose exec mysql mysqldump -u zabbix -p zabbix > backup_$(date +%Y%m%d).sql

# Backup de configurações
docker compose exec zabbix-server cat /etc/zabbix/zabbix_server.conf > zabbix_server_backup.conf
```

## 🐛 Solução de Problemas

### Problemas Comuns:

**Container não inicia:**
```bash
# Verificar logs
docker compose logs zabbix-server

# Reiniciar serviços
docker compose restart
```

**Interface web não carrega:**
```bash
# Verificar status dos containers
docker compose ps

# Verificar logs do Apache/Nginx
docker compose logs zabbix-web
```

**Problema de conectividade:**
```bash
# Testar conectividade SNMP
snmpwalk -v2c -c public [IP_DISPOSITIVO]

# Testar conectividade do agente
telnet [IP_SERVIDOR] 10051
```

## 📚 Documentação Adicional

- **Documentação Oficial**: https://www.zabbix.com/documentation
- **Templates Comunitários**: https://share.zabbix.com/
- **Fórum da Comunidade**: https://www.zabbix.com/forum/
- **GitHub Oficial**: https://github.com/zabbix/zabbix-docker

## 👥 Contribuição

Para contribuir com este projeto:

1. Faça um fork do repositório
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Abra um Pull Request

## 📄 Licença

Este projeto é disponibilizado sob licença MIT. O Zabbix é licenciado sob GPL v2.

---

**⚠️ Nota**: Este projeto é para fins educacionais e de demonstração. Para ambientes de produção, consulte a documentação oficial do Zabbix e siga as melhores práticas de segurança.

  📁 Estrutura Criada:

  projeto-zabbix-docker/
  ├── 📖 README.md                 # Documentação completa do projeto
  ├── 🐳 docker-compose.yml       # Configuração Docker otimizada
  ├── 📜 scripts/
  │   ├── start.sh               # Script para iniciar Zabbix
  │   ├── stop.sh                # Script para parar serviços
  │   └── reset.sh               # Script para reset completo
  ├── ⚙️ config/                  # (Criada automaticamente)
  └── 📚 docs/
      ├── requisitos.md          # Requisitos detalhados do sistema
      └── exemplos-uso.md        # Exemplos práticos de uso

  🚀 Para usar o projeto:

  1. Navegar para a pasta:
  cd /Users/helder/projects/projeto-zabbix-docker

  2. Iniciar o Zabbix:
  ./scripts/start.sh

  3. Acessar a interface:
  - URL: http://localhost
  - Usuário: Admin
  - Senha: zabbix