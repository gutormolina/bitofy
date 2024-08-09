CREATE DATABASE BITOFY;
\c bitofy
CREATE SCHEMA BITOFY AUTHORIZATION POSTGRES;
SET search_path TO BITOFY;

CREATE TABLE Genero (
    genId       serial          not null,
    nome        varchar(30)     not null,
    descr       text,

    PRIMARY KEY (genId)
);

CREATE TABLE Album (
    albId       serial          not null,
    titulo      text            not null,
    dtLanc      date            not null,
    
    PRIMARY KEY (albId)
);

CREATE TABLE Musica (
    musId       serial          not null,
    titulo      text            not null,
    duracao     int             not null, -- em segundos
    dtLanc      date            not null,
    numRep      int             not null,
    albId       int, -- se for single, o que acontece com a fkey?
    linkMus     varchar(11),

    PRIMARY KEY (musId),
    FOREIGN KEY (albId) REFERENCES Album (albId)
);

ALTER TABLE Musica ALTER COLUMN dtLanc SET DEFAULT '2024-08-09';


CREATE TABLE possui (
    musId       int             not null,
    genId       int             not null,

    FOREIGN KEY (musId) REFERENCES Musica (musId), -- precisa indicar que estas são primárias tbm?
    FOREIGN KEY (genId) REFERENCES Genero (genId)
);

CREATE TABLE Usuario (
    CPF         varchar(11)     not null,
    nome        varchar(30)     not null,
    email       varchar(255)    not null,
    senha       varchar(30)     not null,

    PRIMARY KEY (CPF)
);

CREATE TABLE Escuta (
    CPF         varchar(11)     not null,
    musId       int             not null,
    peso        serial          not null, -- marca quantas vezes

    FOREIGN KEY (CPF) REFERENCES Usuario (CPF),
    FOREIGN KEY (musId) REFERENCES Musica (musId)
);

CREATE TABLE Avaliacao (
    avalId      serial          not null,
    nota        decimal(2,1)    not null,
    coment      text,  
    dtAval      date            not null,
    CPF         varchar(11)     not null,
    musId       int             not null,

    PRIMARY KEY (avalId),
    FOREIGN KEY (CPF) REFERENCES Usuario (CPF),
    FOREIGN KEY (musId) REFERENCES Musica (musId),
    CONSTRAINT verifNota CHECK (nota >= 0 AND nota <= 5)
);

CREATE TABLE Playlist (
    playId      serial          not null,
    titulo      varchar(30)     not null,
    dtCria      date            not null,
    CPF         varchar(11)     not null,

    PRIMARY KEY (playId),
    FOREIGN KEY (CPF) REFERENCES Usuario (CPF)
);

CREATE TABLE musica_playlist (
    playId      int             not null,
    musId       int             not null,

    FOREIGN KEY (playId) REFERENCES Playlist (playId),
    FOREIGN KEY (musId) REFERENCES Musica (musId)
);

CREATE TABLE favorita (
    CPF         varchar(11)     not null,
    musId       int             not null,
    dtAdic      date            not null,

    FOREIGN KEY (CPF) REFERENCES Usuario (CPF),
    FOREIGN KEY (musId) REFERENCES Musica (musId)
);

CREATE TABLE Artista  (
    artId       serial          not null,
    CPF         varchar(11)     not null, -- acho q n pode ser not null
    biografia   text,

    PRIMARY KEY (artId),
    FOREIGN KEY (CPF) REFERENCES Usuario (CPF)
);

CREATE TABLE autoria_musica (
    artId       int             not null,
    musId       int             not null,

    FOREIGN KEY (artId) REFERENCES Artista (artId),
    FOREIGN KEY (musId) REFERENCES Musica (musId)
);

CREATE TABLE autoria_album (
    artId       int             not null,
    albId       int             not null,

    FOREIGN KEY (artId) REFERENCES Artista (artId),
    FOREIGN KEY (albId) REFERENCES Album (albId)
);

-- interface:
-- criar playlist
-- consultar musicas por genero

-- INSERTS INICIAIS:

    -- Gêneros:

