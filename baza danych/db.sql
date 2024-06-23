CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100),
    money INT DEFAULT 0,
    score INT DEFAULT 0,
    kills INT DEFAULT 0,
    deaths INT DEFAULT 0,
    reputation INT DEFAULT 0,
    sid VARCHAR(50) UNIQUE,
    serial VARCHAR(50),
    license_category_a BOOLEAN DEFAULT false,
    license_category_b BOOLEAN DEFAULT false,
    license_category_c BOOLEAN DEFAULT false,
    license_category_ce BOOLEAN DEFAULT false,
    last_login DATETIME,
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE punishments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    type ENUM('ban', 'kick', 'warn') NOT NULL,
    reason TEXT,
    duration INT DEFAULT 0,
    punishment_date DATETIME DEFAULT CURRENT_TIMESTAMP
);
