#!/bin/bash

echo "=== RHCSA Lab 03: Text Processing and Redirection ==="
echo "Resetting lab environment..."

# Clean up any existing directories and files from previous runs
rm -rf logs/ workspace/ results/ archive/ 2>/dev/null

# Create fresh directory structure
mkdir -p logs workspace/analysis workspace/reports results archive

# Generate system.log with mixed log levels
cat > logs/system.log << 'EOF'
2024-01-15 08:15:23 INFO System startup completed successfully
2024-01-15 08:16:45 INFO Network service started on port 8080
2024-01-15 08:18:12 WARNING Memory usage at 78% threshold
2024-01-15 08:19:34 ERROR Failed to connect to database server
2024-01-15 08:20:01 INFO Database connection retry attempt 1
2024-01-15 08:20:05 ERROR Database connection failed: timeout exceeded
2024-01-15 08:22:17 INFO Service health check passed
2024-01-15 08:25:43 WARNING Disk space below 20% on /var partition
2024-01-15 08:27:09 ERROR Process crashed: segmentation fault in module xyz
2024-01-15 08:28:15 INFO Automatic restart initiated
2024-01-15 08:28:45 INFO System recovery completed
2024-01-15 08:30:22 WARNING High CPU usage detected: 92%
2024-01-15 08:32:11 INFO Scheduled backup started
2024-01-15 08:35:47 ERROR Backup failed: insufficient permissions
2024-01-15 08:36:23 INFO Manual backup initiated by admin
2024-01-15 08:40:15 INFO Backup completed successfully
2024-01-15 08:42:33 WARNING SSL certificate expires in 30 days
2024-01-15 08:45:01 ERROR Network timeout on interface eth0
2024-01-15 08:45:30 INFO Network interface eth0 restarted
2024-01-15 08:47:12 INFO All services operational
EOF

# Generate security.log with login attempts and various security events
cat > logs/security.log << 'EOF'
2024-01-15 07:30:15 AUTH SUCCESS User admin logged in from 192.168.1.100
2024-01-15 07:32:45 AUTH FAILED Invalid password for user root from 203.45.67.89
2024-01-15 07:33:12 AUTH FAILED Invalid password for user root from 203.45.67.89
2024-01-15 07:33:48 AUTH FAILED Invalid password for user admin from 203.45.67.89
2024-01-15 07:34:23 SECURITY IP 203.45.67.89 blocked due to multiple failed attempts
2024-01-15 07:45:22 AUTH SUCCESS User developer logged in from 10.0.0.45
2024-01-15 07:47:33 SUDO User developer executed sudo command: apt update
2024-01-15 07:52:11 AUTH FAILED Unknown user postgres from 198.23.45.167
2024-01-15 07:52:45 AUTH FAILED Unknown user mysql from 198.23.45.167
2024-01-15 07:53:20 AUTH FAILED Invalid password for user admin from 198.23.45.167
2024-01-15 07:58:09 AUTH SUCCESS User operator logged in from 192.168.1.105
2024-01-15 08:05:14 SSH Connection from 45.67.89.123 rejected - invalid key
2024-01-15 08:10:22 AUTH SUCCESS User admin logged in from 192.168.1.100
2024-01-15 08:12:45 SUDO User admin executed sudo command: systemctl restart nginx
2024-01-15 08:15:33 AUTH FAILED Invalid password for user test from 156.78.90.234
2024-01-15 08:16:01 AUTH FAILED Invalid password for user guest from 156.78.90.234
2024-01-15 08:20:15 AUTH SUCCESS User monitor logged in from 10.0.0.78
2024-01-15 08:25:44 AUTH FAILED Expired password for user olduser from 192.168.1.200
2024-01-15 08:30:22 SSH Key added for user developer
2024-01-15 08:35:11 AUTH SUCCESS User admin logged in from 172.16.0.50
EOF