INSERT INTO Genero (nome, descr) VALUES
    ('Rock', 'Caracterizado por um ritmo forte, geralmente tocado com guitarras elétricas, baixo e bateria.'),
    ('Pop', 'Popular, com melodias cativantes e letras acessíveis.'),
    ('MPB', 'Música Popular Brasileira, surgiu no Brasil na década de 60, caracterizada pela mistura de gêneros e expressões musicais de todo país.'),
    ('Hip-Hop', 'Envolve rimas faladas de forma rítmica sobre batidas.');

    -- Álbuns:

INSERT INTO Album (titulo, dtLanc) VALUES
    ('The Dark Side of the Moon', '1973-03-01'),
    ('Thriller', '1982-11-30'),
    ('Construção', '1971-11-01'),
    ('Illmatic', '1994-04-19');

    -- Músicas:

INSERT INTO Musica (titulo, duracao, numRep, albId, linkMus) VALUES
    ('Speak to Me', 90, 0, (SELECT albId FROM Album WHERE titulo = 'The Dark Side of the Moon'), 'O7qH5RVM7cQ'),
    ('Breathe', 163, 0, (SELECT albId FROM Album WHERE titulo = 'The Dark Side of the Moon'), 'mrojrDCI02k'),
    ('On the Run', 215, 0, (SELECT albId FROM Album WHERE titulo = 'The Dark Side of the Moon'), 'Z--Xaf6PUp0'),
    ('Time', 413, 0, (SELECT albId FROM Album WHERE titulo = 'The Dark Side of the Moon'), 'JwYX52BP2Sk'),
    ('The Great Gig in the Sky', 276, 0, (SELECT albId FROM Album WHERE titulo = 'The Dark Side of the Moon'), '6Dk02J5YZT4'),
    ('Money', 382, 0, (SELECT albId FROM Album WHERE titulo = 'The Dark Side of the Moon'), '-0kcet4aPpQ'),
    ('Us and Them', 462, 0, (SELECT albId FROM Album WHERE titulo = 'The Dark Side of the Moon'), 'nDbeqj-1XOo'),
    ('Any Colour You Like', 205, 0, (SELECT albId FROM Album WHERE titulo = 'The Dark Side of the Moon'), 'ZInRE-KryGA'),
    ('Brain Damage', 228, 0, (SELECT albId FROM Album WHERE titulo = 'The Dark Side of the Moon'), 'DVQ3-Xe_suY'),
    ('Eclipse', 123, 0, (SELECT albId FROM Album WHERE titulo = 'The Dark Side of the Moon'), 'P8Ds8ByYYXs');

UPDATE Musica SET dtLanc = '1973-03-01' WHERE albId = (SELECT albId FROM Album WHERE titulo = 'The Dark Side of the Moon');

INSERT INTO Musica (titulo, duracao, numRep, albId, linkMus) VALUES
    ('Wanna Be Startin Somethin', 362, 0, (SELECT albId FROM Album WHERE titulo = 'Thriller'), '4Uj3zitETs4'),
    ('Baby Be Mine', 259, 0, (SELECT albId FROM Album WHERE titulo = 'Thriller'), 'rD7IVKEXKHA'),
    ('The Girl Is Mine', 221, 0, (SELECT albId FROM Album WHERE titulo = 'Thriller'), 'bOmKTxZAtOU'),
    ('Thriller', 358, 0, (SELECT albId FROM Album WHERE titulo = 'Thriller'), 'sOnqjkJTMaA'),
    ('Beat It', 258, 0, (SELECT albId FROM Album WHERE titulo = 'Thriller'), 'oRdxUFDoQe0'),
    ('Billie Jean', 294, 0, (SELECT albId FROM Album WHERE titulo = 'Thriller'), 'Zi_XLOBDo_Y'),
    ('Human Nature', 240, 0, (SELECT albId FROM Album WHERE titulo = 'Thriller'), 'kqlJNt-_w2E'),
    ('P.Y.T. (Pretty Young Thing)', 239, 0, (SELECT albId FROM Album WHERE titulo = 'Thriller'), '1pqcHzgGuDQ'),
    ('The Lady in My Life', 298, 0, (SELECT albId FROM Album WHERE titulo = 'Thriller'), 'h7Bes8YYa_4');

