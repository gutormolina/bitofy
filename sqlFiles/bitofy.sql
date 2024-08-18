CREATE DATABASE BITOFY;
\c bitofy
CREATE SCHEMA BITOFY AUTHORIZATION POSTGRES;
SET search_path TO BITOFY;

CREATE TABLE Genero (
    genTit      varchar(30),
    descr       text,

    PRIMARY KEY (genTit)
);

CREATE TABLE Album (
    titAlb      text,
    dtLanc      date            not null,
    
    PRIMARY KEY (titAlb)
);

CREATE TABLE Musica (
    musId       serial          not null,
    titulo      text            not null,
    duracao     int             not null, -- em segundos
    dtLanc      date            not null,
    numRep      int             not null,
    titAlb      text,
    linkMus     varchar(11),

    PRIMARY KEY (musId),
    FOREIGN KEY (titAlb) REFERENCES Album (titAlb)
);

ALTER TABLE Musica ALTER COLUMN dtLanc SET DEFAULT '2024-08-09';


CREATE TABLE possui (
    musId       int             not null,
    genTit      varchar(30)     not null,

    PRIMARY KEY (musId, genTit),
    FOREIGN KEY (musId) REFERENCES Musica (musId),
    FOREIGN KEY (genTit) REFERENCES Genero (genTit)
);

CREATE TABLE Usuario (
    usuId       serial          not null,
    nome        varchar(30)     not null,
    email       varchar(255)    not null,
    senha       varchar(30)     not null,

    PRIMARY KEY (usuId)
);

CREATE TABLE Escuta (
    usuId       int             not null,
    musId       int             not null,
    peso        int             not null, -- marca quantas vezes

    PRIMARY KEY (usuId, musId),
    FOREIGN KEY (usuId) REFERENCES Usuario (usuId),
    FOREIGN KEY (musId) REFERENCES Musica (musId)
);

CREATE TABLE Avaliacao (
    nota        decimal(2,1)    not null,
    coment      text,  
    dtAval      date            not null,
    usuId       int             not null,
    musId       int             not null,

    PRIMARY KEY (usuId, musId),
    FOREIGN KEY (usuId) REFERENCES Usuario (usuId),
    FOREIGN KEY (musId) REFERENCES Musica (musId),
    CONSTRAINT verifNota CHECK (nota >= 0 AND nota <= 5)
);

CREATE TABLE Playlist (
    playId      serial          not null,
    titulo      varchar(30)     not null,
    dtCria      date            not null,
    usuId       int             not null,

    PRIMARY KEY (playId),
    FOREIGN KEY (usuId) REFERENCES Usuario (usuId)
);

CREATE TABLE musica_playlist (
    playId      int             not null,
    musId       int             not null,

    PRIMARY KEY (playId, musId),
    FOREIGN KEY (playId) REFERENCES Playlist (playId),
    FOREIGN KEY (musId) REFERENCES Musica (musId)
);

CREATE TABLE favorita (
    usuId       int             not null,
    musId       int             not null,
    dtAdic      date            not null,

    PRIMARY KEY (usuId, musId),
    FOREIGN KEY (usuId) REFERENCES Usuario (usuId),
    FOREIGN KEY (musId) REFERENCES Musica (musId)
);

CREATE TABLE Artista  (
    nomeArt     varchar (30),
    biografia   text,

    PRIMARY KEY (nomeArt)
);

CREATE TABLE autoria_musica (
    nomeArt     varchar(30)			not null,
    musId       int             not null,

    PRIMARY KEY (nomeArt, musId),
    FOREIGN KEY (nomeArt) REFERENCES Artista (nomeArt),
    FOREIGN KEY (musId) REFERENCES Musica (musId)
);

CREATE TABLE autoria_album (
    nomeArt     varchar(30)    not null,
    titAlb      text           not null,

    PRIMARY KEY (nomeArt, titAlb),
    FOREIGN KEY (nomeArt) REFERENCES Artista (nomeArt),
    FOREIGN KEY (titAlb) REFERENCES Album (titAlb)
);

-- interface:
-- criar playlist
-- consultar musicas por genero
-- consultar mais ouvidas por usuário

-- INSERTS INICIAIS:

    -- Gêneros:

INSERT INTO Genero (genTit, descr) VALUES
    ('Rock', 'Caracterizado por um ritmo forte, geralmente tocado com guitarras elétricas, baixo e bateria.'),
    ('Pop', 'Popular, com melodias cativantes e letras acessíveis.'),
    ('MPB', 'Música Popular Brasileira, surgiu no Brasil na década de 60, caracterizada pela mistura de gêneros e expressões musicais de todo país.'),
    ('Hip-Hop', 'Envolve rimas faladas de forma rítmica sobre batidas.');

    -- Álbuns:

INSERT INTO Album (titAlb, dtLanc) VALUES
    ('The Dark Side of the Moon', '1973-03-01'),
    ('Thriller', '1982-11-30'),
    ('Construção', '1971-11-01'),
    ('Illmatic', '1994-04-19');

    -- Músicas:

INSERT INTO Musica (titulo, duracao, numRep, titAlb, linkMus) VALUES
    ('Speak to Me', 90, 0, 'The Dark Side of the Moon', '2o4ygOv0wKk'),
    ('Breathe', 163, 0, 'The Dark Side of the Moon', 'stOCUPEytzg'),
    ('On the Run', 215, 0, 'The Dark Side of the Moon', 'KrfhWmHxKQI'),
    ('Time', 413, 0, 'The Dark Side of the Moon', 'bpnZZ14fGqE'),
    ('The Great Gig in the Sky', 276, 0, 'The Dark Side of the Moon', 'c-8bKbAuGiA'),
    ('Money', 382, 0, 'The Dark Side of the Moon', 'Cy4lg1w3Leo'),
    ('Us and Them', 462, 0, 'The Dark Side of the Moon', '_It2WPW4O3s'),
    ('Any Colour You Like', 205, 0, 'The Dark Side of the Moon', 'nlgIkOT6qJk'),
    ('Brain Damage', 228, 0, 'The Dark Side of the Moon', 'jZEpNJ_bV6w'),
    ('Eclipse', 123, 0, 'The Dark Side of the Moon', 'k0xGxnZFNYs');

UPDATE Musica SET dtLanc = '1973-03-01' WHERE titAlb = 'The Dark Side of the Moon';

INSERT INTO Musica (titulo, duracao, numRep, titAlb, linkMus) VALUES
    ('Wanna Be Startin Somethin', 362, 0, 'Thriller', '8KWf_-ofYgI'),
    ('Baby Be Mine', 259, 0, 'Thriller', 'COSMzAASQj4'),
    ('The Girl Is Mine', 221, 0, 'Thriller', 'SX5vM6F57_E'),
    ('Thriller', 358, 0, 'Thriller', 'Z85lxckrtzg'),
    ('Beat It', 258, 0, 'Thriller', 'kOn-HdEg6AQ'),
    ('Billie Jean', 294, 0, 'Thriller', 'Kr4EQDVETuA'),
    ('Human Nature', 240, 0, 'Thriller', 'oqLpko9Gprs'),
    ('P.Y.T. (Pretty Young Thing)', 239, 0, 'Thriller', 'y32ejtuxSjM'),
    ('The Lady in My Life', 298, 0, 'Thriller', 'Eqcw7tLnrd8');

UPDATE Musica SET dtLanc = '1982-11-30' WHERE titAlb = 'Thriller';

INSERT INTO Musica (titulo, duracao, numRep, titAlb, linkMus) VALUES
    ('Deus Lhe Pague', 226, 0, 'Construção', 'rxiafycMSTY'),
    ('Cotidiano', 169, 0, 'Construção', 'dHYOVuq_Fco'),
    ('Desalento', 123, 0, 'Construção', 'XjWSYQwR-4I'),
    ('Construção', 393, 0, 'Construção', 'wBfVsucRe1w'),
    ('Cordão', 150, 0, 'Construção', 'cPxuSErXvsQ'),
    ('Olha Maria', 227, 0, 'Construção', 'SyDrAH5jrqw'),
    ('Samba de Orly', 171, 0, 'Construção', '6OoyRyePx6o'),
    ('Valsinha', 144, 0, 'Construção', 'RhLJFYwutUs'),
    ('Minha História', 173, 0, 'Construção', 'gZEivZvGohs'),
    ('Acalanto', 217, 0, 'Construção', 'TdtLk3005BM');

UPDATE Musica SET dtLanc = '1971-11-01' WHERE titAlb = 'Construção';

