-- Consultar por gênero
select m.titulo as Titulo
from Musica m
join possui p on m.musId = p.musId
join Genero g on p.genTit = g.genTit
where g.genTit = 'Rock'; -- trocar o genero (pessoa escreve)

-- Consultar por artista
select m.titulo as Titulo
from Musica m
join autoria_musica a on m.musId = a.musId
join Artista t on a.nomeArt = t.nomeArt
where t.nomeArt = 'Nas';

-- Consultar por mais escutadas

SELECT u.nome AS Usuario, m.titulo AS Titulo, e.peso AS Peso
FROM Musica m
JOIN escuta e ON m.musId = e.musId
JOIN Usuario u ON e.usuId = u.usuId
WHERE e.peso = (
  SELECT MAX(e2.peso)
  FROM escuta e2
  WHERE e2.usuId = u.usuId
);

-- Consultar as favoritas de um usuario
SELECT m.titulo as Titulo
from Musica m
join favorita f on m.musId = f.musId
join Usuario u on f.usuId = u.usuId
where u.nome = 'Augusto'; -- nome do usuario passado pelo python

-- Consultar por playlist
select m.titulo as Titulo
join musica_playlist mp on m.musId = mp.musId
join Playlist p on mp.playId = p.playId
where p.nome = 'Playlist do Guto' -- nome da playlist passado pelo python

-- Consultar por ano de lançamento
select m.titulo as Titulo
from Musica m
where m.dtLanc = 1994; -- data passada pelo python (tem que ser exatamente)

-- Consultar genero mais escutado por um usuario
select g.genTit as Genero, SUM(e.peso) as VezesEscutado
from Genero g
join possui p on g.genTit = p.genTit
join escuta e on p.musId = e.musId
join Usuario u on e.usuId = u.usuId
where u.nome = 'User Name' -- vai ser passado pelo python
group by g.genTit
order by VezesEscutado desc
limit 1;

-- Consultar por artista mais escutado por um usuario
select a.nomeArt as Nome, SUM(e.peso) as VezesEscutado
from Artista a
join autoria_musica am on a.nomeArt = am.nomeArt
join escuta e on am.musId = e.musId
join Usuario u on e.usuId = u.usuId
where u.nome = 'User Name' -- vai ser passado pelo python
group by a.nomeArt
order by VezesEscutado desc
limit 1;