UPDATE Musica SET dtLanc = '1982-11-30' WHERE albId = (SELECT albId FROM Album WHERE titulo = 'Thriller');

INSERT INTO Musica (titulo, duracao, numRep, albId, linkMus) VALUES
    ('Deus Lhe Pague', 226, 0, (SELECT albId FROM Album WHERE titulo = 'Construção'), 'eZ8nP1xqfHM'),
    ('Cotidiano', 169, 0, (SELECT albId FROM Album WHERE titulo = 'Construção'), 'MAeJr-p0tnY'),
    ('Desalento', 123, 0, (SELECT albId FROM Album WHERE titulo = 'Construção'), 'Q9nsE_JzbiM'),
    ('Construção', 393, 0, (SELECT albId FROM Album WHERE titulo = 'Construção'), '4Te_lCLaM5k'),
    ('Cordão', 150, 0, (SELECT albId FROM Album WHERE titulo = 'Construção'), 'uwH4_IkIedc'),
    ('Olha Maria', 227, 0, (SELECT albId FROM Album WHERE titulo = 'Construção'), 'IsGquIoAgsk'),
    ('Samba de Orly', 171, 0, (SELECT albId FROM Album WHERE titulo = 'Construção'), 'wJD9HqzWICU'),
    ('Valsinha', 144, 0, (SELECT albId FROM Album WHERE titulo = 'Construção'), 'lsbvGkMMc7E'),
    ('Minha História', 173, 0, (SELECT albId FROM Album WHERE titulo = 'Construção'), 'N6xHMB6GNTY'),
    ('Acalanto', 217, 0, (SELECT albId FROM Album WHERE titulo = 'Construção'), 'VWiGFmnUy84');

UPDATE Musica SET dtLanc = '1971-11-01' WHERE albId = (SELECT albId FROM Album WHERE titulo = 'Construção');

INSERT INTO Musica (titulo, duracao, numRep, albId, linkMus) VALUES
    ('The Genesis', 112, 0, (SELECT albId FROM Album WHERE titulo = 'Illmatic'), 'tiXOQn6XSHM'),
    ('N.Y. State of Mind', 290, 0, (SELECT albId FROM Album WHERE titulo = 'Illmatic'), 'UKjj4hk0pV4'),
    ('Lifes a Bitch', 217, 0, (SELECT albId FROM Album WHERE titulo = 'Illmatic'), '-T9DX0I6_NE'),
    ('The World Is Yours', 257, 0, (SELECT albId FROM Album WHERE titulo = 'Illmatic'), 'e5PnuIRnJW8'),
    ('Halftime', 244, 0, (SELECT albId FROM Album WHERE titulo = 'Illmatic'), 'Z9L8UvA_5a4'),
    ('Memory Lane (Sittin in da Park)', 268, 0, (SELECT albId FROM Album WHERE titulo = 'Illmatic'), 'ZXXj-t1aV9c'),
    ('One Love', 301, 0, (SELECT albId FROM Album WHERE titulo = 'Illmatic'), '5XJwwEo8Xko'),
    ('One Time 4 Your Mind', 194, 0, (SELECT albId FROM Album WHERE titulo = 'Illmatic'), '-UrIty2itEE'),
    ('Represent', 241, 0, (SELECT albId FROM Album WHERE titulo = 'Illmatic'), 'bP3UqJkTYr8'),
    ('It Aint Hard to Tell', 229, 0, (SELECT albId FROM Album WHERE titulo = 'Illmatic'), 'ZlT6n9F5T4I');

UPDATE Musica SET dtLanc = '1994-04-19' WHERE albId = (SELECT albId FROM Album WHERE titulo = 'Illmatic');

    -- Gêneros possuem músicas:

INSERT INTO possui (musId, genId) VALUES
    -- Pink Floyd - The Dark Side of the Moon
    ((SELECT musId FROM Musica WHERE titulo = 'Speak to Me'), (SELECT genId FROM Genero WHERE nome = 'Rock')),
    ((SELECT musId FROM Musica WHERE titulo = 'Breathe'), (SELECT genId FROM Genero WHERE nome = 'Rock')),
    ((SELECT musId FROM Musica WHERE titulo = 'On the Run'), (SELECT genId FROM Genero WHERE nome = 'Rock')),
    ((SELECT musId FROM Musica WHERE titulo = 'Time'), (SELECT genId FROM Genero WHERE nome = 'Rock')),
    ((SELECT musId FROM Musica WHERE titulo = 'The Great Gig in the Sky'), (SELECT genId FROM Genero WHERE nome = 'Rock')),
    ((SELECT musId FROM Musica WHERE titulo = 'Money'), (SELECT genId FROM Genero WHERE nome = 'Rock')),
    ((SELECT musId FROM Musica WHERE titulo = 'Us and Them'), (SELECT genId FROM Genero WHERE nome = 'Rock')),
    ((SELECT musId FROM Musica WHERE titulo = 'Any Colour You Like'), (SELECT genId FROM Genero WHERE nome = 'Rock')),
    ((SELECT musId FROM Musica WHERE titulo = 'Brain Damage'), (SELECT genId FROM Genero WHERE nome = 'Rock')),
    ((SELECT musId FROM Musica WHERE titulo = 'Eclipse'), (SELECT genId FROM Genero WHERE nome = 'Rock')),
    
    -- Michael Jackson - Thriller
    ((SELECT musId FROM Musica WHERE titulo = 'Wanna Be Startin Somethin'), (SELECT genId FROM Genero WHERE nome = 'Pop')),
    ((SELECT musId FROM Musica WHERE titulo = 'Baby Be Mine'), (SELECT genId FROM Genero WHERE nome = 'Pop')),
    ((SELECT musId FROM Musica WHERE titulo = 'The Girl Is Mine'), (SELECT genId FROM Genero WHERE nome = 'Pop')),
    ((SELECT musId FROM Musica WHERE titulo = 'Thriller'), (SELECT genId FROM Genero WHERE nome = 'Pop')),
    ((SELECT musId FROM Musica WHERE titulo = 'Beat It'), (SELECT genId FROM Genero WHERE nome = 'Pop')),
    ((SELECT musId FROM Musica WHERE titulo = 'Billie Jean'), (SELECT genId FROM Genero WHERE nome = 'Pop')),
    ((SELECT musId FROM Musica WHERE titulo = 'Human Nature'), (SELECT genId FROM Genero WHERE nome = 'Pop')),
    ((SELECT musId FROM Musica WHERE titulo = 'P.Y.T. (Pretty Young Thing)'), (SELECT genId FROM Genero WHERE nome = 'Pop')),
    ((SELECT musId FROM Musica WHERE titulo = 'The Lady in My Life'), (SELECT genId FROM Genero WHERE nome = 'Pop')),

    -- Chico Buarque - Construção
    ((SELECT musId FROM Musica WHERE titulo = 'Deus Lhe Pague'), (SELECT genId FROM Genero WHERE nome = 'MPB')),
    ((SELECT musId FROM Musica WHERE titulo = 'Cotidiano'), (SELECT genId FROM Genero WHERE nome = 'MPB')),
    ((SELECT musId FROM Musica WHERE titulo = 'Desalento'), (SELECT genId FROM Genero WHERE nome = 'MPB')),
    ((SELECT musId FROM Musica WHERE titulo = 'Construção'), (SELECT genId FROM Genero WHERE nome = 'MPB')),
    ((SELECT musId FROM Musica WHERE titulo = 'Cordão'), (SELECT genId FROM Genero WHERE nome = 'MPB')),
    ((SELECT musId FROM Musica WHERE titulo = 'Olha Maria'), (SELECT genId FROM Genero WHERE nome = 'MPB')),
    ((SELECT musId FROM Musica WHERE titulo = 'Samba de Orly'), (SELECT genId FROM Genero WHERE nome = 'MPB')),
    ((SELECT musId FROM Musica WHERE titulo = 'Valsinha'), (SELECT genId FROM Genero WHERE nome = 'MPB')),
    ((SELECT musId FROM Musica WHERE titulo = 'Minha História'), (SELECT genId FROM Genero WHERE nome = 'MPB')),
    ((SELECT musId FROM Musica WHERE titulo = 'Acalanto'), (SELECT genId FROM Genero WHERE nome = 'MPB')),

    -- Nas - Illmatic
    ((SELECT musId FROM Musica WHERE titulo = 'The Genesis'), (SELECT genId FROM Genero WHERE nome = 'Hip-Hop')),
    ((SELECT musId FROM Musica WHERE titulo = 'N.Y. State of Mind'), (SELECT genId FROM Genero WHERE nome = 'Hip-Hop')),
    ((SELECT musId FROM Musica WHERE titulo = 'Lifes a Bitch'), (SELECT genId FROM Genero WHERE nome = 'Hip-Hop')),
    ((SELECT musId FROM Musica WHERE titulo = 'The World Is Yours'), (SELECT genId FROM Genero WHERE nome = 'Hip-Hop')),
    ((SELECT musId FROM Musica WHERE titulo = 'Halftime'), (SELECT genId FROM Genero WHERE nome = 'Hip-Hop')),
    ((SELECT musId FROM Musica WHERE titulo = 'Memory Lane (Sittin in da Park)'), (SELECT genId FROM Genero WHERE nome = 'Hip-Hop')),
    ((SELECT musId FROM Musica WHERE titulo = 'One Love'), (SELECT genId FROM Genero WHERE nome = 'Hip-Hop')),
    ((SELECT musId FROM Musica WHERE titulo = 'One Time 4 Your Mind'), (SELECT genId FROM Genero WHERE nome = 'Hip-Hop')),
    ((SELECT musId FROM Musica WHERE titulo = 'Represent'), (SELECT genId FROM Genero WHERE nome = 'Hip-Hop')),
    ((SELECT musId FROM Musica WHERE titulo = 'It Aint Hard to Tell'), (SELECT genId FROM Genero WHERE nome = 'Hip-Hop'));