INSERT INTO Musica (titulo, duracao, numRep, titAlb, linkMus) VALUES
    ('The Genesis', 112, 0, 'Illmatic', 'Y6ElJoP_2S8'),
    ('N.Y. State of Mind', 290, 0, 'Illmatic', '77MOuc6PvNI'),
    ('Lifes a Bitch', 217, 0, 'Illmatic', 'EUHNnVV8X2k'),
    ('The World Is Yours', 257, 0, 'Illmatic', '8Jmeu2oTXJc'),
    ('Halftime', 244, 0, 'Illmatic', 'uoKEDSSuzHk'),
    ('Memory Lane (Sittin in da Park)', 268, 0, 'Illmatic', 'TWKeRXigJsE'),
    ('One Love', 301, 0, 'Illmatic', 'vxMmUDDRsNs'),
    ('One Time 4 Your Mind', 194, 0, 'Illmatic', 'lZ-kW_rMNHk'),
    ('Represent', 241, 0, 'Illmatic', 'MTWhRLUxSOg'),
    ('It Aint Hard to Tell', 229, 0, 'Illmatic', 'WwuY1uTdLJQ');

UPDATE Musica SET dtLanc = '1994-04-19' WHERE titAlb = 'Illmatic';

    -- Gêneros possuem músicas:

INSERT INTO possui (musId, genTit) VALUES
    -- Pink Floyd - The Dark Side of the Moon
    ((SELECT musId FROM Musica WHERE titulo = 'Speak to Me'), 'Rock'),
    ((SELECT musId FROM Musica WHERE titulo = 'Breathe'), 'Rock'),
    ((SELECT musId FROM Musica WHERE titulo = 'On the Run'), 'Rock'),
    ((SELECT musId FROM Musica WHERE titulo = 'Time'), 'Rock'),
    ((SELECT musId FROM Musica WHERE titulo = 'The Great Gig in the Sky'), 'Rock'),
    ((SELECT musId FROM Musica WHERE titulo = 'Money'), 'Rock'),
    ((SELECT musId FROM Musica WHERE titulo = 'Us and Them'), 'Rock'),
    ((SELECT musId FROM Musica WHERE titulo = 'Any Colour You Like'), 'Rock'),
    ((SELECT musId FROM Musica WHERE titulo = 'Brain Damage'), 'Rock'),
    ((SELECT musId FROM Musica WHERE titulo = 'Eclipse'), 'Rock'),

    -- Michael Jackson - Thriller
    ((SELECT musId FROM Musica WHERE titulo = 'Wanna Be Startin Somethin'), 'Pop'),
    ((SELECT musId FROM Musica WHERE titulo = 'Baby Be Mine'), 'Pop'),
    ((SELECT musId FROM Musica WHERE titulo = 'The Girl Is Mine'), 'Pop'),
    ((SELECT musId FROM Musica WHERE titulo = 'Thriller'), 'Pop'),
    ((SELECT musId FROM Musica WHERE titulo = 'Beat It'), 'Pop'),
    ((SELECT musId FROM Musica WHERE titulo = 'Billie Jean'), 'Pop'),
    ((SELECT musId FROM Musica WHERE titulo = 'Human Nature'), 'Pop'),
    ((SELECT musId FROM Musica WHERE titulo = 'P.Y.T. (Pretty Young Thing)'), 'Pop'),
    ((SELECT musId FROM Musica WHERE titulo = 'The Lady in My Life'), 'Pop'),

    -- Chico Buarque - Construção
    ((SELECT musId FROM Musica WHERE titulo = 'Deus Lhe Pague'), 'MPB'),
    ((SELECT musId FROM Musica WHERE titulo = 'Cotidiano'), 'MPB'),
    ((SELECT musId FROM Musica WHERE titulo = 'Desalento'), 'MPB'),
    ((SELECT musId FROM Musica WHERE titulo = 'Construção'), 'MPB'),
    ((SELECT musId FROM Musica WHERE titulo = 'Cordão'), 'MPB'),
    ((SELECT musId FROM Musica WHERE titulo = 'Olha Maria'), 'MPB'),
    ((SELECT musId FROM Musica WHERE titulo = 'Samba de Orly'), 'MPB'),
    ((SELECT musId FROM Musica WHERE titulo = 'Valsinha'), 'MPB'),
    ((SELECT musId FROM Musica WHERE titulo = 'Minha História'), 'MPB'),
    ((SELECT musId FROM Musica WHERE titulo = 'Acalanto'), 'MPB'),

    -- Nas - Illmatic
    ((SELECT musId FROM Musica WHERE titulo = 'The Genesis'), 'Hip-Hop'),
    ((SELECT musId FROM Musica WHERE titulo = 'N.Y. State of Mind'), 'Hip-Hop'),
    ((SELECT musId FROM Musica WHERE titulo = 'Lifes a Bitch'), 'Hip-Hop'),
    ((SELECT musId FROM Musica WHERE titulo = 'The World Is Yours'), 'Hip-Hop'),
    ((SELECT musId FROM Musica WHERE titulo = 'Halftime'), 'Hip-Hop'),
    ((SELECT musId FROM Musica WHERE titulo = 'Memory Lane (Sittin in da Park)'), 'Hip-Hop'),
    ((SELECT musId FROM Musica WHERE titulo = 'One Love'), 'Hip-Hop'),
    ((SELECT musId FROM Musica WHERE titulo = 'One Time 4 Your Mind'), 'Hip-Hop'),
    ((SELECT musId FROM Musica WHERE titulo = 'Represent'), 'Hip-Hop'),
    ((SELECT musId FROM Musica WHERE titulo = 'It Aint Hard to Tell'), 'Hip-Hop');

    -- Usuários:

