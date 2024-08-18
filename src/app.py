from config.connection import getConnection
from datetime import date
import webbrowser

# INICIANDO BD E PREPARANDO PARA OPERAÇÕES
def startBd():
    connection = getConnection()
    cursor = connection.cursor()
    cursor.execute("SET search_path TO bitofy;")
    return connection, cursor

# FUNÇÃO DO MENU DE LOGIN
def login_menu(cursor):
    print("Bem-vindo ao Bitofy")
    print("Digite 1 para fazer login")
    print("Digite 2 para fazer cadastro")
    print("Digite 3 para sair")
    choice = input("Digite sua escolha: ")
    if choice == "1":
        emailLogin = input("Digite seu email: ")
        senhaLogin = input("Digite sua senha: ")
        params = (emailLogin, senhaLogin)
        if loginIn(cursor, params):
            print("Login realizado com sucesso")
            return emailLogin, True
        else:
            print("Erro ao realizar login")
            return None, False
      
    elif choice == "2":
        nome = input("Digite seu nome: ")
        email = input("Digite seu email: ")
        senha = input("Digite sua senha: ")
        params = (nome, email, senha)
        if signUp(cursor, connection, params):
            print("Usuário cadastrado com sucesso")
        else:
            print("Erro ao cadastrar usuário")
        return None, False
      
    elif choice == "3":
        print("Saindo...")
        return None, False
      
    else:
        print("Escolha inválida. Por favor, tente novamente.")
        return None, False

# FUNÇÃO PARA CADASTRAR USUÁRIO
def signUp(cursor, connection, params):
    try:
        cursor.execute("INSERT INTO Usuario (nome, email, senha) VALUES (%s, %s, %s)", params)
        connection.commit()
        return True
    except Exception as e:
        print(f"Erro ao cadastrar usuario: {e}")
        return False

# FUNÇÃO PARA LOGAR USUÁRIO
def loginIn(cursor, params):
    try:
        cursor.execute("SELECT * FROM Usuario WHERE email = %s AND senha = %s", params)
        result = cursor.fetchone()
        if result:
            print("Usuário encontrado:", result)
            return True
        else:
            print("Nenhum usuário encontrado com os dados fornecidos.")
            return False
    except Exception as e:
        print(f"Erro ao realizar login: {e}")
        return False

# FUNÇÃO PARA CRIAR PLAYLIST
def createPlaylist(cursor, connection, params):
    try:
        cursor.execute("INSERT INTO Playlist (titulo, dtCria, usuId) VALUES (%s, %s, %s)", params)
        connection.commit()
        return True
    except Exception as e:
        print(f"Erro ao criar playlist: {e}")
        return False

# FUNÇÃO PARA PEGAR O ID DO USUÁRIO
def getUserId(cursor, params):
    try:
        cursor.execute("SELECT usuId FROM Usuario WHERE email = %s", (params,))
        result = cursor.fetchone()
        return result[0] if result else None
    except Exception as e:
        print(f"Erro ao buscar ID do usuário: {e}")
        return None

# FUNÇÃO PARA ADICIONAR MÚSICA NA PLAYLIST
def addMusicInPlaylist(cursor, connection, params):
    try:
        cursor.execute("""
            INSERT INTO musica_playlist (playId, musId)
            SELECT 
                (SELECT playId FROM Playlist WHERE titulo = %s), 
                (SELECT musId FROM Musica WHERE titulo = %s)
        """, params)
        connection.commit()
        return True
    except Exception as e:
        print(f"Erro ao adicionar música: {e}")
        return False

# FUNÇÃO PARA CONSULTAR PLAYLIST
def getPlaylist(cursor, params):
    try:
        cursor.execute("""
          SELECT m.titulo as Titulo
          FROM Musica m
          JOIN musica_playlist mp ON m.musId = mp.musId
          JOIN Playlist p ON mp.playId = p.playId
          WHERE p.titulo = %s
        """, params)
        return cursor.fetchall()
    except Exception as e:
        print(f"Erro ao buscar playlist: {e}")
        return None

# FUNÇÃO PARA CONSULTAR MÚSICA FAVORITA DO USUÁRIO
def getFavoriteMusic(cursor, params):
    try:
        cursor.execute("""
          SELECT m.titulo as Titulo
          FROM Musica m
          JOIN escuta e ON m.musId = e.musId
          JOIN Usuario u ON e.usuId = u.usuId
          WHERE u.usuId = %s
          GROUP BY m.titulo
          ORDER BY COUNT(m.titulo) DESC
          LIMIT 1;
        """, (params,))
        result = cursor.fetchone()
        return result[0] if result else None
    except Exception as e:
        print(f"Erro ao buscar música favorita: {e}")
        return None

# FUNÇÃO PARA CONSULTAR PLAYLISTS DO USUÁRIO
def getUserPlaylists(cursor, params):
    try:
        cursor.execute("""
          SELECT p.titulo as Titulo
          FROM Playlist p
          JOIN Usuario u ON p.usuId = u.usuId
          WHERE u.usuId = %s
        """, (params,))
        return cursor.fetchall()
    except Exception as e:
        print(f"Erro ao buscar playlists: {e}")
        return None