-- Usuários:

INSERT INTO Usuario (CPF, nome, email, senha) VALUES
    ('12345678909', 'Augusto', 'armolina@inf.ufpel.edu.br', 'gutoadmin123'),
    ('09876543212', 'Luiz Filipe', 'lsfbido@inf.ufpel.edu.br', 'bidoadmin123'),
    ('00000000000', 'Pink Floyd', 'pinkfloyd@pf.com', 'floydpink'),
    ('11111111111', 'Michael Jackson', 'michael@mj.com', 'jackmich'),
    ('22222222222', 'Chico Buarque', 'chico@cb.com', 'buarquechico'),
    ('33333333333', 'Nas', 'nas@nas.com', 'sannas');

-- Artistas: (artistas precisam ser usuários, isso faz com que precise de um cpf (oq eh estranho))

INSERT INTO Artista (CPF, biografia) VALUES
    ('00000000000', 'Uma das bandas de rock mais influentes e icônicas da história da música, formada em Londres em 1965. A banda alcançou sucesso mundial com álbuns conceituais como The Dark Side of the Moon (1973), Wish You Were Here (1975), e The Wall (1979), que são conhecidos por suas letras profundas, sons inovadores, e produções complexas.'),
    ('11111111111', 'Conhecido como o "Rei do Pop", foi um cantor, compositor e dançarino norte-americano que se tornou uma das figuras mais populares e influentes na história da música. Ele lançou sua carreira solo na década de 1970 e alcançou um sucesso fenomenal com álbuns como Off the Wall (1979), Thriller (1982) — o álbum mais vendido de todos os tempos — e Bad (1987).'),
    ('22222222222', 'É um dos compositores, cantores e escritores mais proeminentes do Brasil. Durante a ditadura militar no Brasil, suas canções frequentemente carregavam críticas sociais sutis, o que o levou a ser censurado várias vezes. Álbuns como Construção (1971) são considerados marcos da música brasileira.'),
    ('33333333333', 'É um rapper, compositor e produtor norte-americano. Se tornou um dos maiores nomes do rap ao lançar seu álbum de estreia, Illmatic, em 1994, amplamente considerado um dos melhores álbuns de hip hop de todos os tempos.');

