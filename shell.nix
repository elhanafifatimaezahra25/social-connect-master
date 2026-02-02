{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "social-connect-devshell";

  buildInputs = [
    pkgs.jdk17
    pkgs.maven
    pkgs.mariadb
    
    # JavaFX native dependencies
    pkgs.gtk3
    pkgs.glib
    pkgs.libGL
    pkgs.xorg.libX11
    pkgs.xorg.libXtst
    pkgs.xorg.libXxf86vm
    pkgs.alsa-lib
  ];

  MARIADB_DATA_DIR = "./.mariadb-data";
  MARIADB_PORT     = "3306";
  
  # Set up library path for JavaFX native libraries
  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
    pkgs.gtk3
    pkgs.glib
    pkgs.libGL
    pkgs.xorg.libX11
    pkgs.xorg.libXtst
    pkgs.xorg.libXxf86vm
    pkgs.alsa-lib
  ];

  shellHook = ''
    echo "═══════════════════════════════════════════════════════"
    echo "  🌐 Social Connect - JavaFX Social Media Platform"
    echo "═══════════════════════════════════════════════════════"
    echo ""

    MYSQL="${pkgs.mariadb}/bin/mysql"
    MYSQLD="${pkgs.mariadb}/bin/mysqld"
    MYSQLADMIN="${pkgs.mariadb}/bin/mysqladmin"
    MYSQL_INSTALL="${pkgs.mariadb}/bin/mysql_install_db"

    DATA_DIR="$MARIADB_DATA_DIR"
    PORT="$MARIADB_PORT"
    LOG=".mariadb.log"

    mkdir -p "$DATA_DIR"

    cleanup() {
      echo ""
      echo "🛑 Stopping MariaDB..."
      $MYSQLADMIN --protocol=TCP --host=127.0.0.1 --port=$PORT -u root shutdown 2>/dev/null || true
      pkill -f "mysqld.*$DATA_DIR" 2>/dev/null || true
    }

    trap cleanup EXIT INT TERM

    if pgrep -f "mysqld.*$DATA_DIR" > /dev/null; then
      echo "⚠️ MariaDB already running."
    else
      # Initialize DB if not initialized
      if [ ! -f "$DATA_DIR/ibdata1" ]; then
        echo "🔧 Initializing MariaDB data directory..."
        $MYSQL_INSTALL --datadir="$DATA_DIR" --auth-root-authentication-method=normal >/dev/null 2>&1 || true
        echo "✨ Initialization done."
      fi

      echo "💿 Starting MariaDB on TCP port $PORT (no sockets)..."

      $MYSQLD \
        --datadir="$DATA_DIR" \
        --socket="" \
        --skip-networking=0 \
        --bind-address=127.0.0.1 \
        --port="$PORT" \
        > "$LOG" 2>&1 &

      echo "⏳ Waiting for MariaDB to accept connections..."

      for i in {1..20}; do
        if $MYSQL --protocol=TCP --host=127.0.0.1 --port=$PORT -u root -e "SELECT 1" >/dev/null 2>&1; then
          break
        fi
        sleep 1
      done

      if ! $MYSQL --protocol=TCP --host=127.0.0.1 --port=$PORT -u root -e "SELECT 1" >/dev/null 2>&1; then
        echo "❌ MariaDB failed to start. Check $LOG:"
        tail -n 60 "$LOG"
        exit 1
      fi

      echo "✅ MariaDB is running at 127.0.0.1:$PORT"
    fi

    echo "🔐 Creating database + user (if missing)..."
    $MYSQL --protocol=TCP --host=127.0.0.1 --port=$PORT -u root -e "
      CREATE DATABASE IF NOT EXISTS testdb;
      CREATE USER IF NOT EXISTS 'appuser'@'%' IDENTIFIED BY 'app123';
      GRANT ALL PRIVILEGES ON testdb.* TO 'appuser'@'%';
      FLUSH PRIVILEGES;
    " >/dev/null 2>&1

    echo "📦 Database ready → testdb | user: appuser | pass: app123"
    echo ""

    echo "🛠 Building Social Connect..."
    if mvn -q clean package; then
      echo "✅ Build successful!"
    else
      echo "⚠️ Build finished with warnings/errors."
    fi

    echo ""
    echo "═══════════════════════════════════════════════════════"
    echo "  🎉 DEV ENV READY!"
    echo "═══════════════════════════════════════════════════════"
    echo ""
    echo "Commands:"
    echo "  run                   - Launch app"
    echo "  mvn javafx:run        - Launch app"
    echo "  mvn clean package     - Rebuild"
    echo "  mysql connect:        mysql -h 127.0.0.1 -P $PORT -u appuser -p"
    echo "  exit                  - Stops MariaDB"
    echo ""

    run() {
      echo "🚀 Running Social Connect..."
      mvn javafx:run
    }
    export -f run

    echo "💡 Tip: type 'run'"
    echo ""
  '';
}
