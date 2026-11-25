create table jogadores (
	id serial primary key,
	nome varchar(100) unique not null,
	email varchar(100) unique not null,
	senha varchar(100) not null,
	status varchar(100) not null default 'jogador ativo',
	data_cadastro timestamp default current_timestamp,

constraint 
	status_jogador check(status in ('jogador ativo', 'jogador inativo', 'jogador banido'))
	
);

create table modalidades (
	id serial primary key,
	nome varchar(100) unique not null,
	categoria varchar(100) not null
	
);

CREATE TABLE torneios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) UNIQUE NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    status VARCHAR(30) NOT NULL
);

CREATE TABLE jogos (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(120) NOT NULL,
    id_jogador INTEGER NOT NULL,
    id_modalidade INTEGER NOT NULL,
    id_torneio INTEGER NOT NULL,
    data_agendada TIMESTAMP NOT NULL,
    status VARCHAR(15) NOT NULL DEFAULT 'agendada',
    data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    resultado VARCHAR(150),
    CONSTRAINT fk_partida_jogador FOREIGN KEY (id_jogador) REFERENCES jogadores(id),
    CONSTRAINT fk_partida_modalidade FOREIGN KEY (id_modalidade) REFERENCES modalidades(id),
    CONSTRAINT fk_partida_torneio FOREIGN KEY (id_torneio) REFERENCES torneios(id),
    CONSTRAINT status_partida CHECK (status IN ('agendada', 'em_andamento', 'concluida', 'cancelada'))
);

CREATE TABLE historico_partidas (
    id SERIAL PRIMARY KEY,
    id_partida INTEGER NOT NULL,
    acao VARCHAR(50) NOT NULL,
    descricao VARCHAR(200) NOT NULL,
    data_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_historico_partida FOREIGN KEY (id_partida) REFERENCES jogos(id) ON DELETE CASCADE
);

INSERT INTO jogadores (nome, email, senha, status) VALUES
('Manuela', 'lucca@email.com', 'senha321', 'jogador ativo'),
('Gabriel', 'nicolas@email.com', 'senha456', 'jogador ativo'),
('Felipe', 'felipe@email.com', 'senha789', 'jogador inativo');

INSERT INTO modalidades (nome, categoria) VALUES
('League of Legends', 'MOBA'),
('Counter-Strike 2', 'FPS'),
('Rocket League', 'Esporte eletrônico');

INSERT INTO torneios (nome, data_inicio, data_fim, status) VALUES
('Copa Gamer SC', '2026-12-01', '2026-12-10', 'inscricoes'),
('Desafio Arena Digital', '2027-01-10', '2027-01-20', 'inscricoes'),
('Festival E-sports Sul', '2027-02-05', '2027-02-15', 'inscricoes');

INSERT INTO jogos (titulo, id_jogador, id_modalidade, id_torneio, data_agendada, status, resultado) VALUES
('Manuela x Convidado A', 1, 1, 1, '2026-12-03 14:00:00', 'agendada', NULL),
('Gabriel x Convidado B', 2, 2, 2, '2027-01-12 16:30:00', 'agendada', NULL),
('Manuela x Convidado C', 1, 3, 3, '2027-02-08 19:00:00', 'agendada', NULL);

CREATE VIEW vw_painel_principal AS
SELECT
    j.nome,
    p.titulo,
    m.categoria,
    p.data_agendada,
    p.status
FROM jogos p
JOIN jogadores j ON p.id_jogador = j.id
JOIN modalidades m ON p.id_modalidade = m.id;


CREATE OR REPLACE VIEW vw_cronograma_partidas AS
SELECT
    p.id,
    p.titulo,
    p.data_agendada,
    p.status,