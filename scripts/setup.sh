#!/bin/bash

echo "🚀 Configuración inicial del Sistema de Inventario SUAN"
echo "================================================"

# Verificar si MySQL está instalado
if ! command -v mysql &> /dev/null; then
    echo "❌ MySQL no está instalado"
    echo "Para instalarlo en Ubuntu/Debian:"
    echo "sudo apt update && sudo apt install mysql-server"
    exit 1
fi

echo "✅ MySQL encontrado"

# Verificar si MySQL está corriendo
if ! pgrep -x "mysqld" > /dev/null; then
    echo "⚠️ MySQL no está ejecutándose"
    echo "Iniciando MySQL..."
    sudo service mysql start
    
    if [ $? -eq 0 ]; then
        echo "✅ MySQL iniciado exitosamente"
    else
        echo "❌ Error al iniciar MySQL"
        exit 1
    fi
else
    echo "✅ MySQL está ejecutándose"
fi

# Crear base de datos
echo "📝 Creando base de datos suan_app..."
mysql -u root -p123456 -e "CREATE DATABASE IF NOT EXISTS suan_app CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ Base de datos creada/verificada"
else
    echo "❌ Error al crear base de datos"
    echo "Verifica las credenciales en database_service.dart"
    exit 1
fi

# Ejecutar script de inicialización si existe
if [ -f "database/init_database.sql" ]; then
    echo "🗄️ Ejecutando script de inicialización..."
    mysql -u root -p123456 suan_app < database/init_database.sql
    
    if [ $? -eq 0 ]; then
        echo "✅ Script de inicialización ejecutado"
    else
        echo "⚠️ Advertencia: Error en script de inicialización"
    fi
else
    echo "⚠️ Script de inicialización no encontrado"
fi

echo ""
echo "🎉 Configuración completada!"
echo "💡 Ahora puedes ejecutar: flutter run"
echo ""
echo "📱 Funcionalidades disponibles:"
echo "   - Gestión de productos terminados"
echo "   - Gestión de materias primas"
echo "   - Control de stock por código numérico"
echo "   - Kardex de movimientos"
echo ""
echo "🔧 En caso de problemas:"
echo "   - Verifica que MySQL esté corriendo: sudo service mysql status"
echo "   - Revisa las credenciales en lib/services/database_service.dart"
echo "   - Consulta el README.md para más detalles"
