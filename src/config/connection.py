import psycopg2

# Conexão com DB postgres
def getConnection():
  return psycopg2.connect(
  dbname = "bitofy",
  user = "postgres",
  password = "sua-senha",
  host = "localhost",
  port = 5432
  )
