# 3-Tier Nginx + PHP-FPM + MySQL 

<img width="1920" height="1008" alt="Screenshot 2025-11-23 111634" src="https://github.com/user-attachments/assets/49ccbf75-a31f-4765-8803-d2233ab26418" />
<img width="1920" height="1008" alt="Screenshot 2025-11-23 111700" src="https://github.com/user-attachments/assets/808f757d-61e4-49b2-a28c-c7dc447e422b" />
<img width="1920" height="1008" alt="Screenshot 2025-11-23 111706" src="https://github.com/user-attachments/assets/09be4461-32bc-4f6e-8145-4615efea1209" />

## Steps to Run

### 1. Start containers

```
docker-compose -f 3tier.yml up -d
```

### 2. Configure Nginx (`default.conf`)

```
server {
    listen 80;
    root /var/www/html;
    index index.php index.html;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass myapp:9000;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
```

### 3. Place all files directly in the root directory

(No `app/` folder. You already stored HTML, CSS, JS, PHP directly.)

### 4. Create MySQL table

```
docker exec -it <mysql_container> mysql -u root -p
use mydb;
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(255) UNIQUE,
  password VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 5. Install MySQL PHP Drivers in php‑fpm

```
docker exec -it myapp bash
apt update
apt install -y default-mysql-client
docker-php-ext-install pdo pdo_mysql mysqli
exit

docker restart myapp
```

### 6. Restart Nginx

```
docker restart web
```

---

## Notes

* Use `fastcgi_pass myapp:9000` (service name, not IP).
* Use same document root path inside both containers.
* Store all project files in root directory.
* After setup, access: **[http://<public_ip>/](http://<public_ip>/)**

---