-- Autoria álbum:

INSERT INTO autoria_album (artId, albId) VALUES
    ((SELECT artId FROM Artista WHERE CPF = '00000000000'), (SELECT albId FROM Album WHERE titulo = 'The Dark Side of the Moon')),
    ((SELECT artId FROM Artista WHERE CPF = '11111111111'), (SELECT albId FROM Album WHERE titulo = 'Thriller')),
    ((SELECT artId FROM Artista WHERE CPF = '22222222222'), (SELECT albId FROM Album WHERE titulo = 'Construção')),
    ((SELECT artId FROM Artista WHERE CPF = '33333333333'), (SELECT albId FROM Album WHERE titulo = 'Illmatic'));

-- Autoria música:

INSERT INTO autoria_musica (artId, musId) VALUES
    -- Pink Floyd - The Dark Side of the Moon
    ((SELECT artId FROM Artista WHERE CPF = '00000000000'), (SELECT musId FROM Musica WHERE titulo = 'Speak to Me')),
    ((SELECT artId FROM Artista WHERE CPF = '00000000000'), (SELECT musId FROM Musica WHERE titulo = 'Breathe')),
    ((SELECT artId FROM Artista WHERE CPF = '00000000000'), (SELECT musId FROM Musica WHERE titulo = 'On the Run')),
    ((SELECT artId FROM Artista WHERE CPF = '00000000000'), (SELECT musId FROM Musica WHERE titulo = 'Time')),
    ((SELECT artId FROM Artista WHERE CPF = '00000000000'), (SELECT musId FROM Musica WHERE titulo = 'The Great Gig in the Sky')),
    ((SELECT artId FROM Artista WHERE CPF = '00000000000'), (SELECT musId FROM Musica WHERE titulo = 'Money')),
    ((SELECT artId FROM Artista WHERE CPF = '00000000000'), (SELECT musId FROM Musica WHERE titulo = 'Us and Them')),
    ((SELECT artId FROM Artista WHERE CPF = '00000000000'), (SELECT musId FROM Musica WHERE titulo = 'Any Colour You Like')),
    ((SELECT artId FROM Artista WHERE CPF = '00000000000'), (SELECT musId FROM Musica WHERE titulo = 'Brain Damage')),
    ((SELECT artId FROM Artista WHERE CPF = '00000000000'), (SELECT musId FROM Musica WHERE titulo = 'Eclipse')),

    -- Michael Jackson - Thriller
    ((SELECT artId FROM Artista WHERE CPF = '11111111111'), (SELECT musId FROM Musica WHERE titulo = 'Wanna Be Startin Somethin')),
    ((SELECT artId FROM Artista WHERE CPF = '11111111111'), (SELECT musId FROM Musica WHERE titulo = 'Baby Be Mine')),
    ((SELECT artId FROM Artista WHERE CPF = '11111111111'), (SELECT musId FROM Musica WHERE titulo = 'The Girl Is Mine')),
    ((SELECT artId FROM Artista WHERE CPF = '11111111111'), (SELECT musId FROM Musica WHERE titulo = 'Thriller')),
    ((SELECT artId FROM Artista WHERE CPF = '11111111111'), (SELECT musId FROM Musica WHERE titulo = 'Beat It')),
    ((SELECT artId FROM Artista WHERE CPF = '11111111111'), (SELECT musId FROM Musica WHERE titulo = 'Billie Jean')),
    ((SELECT artId FROM Artista WHERE CPF = '11111111111'), (SELECT musId FROM Musica WHERE titulo = 'Human Nature')),
    ((SELECT artId FROM Artista WHERE CPF = '11111111111'), (SELECT musId FROM Musica WHERE titulo = 'P.Y.T. (Pretty Young Thing)')),
    ((SELECT artId FROM Artista WHERE CPF = '11111111111'), (SELECT musId FROM Musica WHERE titulo = 'The Lady in My Life')),

    -- Chico Buarque - Construção
    ((SELECT artId FROM Artista WHERE CPF = '22222222222'), (SELECT musId FROM Musica WHERE titulo = 'Deus Lhe Pague')),
    ((SELECT artId FROM Artista WHERE CPF = '22222222222'), (SELECT musId FROM Musica WHERE titulo = 'Cotidiano')),
    ((SELECT artId FROM Artista WHERE CPF = '22222222222'), (SELECT musId FROM Musica WHERE titulo = 'Desalento')),
    ((SELECT artId FROM Artista WHERE CPF = '22222222222'), (SELECT musId FROM Musica WHERE titulo = 'Construção')),
    ((SELECT artId FROM Artista WHERE CPF = '22222222222'), (SELECT musId FROM Musica WHERE titulo = 'Cordão')),
    ((SELECT artId FROM Artista WHERE CPF = '22222222222'), (SELECT musId FROM Musica WHERE titulo = 'Olha Maria')),
    ((SELECT artId FROM Artista WHERE CPF = '22222222222'), (SELECT musId FROM Musica WHERE titulo = 'Samba de Orly')),
    ((SELECT artId FROM Artista WHERE CPF = '22222222222'), (SELECT musId FROM Musica WHERE titulo = 'Valsinha')),
    ((SELECT artId FROM Artista WHERE CPF = '22222222222'), (SELECT musId FROM Musica WHERE titulo = 'Minha História')),
    ((SELECT artId FROM Artista WHERE CPF = '22222222222'), (SELECT musId FROM Musica WHERE titulo = 'Acalanto')),

    -- Nas - Illmatic
    ((SELECT artId FROM Artista WHERE CPF = '33333333333'), (SELECT musId FROM Musica WHERE titulo = 'The Genesis')),
    ((SELECT artId FROM Artista WHERE CPF = '33333333333'), (SELECT musId FROM Musica WHERE titulo = 'N.Y. State of Mind')),
    ((SELECT artId FROM Artista WHERE CPF = '33333333333'), (SELECT musId FROM Musica WHERE titulo = 'Lifes a Bitch')),
    ((SELECT artId FROM Artista WHERE CPF = '33333333333'), (SELECT musId FROM Musica WHERE titulo = 'The World Is Yours')),
    ((SELECT artId FROM Artista WHERE CPF = '33333333333'), (SELECT musId FROM Musica WHERE titulo = 'Halftime')),
    ((SELECT artId FROM Artista WHERE CPF = '33333333333'), (SELECT musId FROM Musica WHERE titulo = 'Memory Lane (Sittin in da Park)')),
    ((SELECT artId FROM Artista WHERE CPF = '33333333333'), (SELECT musId FROM Musica WHERE titulo = 'One Love')),
    ((SELECT artId FROM Artista WHERE CPF = '33333333333'), (SELECT musId FROM Musica WHERE titulo = 'One Time 4 Your Mind')),
    ((SELECT artId FROM Artista WHERE CPF = '33333333333'), (SELECT musId FROM Musica WHERE titulo = 'Represent')),
    ((SELECT artId FROM Artista WHERE CPF = '33333333333'), (SELECT musId FROM Musica WHERE titulo = 'It Aint Hard to Tell'));

-- Playlist:

INSERT INTO Playlist (titulo, dtCria, CPF) VALUES
    ('Playlist do Guto', '2024-08-09', '12345678909');

INSERT INTO musica_playlist (playId, musId) VALUES
    ((SELECT playId FROM Playlist WHERE titulo = 'Playlist do Guto'), (SELECT musId FROM Musica WHERE titulo = 'Money')),
    ((SELECT playId FROM Playlist WHERE titulo = 'Playlist do Guto'), (SELECT musId FROM Musica WHERE titulo = 'Beat It')),
    ((SELECT playId FROM Playlist WHERE titulo = 'Playlist do Guto'), (SELECT musId FROM Musica WHERE titulo = 'Deus Lhe Pague')),
    ((SELECT playId FROM Playlist WHERE titulo = 'Playlist do Guto'), (SELECT musId FROM Musica WHERE titulo = 'N.Y. State of Mind'));