INSERT INTO Usuario (nome, email, senha) VALUES
    ('Augusto', 'armolina@inf.ufpel.edu.br', 'gutoadmin123'),
    ('Luiz Filipe', 'lfsbido@inf.ufpel.edu.br', 'bidoadmin123');

    -- Artistas:

INSERT INTO Artista (nomeArt, biografia) VALUES
    ('Pink Floyd', 'Uma das bandas de rock mais influentes e icônicas da história da música, formada em Londres em 1965. A banda alcançou sucesso mundial com álbuns conceituais como The Dark Side of the Moon (1973), Wish You Were Here (1975), e The Wall (1979), que são conhecidos por suas letras profundas, sons inovadores, e produções complexas.'),
    ('Michael Jackson', 'Conhecido como o "Rei do Pop", foi um cantor, compositor e dançarino norte-americano que se tornou uma das figuras mais populares e influentes na história da música. Ele lançou sua carreira solo na década de 1970 e alcançou um sucesso fenomenal com álbuns como Off the Wall (1979), Thriller (1982) — o álbum mais vendido de todos os tempos — e Bad (1987).'),
    ('Chico Buarque', 'É um dos compositores, cantores e escritores mais proeminentes do Brasil. Durante a ditadura militar no Brasil, suas canções frequentemente carregavam críticas sociais sutis, o que o levou a ser censurado várias vezes. Álbuns como Construção (1971) são considerados marcos da música brasileira.'),
    ('Nas', 'É um rapper, compositor e produtor norte-americano. Se tornou um dos maiores nomes do rap ao lançar seu álbum de estreia, Illmatic, em 1994, amplamente considerado um dos melhores álbuns de hip hop de todos os tempos.');

    -- Autoria álbum:

INSERT INTO autoria_album (nomeArt, titAlb) VALUES
    ('Pink Floyd', 'The Dark Side of the Moon'),
    ('Michael Jackson', 'Thriller'),
    ('Chico Buarque', 'Construção'),
    ('Nas', 'Illmatic');

    -- Autoria música:

