CREATE DATABASE BITOFY;
\c bitofy
CREATE SCHEMA BITOFY AUTHORIZATION POSTGRES;
SET search_path TO BITOFY;

CREATE TABLE Genero (
    genId       int         not null,
    genNome     varchar(15) not null,
    genDesc     varchar(40) ,

    PRIMARY KEY (genId)
);

CREATE TABLE Album (
    albId       int         not null,
    albTit      varchar(30) not null,
    albDtLanc   date        not null,
    albNumFai   int         not null,

    PRIMARY KEY (albId)
);

CREATE TABLE Musica (
    musId       int         not null,
    musTit      varchar(30) not null,
    musDur      int         not null, -- em segundos
    musDtLanc   date        not null,
    musNumRep   int         not null,
    albId       int         not null,

    PRIMARY KEY (musId),
    FOREIGN KEY (albId) REFERENCES Album (albId)
);

CREATE TABLE possui (
    musId       int         not null,
    musGen      int         not null,

    FOREIGN KEY (musId) REFERENCES Musica (musId)
)