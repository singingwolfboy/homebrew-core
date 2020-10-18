class SqliteFdw < Formula
  desc "SQLite Foreign Data Wrapper for PostgreSQL"
  homepage "https://github.com/pgspider/sqlite_fdw/"
  url "https://github.com/pgspider/sqlite_fdw/archive/v1.3.0.tar.gz"
  sha256 "61283b7f33b2a727af722fcfcdfe3cb7d6847e1f43e12a4b3554ab7190bfe9b3"
  license "MIT"

  depends_on "postgresql"
  uses_from_macos "sqlite"

  def install
    system "make", "install", "USE_PGXS=1", "DESTDIR=#{prefix}"
  end

  test do
    return if ENV["CI"]

    sqlite_sql = <<~EOS
      CREATE TABLE t1(a INT PRIMARY KEY, b TEXT);
      INSERT INTO t1(a, b) VALUES (1, "test");
    EOS
    system "sqlite3", testpath/"test.db", sqlite_sql

    system "initdb", testpath/"datadir"
    mkdir testpath/"socket"
    File.open(testpath/"datadir"/"postgresql.conf", "a") do |f|
      f << "listen_addresses = ''\n"
      f << "unix_socket_directories = '#{testpath}/socket'\n"
    end
    pid = Process.fork { exec "postgres", "-D", testpath/"datadir" }
    sleep 2
    begin
      system "createdb", "-h", testpath/"socket", "test"

      input_sql = <<~EOS
        CREATE EXTENSION sqlite_fdw;
        CREATE SERVER sqlite_server FOREIGN DATA WRAPPER sqlite_fdw OPTIONS (database '#{testpath}/test.db');
        CREATE FOREIGN TABLE t1(a integer, b text) SERVER sqlite_server OPTIONS (table 't1');
        SELECT * FROM t1;
      EOS

      File.open(testpath/"input.sql", "w") do |f|
        f.write(input_sql)
      end

      system "psql", "-h", testpath/"socket", "-f", testpath/"input.sql", "-o", testpath/"output.txt", "-Atq", "test"
      actual_output = File.read(testpath/"output.txt")

      expected_output = <<~EOS
        SET
        CREATE EXTENSION
        CREATE SERVER
        CREATE FOREIGN TABLE
        1|test
      EOS

      assert_equal(expected_output.gsub(/\s+/, ""), actual_output.gsub(/\s+/, ""))
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