INSERT INTO autoria_musica (nomeArt, musId) VALUES -- mudar artId para nomeArt
    -- Pink Floyd - The Dark Side of the Moon
    ('Pink Floyd', (SELECT musId FROM Musica WHERE titulo = 'Speak to Me')),
    ('Pink Floyd', (SELECT musId FROM Musica WHERE titulo = 'Breathe')),
    ('Pink Floyd', (SELECT musId FROM Musica WHERE titulo = 'On the Run')),
    ('Pink Floyd', (SELECT musId FROM Musica WHERE titulo = 'Time')),
    ('Pink Floyd', (SELECT musId FROM Musica WHERE titulo = 'The Great Gig in the Sky')),
    ('Pink Floyd', (SELECT musId FROM Musica WHERE titulo = 'Money')),
    ('Pink Floyd', (SELECT musId FROM Musica WHERE titulo = 'Us and Them')),
    ('Pink Floyd', (SELECT musId FROM Musica WHERE titulo = 'Any Colour You Like')),
    ('Pink Floyd', (SELECT musId FROM Musica WHERE titulo = 'Brain Damage')),
    ('Pink Floyd', (SELECT musId FROM Musica WHERE titulo = 'Eclipse')),

    -- Michael Jackson - Thriller
    ('Michael Jackson', (SELECT musId FROM Musica WHERE titulo = 'Wanna Be Startin Somethin')),
    ('Michael Jackson', (SELECT musId FROM Musica WHERE titulo = 'Baby Be Mine')),
    ('Michael Jackson', (SELECT musId FROM Musica WHERE titulo = 'The Girl Is Mine')),
    ('Michael Jackson', (SELECT musId FROM Musica WHERE titulo = 'Thriller')),
    ('Michael Jackson', (SELECT musId FROM Musica WHERE titulo = 'Beat It')),
    ('Michael Jackson', (SELECT musId FROM Musica WHERE titulo = 'Billie Jean')),
    ('Michael Jackson', (SELECT musId FROM Musica WHERE titulo = 'Human Nature')),
    ('Michael Jackson', (SELECT musId FROM Musica WHERE titulo = 'P.Y.T. (Pretty Young Thing)')),
    ('Michael Jackson', (SELECT musId FROM Musica WHERE titulo = 'The Lady in My Life')),

    -- Chico Buarque - Construção
    ('Chico Buarque', (SELECT musId FROM Musica WHERE titulo = 'Deus Lhe Pague')),
    ('Chico Buarque', (SELECT musId FROM Musica WHERE titulo = 'Cotidiano')),
    ('Chico Buarque', (SELECT musId FROM Musica WHERE titulo = 'Desalento')),
    ('Chico Buarque', (SELECT musId FROM Musica WHERE titulo = 'Construção')),
    ('Chico Buarque', (SELECT musId FROM Musica WHERE titulo = 'Cordão')),
    ('Chico Buarque', (SELECT musId FROM Musica WHERE titulo = 'Olha Maria')),
    ('Chico Buarque', (SELECT musId FROM Musica WHERE titulo = 'Samba de Orly')),
    ('Chico Buarque', (SELECT musId FROM Musica WHERE titulo = 'Valsinha')),
    ('Chico Buarque', (SELECT musId FROM Musica WHERE titulo = 'Minha História')),
    ('Chico Buarque', (SELECT musId FROM Musica WHERE titulo = 'Acalanto')),

    -- Nas - Illmatic
    ('Nas', (SELECT musId FROM Musica WHERE titulo = 'The Genesis')),
    ('Nas', (SELECT musId FROM Musica WHERE titulo = 'N.Y. State of Mind')),
    ('Nas', (SELECT musId FROM Musica WHERE titulo = 'Lifes a Bitch')),
    ('Nas', (SELECT musId FROM Musica WHERE titulo = 'The World Is Yours')),
    ('Nas', (SELECT musId FROM Musica WHERE titulo = 'Halftime')),
    ('Nas', (SELECT musId FROM Musica WHERE titulo = 'Memory Lane (Sittin in da Park)')),
    ('Nas', (SELECT musId FROM Musica WHERE titulo = 'One Love')),
    ('Nas', (SELECT musId FROM Musica WHERE titulo = 'One Time 4 Your Mind')),
    ('Nas', (SELECT musId FROM Musica WHERE titulo = 'Represent')),
    ('Nas', (SELECT musId FROM Musica WHERE titulo = 'It Aint Hard to Tell'));

    -- Playlist:

INSERT INTO Playlist (titulo, dtCria, usuId) VALUES
    ('Playlist do Guto', '2024-08-09', 1);

INSERT INTO musica_playlist (playId, musId) VALUES
    ((SELECT playId FROM Playlist WHERE titulo = 'Playlist do Guto'), (SELECT musId FROM Musica WHERE titulo = 'Money')),
    ((SELECT playId FROM Playlist WHERE titulo = 'Playlist do Guto'), (SELECT musId FROM Musica WHERE titulo = 'Beat It')),
    ((SELECT playId FROM Playlist WHERE titulo = 'Playlist do Guto'), (SELECT musId FROM Musica WHERE titulo = 'Deus Lhe Pague')),
    ((SELECT playId FROM Playlist WHERE titulo = 'Playlist do Guto'), (SELECT musId FROM Musica WHERE titulo = 'N.Y. State of Mind'));
