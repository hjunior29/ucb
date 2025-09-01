#!/bin/bash

echo "🚀 Iniciando Zabbix Docker..."
echo "================================"

# Verificar se Docker está rodando
if ! docker info > /dev/null 2>&1; then
    echo "❌ Erro: Docker não está rodando!"
    echo "   Inicie o Docker e tente novamente."
    exit 1
fi

# Verificar se docker-compose existe
if ! command -v docker compose &> /dev/null; then
    echo "❌ Erro: Docker Compose não encontrado!"
    echo "   Instale o Docker Compose e tente novamente."
    exit 1
fi

# Criar diretórios de configuração se não existirem
mkdir -p ../config

# Verificar se o arquivo docker-compose.yml existe
if [ ! -f "../docker-compose.yml" ]; then
    echo "❌ Erro: docker-compose.yml não encontrado!"
    echo "   Execute este script a partir da pasta scripts/"
    exit 1
fi

echo "📋 Verificando arquivos necessários..."

# Criar arquivos de configuração básicos se não existirem
if [ ! -f "../config/php.ini" ]; then
    echo "📄 Criando configuração PHP básica..."
    cat > ../config/php.ini << EOF
[PHP]
max_execution_time = 300
memory_limit = 128M
post_max_size = 16M
upload_max_filesize = 2M
max_input_time = 300
max_input_vars = 10000
date.timezone = America/Sao_Paulo
EOF
fi

if [ ! -f "../config/zabbix_server.conf" ]; then
    echo "📄 Criando configuração básica do Zabbix Server..."
    cat > ../config/zabbix_server.conf << EOF
# Configurações básicas do Zabbix Server
LogFile=/tmp/zabbix_server.log
LogFileSize=10
PidFile=/tmp/zabbix_server.pid
SocketDir=/tmp
DBHost=mysql
DBName=zabbix
DBUser=zabbix
DBPassword=zabbix_password
DBPort=3306
StartPollers=5
StartPollersUnreachable=1
StartTrappers=5
StartPingers=1
StartDiscoverers=1
StartHTTPPollers=1
StartTimers=1
StartEscalators=1
ListenPort=10051
HousekeepingFrequency=1
MaxHousekeeperDelete=5000
CacheSize=8M
CacheUpdateFrequency=60
StartDBSyncers=4
HistoryCacheSize=16M
HistoryIndexCacheSize=4M
TrendCacheSize=4M
ValueCacheSize=8M
Timeout=4
TrapperTimeout=300
UnreachablePeriod=45
UnavailableDelay=60
UnreachableDelay=15
AlertScriptsPath=/usr/lib/zabbix/alertscripts
ExternalScripts=/usr/lib/zabbix/externalscripts
LogSlowQueries=3000
TmpDir=/tmp
StartProxyPollers=1
ProxyConfigFrequency=3600
ProxyDataFrequency=1
LoadModulePath=/var/lib/zabbix/modules
EOF
fi

echo "🔧 Iniciando containers..."
cd ..

# Iniciar serviços
docker compose up -d

# Verificar status
echo ""
echo "⏱️  Aguardando inicialização dos serviços..."
sleep 10

echo ""
echo "📊 Status dos containers:"
docker compose ps

echo ""
echo "🌐 Verificando disponibilidade dos serviços..."

# Verificar se MySQL está respondendo
echo -n "   MySQL: "
if docker compose exec mysql mysqladmin ping -h localhost --silent; then
    echo "✅ Online"
else
    echo "⚠️  Inicializando..."
fi

# Verificar se Zabbix Server está respondendo
echo -n "   Zabbix Server: "
if docker compose logs zabbix-server | grep -q "server started"; then
    echo "✅ Online"
else
    echo "⚠️  Inicializando..."
fi

# Verificar se Web Interface está respondendo
echo -n "   Interface Web: "
if curl -s http://localhost > /dev/null 2>&1; then
    echo "✅ Online"
else
    echo "⚠️  Inicializando..."
fi

echo ""
echo "🎉 Zabbix Docker iniciado com sucesso!"
echo "================================"
echo ""
echo "🌐 Acesso:"
echo "   URL: http://localhost"
echo "   Usuário: Admin"
echo "   Senha: zabbix"
echo ""
echo "🔧 Comandos úteis:"
echo "   Ver logs: docker compose logs -f"
echo "   Parar: ./stop.sh"
echo "   Status: docker compose ps"
echo ""
echo "⚠️  IMPORTANTE: Altere a senha padrão após o primeiro login!"
echo ""
echo "📋 Se algum serviço não estiver online, aguarde alguns minutos"
echo "   para a inicialização completa e verifique os logs."