# Generate access.log with web server style entries
cat > logs/access.log << 'EOF'
192.168.1.100 - - [15/Jan/2024:08:00:15 +0000] "GET /index.html HTTP/1.1" 200 5234
198.23.45.167 - - [15/Jan/2024:08:00:23 +0000] "GET /admin HTTP/1.1" 401 234
192.168.1.105 - - [15/Jan/2024:08:00:45 +0000] "POST /api/login HTTP/1.1" 200 128
203.45.67.89 - - [15/Jan/2024:08:01:12 +0000] "GET /admin/config HTTP/1.1" 403 98
10.0.0.45 - - [15/Jan/2024:08:01:34 +0000] "GET /dashboard HTTP/1.1" 200 8976
192.168.1.100 - - [15/Jan/2024:08:02:15 +0000] "GET /api/users HTTP/1.1" 200 4532
45.67.89.123 - - [15/Jan/2024:08:02:45 +0000] "GET /../etc/passwd HTTP/1.1" 404 134
192.168.1.105 - - [15/Jan/2024:08:03:22 +0000] "POST /api/data HTTP/1.1" 201 256
156.78.90.234 - - [15/Jan/2024:08:03:55 +0000] "GET /phpmyadmin HTTP/1.1" 404 145
10.0.0.78 - - [15/Jan/2024:08:04:18 +0000] "GET /status HTTP/1.1" 200 89
192.168.1.100 - - [15/Jan/2024:08:04:45 +0000] "DELETE /api/cache HTTP/1.1" 204 0
172.16.0.50 - - [15/Jan/2024:08:05:12 +0000] "GET /metrics HTTP/1.1" 200 12453
198.23.45.167 - - [15/Jan/2024:08:05:38 +0000] "POST /upload HTTP/1.1" 500 567
192.168.1.200 - - [15/Jan/2024:08:06:15 +0000] "GET /download/file.pdf HTTP/1.1" 200 234567
10.0.0.45 - - [15/Jan/2024:08:06:45 +0000] "GET /api/reports HTTP/1.1" 200 7896
203.45.67.89 - - [15/Jan/2024:08:07:23 +0000] "GET /wp-admin HTTP/1.1" 404 123
192.168.1.105 - - [15/Jan/2024:08:07:58 +0000] "PUT /api/user/123 HTTP/1.1" 200 345
45.67.89.123 - - [15/Jan/2024:08:08:34 +0000] "GET /shell.php HTTP/1.1" 404 134
172.16.0.50 - - [15/Jan/2024:08:09:12 +0000] "GET /health HTTP/1.1" 200 45
156.78.90.234 - - [15/Jan/2024:08:09:45 +0000] "POST /api/authenticate HTTP/1.1" 500 789
EOF

# Generate application.log with various application errors and stack traces
cat > logs/application.log << 'EOF'
2024-01-15 08:00:15.234 INFO Application starting version 2.3.4
2024-01-15 08:00:18.567 INFO Loading configuration from /etc/app/config.yaml
2024-01-15 08:00:22.891 WARNING Config parameter 'cache_size' not set, using default: 100MB
2024-01-15 08:00:25.123 INFO Database connection pool initialized
2024-01-15 08:01:34.456 ERROR NullPointerException in UserService.getUser()
	at com.app.UserService.getUser(UserService.java:45)
	at com.app.Controller.handleRequest(Controller.java:123)
	at com.app.Main.processRequest(Main.java:78)
2024-01-15 08:02:45.789 WARNING Performance degradation detected: response time > 2000ms
2024-01-15 08:03:12.234 ERROR Database query failed: connection timeout
2024-01-15 08:03:15.567 INFO Retrying database connection...
2024-01-15 08:03:18.890 INFO Database connection restored
2024-01-15 08:04:23.456 ERROR Failed to parse JSON: unexpected token at position 234
2024-01-15 08:05:34.789 WARNING Memory usage high: 85% of heap utilized
2024-01-15 08:06:45.123 ERROR FileNotFoundException: /data/config.xml not found
	at java.io.FileInputStream.open(FileInputStream.java:234)
	at com.app.ConfigLoader.load(ConfigLoader.java:56)
2024-01-15 08:07:56.456 INFO Cache cleared successfully
2024-01-15 08:08:12.789 ERROR Authentication failed: invalid token
2024-01-15 08:09:23.123 WARNING Deprecated API endpoint accessed: /api/v1/oldmethod
2024-01-15 08:10:34.456 ERROR IndexOutOfBoundsException: Index 10 out of bounds for length 5
	at java.util.ArrayList.get(ArrayList.java:123)
	at com.app.DataProcessor.process(DataProcessor.java:89)
2024-01-15 08:11:45.789 INFO Scheduled task 'cleanup' completed
2024-01-15 08:12:56.123 ERROR Connection pool exhausted: no available connections
2024-01-15 08:13:12.456 WARNING SSL certificate validation failed for external service
2024-01-15 08:14:23.789 INFO Application shutdown initiated
EOF

echo "Lab 03 setup complete! All previous changes have been reset."
echo ""
echo "Directory structure created:"
echo "  logs/           - Contains various log files to analyze"
echo "  workspace/      - Your working directory"
echo "    analysis/     - For copying and analyzing logs"
echo "    reports/      - For creating reports"
echo "  results/        - For final report files"
echo "  archive/        - For archiving original logs"
echo ""
echo "Run './check.sh' after completing tasks to verify your work."