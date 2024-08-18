from config.connection import getConnection


# INICIANDO BD E PREPARANDO PARA OPERAÇÕES
def startBd(): 
  connection = getConnection()

  cursor = connection.cursor()

  cursor.execute("SET search_path TO bitofy;")

# FUNÇÃO PARA CADASTRAR USUÁRIO
def signUp(params):
  try:
    cursor.execute("INSERT INTO Usuario (nome, email, senha) VALUES (%s, %s, %s)", params)
    connection.commit()
    print("Usuario cadastrado com sucesso")
    return True
  except:
    print("Erro ao cadastrar usuario")
    return False

def loginIn(params):
  try:
    cursor.execute("SELECT * FROM Usuario WHERE email = %s AND senha = %s", params)
    connection.commit()
    if cursor.rowcount > 0:
      return True
    else:
      return False
  except:
    return


def main():
  startBd()
  print("Bem vindo ao Bitofy")
  print("Digite 1 para fazer login")
  print("Digite 2 para fazer cadastro")
  print("Digite 3 para sair")
  choice = input("Digite sua escolha: ")
  while True:
    if choice == "1":
      nome = input("Digite seu nome: ")
      email = input("Digite seu email: ")
      senha = input("Digite sua senha: ")
      params = (nome, email, senha)
      if loginIn(params):
        print("Login realizado com sucesso")
        break
      else:
        print("Erro ao realizar login")
    elif choice == "2":
      nome = input("Digite seu nome: ")
      email = input("Digite seu email: ")
      senha = input("Digite sua senha: ")
      params = (nome, email, senha)
      if signUp(params):
        print("Usuário cadastrado com sucesso")
      else:
        print("Erro ao cadastrar usuário")
    elif choice == "3":
      print("Saindo...")
      return
    else:
      print("Escolha inválida. Por favor, tente novamente.")
  
  while True:
    print("BITOFY:")
    print("1. CRIAR PLAYLIST")
    print("2. ADICIONAR MUSICA NA PLAYLIST")
    print("3. CONSULTAR PLAYLIST")
    print("4. CONSULTAR PLAYLISTS DO USER")
    print("5. CONSULTAR MÚSICA FAVORITA DO USER")
    print("6. CONSULTAR GÊNERO FAVORITO DO USER")

    choice = input("Enter your choice: ")

    if choice == "1":
      # Code for operation 1
      print("Performing operation 1...")
    elif choice == "2":
      # Code for operation 2
      print("Performing operation 2...")
    elif choice == "3":
      # Code for operation 3
      print("Performing operation 3...")
    elif choice == "4":
      print("Exiting...")
      break
    else:
      print("Invalid choice. Please try again.")

if __name__ == "__main__":
  main()