# FUNÇÃO PARA CONSULTAR O GÊNERO FAVORITO DO USUÁRIO
def getGenreFavorite(cursor, params):
    try:
        cursor.execute("""
          SELECT g.genTit as Genero, SUM(e.peso) as VezesEscutado
          FROM Genero g
          JOIN possui p ON g.genTit = p.genTit
          JOIN escuta e ON p.musId = e.musId
          JOIN Usuario u ON e.usuId = u.usuId
          WHERE u.usuId = %s
          GROUP BY g.genTit
          ORDER BY VezesEscutado DESC
          LIMIT 1;
        """, (params,))
        result = cursor.fetchone()
        return result[0] if result else None
    except Exception as e:
        print(f"Erro ao buscar gênero favorito: {e}")
        return None

import webbrowser

def openMusic(cursor, params):
    try:
        cursor.execute("""
          SELECT m.linkMus as Link
          FROM Musica m
          WHERE m.titulo = %s
        """, (params,))
        result = cursor.fetchone()
        
        if result:
            link = result[0]

            webbrowser.open(f"https://www.youtube.com/watch?v={link}")

            cursor.execute("""
                INSERT INTO escuta (musId, peso) 
                VALUES (
                    (SELECT musId FROM Musica WHERE titulo = %s),
                    (SELECT COALESCE(MAX(peso), 0) + 1 FROM escuta WHERE musId = (SELECT musId FROM Musica WHERE titulo = %s))
                )
            """, (params, params))
            cursor.connection.commit()
        else:
            print("Música não encontrada.")
    except Exception as e:
        print(f"Erro ao abrir música: {e}")

        
# APLICAÇÃO
def main():
    connection, cursor = startBd()
    
    # MENU DE LOGIN
    while True:
        login = login_menu(cursor)
        if login[1]:
            emailLogin = login[0]
            break
        if login[1] == False:
            return

    # MENU DE OPERAÇÕES
    while True:
        print("BITOFY:")
        print("1. CRIAR PLAYLIST")
        print("2. ADICIONAR MÚSICA NA PLAYLIST")
        print("3. CONSULTAR PLAYLIST")
        print("4. CONSULTAR PLAYLISTS DO USER")
        print("5. CONSULTAR MÚSICA FAVORITA DO USER")
        print("6. CONSULTAR GÊNERO FAVORITO DO USER")
        print("7. ESCUTAR MÚSICA")
        print("8. SAIR")

        choice = input("Digite sua escolha: ")

        if choice == "1":
          nomePlaylist = input("Digite o nome da playlist: ")
          dtCria = date.today()
          usuId = getUserId(cursor, emailLogin)
          params = (nomePlaylist, dtCria, usuId)
          if createPlaylist(cursor, connection, params):
              print("Playlist criada com sucesso")
          else:
              print("Erro ao criar playlist")
        
        elif choice == "2":
          nomePlaylist = input("Digite o nome da playlist: ")
          nomeMusica = input("Digite o nome da música: ")
          params = (nomePlaylist, nomeMusica)
          if addMusicInPlaylist(cursor, connection, params):
              print("Música adicionada à playlist com sucesso")
          else:
              print("Erro ao adicionar música à playlist")
        
        elif choice == "3":
          nomePlaylist = input("Digite o nome da playlist: ")
          params = (nomePlaylist,)
          playlist = getPlaylist(cursor, params)
          if playlist:
              print("Músicas na playlist:")
              for musica in playlist:
                  print(musica)
          if len(playlist) == 0:
              print("Playlist sem músicas")

        elif choice == "4":
          userId = getUserId(cursor, emailLogin)
          playlists = getUserPlaylists(cursor, userId)
          if playlists:
              print("Suas playlists:")
              for playlist in playlists:
                  print(playlist)
          else:
              print("Playlists não encontradas")

        elif choice == "5":
          userId = getUserId(cursor, emailLogin)
          favoriteMusic = getFavoriteMusic(cursor, userId)
          if favoriteMusic:
              print(f"Sua música favorita é: {favoriteMusic}")
          else:
              print("Não foi possível determinar sua música favorita")

        elif choice == "6":
          userId = getUserId(cursor, emailLogin)
          favoriteGenre = getGenreFavorite(cursor, userId)
          if favoriteGenre:
              print(f"Seu gênero favorito é: {favoriteGenre}")
          else:
              print("Não foi possível determinar seu gênero favorito")

        elif choice == "7":
          nomeMusica = input("Digite o nome da música: ")
          openMusic(cursor, nomeMusica)
          if openMusic:
              print("Música aberta com sucesso")
          else:
              print("Erro ao abrir música")

        elif choice == "8":
            print("Saindo...")
            break

        else:
            print("Escolha inválida. Por favor, tente novamente.")


if __name__ == "__main__":
  main()
