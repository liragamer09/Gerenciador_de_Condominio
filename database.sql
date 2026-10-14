CREATE DATABASE IF NOT EXISTS condominio;
USE condominio;

CREATE TABLE morador (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    telefone VARCHAR(15),
    email VARCHAR(100),
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE apartamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(10) NOT NULL,
    bloco VARCHAR(10) NOT NULL,
    morador_id INT,
    FOREIGN KEY (morador_id) REFERENCES morador(id) ON DELETE SET NULL
);

CREATE TABLE conta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    apartamento_id INT NOT NULL,
    descricao VARCHAR(100) NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    data_vencimento DATE NOT NULL,
    status ENUM('Pendente', 'Pago', 'Vencido') DEFAULT 'Pendente',
    FOREIGN KEY (apartamento_id) REFERENCES apartamento(id) ON DELETE CASCADE
);

CREATE TABLE morador_backup (
    id INT AUTO_INCREMENT PRIMARY KEY,
    morador_id INT, 
    nome VARCHAR(100), 
    cpf VARCHAR(14), 
    telefone VARCHAR(15), 
    email VARCHAR(100),
    tipo_operacao VARCHAR(20), 
    data_alteracao DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE conta_backup (
    id INT AUTO_INCREMENT PRIMARY KEY,
    conta_id INT, 
    apartamento_id INT, 
    descricao VARCHAR(100), 
    valor DECIMAL(10, 2), 
    data_vencimento DATE, 
    status VARCHAR(20),
    tipo_operacao VARCHAR(20), 
    data_alteracao DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER registrar_morador_atualizado AFTER UPDATE ON morador FOR EACH ROW
BEGIN
    INSERT INTO morador_backup (morador_id, nome, cpf, telefone, email, tipo_operacao)
    VALUES (OLD.id, OLD.nome, OLD.cpf, OLD.telefone, OLD.email, 'Atualizacao');
END //

CREATE TRIGGER registrar_morador_excluido BEFORE DELETE ON morador FOR EACH ROW
BEGIN
    INSERT INTO morador_backup (morador_id, nome, cpf, telefone, email, tipo_operacao)
    VALUES (OLD.id, OLD.nome, OLD.cpf, OLD.telefone, OLD.email, 'Exclusao');
END //

CREATE TRIGGER registrar_conta_atualizada AFTER UPDATE ON conta FOR EACH ROW
BEGIN
    INSERT INTO conta_backup (conta_id, apartamento_id, descricao, valor, data_vencimento, status, tipo_operacao)
    VALUES (OLD.id, OLD.apartamento_id, OLD.descricao, OLD.valor, OLD.data_vencimento, OLD.status, 'Atualizacao');
END //

CREATE TRIGGER registrar_conta_excluida BEFORE DELETE ON conta FOR EACH ROW
BEGIN
    INSERT INTO conta_backup (conta_id, apartamento_id, descricao, valor, data_vencimento, status, tipo_operacao)
    VALUES (OLD.id, OLD.apartamento_id, OLD.descricao, OLD.valor, OLD.data_vencimento, OLD.status, 'Exclusao');
END //
DELIMITER ;
