CREATE DATABASE BITOFY;
\c bitofy
CREATE SCHEMA BITOFY AUTHORIZATION POSTGRES;
SET search_path TO BITOFY;

CREATE TABLE Genero (
    genId       int             not null,
    nome        varchar(30)     not null,
    descr       text,

    PRIMARY KEY (genId)
);

CREATE TABLE Album (
    albId       int             not null,
    titulo      text            not null,
    dtLanc      date            not null,
    numFai      int             not null, -- ñ precisa (relação alb - mus já fornece esse número);

    PRIMARY KEY (albId)
);

CREATE TABLE Musica (
    musId       int             not null,
    titulo      text            not null,
    duracao     int             not null, -- em segundos
    dtlanc      date            not null,
    numRep      int             not null,
    albId       int, -- se for single, o que acontece com a fkey?
    linkMus

    PRIMARY KEY (musId),
    FOREIGN KEY (albId) REFERENCES Album (albId)
);

CREATE TABLE possui (
    musId       int             not null,
    genId       int             not null,

    FOREIGN KEY (musId) REFERENCES Musica (musId),
    FOREIGN KEY (genId) REFERENCES Genero (genId)
);

CREATE TABLE Usuario (
    CPF         varchar(11)     not null,
    nome        varchar(30)     not null,
    email       varchar(MAX)    not null,
    senha       varchar(30)     not null,

    PRIMARY KEY (CPF)
);

CREATE TABLE Escuta (
    escId       int             not null, -- add para que funcione como tabela de log
    CPF         varchar(11)     not null,
    musId       int             not null,
    peso        int             not null,

    PRIMARY KEY (escId), -- serial faz o auto incremento?
    FOREIGN KEY (CPF) REFERENCES Usuario (CPF),
    FOREIGN KEY (musId) REFERENCES Musica (musId)
);

CREATE TABLE Avaliacao (
    avalId      int             not null,
    nota        decimal(2,1)    not null,
    coment      text,  
    dtAval      date            not null,
    CPF         varchar(11)     not null,
    musId       int             not null,

    PRIMARY KEY (avalId),
    FOREIGN KEY (CPF) REFERENCES Usuario (CPF),
    FOREIGN KEY (musId) REFERENCES Musica (musId),
    CONSTRAINT verifNota CHECK (nota >= 0 AND nota <-= 5)
);

CREATE TABLE Playlist (
    playId      int             not null,
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
    artId       int             not null,
    CPF         varchar(11)     not null,
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
