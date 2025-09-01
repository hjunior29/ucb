#!/bin/bash

echo "🔄 Reset Completo do Zabbix Docker"
echo "=================================="
echo ""
echo "⚠️  ATENÇÃO: Esta operação irá:"
echo "   - Parar todos os containers"
echo "   - Remover todos os containers"
echo "   - APAGAR TODOS OS DADOS do banco"
echo "   - Remover volumes e configurações"
echo ""

read -p "🤔 Tem certeza que deseja continuar? (Digite 'sim' para confirmar): " confirmation

if [ "$confirmation" != "sim" ]; then
    echo "❌ Operação cancelada."
    exit 0
fi

echo ""
echo "🔄 Iniciando reset completo..."

# Verificar se está na pasta correta
if [ ! -f "../docker-compose.yml" ]; then
    echo "❌ Erro: docker-compose.yml não encontrado!"
    echo "   Execute este script a partir da pasta scripts/"
    exit 1
fi

cd ..

echo "⏹️  Parando todos os containers..."
docker compose down

echo "🗑️  Removendo containers, volumes e redes..."
docker compose down -v --remove-orphans

echo "🧹 Removendo imagens do Zabbix (opcional)..."
read -p "Deseja remover também as imagens Docker? (s/N): " remove_images

if [[ $remove_images =~ ^[Ss]$ ]]; then
    echo "🗑️  Removendo imagens..."
    docker images | grep zabbix | awk '{print $3}' | xargs -r docker rmi -f
    docker images | grep mysql | awk '{print $3}' | xargs -r docker rmi -f
    echo "✅ Imagens removidas!"
else
    echo "⏭️  Mantendo imagens Docker (para reinstalação mais rápida)"
fi

echo "🗑️  Removendo arquivos de configuração..."
rm -rf config/

echo "🧹 Limpando cache do Docker..."
docker system prune -f

echo ""
echo "✅ Reset completo realizado com sucesso!"
echo "=================================="
echo ""
echo "📋 O que foi removido:"
echo "   ✅ Todos os containers Zabbix"
echo "   ✅ Todos os dados do banco de dados"
echo "   ✅ Todas as configurações customizadas"
echo "   ✅ Todos os volumes Docker"
echo "   ✅ Rede Docker criada"
if [[ $remove_images =~ ^[Ss]$ ]]; then
    echo "   ✅ Imagens Docker"
fi
echo ""
echo "🚀 Para reinstalar do zero:"
echo "   ./start.sh"
echo ""
echo "💡 Dica: Mantenha backup das configurações importantes!"