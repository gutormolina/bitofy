# Bitofy

## Descrição do trabalho

Ideia: Um sistema de streaming de músicas.

Trabalho criado para a disciplina de Projeto de Banco de Dados, que envolve a criação de um BD e uma interface para a manipulação e consulta dos dados. O banco de dados foi criado em PostgreSQL e a interface foi criada em Python. Além disso, existem consultas pré-prontas para serem rodadas direto no BD.

## Funcionamento:

- Utiliza a biblioteca psycopg2 para a conexão com o db;

<img src="img/conexãoDB.png" width="400px"/>

- Utiliza a biblioteca datetime para data de criação da playlist;
- Utiliza a biblioteca webbroser para abrir músicas no navegador;

<img src="img/bibliotecas.png" width="500px"/>

- Tem terminal simples para aplicar as consultas no db;

- É necessário fazer a adição das músicas e artistas diretamente pelo psql.


## Dependencias a baixar

- pyscopg2:
    ```bash
    pip install psycopg2-binary
    ```

## Contribuidores


<div style="display: flex; justify-content: space-evenly;">

  <div style="text-align: center; margin: 10px;">
    <a href="https://github.com/gutormolina">
      <img src="https://avatars.githubusercontent.com/gutormolina?s=100" alt="Contribuidor 1" style="border-radius: 50%;"/>
    </a>
    <p><a href="https://github.com/gutormolina">Augusto Molina</a></p>
  </div>

  <div style="text-align: center; margin: 10px;">
    <a href="https://github.com/LuizBidoo">
      <img src="https://avatars.githubusercontent.com/LuizBidoo?s=100" alt="Contribuidor 2" style="border-radius: 50%;"/>
    </a>
    <p><a href="https://github.com/LuizBidoo">Luiz Bido</a></p>
  </div>

</div>