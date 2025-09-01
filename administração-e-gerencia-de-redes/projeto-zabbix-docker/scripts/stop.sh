#!/bin/bash

echo "⏹️  Parando Zabbix Docker..."
echo "================================"

# Verificar se está na pasta correta
if [ ! -f "../docker-compose.yml" ]; then
    echo "❌ Erro: docker-compose.yml não encontrado!"
    echo "   Execute este script a partir da pasta scripts/"
    exit 1
fi

cd ..

echo "📊 Status atual dos containers:"
docker compose ps

echo ""
echo "🔄 Parando todos os serviços..."

# Parar e remover containers
docker compose down

echo ""
echo "📋 Verificando se containers foram parados..."
RUNNING=$(docker compose ps --services --filter "status=running")

if [ -z "$RUNNING" ]; then
    echo "✅ Todos os serviços foram parados com sucesso!"
else
    echo "⚠️  Alguns serviços ainda estão rodando:"
    docker compose ps
    echo ""
    echo "🔄 Tentando parar forçadamente..."
    docker compose kill
    docker compose down
fi

echo ""
echo "💾 Informações sobre dados persistentes:"
echo "   Os dados do banco de dados foram preservados"
echo "   Para iniciar novamente: ./start.sh"
echo "   Para reset completo: ./reset.sh"
echo ""
echo "🎉 Zabbix Docker parado com sucesso!"